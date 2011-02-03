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


// Netcode

#include <iostream>
#include <sstream>
#include <vector>
#include <list>
#include <set>
#ifdef WIN32
#include <WinSock2.h>
#endif
#include "Particle.h"
#include <SDL/SDL.h>
#include <SDL/SDL_net.h>
#include "PlayerData.h"
#include "CollisionDetection.h"
#include "Packet.h"
#include "ServerInfo.h"
#include "types.h"
#include "gui/ComboBox.h"
#include "netdefs.h"
#include "globals.h"
#include "util.h"


int NetSend(void*);
int NetListen(void*);
string FillUpdatePacket();
string AddressToDD(Uint32);
void Ack(unsigned long);

// From actions.cpp
void Action(const string&);

list<Packet> sendqueue;
UDPsocket sock;
UDPpacket *outpack;
IPaddress addr;
// netmutex protects both the send queue and the socket shared by the send and receive threads
MutexPtr netmutex;
bool socketopen;

// Gets split off as a separate thread to handle sending network packets
int NetSend(void* dummy)
{
   Uint32 lastnettick = SDL_GetTicks();
   Uint32 currnettick = 0;
   Uint32 occpacketcounter = 0;
   changeteam = -1;
   
   setsighandler();
   
   // Debugging
   Timer t;
   unsigned long runtimes = 0;
   
   if (!(outpack = SDLNet_AllocPacket(5000))) // 65000 probably won't work
   {
      logout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   logout << "NetSend " << gettid() << endl;
   
   while (running)
   {
      ++runtimes;
      //t.start();
      /* If we allow this to be a very tight loop (which is what it will
      be since most of the iterations are going to skip this section), it
      kills the performance of the main thread so we do the delay to
      force it to give up CPU time.*/
      SDL_Delay(1);
      
      currnettick = SDL_GetTicks();
      if (currnettick - lastnettick >= 1000 / (Uint32)console.GetInt("tickrate"))
      {
         if (connected)
         {
            lastnettick = currnettick;
            Packet p(&addr);
            p << FillUpdatePacket();
            netmutex->lock();
            sendqueue.push_back(p);
            netmutex->unlock();
         }
         occpacketcounter++;
      }
      if (occpacketcounter > 100)
      {
         // Send a request for the server's information
         clientmutex->lock();
         vector<ServerInfo>::iterator i;
         for (i = servers.begin(); i != servers.end(); ++i)
         {
            Packet p(&i->address);
            p << "i\n";
            p << sendpacketnum;
            netmutex->lock();
            sendqueue.push_back(p);
            netmutex->unlock();
            i->tick = SDL_GetTicks();
         }
         clientmutex->unlock();
         occpacketcounter = 0;
      }
      if (doconnect)
      {
         // Get hostname for telling players at the same IP apart
         char hn[256];
         string hostname;
         if (gethostname(hn, 255) == 0)
         {
            hostname = hn;
         }
         else
         {
            hostname = "Failed"; // This is no big deal as long as it doesn't happen to two people from the same public IP
         }
         
         SDLNet_ResolveHost(&addr, console.GetString("serveraddr").c_str(), console.GetInt("serverport"));
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "C\n";
         p << p.ack << eol;
         p << hostname << eol;
         p << player[0].unit << eol;
         p << player[0].name << eol;
         p << netver << eol;
         netmutex->lock();
         sendqueue.push_back(p);
         netmutex->unlock();
         doconnect = false;
         logout << "Sending connect to " << console.GetString("serveraddr") << ":" << console.GetInt("serverport") << endl;
      }
      if (spawnrequest)
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "S\n";
         p << p.ack << eol;
         clientmutex->lock();
         p << player[0].unit << eol;
         for (int i = 0; i < numbodyparts; ++i)
         {
            p << player[0].weapons[i].Id() << eol;
         }
         p << player[0].item.Type() << eol;
         ComboBox *spawnpointsbox = (ComboBox*)gui[loadoutmenu]->GetWidget("SpawnPoints");
         int sel = spawnpointsbox->Selected();
         p << availablespawns[sel].position.x << eol;
         p << availablespawns[sel].position.y << eol;
         p << availablespawns[sel].position.z << eol;
         
         clientmutex->unlock();
         netmutex->lock();
         sendqueue.push_back(p);
         netmutex->unlock();
         spawnrequest = false;
      }
      clientmutex->lock();
      if (chatstring != "")
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "T\n";
         p << p.ack << eol;
         p << chatteam << eol;
         p << chatstring << eol;
         chatstring = "";
         clientmutex->unlock(); // Just to be safe, don't hold both mutexes at once
         netmutex->lock();
         sendqueue.push_back(p);
         netmutex->unlock();
      }
      clientmutex->unlock(); // Not sure a double unlock is allowed, but we'll see (so far so good)
      
      if (changeteam != -1)
      {
         logout << "Changing team " << endl;
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "M\n";
         p << p.ack << eol;
         p << changeteam << eol;
         netmutex->lock();
         sendqueue.push_back(p);
         netmutex->unlock();
         changeteam = -1;
      }
      if (useitem)
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "I\n";
         p << p.ack << eol;
         netmutex->lock();
         sendqueue.push_back(p);
         netmutex->unlock();
         useitem = false;
      }
      if (sendkill)
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "K\n";
         p << p.ack << eol;
         netmutex->lock();
         sendqueue.push_back(p);
         netmutex->unlock();
         sendkill = false;
      }
      if (needsync)
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "Y\n";
         p << p.ack << eol;
         netmutex->lock();
         sendqueue.push_back(p);
         netmutex->unlock();
         needsync = false;
      }
      if (sendloadout)
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "L\n";
         p << p.ack << eol;
         netmutex->lock();
         sendqueue.push_back(p);
         netmutex->unlock();
         sendloadout = 0;
      }
      
      
      netmutex->lock();
      list<Packet>::iterator i = sendqueue.begin();
      while (i != sendqueue.end())
      {
         if (i->sendtick <= currnettick)
         {
            i->Send(outpack, sock);
            if (!i->ack || i->attempts > 100000) // Non-ack packets get sent once and then are on their own
            {
               i = sendqueue.erase(i);
               continue;
            }
         }
         ++i;
      }
      netmutex->unlock();
      //t.stop();
   }
   
   logout << "NetSend " << runtimes << endl;
   SDLNet_FreePacket(outpack);
   return 0;
}


string FillUpdatePacket()
{
   stringstream temp;
   
   temp << "U" << eol;
   temp << sendpacketnum << eol;
   clientmutex->lock();
   temp << player[0].pos.x << eol;
   temp << player[0].pos.y << eol;
   temp << player[0].pos.z << eol;
   temp << player[0].rotation << eol;
   temp << player[0].pitch << eol;
   temp << player[0].roll << eol;
   temp << player[0].facing << eol;
   temp << player[0].moveforward << eol;
   temp << player[0].moveback << eol;
   temp << player[0].moveleft << eol;
   temp << player[0].moveright << eol;
   temp << player[0].leftclick << eol;
   temp << player[0].rightclick << eol;
   temp << player[0].run << eol;
   temp << player[0].unit << eol;
   temp << player[0].currweapon << eol;
   clientmutex->unlock();
   
   // Quick and dirty checksumming
   unsigned long value = 0;
   for (size_t i = 0; i < temp.str().length(); ++i)
   {
      value += (char)(temp.str()[i]);
   }
   temp << "&\n";
   temp << value << eol;
   return temp.str();
}


// Gets split off as a separate thread to handle receiving network packets
int NetListen(void* dummy)
{
   UDPpacket *inpack;
   IPaddress connectedaddr;
   unsigned int packetnum;
   float oppx, oppy, oppz;
   float opprot, opppitch, opproll, oppfacing;
   unsigned short oppnum;
   string getdata;
   string packettype;
   bool annlisten = true;
   lastsyncpacket = 0;
   
   connectedaddr.host = INADDR_NONE;
   connectedaddr.port = 0;
   
   setsighandler();
   
   // Just for announcement packets
   UDPsocket annsock;
   
   // Debugging
   Timer t;
   unsigned long runtimes = 0;
   
   netmutex = MutexPtr(new Mutex());
   
   // Note: This socket should be opened before the other, on the off chance that it would choose
   // this port.  No, I didn't learn that the hard way, but I did almost forget.
   if (!(annsock = SDLNet_UDP_Open(12011)))
   {
      logout << "Announce port SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      annlisten = false;
      //return -1;
   }
   
   if (!(sock = SDLNet_UDP_Open(0)))  // Use any open port
   {
      logout << "Listen SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   if (!(inpack = SDLNet_AllocPacket(5000)))
   {
      logout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   netout = SDL_CreateThread(NetSend, NULL); // Start send thread
   logout << "NetListen " << gettid() << endl;
   
   SendMasterListRequest();
   
   while (running)
   {
      ++runtimes;
      //t.start();
      SDL_Delay(1); // See comments for NetSend loop
      
      while ((netmutex->lock() == 0) &&
              SDLNet_UDP_Recv(sock, inpack) && 
              (netmutex->unlock() == 0))
      {
         getdata = (char*)inpack->data;
         stringstream get(getdata);
         
         string debug = getdata;
         
         get >> packettype;
         get >> packetnum;
         
         if (!connected && (packettype == "U" || packettype == "u")) // Causes problems on reconnect
            continue;
         if ((connectedaddr.host != inpack->address.host || connectedaddr.port != inpack->address.port) &&
              packettype != "c" && packettype != "f" && packettype != "i" && packettype != "a" && packettype != "v")
            continue;
         
         if (packettype == "U") // Update packet
         {
            if (packetnum > recpacketnum) // Ignore older out of order packets
            {
               recpacketnum = packetnum;
               oppnum = 0;
               clientmutex->lock();
               
               get >> oppnum;
               while (oppnum != 0)
               {
                  while (oppnum >= player.size())  // Add new player(s)
                  {
                     PlayerData dummy(meshes);
                     player.push_back(dummy);
                     logout << "Adding player " << (player.size() - 1) << endl;
                  }
                  get >> player[oppnum].spawned;
                  if (player[oppnum].spawned)
                  {
                     // It's not necessary to load these into buffers, but for debugging
                     // it's handy to.
                     get >> oppx >> oppy >> oppz;
                     get >> opprot;
                     player[oppnum].rotation = opprot;
                     get >> opppitch;
                     player[oppnum].pitch = opppitch;
                     get >> opproll;
                     player[oppnum].roll = opproll;
                     get >> oppfacing;
                     player[oppnum].facing = oppfacing;
                     get >> player[oppnum].temperature;
                     if (oppnum == servplayernum)
                        player[0].temperature = player[oppnum].temperature;
                     get >> player[oppnum].moveforward;
                     get >> player[oppnum].moveback;
                     get >> player[oppnum].moveleft;
                     get >> player[oppnum].moveright;
                     get >> player[oppnum].speed;
                     get >> player[oppnum].powerdowntime;
                     
                     player[oppnum].pos.x = oppx;
                     player[oppnum].pos.y = oppy;
                     player[oppnum].pos.z = oppz;
                     
                  }
                  get >> oppnum;
               }
               
               // Freak out if we get a packet whose checksum isn't right
               size_t value = 0;
               for (size_t i = 0; i < debug.length(); ++i)
               {
                  if (debug[i] == '&')
                     break;
                  value += (char)(debug[i]);
               }
               string dummy;
               get >> dummy;
               size_t checksum;
               get >> checksum;
               if (checksum != value)
               {
                  logout << "Client freaking out on packet " << packetnum << endl;
                  logout << checksum << endl << value << endl << dummy << endl;
                  logout << debug << endl;
               }
               
               // Indicate to main thread that models for unspawned players need to be removed
               bool addemitter;
               for (vector<PlayerData>::iterator i = player.begin(); i != player.end(); ++i)
               {
                  if (!i->spawned)
                  {
                     addemitter = false;
                     locks.Read(meshes);
                     for (int part = 0; part < numbodyparts; ++part)
                     {
                        if (i->mesh[part] != meshes.end())
                        {
                           deletemeshes.push_back(i->mesh[part]);
                           i->mesh[part] = meshes.end();
                           addemitter = true;
                        }
                     }
                     locks.EndRead(meshes);
                     if (addemitter)
                     {
                        ParticleEmitter newemitter("particles/emitters/explosion", resman);
                        newemitter.position = i->pos;
                        emitters.push_back(newemitter);
                     }
                     if (i->indicator)
                     {
                        i->indicator->ttl = 1;
                        i->indicator = NULL; // Oops, don't forget this!
                     }
                  }
               }
               
               // Adjust our position toward where the server thinks we are
               if (console.GetBool("serversync") && !player[0].spectate && player[0].spawned)
                  SynchronizePosition();
               clientmutex->unlock();
            }
         }
         else if (packettype == "u") // Occasional updates
         {
            if (packetnum > recpacketnum)
            {
               oppnum = 0;
               
               long temp;
               get >> temp;
               serverfps = temp;
               get >> temp;
               serverbps = temp;
               get >> oppnum;
               short getunit, getteam;
               int getkills, getdeaths, getsalvage, getspawntimer;
               vector<int> gethp(numbodyparts);
               int getping;
               bool getspawned, getconnected;
               string getname;
               clientmutex->lock();
               while (oppnum != 0)
               {
                  get >> getteam;
                  get >> getunit;
                  get >> getkills;
                  get >> getdeaths;
                  for (int i = 0; i < numbodyparts; ++i)
                     get >> gethp[i];
                  get >> getping;
                  get >> getspawned;
                  get >> getconnected;
                  get.ignore();
                  getline(get, getname);
                  get >> getsalvage;
                  get >> getspawntimer;
                  if (oppnum < player.size())
                  {
                     player[oppnum].team = getteam;
                     player[oppnum].unit = getunit; // Check that this hasn't changed?  Probably should, although it's unlikely anyone could respawn fast enough to cause problems.
                     player[oppnum].kills = getkills;
                     player[oppnum].deaths = getdeaths;
                     for (size_t i = 0; i < numbodyparts; ++i)
                        player[oppnum].hp[i] = gethp[i];
                     player[oppnum].ping = getping;
                     player[oppnum].spawned = getspawned;
                     player[oppnum].connected = getconnected;
                     player[oppnum].name = getname;
                     player[oppnum].salvage = getsalvage;
                     player[oppnum].spawntimer = getspawntimer;
                  }
                  get >> oppnum;
               }
               if (servplayernum < player.size())
               {
                  player[0].kills = player[servplayernum].kills;
                  player[0].deaths = player[servplayernum].deaths;
                  for (int i = 0; i < numbodyparts; ++i)
                     player[0].hp[i] = player[servplayernum].hp[i];
                  player[0].ping = player[servplayernum].ping;
                  player[0].salvage = player[servplayernum].salvage;
                  player[0].spawntimer = player[servplayernum].spawntimer;
                  if (gui[loadoutmenu]->visible)
                     Action("updateunitselection");
               }
               clientmutex->unlock();
            }
         }
         else if (packettype == "c") // Connect packet
         {
            if (!connected)
            {
               connectedaddr = inpack->address;
               clientmutex->lock();
               get >> servplayernum;
               get >> nextmap;
               long newteam;
               get >> newteam;
               changeteam = newteam;
               if (!server)
                  mapname = ""; // Force reload of the map even if same name
               nextmap = "maps/" + nextmap;
               doconnect = false;
               connected = true;
               logout << "We are server player " << servplayernum << endl;
               logout << "Map is: " << nextmap << endl;
               clientmutex->unlock();
               itemsreceived.clear();
               hitsreceived.clear();
            }
            HandleAck(packetnum);
         }
         else if (packettype == "f") // Server was full or our netcode doesn't match theirs
         {
            logout << "Error: Server is full or netcode version mismatch\n";
            clientmutex->lock();
            ShowGUI(mainmenu);
            clientmutex->unlock();
            HandleAck(packetnum);
         }
         else if (packettype == "P") // Ping
         {
            Packet p(&addr);
            p << "p\n";
            p << sendpacketnum << eol;
            netmutex->lock();
            sendqueue.push_back(p);
            netmutex->unlock();
         }
         else if (packettype == "s") // Shots
         {
            unsigned long id, weapid;
            
            get >> id;
            if (partids.find(id) == partids.end())
            {
               partids.insert(id);
               get >> weapid;
               Weapon dummy(weapid);
               size_t pnum;
               get >> pnum;
               clientmutex->lock();
               ClientCreateShot(player[pnum], dummy);
               recorder->AddShot(pnum, weapid);
               clientmutex->unlock();
            }
            Ack(packetnum);
         }
         else if (packettype == "h") // Hit
         {
            Vector3 hitpos;
            int type;
            unsigned long id;
            get >> id;
            if (hitsreceived.find(id) == hitsreceived.end())
            {
               hitsreceived.insert(id);
               get >> hitpos.x >> hitpos.y >> hitpos.z;
               get >> type;
               
               AddHit(hitpos, type);
               recorder->AddHit(hitpos, type);
            }
            
            Ack(packetnum);
         }
         else if (packettype == "D") // We were damaged
         {
            lasthit = SDL_GetTicks();
            Ack(packetnum);
         }
         else if (packettype == "i")  // Server info
         {
            vector<ServerInfo>::iterator i;
            clientmutex->lock();
            for (i = servers.begin(); i != servers.end(); ++i)
            {
               if (i->address.host == inpack->address.host)
               {
                  getline(get, i->name); // Need to do this twice to get off the previous line
                  getline(get, i->name);
                  getline(get, i->map);
                  get >> i->players;
                  get >> i->maxplayers;
                  i->ping = SDL_GetTicks() - i->tick;
                  i->haveinfo = true;
                  break;
               }
            }
            clientmutex->unlock();
         }
         else if (packettype == "S") // Spawn request ack
         {
            bool accepted;
            unsigned long acknum;
            Vector3 newpos;
            get >> accepted;
            get >> acknum;
            get >> newpos.x >> newpos.y >> newpos.z;
            
            clientmutex->lock();
            if (gui[loadoutmenu]->visible)
            {
               if (accepted)
               {
                  gui[loadoutmenu]->visible = false;
                  gui[hud]->visible = true;
                  player[0].pos = newpos;
                  player[0].size = units[player[0].unit].size;
                  player[0].lastmovetick = SDL_GetTicks();
                  if (player[0].team != 0)
                     player[0].spectate = false;
                  player[0].spawned = true;
                  player[0].Reset();
               }
               else
               {
                  logout << "Spawn request not accepted.  This is either a program error or you're hacking.  If the latter, shame on you.  If the former, shame on me." << endl;
               }
            }
            clientmutex->unlock();
            HandleAck(acknum);
         }
         else if (packettype == "A") // Ack packet
         {
            unsigned long acknum;
            get >> acknum;
            HandleAck(acknum);
         }
         else if (packettype == "T") // Text packet
         {
            clientmutex->lock();
            string line;
            get >> oppnum;
            if (oppnum < player.size())
            {
               if (player[oppnum].acked.find(packetnum) == player[oppnum].acked.end())
               {
                  player[oppnum].acked.insert(packetnum);
                  getline(get, line);
                  getline(get, line);
                  newchatlines.push_back(line);
                  newchatplayers.push_back(oppnum);
               }
               // Ack it
               Ack(packetnum); // Danger: this grabs the net mutex while we hold the clientmutex
            }
            clientmutex->unlock();
         }
         else if (packettype == "M") // Team change request
         {
            unsigned long acknum;
            bool accepted;
            short newteam;
            get >> acknum;
            HandleAck(acknum);
            get >> accepted;
            if (accepted)
            {
               get >> newteam;
               clientmutex->lock();
               if (player[0].team != newteam)
               {
                  logout << "Joined team " << newteam << endl;
                  player[0].team = newteam;
                  
                  mapspawns.clear();
                  bool morespawns;
                  SpawnPointData read;
                  while (get >> morespawns && morespawns)
                  {
                     get >> read.position.x >> read.position.y >> read.position.z;
                     get.ignore(); // Throw out \n
                     getline(get, read.name);
                     mapspawns.push_back(read);
                  }
                  spawnschanged = true;
               }
               
               Button* team1button = dynamic_cast<Button*>(gui[loadoutmenu]->GetWidget("Team1"));
               Button* team2button = dynamic_cast<Button*>(gui[loadoutmenu]->GetWidget("Team2"));
               Button* specbutton = dynamic_cast<Button*>(gui[loadoutmenu]->GetWidget("Spectate"));
               if (player[0].team == 1)
               {
                  team1button->togglestate = 1;
                  team2button->togglestate = 0;
                  specbutton->togglestate = 0;
               }
               else if (player[0].team == 2)
               {
                  team1button->togglestate = 0;
                  team2button->togglestate = 1;
                  specbutton->togglestate = 0;
               }
               else if (player[0].team == 0)
               {
                  team1button->togglestate = 0;
                  team2button->togglestate = 0;
                  specbutton->togglestate = 1;
               }
               clientmutex->unlock();
            }
         }
         else if (packettype == "m") // General server message
         {
            if (messagesreceived.find(packetnum) == messagesreceived.end())
            {
               messagesreceived.insert(packetnum);
               string message;
               get.ignore();
               getline(get, message);
               clientmutex->lock();
               servermessages.push_back(message);
               messageschanged = 1;
               clientmutex->unlock();
            }
            Ack(packetnum);
         }
         else if (packettype == "d") // Somebody died
         {
            if (killsreceived.find(packetnum) == killsreceived.end())
            {
               killsreceived.insert(packetnum);
               size_t killed, killer;
               get >> killed >> killer;
               
               clientmutex->lock();
               if (killed == servplayernum)
               {
                  player[0].weight = -1.f;
                  player[0].spectate = true;
                  player[0].spawned = false;
                  player[0].size = 5.f;
                  ResetKeys();
               }
               string message = player[killer].name + " killed " + player[killed].name;
               servermessages.push_back(message);
               messageschanged = 1;
               clientmutex->unlock();
            }
            // Ack it
            Ack(packetnum);
         }
         else if (packettype == "I") // Add item
         {
            Vector3 itempos;
            unsigned long id;
            int type, team;
            get >> type;
            get >> id;
            get >> itempos.x >> itempos.y >> itempos.z;
            get >> team;
            
            if (itemsreceived.find(id) == itemsreceived.end())
            {
               Item newitem(type, meshes);
               newitem.id = id;
               newitem.team = team;
               newitem.position = itempos;
               clientmutex->lock();
               additems.push_back(newitem);
               clientmutex->unlock();
               itemsreceived.insert(id);
            }
            Ack(packetnum);
         }
         else if (packettype == "R") // Remove item
         {
            unsigned long id;
            get >> id;
            for (vector<Item>::iterator i = items.begin(); i != items.end(); ++i)
            {
               if (i->id == id)
               {
                  clientmutex->lock();
                  deletemeshes.push_back(i->mesh);
                  items.erase(i);
                  spawnschanged = true;
                  clientmutex->unlock();
                  break;
               }
            }
            Ack(packetnum);
         }
         else if (packettype == "Y" && packetnum > lastsyncpacket) // Sync packet
         {
            unsigned long acknum;
            logout << "Got sync packet " << packetnum << endl;
            get >> acknum;
            HandleAck(acknum);
            lastsyncpacket = packetnum;
            string buffer;
            clientmutex->lock();
            while (getline(get, buffer) && buffer != "endofcommands")
            {
               console.Parse(buffer, false);
            }
            clientmutex->unlock();
            Ack(packetnum);
            needsync = false;
         }
         else if (packettype == "C")
         {
            connected = false;
            doconnect = true;
         }
         else if (packettype == "O") // Game over man, game over
         {
            long getteam;
            get >> getteam;
            winningteam = getteam;
            logout << "Team " << winningteam << " wins!" << endl;
            Ack(packetnum);
         }
         else if (packettype == "r") // Remove body part
         {
            size_t num, part;
            get >> num;
            get >> part;
            
            if (num == servplayernum)
               num = 0;
            
            clientmutex->lock();
            locks.Read(meshes);
            deletemeshes.push_back(player[num].mesh[part]);
            player[num].mesh[part] = meshes.end();
            player[num].hp[part] = 0;
            locks.EndRead(meshes);
            clientmutex->unlock();
            
            Ack(packetnum);
         }
         else if (packettype == "a") // Master server announce packet
         {
            Uint32 serverhost;
            Uint16 serverport;
            get >> serverhost >> serverport;
            ServerInfo addme;
            addme.address.host = serverhost;
            SDLNet_Write16(serverport, &addme.address.port);
            if (knownservers.find(addme) == knownservers.end())
            {
               logout << "Received master server announcement for ";
               string dotteddec = AddressToDD(addme.address.host);
               logout << dotteddec << ":" << serverport << endl;
               addme.strip = dotteddec;
               clientmutex->lock();
               servers.push_back(addme);
               clientmutex->unlock();
               knownservers.insert(addme); // No need to wrap this, only used in this thread
            }
         }
         else if (packettype == "v")
         {
            long v;
            unsigned long acknum;
            get >> v;
            get >> acknum;
            currversion = v;
            HandleAck(acknum);
         }
         else if (packettype != "Y") // It's okay to get here on a Y packet
         {
            logout << "Warning: Unknown packet type received: " << packettype << endl;
         }
      }
      // After the while loop we have to unlock the mutex, since we didn't get to that stage before
      netmutex->unlock();
      //t.stop();
      
      // Have to listen on a specific port for server announcements.  Since this is only for LAN play
      // it doesn't matter that this won't work with NAT
      if (annlisten)
      {
         string anntype;
         while (SDLNet_UDP_Recv(annsock, inpack))
         {
            getdata = (char*)inpack->data;
            stringstream get(getdata);
            
            get >> anntype;
            get >> packetnum;
            if (anntype == "a")
            {
               Uint16 serverport;
               get >> serverport;
               ServerInfo addme;
               addme.address = inpack->address;
               SDLNet_Write16(serverport, &addme.address.port);
               if (knownservers.find(addme) == knownservers.end())
               {
                  logout << "Received announcement packet from ";
                  string dotteddec = AddressToDD(inpack->address.host);
                  logout << dotteddec << ":" << serverport << endl;
                  addme.strip = dotteddec;
                  clientmutex->lock();
                  servers.push_back(addme);
                  clientmutex->unlock();
                  knownservers.insert(addme); // No need to wrap this, only used in this thread
               }
            }
         }
      }
   }
   
   logout << "NetListen " << runtimes << endl;
   SDLNet_FreePacket(inpack);
   SDLNet_UDP_Close(sock);
   SDLNet_UDP_Close(annsock);
   return 0;
}


void HandleAck(unsigned long acknum)
{
   netmutex->lock();
   for (list<Packet>::iterator i = sendqueue.begin(); i != sendqueue.end(); ++i)
   {
      if (i->ack == acknum)
      {
         sendqueue.erase(i);
         break;
      }
   }
   netmutex->unlock();
}


// This grabs the send mutex, it should probably not be called while holding the client mutex
void Ack(unsigned long acknum)
{
   Packet response(&addr);
   response << "A\n";
   response << 0 << eol;
   response << acknum << eol;
   netmutex->lock();
   sendqueue.push_back(response);
   netmutex->unlock();
}


void SendPowerdown()
{
   Packet pack(&addr);
   pack.ack = sendpacketnum;
   pack << "P\n";
   pack << pack.ack << eol;
   netmutex->lock();
   sendqueue.push_back(pack);
   netmutex->unlock();
}


void SendCommand(const string& command)
{
   Packet pack(&addr);
   pack.ack = sendpacketnum;
   pack << "c\n";
   pack << pack.ack << eol;
   pack << command << eol;
   netmutex->lock();
   sendqueue.push_back(pack);
   netmutex->unlock();
}


void SendFire()
{
   Packet pack(&addr);
   pack.ack = sendpacketnum;
   pack << "f\n";
   pack << pack.ack << eol;
   netmutex->lock();
   sendqueue.push_back(pack);
   netmutex->unlock();
}


void SendPassword(const string& password)
{
   Packet pack(&addr);
   pack.ack = sendpacketnum;
   pack << "t\n";
   pack << pack.ack << eol;
   pack << password << eol;
   netmutex->lock();
   sendqueue.push_back(pack);
   netmutex->unlock();
}


void SendKeepalive()
{
   Packet pack(&addr);
   pack << "k\n";
   pack << 0 << eol;
   netmutex->lock();
   sendqueue.push_back(pack);
   netmutex->unlock();
}


// Master server related functions
void SendMasterListRequest()
{
   IPaddress masteraddr;
   SDLNet_ResolveHost(&masteraddr, console.GetString("master").c_str(), 12011);
   Packet pack(&masteraddr);
   pack << "r\n0\n";
   netmutex->lock();
   sendqueue.push_back(pack);
   netmutex->unlock();
}


bool SendVersionRequest()
{
   IPaddress masteraddr;
   if (SDLNet_ResolveHost(&masteraddr, console.GetString("master").c_str(), 12011) < 0)
      return false;
   Packet pack(&masteraddr);
   pack.ack = sendpacketnum;
   pack << "v\n";
   pack << pack.ack << eol;
   pack.sendinterval = 5000;
   netmutex->lock();
   sendqueue.push_back(pack);
   netmutex->unlock();
   return true;
}
