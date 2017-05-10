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
// Copyright 2008-2012 Ben Nemec
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
// Winsock2 apparently pulls in windows.h, because this breaks std::max.  Sigh.
#define NOMINMAX
#define WIN32_LEAN_AND_MEAN
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
#include "PathNode.h"

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
Uint32 nextmaptime = 0;
set<unsigned long> commandids;
size_t framecount;
Uint32 lastfpsupdate;
int servfps;
vector<BotPtr> bots;
vector<intvec> visible;
vector<PathNodePtr> pathnodes;
int aipathversion = 1;
int timedserver;
int maptime;

int Server(void* dummy)
{
   if (console.GetString("servername") == "@none@")
   {
      srand(time(0));
      int choosename = (int)Random(0, 16);  // Just for fun:-)
      switch (choosename)
      {
         case 0:
            servername = "Big Stompy Robots";
            break;
         case 1:
            servername = "Assaulting the Warriors";
            break;
         case 2:
            servername = "Hey look! A bird!";
            break;
         case 3:
            servername = "Admin didn't bother changing the name";
            break;
         case 4:
            servername = "Death by Robot";
            break;
         case 5:
            servername = "Freaking freezing in here";
            break;
         case 6:
            servername = "My Battle Frame is better";
            break;
         case 7:
            servername = "Commanding the Tech";
            break;
         case 8:
            servername = "Giant Rust Buckets";
            break;
         case 9:
            servername = "Mechs shouldn't have hands";
            break;
         case 10:
            servername = "But it's a dry overheat";
            break;
         case 11:
            servername = "Burninating the countryside";
            break;
         case 12:
            servername = "Tin-foil Armor";
            break;
         case 13:
            servername = "Eject! Eject! Eject!";
            break;
         case 14:
            servername = "Mouthy Mercs";
            break;
         case 15:
            servername = "Awesome Server Name";
            break;
      }
      logout << "Chose name " << servername << " which is #" << choosename << endl;
   }
   else
   {
      servername = console.GetString("servername");
   }
   nextservparticleid.next(); // 0 has special meaning
   gamemode = console.GetString("gamemode");
   servertickrate = console.GetInt("tickrate");
   maxplayers = console.GetInt("maxplayers");
   timedserver = console.GetInt("timedserver");
   if (timedserver > 0)
   {
    timedserver = console.GetInt("timedserver") * 60000;
    logout << "Time Limit Enabled. Round time is: " << timedserver << endl;
   }

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

   int mapstart = 0;

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


      int startupdelay = console.GetInt("startupdelay") * 1000;

      if (gameover && SDL_GetTicks() > nextmaptime)
      {
         srand(time(0));
         int choosemap = (int) Random(0, maplist.size());
         ServerLoadMap(maplist[choosemap]);
         mapstart=SDL_GetTicks();
         logout << "Map Start " << mapstart << endl;
      }

      maptime = mapstart + timedserver;
      if (!gameover && timedserver != 0 && SDL_GetTicks() >= maptime)
      {
        logout << "Round Time Limit Hit " << maptime << endl;
        gameover = 1;
      }

      if (consoleloadmap)
      {
         ServerLoadMap(servermapname);
         mapstart=SDL_GetTicks();
         logout << "Map Start " << mapstart << endl;
      }

      // Update server meshes
      // Needs to happen before updating players or meshes added by netcode may end up with bogus collision detection data
      for (Meshlist::iterator i = servermeshes.begin(); i != servermeshes.end(); ++i)
      {
         i->Update();
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

            // *** Debugging of pathing code ***
            if (false)
            {
               PathNodePtr currpathnode = pathnodes[0];
               float currdist = pathnodes[0]->position.distance2(serverplayers[i].pos);
               for (size_t j = 1; j < pathnodes.size(); ++j)
               {
                  float checkdist = pathnodes[j]->position.distance2(serverplayers[i].pos);
                  if (checkdist < currdist)
                  {
                     currdist = checkdist;
                     currpathnode = pathnodes[j];
                  }
               }

               Vector3 facingvec(0.f, 0.f, -1.f);
               GraphicMatrix m;
               m.rotatey(serverplayers[i].facing);
               facingvec.transform(m);
               facingvec *= 500.f;

               //logout << "currpathnode " << currpathnode << endl;

               logout << "Server validation " << currpathnode->Validate(serverplayers[i].pos, facingvec, serverplayers[i].size) << endl;
               logout << serverplayers[i].pos << endl << facingvec << endl << serverplayers[i].size << endl;
            }

            ServerUpdatePlayer(i);
         }
      }

      UpdateVisibility();

      Bot::SetPlayers(serverplayers);
      for (size_t i = 0; i < bots.size(); ++i)
      {
         bots[i]->SetAllSpawns(servermap->SpawnPoints());
      }

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

   size_t numbots = console.GetInt("bots");
   if (numbots && !LoadPathData())
      GenPathData();

   logout << "Server map loaded" << endl;

   consoleloadmap = 0;

   bots.clear();
   Bot::Initialize();
   Bot::SetPathNodes(pathnodes);
   for (size_t i = 0; i < numbots; ++i)
   {
      bots.push_back(BotPtr(new Bot()));
      bots.back()->checkdist = servermap->BotCheckDist();
   }
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

         size_t spawnpoint = servermap->SpawnPoints().size();
         for (size_t j = 0; j < servermap->SpawnPoints().size(); ++j)
         {
            if (&(*serveritems[j].mesh) == curr)
            {
               spawnpoint = j;
               if (servermap->SpawnPoints(spawnpoint).team != serverplayers[playernum].team)
               {
                  for (size_t k = 0; k < bots.size(); ++k)
                  {
                     if (bots[k]->Team() == servermap->SpawnPoints(spawnpoint).team)
                        bots[k]->baseattacker = playernum;
                  }
               }
            }
         }
         if (i->hp < 0)
         {
            doremove = true;
            if (spawnpoint < servermap->SpawnPoints().size())
            {
               RemoveTeam(servermap->SpawnPoints(spawnpoint).team);
               doremove = false;
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
      logout << "Player " << i << " overheated." << endl;
      logout << serverplayers[i].temperature << endl;
   }

   // Powered down?
   bool powereddown = (serverplayers[i].powerdowntime > 0);
   serverplayers[i].powerdowntime -= ticks; // Reuse lastcoolingtick
   if (serverplayers[i].powerdowntime <= 0)
   {
      serverplayers[i].powerdowntime = 0;
      if (powereddown)
      {
         for (int j = 0; j < numbodyparts; ++j)
         {
            if (serverplayers[i].hp[j] > 0)
            {
               int maxhp = units[serverplayers[i].unit].maxhp[j];
               serverplayers[i].hp[j] += maxhp * 3 / 4;
               if (serverplayers[i].hp[j] > maxhp)
                  serverplayers[i].hp[j] = maxhp;
            }
         }
      }
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
      RewindPlayer(serverplayers[i].ping, i);
      Vector3 startpos = serverplayers[i].pos;
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

      RewindPlayer(0, i);
   }
}


ServerState& GetState(Uint32 ticks)
{
   Uint32 currtick = SDL_GetTicks();

   // Remove states older than 500 ms
   while (oldstate.size() && currtick - oldstate[0].tick > 3000)
   {
      oldstate.pop_front();
   }

   if (!oldstate.size())
   {
      logout << "Error: GetState ran out of states" << endl;
      oldstate.push_back(ServerState(0));
   }

   // Search backwards through our old states.  Stop at 0 and use that if we don't have a state old enough
   size_t i;
   for (i = oldstate.size() - 1; i > 0; --i)
   {
      if (currtick - oldstate[i].tick >= ticks) break;
   }

   return oldstate[i];
}



// Only rewinds meshes that fall within the cylinder defined by start, end, and radius
void Rewind(Uint32 ticks, const Vector3& start, const Vector3& end, const float radius)
{
   if (!oldstate.size()) return;

   ServerState& state = GetState(ticks);

   Vector3 move = end - start;
   float movemaginv = 1.f / start.distance(end);
   size_t rewindcounter = 0;
   for (size_t j = 0; j < state.index.size(); ++j)
   {
      size_t p = state.index[j];
      if (serverplayers[p].spawned)
      {
         for (size_t k = 0; k < numbodyparts; ++k)
         {
            if (coldet.DistanceBetweenPointAndLine(state.position[j][k], start, move, movemaginv) < radius + state.size[j][k] &&
               serverplayers[p].hp[k] > 0)
            {
               ++rewindcounter;
               serverplayers[p].mesh[k]->SetState(state.position[j][k], state.rots[j][k],
                                             state.frame[j][k], state.animtime[j][k],
                                             state.animspeed[j][k]);
            }
         }
      }
   }
}

// Rewind all to 0
void Rewind()
{
   Rewind(0, Vector3(0.f, -1e38f, 0.f), Vector3(0.f, 1e38f, 0.f), 1e38f);
}

void RewindPlayer(Uint32 ticks, size_t p)
{
   if (!oldstate.size()) return;

   if (serverplayers[p].spawned)
   {
      ServerState& state = GetState(ticks);

      bool found = false;
      size_t j = 0;
      for (; j < state.index.size(); ++j)
      {
         if (state.index[j] == p)
         {
            found = true;
            break;
         }
      }
      if (!found)
         return;

      for (size_t k = 0; k < numbodyparts; ++k)
      {
         if (serverplayers[p].hp[k] > 0)
            serverplayers[p].mesh[k]->SetState(state.position[j][k], state.rots[j][k],
                                               state.frame[j][k], state.animtime[j][k],
                                               state.animspeed[j][k]);
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
                                             -std::max(serverplayers[i].size, serverplayers[j].size),
                                             check,
                                             servermap,
                                             NULL);

            visible[i][j] = hit ? 0 : 1;
            visible[j][i] = visible[i][j]; // If j is visible to i, then the reverse should also be true
         }
      }
   }
}


void GenPathData()
{
   float step = servermap->PathNodeSize();
   float checkdist = servermap->PathNodeCheckDist();
   size_t width = servermap->Width();
   size_t height = servermap->Height();

   Vector3 base(step / 2.f, -1000.f, step / 2.f);
   Vector3 start(base);
   start.y = servermap->MaxHeight() + step;

   vector<Mesh*> check = serverkdtree.getmeshes(start, base, step / 2.f);
   Vector3 hitpos;
   Mesh* dummy;
   coldet.CheckSphereHit(start,
                         base,
                         step / 2.f,
                         check,
                         servermap,
                         hitpos,
                         dummy);
   base.y = hitpos.y;

   pathnodes.push_back(PathNodePtr(new PathNode(base)));
   size_t i = 0;
   bool hit = false;
   while (i < pathnodes.size())
   {
      logout << "Processing " << i << " out of approximately " << (float(width) / step * (float(height) / step)) << endl;
      Vector3vec add = pathnodes[i]->GetAdjacent(step);
      pathnodes[i]->step = step;
      for (size_t j = 0; j < add.size(); ++j)
      {
         if (add[j].x > 0 && add[j].x < width &&
             add[j].z > 0 && add[j].z < height)
         {
            base = start = add[j];
            base.y = 0;
            hit = false;
            while (!hit)
            {
               start.y += checkdist;

               check = serverkdtree.getmeshes(start, base, step / 2.f);
               hit = coldet.CheckSphereHit(start,
                                          base,
                                          step / 2.f,
                                          check,
                                          servermap,
                                          hitpos,
                                          dummy);
            }
            add[j].y = hitpos.y;

            bool addnew = true;
            for (size_t k = 0; k < pathnodes.size(); ++k)
            {
               if (pathnodes[k]->position.distance2(add[j]) < 10.f)
               {
                  pathnodes[i]->nodes[j] = pathnodes[k];
                  pathnodes[i]->num[j] = k;
                  addnew = false;
               }
               // Useful for debugging problems with nodes not lining up when they should
               /*Vector3 one = pathnodes[k]->position;
               Vector3 two = add[j];
               one.y = two.y = 0.f;
               if (one.distance2(two) < 10.f && addnew)
                  logout << pathnodes[k]->position << "  " << add[j] << endl;*/
            }

            if (addnew)
            {
               pathnodes.push_back(PathNodePtr(new PathNode(add[j])));
               pathnodes[i]->nodes[j] = pathnodes.back();
               pathnodes[i]->num[j] = pathnodes.size() - 1;
            }
         }
      }
      ++i;
   }

   // Determine whether nodes are passable
   for (i = 0; i < pathnodes.size(); ++i)
   {
      PathNodePtr curr = pathnodes[i];
      Vector3 flatcurr = curr->position;
      flatcurr.y = 0;
      for (size_t j = 0; j < curr->nodes.size(); ++j)
      {
         Vector3 flatcheck;
         float ratio = 1.f;
         if (curr->nodes[j])
         {
            flatcheck = curr->nodes[j]->position;
            flatcheck.y = 0;
            ratio = flatcheck.distance(flatcurr) / step;
         }
         if (curr->nodes[j] && (curr->position.y > curr->nodes[j]->position.y - step * .75f * ratio)) // This may need tweaking
         {
            curr->passable[j] = true;
         }
      }
   }

   // Write results to file so we don't have to do this again
   ofstream out(servermap->PathName().c_str());
   out << "FileVersion " << aipathversion << endl;
   out << "Step " << step << endl;
   for (i = 0; i < pathnodes.size(); ++i)
   {
      out << i << endl;
      Vector3 p = pathnodes[i]->position;
      out << "   Pos " << p.x << " " << p.y << " " << p.z << endl;
      out << "   Nodes";
      for (size_t j = 0; j < pathnodes[i]->nodes.size(); ++j)
      {
         out << " " << pathnodes[i]->num[j];
      }
      out << endl << "   Passable";
      for (size_t j = 0; j < pathnodes[i]->nodes.size(); ++j)
      {
         out << " " << pathnodes[i]->passable[j];
      }
      out << endl;
   }
}


bool LoadPathData()
{
   NTreeReader reader(servermap->PathName());
   if (reader.Error())
      return false;

   int version = 0;
   reader.Read(version, "FileVersion");
   if (version != aipathversion)
   {
      logout << "Wrong AI path version for " << servermap->PathName() << endl;
      return false;
   }
   float step = 0.f;
   reader.Read(step, "Step");

   pathnodes.clear();
   for (size_t i = 0; i < reader.NumChildren(); ++i)
   {
      const NTreeReader& curr = reader(i);
      Vector3 pos;
      curr.Read(pos.x, "Pos", 0);
      curr.Read(pos.y, "Pos", 1);
      curr.Read(pos.z, "Pos", 2);

      PathNodePtr p(new PathNode(pos));
      p->step = step;
      for (size_t j = 0; j < p->nodes.size(); ++j)
      {
         bool passable = false;
         curr.Read(passable, "Passable", j);
         p->passable[j] = passable;
         curr.Read(p->num[j], "Nodes", j);
      }
      pathnodes.push_back(p);
   }

   for (size_t i = 0; i < pathnodes.size(); ++i)
   {
      for (size_t j = 0; j < pathnodes[i]->nodes.size(); ++j)
      {
         if (pathnodes[i]->num[j] >= 0)
            pathnodes[i]->nodes[j] = pathnodes[pathnodes[i]->num[j]];
      }
   }
   return true;
}
