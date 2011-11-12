// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2011 Ben Nemec
// @End License@

#include <list>
#include <queue>
#include <sstream>
#include <string>
#include <vector>
#include <deque>
#ifndef _WIN32
#include <poll.h>
#else
#include <Winsock2.h>
#endif
#include "Particle.h"
#include <SDL/SDL_net.h>
#include "PlayerData.h"
#include "Vector3.h"
#include "Packet.h"
#include "ObjectKDTree.h"
#include "CollisionDetection.h"
#include "ProceduralTree.h"
#include "Timer.h"
#include "globals.h"
#include "ServerState.h"
#include "IDGen.h"
#include "util.h"
#include "Bot.h"
#include "Mutex.h"
#include "ServerNetCode.h"
#include "serverdefs.h"

SDL_Thread* serverinput;
UDPsocket servsock;
MapPtr servermap;
ServerNetCodePtr servernetcode;
vector<PlayerData> serverplayers;
list<Particle> servparticles;
vector<Item> serveritems;
tsint serverloadmap;
tsint consoleloadmap;
string servermapname;
IDGen servsendpacketnum;
IDGen nextservparticleid;
IDGen serveritemid;
IDGen nexthitid;
unsigned short servertickrate;
string currentmap;
string servername;
list<Packet> servqueue;
UDPpacket *servoutpack;
Meshlist servermeshes;
ObjectKDTree serverkdtree;
short maxplayers;
deque<ServerState> oldstate;
vector<string> maplist;
bool gameover;
Uint32 nextmaptime;
set<unsigned long> commandids;
size_t framecount;
Uint32 lastfpsupdate;
int servfps;
vector<BotPtr> bots;
vector<intvec> visible;


int Server(void* dummy)
{
   if (console.GetString("servername") == "@none@")
   {
      srand(time(0));
      int choosename = (int)Random(0, 16);  // Just for fun:-)
      switch (choosename)
      {
         case 0:
            servername = "ORLY?";
            break;
         case 1:
            servername = "Scoop!";
            break;
         case 2:
            servername = "YARLY!";
            break;
         case 3:
            servername = "Cybertron";
            break;
         case 4:
            servername = "In ur server, pwnin ur cycles";
            break;
         case 5:
            servername = "Nameless One";
            break;
         case 6:
            servername = "Aimbots Anonymous";
            break;
         case 7:
            servername = "Hax!";
            break;
         case 8:
            servername = "Nooblet";
            break;
         case 9:
            servername = "So yeah...and stuff";
            break;
         case 10:
            servername = "<3 unnamed servers";
            break;
         case 11:
            servername = "Candy Land";
            break;
         case 12:
            servername = "[insert server name here]";
            break;
         case 13:
            servername = "404: Server name not found";
            break;
         case 14:
            servername = "I have a bad feeling about this...";
            break;
         case 15:
            servername = "Indubitably";
            break;
      }
      logout << "Chose name " << servername << " which is #" << choosename << endl;
   }
   else
      servername = console.GetString("servername");
   nextservparticleid.next(); // 0 has special meaning
   servertickrate = console.GetInt("tickrate");
   maxplayers = console.GetInt("maxplayers");
   framecount = 0;
   lastfpsupdate = SDL_GetTicks();
   if (console.GetString("map") == "")
      console.Parse("set map riverside");
   LoadMapList();
   servernetcode = ServerNetCodePtr(new ServerNetCode());
   ServerLoadMap(console.GetString("map"));
   serverinput = SDL_CreateThread(ServerInput, NULL);
   
   ServerLoop();
   
   bots.clear();
   SDL_WaitThread(serverinput, NULL);
   return 0;
}


void ServerLoop()
{
   setsighandler();
   
   logout << "ServerLoop " << gettid() << endl;
   
   Uint32 currtick;
   Timer frametimer;
   frametimer.start();
   
   while (running)
   {
      servernetcode->Update();
      
      if (console.GetBool("limitserverrate"))
      {
         while (frametimer.elapsed() < Uint32(1000 / servertickrate - 1))
         {
            servernetcode->Update();
            SDL_Delay(1);
         }
      }
      else
      {
         SDL_Delay(1); // Otherwise if we turn off limitserverrate this will hog CPU
      }
      frametimer.start();

      if (gameover && SDL_GetTicks() > nextmaptime)
      {
         srand(time(0));
         int choosemap = (int) Random(0, maplist.size());
         ServerLoadMap(maplist[choosemap]);
      }

      if (consoleloadmap)
      {
         ServerLoadMap(servermapname);
      }

      Uint32 timeout = console.GetInt("timeout");
      for (size_t i = 1; i < serverplayers.size(); ++i)
      {
         currtick = SDL_GetTicks();
         if (serverplayers[i].connected && currtick > serverplayers[i].lastupdate + timeout * 1000)
         {
            servernetcode->EraseValidAddr(serverplayers[i].addr);
            serverplayers[i].salvage += CalculatePlayerWeight(serverplayers[i]); 
            serverplayers[i].Disconnect();
            servernetcode->SendMessage(serverplayers[i].name + " timed out.");
         }
         else if (serverplayers[i].connected)
         {
            ServerUpdatePlayer(i);
         }
      }
         
      // Update server meshes
      for (Meshlist::iterator i = servermeshes.begin(); i != servermeshes.end(); ++i)
      {
         i->Update();
      }
      
      UpdateVisibility();
      
      Bot::SetPlayers(serverplayers);
      
      // Save state so we can recall it for collision detection
      SaveState();
         
      // Update particles
      int updinterval = 100;
      UpdateParticles(servparticles, updinterval, serverkdtree, servermeshes, serverplayers, Vector3(), &HandleHit, &Rewind);
         
      // Update server FPS
      ++framecount;
      currtick = SDL_GetTicks();
      if (currtick - lastfpsupdate > 1000)
      {
         servfps = int(float(framecount) * 1000.f / float(currtick - lastfpsupdate));
         framecount = 0;
         lastfpsupdate = currtick;
      }
   }
}


void ServerLoadMap(const string& mn)
{
   gameover = 0;
   servermeshes.clear();
   serveritems.clear();
   serverplayers.clear();
   PlayerData local(servermeshes); // Dummy placeholder for the local player
   serverplayers.push_back(local);
   servernetcode->ClearValidAddrs();
   servparticles.clear();

   // Unfortunately SDL_Image is not thread safe, so we have to signal the main thread to do this
   servermapname = mn;
   serverloadmap = 1;

   // Wait for main thread to load the map - after this completes servermap should be properly populated
   while (serverloadmap) {SDL_Delay(1);}
   
   // Generate main base items
   for (size_t i = 0; i < servermap->SpawnPoints().size(); ++i)
   {
      Item newitem(Item::Base, servermeshes);
      MeshPtr newmesh = meshcache->GetNewMesh(newitem.ModelFile());
      newmesh->Move(servermap->SpawnPoints(i).position);
      servermeshes.push_front(*newmesh);
      serveritems.push_back(newitem);
      Item& curritem = serveritems.back();
      curritem.mesh = servermeshes.begin();
      curritem.id = serveritemid;
      curritem.team = servermap->SpawnPoints(i).team;
   }
   
   // Must be done here so it's available for KDTree creation
   for (Meshlist::iterator i = servermeshes.begin(); i != servermeshes.end(); ++i)
   {
      i->Update();
   }
   
   Vector3vec points(8, Vector3());
   for (int i = 0; i < 4; ++i)
   {
      points[i] = servermap->WorldBounds(0).GetVertex(i);
   }
   for (int i = 0; i < 4; ++i)
   {
      points[i + 4] = servermap->WorldBounds(5).GetVertex(i);
   }
   serverkdtree = ObjectKDTree(&servermeshes, points);
   serverkdtree.refine(0);
   
   logout << "Server map loaded" << endl;

   consoleloadmap = 0;
   
   bots.clear();
   size_t numbots = console.GetInt("bots");
   Bot::Initialize();
   for (size_t i = 0; i < numbots; ++i)
      bots.push_back(BotPtr(new Bot()));
}


void HandleHit(Particle& p, Mesh* curr, const Vector3& hitpos)
{
   servernetcode->SendHit(hitpos, p);
   
   if (!curr)
      return;
   
   if (floatzero(p.dmgrad))
   {
      ApplyDamage(curr, p.damage, p.playernum);
   }
   else
   {
      SplashDamage(hitpos, p.damage, p.dmgrad, p.playernum);
   }
}


void SplashDamage(const Vector3& hitpos, float damage, float dmgrad, int playernum, const bool teamdamage)
{
   vector<Mesh*> hitmeshes;
   vector<Mesh*> check;
   Vector3 dummy; // Don't care about where we hit with splash
   
   unsigned int numlevels = console.GetInt("splashlevels");
   for (size_t i = 1; i <= numlevels; ++i)
   {
      // Have to reget the meshes each time or we can end up checking removed ones
      check = serverkdtree.getmeshes(hitpos, hitpos, dmgrad);
      AppendDynamicMeshes(check, servermeshes);
      
      Mesh* dummymesh;
      coldet.CheckSphereHit(hitpos, hitpos, dmgrad * (float(i) / float(numlevels)), check, servermap, dummy, dummymesh, NULL, &hitmeshes);
      std::sort(hitmeshes.begin(), hitmeshes.end());
      hitmeshes.erase(std::unique(hitmeshes.begin(), hitmeshes.end()), hitmeshes.end());
      
      for (vector<Mesh*>::iterator j = hitmeshes.begin(); j != hitmeshes.end(); ++j)
      {
         ApplyDamage(*j, damage / float(numlevels), playernum, teamdamage);
      }
   }
}


void ApplyDamage(Mesh* curr, const float damage, const size_t playernum, const bool teamdamage)
{
   bool dead;
   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      dead = false;
      for (size_t part = 0; part < numbodyparts; ++part)
      {
         if (serverplayers[i].mesh[part] != servermeshes.end())
         {
            if (curr == &(*serverplayers[i].mesh[part]) &&
                (serverplayers[i].team != serverplayers[playernum].team || i == playernum || teamdamage))
            {
               logout << "Hit " << part << endl;
               serverplayers[i].hp[part] -= int(damage * serverplayers[i].item.ArmorMult());
               servernetcode->SendDamage(i, playernum);
               if (serverplayers[i].hp[part] <= 0)
               {
                  if (part != LArm && part != RArm)
                     dead = true;
                  else
                  {
                     servermeshes.erase(serverplayers[i].mesh[part]);
                     serverplayers[i].mesh[part] = servermeshes.end();
                     servernetcode->SendRemove(i, part);
                  }
               }
            }
         }
      }
      if (dead)
      {
         serverplayers[i].salvage += 100;
         serverplayers[playernum].kills++;
         serverplayers[playernum].salvage += CalculatePlayerWeight(serverplayers[i]) / 2;
         logout << "Player " << i << " was killed by Player " << playernum << endl;
         KillPlayer(i, playernum);
      }
   }
   bool doremove;
   vector<Item>::iterator i = serveritems.begin();
   while (i != serveritems.end())
   {
      if (&(*i->mesh) == curr)
      {
         logout << "Hit item " << curr << endl;
         i->hp -= int(damage);
         if (i->hp < 0)
         {
            doremove = true;
            for (size_t j = 0; j < servermap->SpawnPoints().size(); ++j)
            {
               if (&(*serveritems[j].mesh) == curr)
               {
                  RemoveTeam(servermap->SpawnPoints(j).team);
                  doremove = false;
               }
            }
            if (doremove)
               i = RemoveItem(i);
            else ++i;
         }
         else ++i;
      }
      else ++i;
   }
}


void ServerUpdatePlayer(int i)
{
   Uint32 ticks = SDL_GetTicks() - serverplayers[i].lastcoolingtick;
   // Cooling
   float coolrate = .01f;
   coolrate *= serverplayers[i].item.CoolMult();
   if (serverplayers[i].pos.y < serverplayers[i].size * 2.f)
      coolrate *= 1.5f;
   serverplayers[i].lastcoolingtick += ticks;
   serverplayers[i].temperature -= ticks * coolrate;
   if (serverplayers[i].temperature < 0)
      serverplayers[i].temperature = 0;
   
   // Update spawn timer
   serverplayers[i].spawntimer -= ticks;
   if (serverplayers[i].spawntimer < 0)
      serverplayers[i].spawntimer = 0;
   
   if (!serverplayers[i].spawned)
      return;
   
   // Give them the benefit of the doubt and cool them before calculating overheating
   if (serverplayers[i].temperature > 100.f && serverplayers[i].spawned && console.GetBool("overheat"))
   {
      if (serverplayers[i].salvage < 100)
         serverplayers[i].salvage = 100;
      KillPlayer(i, i);
   }
   
   // Powered down?
   serverplayers[i].powerdowntime -= ticks; // Reuse lastcoolingtick
   if (serverplayers[i].powerdowntime <= 0)
   {
      serverplayers[i].powerdowntime = 0;
   }
   
   if (serverplayers[i].powerdowntime) return;
   
   // Healing
   serverplayers[i].healaccum += float(ticks) * .0005f;
   if (serverplayers[i].healaccum > 1)
   {
      int addhp = int(serverplayers[i].healaccum);
      serverplayers[i].healaccum -= addhp;
      for (size_t j = 0; j < numbodyparts; ++j)
      {
         if (serverplayers[i].hp[j] > 0)
         {
            int maxhp = units[serverplayers[i].unit].maxhp[j];
            serverplayers[i].hp[j] += addhp;
            if (serverplayers[i].hp[j] > maxhp)
               serverplayers[i].hp[j] = maxhp;
         }
      }
   }
   
   // Movement and necessary model updates
   
   // This is odd, but I'm too lazy to fix it.  We call UpdatePlayerModel twice: once to make sure
   // the model is loaded, the second to move it to its new position.  Loading and moving should
   // probably be done separately, but I doubt this is going to have any significant effect
   // so I'm just going to leave it.
   UpdatePlayerModel(serverplayers[i], servermeshes, false);
   
   // If we rewind here then when we put the state back to 0 time offset we actually get the
   // previous state, which is bad because player models get stuck.  Thus movement collisions
   // won't be lag-compensated for now (will this be a problem? We'll see).
   if (!serverplayers[i].powerdowntime)
   {
      //Rewind(serverplayers[i].ping);
      Move(serverplayers[i], servermeshes, serverkdtree, servermap);
      //Rewind(0);
      UpdatePlayerModel(serverplayers[i], servermeshes, false);
   }
   
   // Shots fired!
   int weaponslot = weaponslots[serverplayers[i].currweapon];
   Weapon& currplayerweapon = serverplayers[i].weapons[weaponslot];
   while (serverplayers[i].firerequests.size() && 
       (SDL_GetTicks() - serverplayers[i].lastfiretick[weaponslot] >= currplayerweapon.ReloadTime()) &&
       (currplayerweapon.ammo != 0) && serverplayers[i].hp[weaponslot] > 0)
   {
      /* Use the client position if it's within ten units of the serverpos.  This avoids the need to
      slide the player around as much because this way they see their shots going exactly where
      they expect, even if the positions don't match exactly (and they rarely will:-).*/
      Vector3 startpos = serverplayers[i].pos;
      if (serverplayers[i].pos.distance2(serverplayers[i].clientpos) < 100)
         startpos = serverplayers[i].clientpos;
      Vector3 rot(serverplayers[i].pitch, serverplayers[i].facing + serverplayers[i].rotation, 0.f);
      Vector3 offset = units[serverplayers[i].unit].weaponoffset[weaponslots[serverplayers[i].currweapon]];
      
      Particle part = CreateShot(currplayerweapon, rot, startpos, offset, units[serverplayers[i].unit].viewoffset, i);
      part.rewind = serverplayers[i].ping;
      part.id = nextservparticleid;
      

      serverplayers[i].lastfiretick[weaponslot] = SDL_GetTicks();
      serverplayers[i].temperature += currplayerweapon.Heat();
      if (currplayerweapon.ammo > 0) // Negative ammo value indicates infinite ammo
         currplayerweapon.ammo--;
      
      servparticles.push_back(part);

      serverplayers[i].firerequests.pop_front();
      
      servernetcode->SendShot(part);
   }
}



// Only rewinds meshes that fall within the cylinder defined by start, end, and radius
void Rewind(Uint32 ticks, const Vector3& start, const Vector3& end, const float radius)
{
   Uint32 currtick = SDL_GetTicks();
   size_t i;
   
   // Remove states older than 500 ms
   while (oldstate.size() && currtick - oldstate[0].tick > 500)
   {
      oldstate.pop_front();
   }
   
   if (!oldstate.size()) return;
   
   // Search backwards through our old states.  Stop at 0 and use that if we don't have a state old enough
   for (i = oldstate.size() - 1; i > 0; --i)
   {
      if (currtick - oldstate[i].tick >= ticks) break;
   }
   
   Vector3 move = end - start;
   float movemaginv = 1.f / start.distance(end);
   size_t rewindcounter = 0;
   for (size_t j = 0; j < oldstate[i].index.size(); ++j)
   {
      size_t p = oldstate[i].index[j];
      if (serverplayers[p].spawned)
      {
         for (size_t k = 0; k < numbodyparts; ++k)
         {
            if (coldet.DistanceBetweenPointAndLine(oldstate[i].position[j][k], start, move, movemaginv) < radius + oldstate[i].size[j][k] &&
               serverplayers[p].hp[k] > 0)
            {
               ++rewindcounter;
               serverplayers[p].mesh[k]->SetState(oldstate[i].position[j][k], oldstate[i].rots[j][k],
                                             oldstate[i].frame[j][k], oldstate[i].animtime[j][k],
                                             oldstate[i].animspeed[j][k]);
            }
         }
      }
   }
}


void SaveState()
{
   ServerState newstate(SDL_GetTicks());
   
   for (size_t i = 0; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].spawned)
      {
         newstate.Add(serverplayers[i], i, servermeshes.end());
      }
   }
   oldstate.push_back(newstate);
}


int ServerInput(void* dummy)
{
#ifdef DEDICATED
   setsighandler();
   // Check for commands being input from stdin
   string command;
#ifndef WIN32
   pollfd cinfd[1];
   // Theoretically this should always be 0, but one fileno call isn't going to hurt, and if
   // we try to run somewhere that stdin isn't fd 0 then it will still just work
   cinfd[0].fd = fileno(stdin);
   cinfd[0].events = POLLIN;
#else
   HANDLE h = GetStdHandle(STD_INPUT_HANDLE);
#endif
   while (running)
   {
#ifndef WIN32
      if (poll(cinfd, 1, 1000))
#else
      // This is problematic because input on Windows is not line-buffered so this will return
      // even if getline may block.  I haven't found a good way to fix it, so for the moment
      // I just strongly suggest only running the server from the Python frontend, which does
      // line buffer input.  This does work okay as long as the user doesn't enter characters
      // without pressing enter, and then try to end the server another way (say a remote
      // console command), in which case we'll still be waiting for the stdin EOL and hang.
      if (WaitForSingleObject(h, 0) == WAIT_OBJECT_0)
#endif
      {
         getline(std::cin, command);
         console.Parse(command, false);
      }
      SDL_Delay(1);
   }
#endif
   return 0;
}


void AddItem(const Item& it, int oppnum)
{
   if (it.Type() == Item::SpawnPoint)
   {
      MeshPtr newmesh = meshcache->GetNewMesh(it.ModelFile());
      newmesh->Move(serverplayers[oppnum].pos - Vector3(0, serverplayers[oppnum].size * 2.f, 0));
      newmesh->dynamic = true;
      servermeshes.push_front(*newmesh);
      serveritems.push_back(serverplayers[oppnum].item);
      Item& curritem = serveritems.back();
      curritem.mesh = servermeshes.begin();
      curritem.id = serveritemid;
      curritem.team = serverplayers[oppnum].team;
      
      for (size_t i = 1; i < serverplayers.size(); ++i)
      {
         if (serverplayers[i].connected)
         {
            servernetcode->SendItem(curritem, i);
         }
      }
   }
}


vector<Item>::iterator RemoveItem(const vector<Item>::iterator& it)
{
   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].connected)
      {
         Packet p(&serverplayers[i].addr);
         p.ack = servsendpacketnum;
         p << "R\n";
         p << p.ack << eol;
         p << it->id << eol;
         
         servqueue.push_back(p);
      }
   }
   servermeshes.erase(it->mesh);
   return serveritems.erase(it);
}


// At this time just ends the game because only two teams are supported.  Will more be in the future?  Who knows.
void RemoveTeam(int num)
{
   if (!gameover)
   {
      logout << "Team " << num << " has been defeated" << endl;
      gameover = true;
      nextmaptime = SDL_GetTicks() + console.GetInt("endgametime") * 1000;
      for (size_t i = 0; i < serverplayers.size(); ++i)
      {
         if (serverplayers[i].connected)
         {
            servernetcode->SendGameOver(serverplayers[i], num == 1 ? 2 : 1);
         }
      }
   }
}


void LoadMapList()
{
   NTreeReader readmaps("maps/maplist");
   
   for (size_t i = 0; i < readmaps.NumChildren(); ++i)
   {
      const NTreeReader& currmap = readmaps(i);
      maplist.push_back(currmap.GetName());
   }
}


void KillPlayer(const int i, const int killer)
{
   serverplayers[i].deaths++;
   serverplayers[i].Kill();
   serverplayers[i].spawntimer = console.GetInt("respawntime");
   servernetcode->SendKill(i, killer);
   SplashDamage(serverplayers[i].pos, 50.f, 50.f, 0, true);
}


int CountPlayers()
{
   int retval = 0;
   for (size_t i = 0; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].connected)
         ++retval;
   }
   return retval;
}


void UpdateVisibility()
{
   visible.clear();
   visible = vector<intvec>(serverplayers.size(), intvec(serverplayers.size(), -1));
   
   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      for (size_t j = 1; j < serverplayers.size(); ++j)
      {
         if (visible[i][j] < 0 && i != j)
         {
            Vector3 dummy;
            vector<Mesh*> check = serverkdtree.getmeshes(serverplayers[i].pos, serverplayers[j].pos, 1);
            bool hit = coldet.CheckSphereHit(serverplayers[i].pos,
                                             serverplayers[j].pos,
                                             -serverplayers[i].size,
                                             check,
                                             servermap,
                                             NULL);
         
            visible[i][j] = hit ? 0 : 1;
            visible[j][i] = visible[i][j]; // If j is visible to i, then the reverse should also be true
         }
      }
   }
}

