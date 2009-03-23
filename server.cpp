// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
/* Gets started as a separate thread whenever it is requested to start
   a server from the main progam file.*/

#include <list>
#include <queue>
#include <sstream>
#include <string>
#include <vector>
#include <deque>
#ifndef WIN32
#include <poll.h>
#else
#include <Winsock2.h>
#endif
#include "Particle.h"
#include "SDL_net.h"
#include "PlayerData.h"
#include "Vector3.h"
#include "Packet.h"
#include "ObjectKDTree.h"
#include "CollisionDetection.h"
#include "ProceduralTree.h"
#include "Timer.h"
#include "globals.h"
#include "netdefs.h"
#include "ServerState.h"
#include "IDGen.h"
#include "util.h"
#include "Bot.h"

// Necessary declarations
void ServerLoop();
int ServerSend(void*);
int ServerListen(void*);
int ServerInput(void*);
void ServerLoadMap();
void HandleHit(Particle&, vector<Mesh*>&, const Vector3&);
void SplashDamage(const Vector3&, const float, const float, const int, const bool teamdamage = false);
void ApplyDamage(Mesh*, const float, const int, const bool teamdamage = false);
void ServerUpdatePlayer(int);
void Rewind(int, const Vector3&, const Vector3&, const float);
void SaveState();
void AddItem(const Item&, int);
void SendItem(const Item&, const int);
vector<Item>::iterator RemoveItem(const vector<Item>::iterator&);
void SendKill(size_t, size_t);
void RemoveTeam(int);
void SendSyncPacket(PlayerData&, unsigned long);
void SendGameOver(PlayerData&, int);
void SendShot(const Particle&);
void SendHit(const Vector3&, const Particle& p);
void SendDamage(const int);
void SendRemove(PlayerData&, const int, const int);
string AddressToDD(Uint32);
void LoadMapList();
void Ack(unsigned long acknum, UDPpacket* inpack);
void KillPlayer(const int, const int);
int CountPlayers();

SDL_Thread* serversend;
SDL_Thread* serverlisten;
SDL_Thread* serverinput;
UDPsocket servsock;
vector<PlayerData> serverplayers;
list<Particle> servparticles;
vector<Item> serveritems;
SDL_mutex* servermutex;
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

class SortableIPaddress
{
   public:
      //SortableIPaddress() : addr(INADDR_NONE){}
      SortableIPaddress(const IPaddress& a) : addr(a){}
      bool operator<(const SortableIPaddress& a) const
      {
         if (addr.host != a.addr.host) return addr.host < a.addr.host;
         return addr.port < a.addr.port;
      }
      
      IPaddress addr;
};

set<SortableIPaddress> validaddrs;

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
      console.Parse("set map newtest");
   LoadMapList();
   servermutex = SDL_CreateMutex();
   if (!(servsock = SDLNet_UDP_Open(console.GetInt("serverport"))))
   {
      logout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   ServerLoadMap();
   serversend = SDL_CreateThread(ServerSend, NULL);
   serverlisten = SDL_CreateThread(ServerListen, NULL);
   serverinput = SDL_CreateThread(ServerInput, NULL);
   
   ServerLoop();
   
   bots.clear();
   SDL_WaitThread(serversend, NULL);
   SDL_WaitThread(serverlisten, NULL);
   SDL_WaitThread(serverinput, NULL);
   SDLNet_UDP_Close(servsock);
   return 0;
}


// Make sure to unlock the mutex in between long operations so the other threads don't end up waiting on us
void ServerLoop()
{
   setsighandler();
   
   logout << "ServerLoop " << gettid() << endl;
   
   Uint32 currtick;
   bool doanimation = true;
   int checkmap = 0;
   Timer frametimer;
   frametimer.start();
   
   while (running)
   {
      SDL_Delay(1); // Otherwise if we turn off limitserverrate this will hog CPU
      if (console.GetBool("limitserverrate"))
      {
         while (frametimer.elapsed() < 1000 / servertickrate - 1)
            SDL_Delay(1);
      }
      frametimer.start();
      
      // Grabbing clientmutex can take a long time, so don't check every time through
      if (checkmap % 5 == 0)
      {
         SDL_mutexP(clientmutex); // Have to have clientmutex before touching mapname
         if ("maps/" + console.GetString("map") != mapname || (gameover && SDL_GetTicks() > nextmaptime)) // If the server changed maps load the new one
         {
            if (gameover && SDL_GetTicks() > nextmaptime)
            {
               srand(time(0));
               int choosemap = (int)Random(0, maplist.size());
               console.Parse("set map " + maplist[choosemap], false);
            }
            SDL_mutexV(clientmutex);
            ServerLoadMap();
            SDL_mutexP(clientmutex); // Avoid double unlock.  Necessary?  Eh.
         }
         SDL_mutexV(clientmutex);
      }
      checkmap = (checkmap + 1) % 5;
      
      SDL_mutexP(servermutex);
      for (int i = 1; i < serverplayers.size(); ++i)
      {
         currtick = SDL_GetTicks();
         if (serverplayers[i].connected && currtick > serverplayers[i].lastupdate + 30000)
         {
            validaddrs.erase(SortableIPaddress(serverplayers[i].addr));
            serverplayers[i].Disconnect();
            logout << "Player " << i << " timed out.\n" << flush;
         }
         else if (serverplayers[i].connected)
         {
            ServerUpdatePlayer(i);
         }
      }
      SDL_mutexV(servermutex);
         
      // Update server meshes
      if (doanimation)
      {
         SDL_mutexP(servermutex);
         for (Meshlist::iterator i = servermeshes.begin(); i != servermeshes.end(); ++i)
         {
            i->AdvanceAnimation();
         }
         SDL_mutexV(servermutex);
      }
      doanimation = !doanimation;
      
      SDL_mutexP(servermutex);
      // Save state so we can recall it for collision detection
      SaveState();
      SDL_mutexV(servermutex);
         
      // Update particles
      int updinterval = 100;
      SDL_mutexP(servermutex);
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
         
      SDL_mutexV(servermutex);
   }
}


int ServerListen(void* dummy)
{
   UDPpacket *inpack;
   unsigned long packetnum;
   string getdata;
   string packettype;
   float oppx, oppy, oppz;
   //float dummy;
   unsigned short oppnum;
   
   setsighandler();
   
   // Debugging
   Timer t;
   unsigned long runtimes = 0;
   
   if (!(inpack = SDLNet_AllocPacket(5000)))
   {
      logout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   logout << "ServerListen " << gettid() << endl;
   
   while (running)
   {
      ++runtimes;
      SDL_Delay(1); // Prevent CPU hogging
      
      /* While loop FTW!  (showing my noobness to networking, I was only allowing it to process one
         packet per outer loop, which meant it did the entire ~20 ms particle/player update
         process between every single packet it received.  Needless to say, this caused serious
         ping problems.)
      
         Note: Having this blindly loop as long as there are packets could cause problems under
         extremely heavy network loads.  It remains to be seen whether that's actually an issue
         (or whether the server would be usable under such circumstances, loop or not)
      */
      while (SDLNet_UDP_Recv(servsock, inpack))
      {
         getdata = (char*)inpack->data;
         stringstream get(getdata);
         
         string debug = getdata;
         
         get >> packettype;
         get >> packetnum;
         
         // Packet from an address that is not connected.  Inform them that they need to connect.
         if (packettype != "C" && packettype != "i" && validaddrs.find(SortableIPaddress(inpack->address)) == validaddrs.end())
         {
            Packet p(&inpack->address);
            p << "C\n";
            p << 0 << eol;
            
            SDL_mutexP(servermutex);
            servqueue.push_back(p);
            SDL_mutexV(servermutex);
            continue;
         }
         
         for (size_t i = 1; i < serverplayers.size(); ++i)
         {
            if (serverplayers[i].addr.host == inpack->address.host &&
               serverplayers[i].addr.port == inpack->address.port)
            {
               //logout << "Packet " << packettype << " " << packetnum << " from " << i << endl;
               oppnum = i;
               break;
            }
         }
         
         if (packettype == "U") // Update packet
         {
            SDL_mutexP(servermutex);
            if (oppnum < serverplayers.size() && (packetnum > serverplayers[oppnum].recpacketnum))  // Ignore out of order packets
            {
               serverplayers[oppnum].recpacketnum = packetnum;
               get >> oppx >> oppy >> oppz;
               get >> serverplayers[oppnum].rotation;
               get >> serverplayers[oppnum].pitch;
               get >> serverplayers[oppnum].roll;
               get >> serverplayers[oppnum].facing;//dummy; // We tell them their facing now Edit: or not
               get >> serverplayers[oppnum].moveforward;
               get >> serverplayers[oppnum].moveback;
               get >> dummy;//serverplayers[oppnum].moveleft;
               get >> dummy;//serverplayers[oppnum].moveright;
               get >> serverplayers[oppnum].leftclick;
               get >> serverplayers[oppnum].rightclick;
               get >> serverplayers[oppnum].run;
               get >> serverplayers[oppnum].unit;
               get >> serverplayers[oppnum].currweapon;
               serverplayers[oppnum].clientpos.x = oppx; // Keep track of where the player thinks they are
               serverplayers[oppnum].clientpos.y = oppy;
               serverplayers[oppnum].clientpos.z = oppz;
               serverplayers[oppnum].lastupdate = SDL_GetTicks();
               
               //logout << oppx << "  " << oppy << "  " << oppz << endl << flush;
               
               // Freak out if we get a packet whose checksum isn't right
               unsigned long value = 0;
               for (int i = 0; i < debug.length(); ++i)
               {
                  if (debug[i] == '&')
                     break;
                  value += (char)(debug[i]);
               }
               string dummy;
               get >> dummy;
               int checksum;
               get >> checksum;
               if (checksum != value)
               {
                  logout << "Freaking out on packet " << packetnum << endl;
                  logout << debug << endl;
                  logout << checksum << "  " << value << endl;
               }
            }
            SDL_mutexV(servermutex);
         }
         else if (packettype == "C")
         {
            short unit;
            string name;
            int clientver;
            get >> unit;
            get.ignore();
            getline(get, name);
            get >> clientver;
            bool add = true;
            int respondto = 0;
            SDL_mutexP(servermutex);
            
            if (CountPlayers() < maxplayers && clientver == netver)
            {
               for (int i = 1; i < serverplayers.size(); ++i)
               {
                  if (serverplayers[i].addr.host == inpack->address.host && serverplayers[i].addr.port == inpack->address.port)
                  {
                     respondto = i;
                     add = false;
                  }
               }
               if (add)
               {
                  PlayerData temp(servermeshes);
                  temp.addr = inpack->address;
                  temp.unit = unit;
                  temp.acked.insert(packetnum);
                  temp.salvage = console.GetInt("startsalvage");
                  UpdatePlayerModel(temp, servermeshes, false);
                  
                  serverplayers.push_back(temp);
                  respondto = serverplayers.size() - 1;
                  validaddrs.insert(SortableIPaddress(inpack->address));
                  
                  // Choose a team for them
                  vector<int> teamcount(2, 0);
                  for (size_t i = 1; i < serverplayers.size(); ++i)
                  {
                     if (serverplayers[i].team != 0 && serverplayers[i].connected)
                        ++teamcount[serverplayers[i].team - 1];
                  }
                  logout << teamcount[0] << " " << teamcount[1] << endl;
                  int newteam = teamcount[0] > teamcount[1] ? 2 : 1;
                  serverplayers[respondto].team = newteam;
               }
               
               if (!serverplayers[respondto].connected)
               {
                  serverplayers[respondto].lastupdate = SDL_GetTicks();
                  serverplayers[respondto].recpacketnum = packetnum;
                  validaddrs.erase(SortableIPaddress(serverplayers[respondto].addr));
                  serverplayers[respondto].addr = inpack->address;
                  validaddrs.insert(SortableIPaddress(serverplayers[respondto].addr));
                  serverplayers[respondto].needsync = true;
                  logout << "Player " << respondto << " connected\n" << flush;
               }
               serverplayers[respondto].connected = true;
               serverplayers[respondto].name = name;
               
               Packet fill;
               fill << "c\n";
               fill << packetnum << eol;
               fill << respondto << eol;
               fill << console.GetString("map") << eol;
               fill << serverplayers[respondto].team << eol;
               
               fill.addr = serverplayers[respondto].addr;
               servqueue.push_back(fill);
            }
            else
            {
               Packet respond(&inpack->address);
               respond << "f\n";
               respond << packetnum << eol;
               servqueue.push_back(respond);
            }
            
            SDL_mutexV(servermutex);
         }
         else if (packettype == "p")
         {
            SDL_mutexP(servermutex);
            serverplayers[oppnum].ping = SDL_GetTicks() - serverplayers[oppnum].pingtick;
            //logout << oppnum << " ping: " << serverplayers[oppnum].ping << endl;
            SDL_mutexV(servermutex);
         }
         else if (packettype == "i")
         {
            Packet response(&inpack->address);
            response << "i\n";
            response << 0 << eol; // Don't care about the packet number
            SDL_mutexP(servermutex);
            response << servername << eol;
            response << console.GetString("map") << eol;
            response << CountPlayers() << eol;
            response << maxplayers << eol;
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "S")
         {
            bool accepted = false;
            Vector3 spawnpointreq;
            
            logout << "Player " << oppnum << " is spawning" << endl;
            SDL_mutexP(servermutex);
            get >> serverplayers[oppnum].unit;
            int weapid;
            for (int i = 0; i < numbodyparts; ++i)
            {
               get >> weapid;
               serverplayers[oppnum].weapons[i] = Weapon(weapid);
            }
            int itemtype;
            get >> itemtype;
            serverplayers[oppnum].item = Item(itemtype, servermeshes);
            get >> spawnpointreq.x;
            get >> spawnpointreq.y;
            get >> spawnpointreq.z;
            
            // TODO: Make sure weight and salvage are legal
            vector<SpawnPointData> allspawns = spawnpoints;
            for (int i = 0; i < serveritems.size(); ++i)
            {
               if (serveritems[i].Type() == Item::SpawnPoint && serveritems[i].team == serverplayers[oppnum].team)
               {
                  string name = "Spawn " + ToString(i);
                  SpawnPointData sp;
                  sp.name = name;
                  sp.position = serveritems[i].mesh->GetPosition();
                  sp.team = serveritems[i].team;
                  allspawns.push_back(sp);
               }
            }
            for (size_t i = 0; i < allspawns.size(); ++i)
            {
               if (spawnpointreq.distance(allspawns[i].position) < 1.f && allspawns[i].team == serverplayers[oppnum].team)
               {
                  accepted = true;
                  break;
               }
            }
            
            // Make sure we don't spawn some place invalid
            vector<Mesh*> check;
            check = serverkdtree.getmeshes(spawnpointreq, spawnpointreq, 150.f);
            AppendDynamicMeshes(check, servermeshes);
            Vector3 checkvec;
            bool found = false;
            // Since this check isn't actually moving doing the extended collision checks is pointless
            if (coldet.CheckSphereHit(spawnpointreq, spawnpointreq, 49.f, check, false).distance2() > 1e-4f)
            {
               for (float ycheck = spawnpointreq.y; ycheck <= 10000.f; ycheck += 100.f)
               {
                  for (float xcheck = spawnpointreq.x - 100.f; xcheck <= spawnpointreq.x + 101.f; xcheck += 100.f)
                  {
                     for (float zcheck = spawnpointreq.z - 100.f; zcheck <= spawnpointreq.z + 101.f; zcheck += 100.f)
                     {
                        checkvec = Vector3(xcheck, ycheck, zcheck);
                        if (coldet.CheckSphereHit(checkvec, checkvec, 49.f, check, false).distance2() < 1e-4f && GetTerrainHeight(xcheck, zcheck) < ycheck - 1.f)
                        {
                           spawnpointreq = checkvec;
                           found = true;
                           break;
                        }
                     }
                     if (found)
                        break;
                  }
                  if (found)
                     break;
               }
            }
            
            if (serverplayers[oppnum].spawntimer)
               accepted = false;
            
            // Weight of weapons and items
            int maxweight = units[serverplayers[oppnum].unit].weight;
            int totalweight = 0;
            for (size_t i = 0; i < numbodyparts; ++i)
               totalweight += serverplayers[oppnum].weapons[i].Weight();
            totalweight += serverplayers[oppnum].item.Weight();
            
            if (totalweight > maxweight || CalculatePlayerWeight(serverplayers[oppnum]) > serverplayers[oppnum].salvage)
               accepted = false;
            
            if (accepted)
            {
               if (!serverplayers[oppnum].spawned)
               {
                  if (serverplayers[oppnum].team != 0)
                  {
                     serverplayers[oppnum].salvage -= CalculatePlayerWeight(serverplayers[oppnum]);
                     serverplayers[oppnum].spawned = true;
                  }
                  serverplayers[oppnum].pos = spawnpointreq;
                  serverplayers[oppnum].lastmovetick = 0;
                  serverplayers[oppnum].Reset();
                  for (int i = 0; i < numbodyparts; ++i)
                  {
                     serverplayers[oppnum].hp[i] = units[serverplayers[oppnum].unit].maxhp[i];
                     serverplayers[oppnum].weapons[i].ammo = int(float(serverplayers[oppnum].weapons[i].ammo) * serverplayers[oppnum].item.AmmoMult());
                  }
                  UpdatePlayerModel(serverplayers[oppnum], servermeshes, false);
                  for (size_t i = 0; i < numbodyparts; ++i)
                     serverplayers[oppnum].mesh[i]->AdvanceAnimation();
               }
            }
            
            Packet response(&inpack->address);
            response << "S\n";
            response << 0 << eol;
            if (accepted)
               response << 1 << eol;
            else response << 0 << eol;
            response << packetnum << eol;
            response << spawnpointreq.x << eol << spawnpointreq.y << eol << spawnpointreq.z << eol;
            
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "T")  // Chat packet
         {
            string line;
            bool team;
            get >> team;
            get.ignore(); // \n is still in buffer
            getline(get, line);
            SDL_mutexP(servermutex);
            if (serverplayers[oppnum].acked.find(packetnum) == serverplayers[oppnum].acked.end())
            {
               serverplayers[oppnum].acked.insert(packetnum);
               
               // Propogate that chat text to all other connected players
               for (int i = 1; i < serverplayers.size(); ++i)
               {
                  if (serverplayers[i].connected && i != oppnum && (!team || serverplayers[i].team == serverplayers[oppnum].team))
                  {
                     unsigned long packid = servsendpacketnum;
                     Packet temp;
                     temp.ack = packid;
                     temp << "T\n";
                     temp << packid << eol;
                     temp << oppnum << eol;
                     if (team)
                        temp << "[Team]";
                     temp << line << eol;
                     temp.addr = serverplayers[i].addr;
                     servqueue.push_back(temp);
                  }
               }
            }
            SDL_mutexV(servermutex);
            Ack(packetnum, inpack);
         }
         else if (packettype == "A")  // Ack
         {
            unsigned long acknum;
            get >> acknum;
            SDL_mutexP(servermutex);
            for (list<Packet>::iterator i = servqueue.begin(); i != servqueue.end(); ++i)
            {
               if (i->ack == acknum)
               {
                  servqueue.erase(i);
                  break;
               }
            }
            SDL_mutexV(servermutex);
         }
         else if (packettype == "M")  // Team switch request
         {
            // For the moment just ack it, we probably want to ensure even teams at some point
            short newteam;
            get >> newteam;
            
            Packet response(&inpack->address);
            response << "M\n";
            response << servsendpacketnum << eol;
            response << packetnum << eol;
            response << 1 << eol;
            response << newteam << eol;
            SDL_mutexP(servermutex);
            serverplayers[oppnum].team = newteam;
            for (int i = 0; i < spawnpoints.size(); ++i)
            {
               if ((spawnpoints[i].team == serverplayers[oppnum].team) || serverplayers[oppnum].team == 0)
               {
                  response << "1\n"; // Indicate that there are more spawn points to be read
                  response << spawnpoints[i].position.x << eol;
                  response << spawnpoints[i].position.y << eol;
                  response << spawnpoints[i].position.z << eol;
                  response << spawnpoints[i].name << eol;
               }
            }
            response << 0 << eol; // No more spawn points
            
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "I") // Player wants to use item
         {
            SDL_mutexP(servermutex);
            if (serverplayers[oppnum].item.usesleft > 0)
            {
               AddItem(serverplayers[oppnum].item, oppnum);
               serverplayers[oppnum].item.usesleft--;
            }
            SDL_mutexV(servermutex);
            Ack(packetnum, inpack);
         }
         else if (packettype == "K")
         {
            SDL_mutexP(servermutex);
            if (serverplayers[oppnum].spawned)
            {
               serverplayers[oppnum].spawned = false;
               serverplayers[oppnum].Kill();
               SendKill(oppnum, oppnum);
            }
            SDL_mutexV(servermutex);
            Ack(packetnum, inpack);
         }
         else if (packettype == "Y") // Client is ready to sync
         {
            SDL_mutexP(servermutex);
            if (serverplayers[oppnum].needsync)
            {
               logout << "Syncing with " << oppnum << endl;
               SendSyncPacket(serverplayers[oppnum], packetnum);
               for (size_t i = 0; i < serveritems.size(); ++i)
                  SendItem(serveritems[i], oppnum);
               serverplayers[oppnum].needsync = false;
            }
            SDL_mutexV(servermutex);
         }
         else if (packettype == "P") // Powerdown - be careful, we send this type as a ping packet, but don't receive it
         {
            SDL_mutexP(servermutex);
            // Note: Theoretically this could cause someone to accidentally power down when they don't
            // want to, but if their packets are delayed 5+ seconds then the game is probably not
            // playable anyway.  I suppose a single packet could for some reason get delayed, but
            // we'll see if that's actually a realistic problem.
            if (!serverplayers[oppnum].powerdowntime)
            {
               serverplayers[oppnum].powerdowntime = 5000;
               for (int i = 0; i < numbodyparts; ++i)
               {
                  if (serverplayers[oppnum].hp[i] > 0)
                  {
                     int maxhp = units[serverplayers[oppnum].unit].maxhp[i];
                     serverplayers[oppnum].hp[i] += maxhp * 3 / 4;
                     if (serverplayers[oppnum].hp[i] > maxhp)
                        serverplayers[oppnum].hp[i] = maxhp;
                  }
               }
            }
            SDL_mutexV(servermutex);
            Ack(packetnum, inpack);
         }
         else if (packettype == "c") // Console command
         {
            SDL_mutexP(servermutex);
            if (serverplayers[oppnum].commandids.find(packetnum) == serverplayers[oppnum].commandids.end() && serverplayers[oppnum].admin)
            {
               serverplayers[oppnum].commandids.insert(packetnum);
               SDL_mutexV(servermutex); // Don't hold two mutexes at a time
               string command;
               get.ignore();
               getline(get, command);
               SDL_mutexP(clientmutex);
               console.Parse(command, false);
               SDL_mutexV(clientmutex);
               SDL_mutexP(servermutex);
               for (size_t i = 0; i < serverplayers.size(); ++i)
                  SendSyncPacket(serverplayers[i], 0);
               
            }
            else if (!serverplayers[oppnum].admin)
            {
               logout << "Command received from non-admin player" << endl;
            }
            SDL_mutexV(servermutex);
            Ack(packetnum, inpack);
         }
         else if (packettype == "f") // Fire request
         {
            SDL_mutexP(servermutex);
            if (serverplayers[oppnum].fireids.find(packetnum) == serverplayers[oppnum].fireids.end())
            {
               serverplayers[oppnum].fireids.insert(packetnum);
               serverplayers[oppnum].firerequests++;
            }
            SDL_mutexV(servermutex);
            Ack(packetnum, inpack);
         }
         else if (packettype == "t") // Authenticate admin
         {
            string password;
            get >> password;
            SDL_mutexP(servermutex);
            if (password == console.GetString("serverpwd"))
            {
               if (!serverplayers[oppnum].admin)
                  logout << "Player " << oppnum << " authenticated from " << AddressToDD(inpack->address.host) << endl;
               serverplayers[oppnum].admin = true;
            }
            else
            {
               logout << "Password incorrect" << endl;
            }
            SDL_mutexV(servermutex);
            Ack(packetnum, inpack);
         }
      }
      //t.stop();
   }
   
   logout << "Server Listen " << runtimes << endl;
   
   // Clean up
   SDLNet_FreePacket(inpack);
}


int ServerSend(void* dummy)  // Thread for sending updates
{
   Uint32 lastnettick = SDL_GetTicks();
   Uint32 currnettick = 0;
   short int pingtick = 0;
   UDPsocket broadcastsock;
   Timer frametimer;
   frametimer.start();
   
   setsighandler();
   
   // Debugging
   Timer t;
   unsigned long runtimes = 0;
   
   if (!(servoutpack = SDLNet_AllocPacket(5000)))  // 5000 is arbitrary at this point
   {
      logout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   if (!(broadcastsock = SDLNet_UDP_Open(0)))
   {
      logout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   logout << "ServerSend " << gettid() << endl;
   
   while (running)
   {
      ++runtimes;
      t.start();
      SDL_Delay(1);  // Keep the loop from eating too much CPU
      frametimer.start();
      
      currnettick = SDL_GetTicks();
      if (currnettick - lastnettick >= 1000 / servertickrate)
      {
         lastnettick = currnettick;
         // Send out an update packet
         Packet temp;
   
         temp << "U" << eol;
         temp << servsendpacketnum << eol;
         SDL_mutexP(servermutex);
         for (int i = 1; i < serverplayers.size(); ++i)
         {
            temp << i << eol;
            temp << serverplayers[i].spawned << eol;
            if (serverplayers[i].spawned)
            {
               temp << serverplayers[i].pos.x << eol;
               temp << serverplayers[i].pos.y << eol;
               temp << serverplayers[i].pos.z << eol;
               temp << serverplayers[i].rotation << eol;
               temp << serverplayers[i].pitch << eol;
               temp << serverplayers[i].roll << eol;
               temp << serverplayers[i].facing << eol;
               temp << serverplayers[i].temperature << eol;
               temp << serverplayers[i].moveforward << eol;
               temp << serverplayers[i].moveback << eol;
               temp << serverplayers[i].moveleft << eol;
               temp << serverplayers[i].moveright << eol;
               temp << serverplayers[i].speed << eol;
               temp << serverplayers[i].powerdowntime << eol; // This may not belong here
            }
         }
         temp << 0 << eol; // Indicates end of player data
         
         SDL_mutexV(servermutex);
         
         // Quick and dirty checksumming
         unsigned long value = 0;
         for (int i = 0; i < temp.data.length(); ++i)
         {
            value += (char)(temp.data[i]);
         }
         temp << "&\n";
         temp << value << eol;
         
         // Add updates to send queue
         if (temp.data.length() < 5000)
         {
            SDL_mutexP(servermutex);
            for (int i = 1; i < serverplayers.size(); ++i)
            {
               if (serverplayers[i].connected)
               {
                  temp.addr = serverplayers[i].addr;
                  servqueue.push_back(temp);
               }
            }
            SDL_mutexV(servermutex);
         }
         else logout << "Error: data too long\n" << flush;
         
         // Send pings to monitor network performance
         // Also use this opportunity to send occasional updates
         pingtick++;
         if (pingtick > 30)
         {
            Packet pingpack;
            
            pingpack << "P\n";
            pingpack << servsendpacketnum << eol;
            SDL_mutexP(servermutex);
            for (int i = 1; i < serverplayers.size(); ++i)
            {
               if (serverplayers[i].connected)
               {
                  pingpack.addr = serverplayers[i].addr;
                  servqueue.push_back(pingpack);
                  serverplayers[i].pingtick = SDL_GetTicks();
               }
            }
            pingtick = 0;
            
            // Occasional update packet
            Packet occup;
            
            occup << "u\n";
            occup << servsendpacketnum << eol;
            occup << servfps << eol;
            for (int i = 1; i < serverplayers.size(); ++i)
            {
               if (serverplayers[i].connected)
               {
                  occup << i << eol;
                  occup << serverplayers[i].team << eol;
                  occup << serverplayers[i].unit << eol;
                  occup << serverplayers[i].kills << eol;
                  occup << serverplayers[i].deaths << eol;
                  for (int j = 0; j < numbodyparts; ++j)
                     occup << serverplayers[i].hp[j] << eol;
                  occup << serverplayers[i].ping << eol;
                  occup << serverplayers[i].spawned << eol;
                  occup << serverplayers[i].name << eol;
                  occup << serverplayers[i].salvage << eol;
                  occup << serverplayers[i].spawntimer << eol;
               }
            }
            occup << 0 << eol;
            for (int i = 1; i < serverplayers.size(); ++i)
            {
               if (serverplayers[i].connected)
               {
                  occup.addr = serverplayers[i].addr;
                  servqueue.push_back(occup);
               }
            }
            
            // Broadcast announcement packets to the subnet for LAN servers
            IPaddress bc;
            bc.host = INADDR_BROADCAST;
            SDLNet_Write16(12011, &(bc.port));
            Packet bcpack(&bc);
            bcpack << "a\n";
            bcpack << servsendpacketnum << eol;
            bcpack << console.GetString("serverport") << eol;
            bcpack.Send(servoutpack, broadcastsock);
            
            // Resend to just master server
            SDLNet_ResolveHost(&bcpack.addr, console.GetString("master").c_str(), 12011); 
            bcpack.Send(servoutpack, servsock);
            
            SDL_mutexV(servermutex);
         }
      }
      
      SDL_mutexP(servermutex);
      list<Packet>::iterator i = servqueue.begin();
      while (i != servqueue.end())
      {
         if (i->sendtick <= currnettick)
         {
            i->Send(servoutpack, servsock);
            if (!i->ack || i->attempts > 5000) // Non-ack packets get sent once and then are on their own
            {
               i = servqueue.erase(i);
               continue;
            }
         }
         ++i;
      }
      SDL_mutexV(servermutex);
      //t.stop();
   }
   logout << "Server Send " << runtimes << endl;
   return 0;
}


// Unfortunately SDL_Image is not thread safe, so we have to signal the main thread to do this
void ServerLoadMap()
{
   serverhasmap = 0;
   SDL_mutexP(clientmutex);
   nextmap = "maps/" + console.GetString("map");
   mapname = "";
   SDL_mutexV(clientmutex);
   // I suspect that this while loop is no longer necessary because getmap locks the clientmutex
   // until it's done running, so waiting on that is sufficient.
   while ((SDL_mutexP(clientmutex) == 0) && mapname != nextmap && (SDL_mutexV(clientmutex) == 0))
   {
      SDL_Delay(1); // Wait for main thread to load map
   }
   SDL_mutexV(clientmutex);
   
   SDL_mutexP(servermutex); // Grab this so the send thread doesn't do something funny on us
   servermeshes = meshes;
   
   serveritems.clear();
   
   serverplayers.clear();
   PlayerData local(servermeshes); // Dummy placeholder for the local player
   serverplayers.push_back(local);
   validaddrs.clear();
   
   servparticles.clear();
   
   // Generate main base items
   for (int i = 0; i < spawnpoints.size(); ++i)
   {
      Item newitem(Item::Base, servermeshes);
      MeshPtr newmesh = meshcache->GetNewMesh(newitem.ModelFile());
      newmesh->Move(spawnpoints[i].position);
      servermeshes.push_front(*newmesh);
      serveritems.push_back(newitem);
      Item& curritem = serveritems.back();
      curritem.mesh = servermeshes.begin();
      curritem.id = serveritemid;
      curritem.team = spawnpoints[i].team;
   }
   
   // Must be done here so it's available for KDTree creation
   for (Meshlist::iterator i = servermeshes.begin(); i != servermeshes.end(); ++i)
   {
      i->CalcBounds();
   }
   
   Vector3vec points(8, Vector3());
   for (int i = 0; i < 4; ++i)
   {
      points[i] = coldet.worldbounds[0].GetVertex(i);
   }
   for (int i = 0; i < 4; ++i)
   {
      points[i + 4] = coldet.worldbounds[5].GetVertex(i);
   }
   serverkdtree = ObjectKDTree(&servermeshes, points);
   serverkdtree.refine(0);
   
   logout << "Map loaded" << endl;
   serverhasmap = 1;
   gameover = 0;
   
   bots.clear();
   int numbots = console.GetInt("bots");
   for (size_t i = 0; i < numbots; ++i)
      bots.push_back(BotPtr(new Bot()));
   SDL_mutexV(servermutex);
}


// No need to grab the servermutex in this function because it is only called from code that already has the mutex
void HandleHit(Particle& p, vector<Mesh*>& hitobjs, const Vector3& hitpos)
{
   Mesh* curr;
   // 1e38 is near the maximum representable value for a single precision float
   float currmindist = 1e38f, currdist = 0.f;
   bool dead;
   // Should only hit each body part once per projectile
   sort(hitobjs.begin(), hitobjs.end());
   hitobjs.erase(unique(hitobjs.begin(), hitobjs.end()), hitobjs.end());
   // In fact, we should probably only hit a single object with a single shot, even if it
   // would have passed through multiple objects.  Eliminate all but the nearest one.
   // This may obsolete the above, but I suspect that's a quicker way to eliminate dupes
   // so I'm going to leave it.
   for (int j = 0; j < hitobjs.size(); ++j)
   {
      currdist = hitobjs[j]->GetPosition().distance2(p.origin);
      if (currdist < currmindist)
      {
         curr = hitobjs[j];
         currmindist = currdist;
      }
   }
   
   SendHit(hitpos, p);
   
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
   for (size_t i = 0; i < numlevels; ++i)
   {
      // Have to reget the meshes each time or we can end up checking removed ones
      check = serverkdtree.getmeshes(hitpos, hitpos, dmgrad);
      AppendDynamicMeshes(check, servermeshes);
      
      Mesh* dummymesh = NULL;
      Vector3 partcheck = coldet.CheckSphereHit(hitpos, hitpos, dmgrad * (float(i + 1) / float(numlevels)), check, dummy, dummymesh, &hitmeshes);
      sort(hitmeshes.begin(), hitmeshes.end());
      hitmeshes.erase(unique(hitmeshes.begin(), hitmeshes.end()), hitmeshes.end());
      
      for (vector<Mesh*>::iterator j = hitmeshes.begin(); j != hitmeshes.end(); ++j)
      {
         ApplyDamage(*j, damage / float(numlevels), playernum, teamdamage);
      }
   }
}


void ApplyDamage(Mesh* curr, const float damage, const int playernum, const bool teamdamage)
{
   bool dead;
   for (int i = 1; i < serverplayers.size(); ++i)
   {
      dead = false;
      for (int part = 0; part < numbodyparts; ++part)
      {
         if (serverplayers[i].mesh[part] != servermeshes.end())
         {
            if (curr == &(*serverplayers[i].mesh[part]) &&
                (serverplayers[i].team != serverplayers[playernum].team || i == playernum || teamdamage))
            {
               logout << "Hit " << part << endl;
               serverplayers[i].hp[part] -= int(damage * serverplayers[i].item.ArmorMult());
               SendDamage(i);
               if (serverplayers[i].hp[part] <= 0)
               {
                  if (part != LArm && part != RArm)
                     dead = true;
                  else
                  {
                     servermeshes.erase(serverplayers[i].mesh[part]);
                     serverplayers[i].mesh[part] = servermeshes.end();
                     for (size_t j = 1; j < serverplayers.size(); ++j)
                     {
                        SendRemove(serverplayers[j], i, part);
                     }
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
         logout << "Hit " << curr << endl;
         i->hp -= int(damage);
         if (i->hp < 0)
         {
            doremove = true;
            for (size_t j = 0; j < spawnpoints.size(); ++j)
            {
               if (&(*serveritems[j].mesh) == curr)
               {
                  RemoveTeam(spawnpoints[j].team);
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


// Note: must be called from within mutex'd code
void ServerUpdatePlayer(int i)
{
   // Cooling
   float coolrate = .01f;
   coolrate *= serverplayers[i].item.CoolMult();
   if (serverplayers[i].pos.y < serverplayers[i].size * 2.f)
      coolrate *= 1.5f;
   Uint32 ticks = SDL_GetTicks() - serverplayers[i].lastcoolingtick;
   serverplayers[i].lastcoolingtick += ticks;
   serverplayers[i].temperature -= ticks * coolrate;
   if (serverplayers[i].temperature < 0)
      serverplayers[i].temperature = 0;
   
   // Give them the benefit of the doubt and cool them before calculating overheating
   if (serverplayers[i].temperature > 100.f && serverplayers[i].spawned && console.GetBool("overheat"))
   {
      KillPlayer(i, i);
   }
   
   // Powered down?
   serverplayers[i].powerdowntime -= ticks; // Reuse lastcoolingtick
   if (serverplayers[i].powerdowntime <= 0)
   {
      serverplayers[i].powerdowntime = 0;
   }
   
   if (serverplayers[i].powerdowntime) return;
   
   // Update spawn timer
   serverplayers[i].spawntimer -= ticks;
   if (serverplayers[i].spawntimer < 0)
      serverplayers[i].spawntimer = 0;
   
   if (!serverplayers[i].spawned)
      return;
   
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
      Move(serverplayers[i], servermeshes, serverkdtree);
      //Rewind(0);
      UpdatePlayerModel(serverplayers[i], servermeshes, false);
   }
   
   // Shots fired!
   int weaponslot = weaponslots[serverplayers[i].currweapon];
   Weapon& currplayerweapon = serverplayers[i].weapons[weaponslot];
   while (serverplayers[i].firerequests && 
       (SDL_GetTicks() - serverplayers[i].lastfiretick[weaponslot] >= currplayerweapon.ReloadTime()) &&
       (currplayerweapon.ammo != 0) && serverplayers[i].hp[weaponslot] > 0)
   {
      serverplayers[i].firerequests--;
      /* Use the client position if it's within ten units of the serverpos.  This avoids the need to
      slide the player around as much because this way they see their shots going exactly where
      they expect, even if the positions don't match exactly (and they rarely will:-).*/
      Vector3 startpos = serverplayers[i].pos;
      if (serverplayers[i].pos.distance2(serverplayers[i].clientpos) < 100)
         startpos = serverplayers[i].clientpos;
      Vector3 rot(serverplayers[i].pitch, serverplayers[i].facing + serverplayers[i].rotation, 0.f);
      Vector3 offset = units[serverplayers[i].unit].weaponoffset[weaponslots[serverplayers[i].currweapon]];
      
      Particle part = CreateShot(currplayerweapon, rot, startpos, offset, i);
      part.rewind = serverplayers[i].ping;
      part.id = nextservparticleid;
      

      serverplayers[i].lastfiretick[weaponslot] = SDL_GetTicks();
      serverplayers[i].temperature += currplayerweapon.Heat();
      if (currplayerweapon.ammo > 0) // Negative ammo value indicates infinite ammo
         currplayerweapon.ammo--;
      
      servparticles.push_back(part);
      
      SendShot(part);
   }
}



// Only rewinds meshes that fall within the cylinder defined by start, end, and radius
void Rewind(int ticks, const Vector3& start, const Vector3& end, const float radius)
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
         newstate.Add(serverplayers[i], i);
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
   fd_set readfds;
   timeval timeout;
   FD_ZERO(&readfds);
   FD_SET(fileno(stdin), readfds);
   timeout.tv_sec = 1;
   timeout.tv_usec = 0;
#endif
   while (running)
   {
#ifndef WIN32
      if (poll(cinfd, 1, 1000))
#else
      if (select(1, &readfds, NULL, NULL, timeout))
#endif
      {
         getline(cin, command);
         console.Parse(command, false);
      }
   }
#endif
   return 0;
}


// Grab the servermutex before calling
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
            SendItem(curritem, i);
         }
      }
   }
}


// Grab the servermutex before calling
void SendItem(const Item& curritem, int oppnum)
{
   Packet p(&serverplayers[oppnum].addr);
   p.ack = servsendpacketnum;
   p << "I\n";
   p << p.ack << eol;
   p << curritem.Type() << eol;
   p << curritem.id << eol;
   Vector3 mpos = curritem.mesh->GetPosition();
   p << mpos.x << eol;
   p << mpos.y << eol;
   p << mpos.z << eol;
   p << curritem.team << eol;
      
   servqueue.push_back(p);
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


// Note: Must grab mutex first
void SendKill(size_t killed, size_t killer)
{
   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].connected)
      {
         Packet deadpacket;
         deadpacket.ack = servsendpacketnum;
         deadpacket.addr = serverplayers[i].addr;
                  
         deadpacket << "d\n";
         deadpacket << deadpacket.ack << eol; // This line is kind of strange looking, but it's okay
         deadpacket << killed << eol;
         deadpacket << killer << eol;
         servqueue.push_back(deadpacket);
      }
   }
}


// At this time just ends the game because only two teams are supported.  Will more be in the future?  Who knows.
// Must have mutex before calling this function
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
            SendGameOver(serverplayers[i], num == 1 ? 2 : 1);
         }
      }
   }
}


void SendSyncPacket(PlayerData& p, unsigned long packetnum)
{
   Packet pack(&p.addr);
   pack.ack = servsendpacketnum;
   pack << "Y\n";
   pack << pack.ack << eol;
   pack << packetnum << eol;
   pack << "set movestep " << console.GetInt("movestep") << eol;
   pack << "set ghost " << console.GetBool("ghost") << eol;
   pack << "set fly " << console.GetBool("fly") << eol;
   pack << "set tickrate " << console.GetInt("tickrate") << eol;
   pack << "endofcommands\n";
   
   servqueue.push_back(pack);
}


void SendGameOver(PlayerData& p, const int winner)
{
   Packet pack(&p.addr);
   pack.ack = servsendpacketnum;
   pack << "O\n";
   pack << pack.ack << eol;
   pack << winner << eol;
   
   servqueue.push_back(pack);
}


void SendShot(const Particle& p)
{
   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].connected && i != p.playernum)
      {
         Packet pack(&serverplayers[i].addr);
         pack.ack = servsendpacketnum;
         pack << "s\n";
         pack << pack.ack << eol;
         pack << p.id << eol;
         pack << p.weapid << eol;
         pack << p.pos.x << eol << p.pos.y << eol << p.pos.z << eol;
         pack << p.dir.x << eol << p.dir.y << eol << p.dir.z << eol;
         pack << p.playernum << eol;
         
         servqueue.push_back(pack);
      }
   }
}


void SendHit(const Vector3& hitpos, const Particle& p)
{
   unsigned long hid = nexthitid;
   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].connected)
      {
         Packet pack(&serverplayers[i].addr);
         pack.ack = servsendpacketnum;
         pack << "h\n";
         pack << pack.ack << eol;
         pack << hid << eol;
         pack << hitpos.x << eol << hitpos.y << eol << hitpos.z << eol;
         pack << p.weapid << eol;
         
         servqueue.push_back(pack);
      }
   }
}


void SendDamage(const int i)
{
   Packet pack(&serverplayers[i].addr);
   pack.ack = servsendpacketnum;
   pack << "D\n";
   pack << pack.ack << eol;
   
   servqueue.push_back(pack);
}


void SendRemove(PlayerData& p, const int i, const int part)
{
   Packet pack(&p.addr);
   pack.ack = servsendpacketnum;
   pack << "r\n";
   pack << pack.ack << eol;
   pack << i << eol;
   pack << part << eol;
   
   servqueue.push_back(pack);
}


void LoadMapList()
{
   IniReader readmaps("maps/maplist");
   
   for (size_t i = 0; i < readmaps.NumChildren(); ++i)
   {
      const IniReader& currmap = readmaps(i);
      string buffer;
      currmap.Read(buffer, "File");
      maplist.push_back(buffer);
   }
}


void Ack(unsigned long acknum, UDPpacket* inpack)
{
   Packet response(&inpack->address);
   response << "A\n";
   response << 0 << eol;
   response << acknum << eol;
   SDL_mutexP(servermutex);
   servqueue.push_back(response);
   SDL_mutexV(servermutex);
}


void KillPlayer(const int i, const int killer)
{
   serverplayers[i].deaths++;
   serverplayers[i].Kill();
   serverplayers[i].spawntimer = console.GetInt("respawntime");
   SendKill(i, killer);
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

