// Netcode

#include <iostream>
#include <sstream>
#include <vector>
#include <list>
#include <set>
#include "Particle.h"
#include "SDL.h"
#include "SDL_net.h"
#include "PlayerData.h"
#include "CollisionDetection.h"
#include "Packet.h"
#include "ServerInfo.h"
#include "types.h"
#include "gui/ComboBox.h"
#include "netdefs.h"
#include "globals.h"

#include <sys/types.h>
#include <linux/unistd.h>
#include <errno.h>

using namespace std;

int NetSend(void*);
int NetListen(void*);
//void SendPacket(UDPpacket*, string, IPaddress, UDPsocket);
string FillUpdatePacket();
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);
string AddressToDD(Uint32);

list<Packet> sendqueue;
UDPsocket outsock;
UDPpacket *outpack;
IPaddress addr;
SDL_mutex* sendmutex;

// Gets split off as a separate thread to handle sending network packets
int NetSend(void* dummy)
{
   Uint32 lastnettick = SDL_GetTicks();
   Uint32 currnettick = 0;
   Uint32 occpacketcounter = 0;
   sendmutex = SDL_CreateMutex();
   changeteam = 0;
   
   // Debugging
   Timer t;
   unsigned long runtimes = 0;
   
   if (!(outsock = SDLNet_UDP_Open(0)))  // Use any open port
   {
      cout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   if (!(outpack = SDLNet_AllocPacket(5000))) // 65000 probably won't work
   {
      cout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   cout << "NetSend " << syscall(224) << endl;
   
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
      if (currnettick - lastnettick >= 1000 / tickrate)
      {
         if (connected)
         {
            lastnettick = currnettick;
            Packet p(outpack, &outsock, &addr);
            p << FillUpdatePacket();
            SDL_mutexP(sendmutex);
            sendqueue.push_back(p);
            SDL_mutexV(sendmutex);
            
            sendpacketnum++;
         }
         occpacketcounter++;
      }
      if (occpacketcounter > 100)
      {
         // Send a request for the server's information
         SDL_mutexP(clientmutex);
         vector<ServerInfo>::iterator i;
         for (i = servers.begin(); i != servers.end(); ++i)
         {
            Packet p(outpack, &outsock, &i->address);
            SDLNet_Write16(1337, &(p.addr.port));
            p << "i\n";
            p << sendpacketnum;
            SDL_mutexP(sendmutex);
            sendqueue.push_back(p);
            SDL_mutexV(sendmutex);
            i->tick = SDL_GetTicks();
         }
         SDL_mutexV(clientmutex);
         occpacketcounter = 0;
      }
      if (doconnect)
      {
         SDLNet_ResolveHost(&addr, serveraddr.c_str(), 1337);
         Packet p(outpack, &outsock, &addr);
         p << "C\n";
         p << sendpacketnum << eol;
         p << player[0].unit << eol;
         p << player[0].name << eol;
         p.ack = sendpacketnum;
         ++sendpacketnum;
         SDL_mutexP(sendmutex);
         sendqueue.push_back(p);
         SDL_mutexV(sendmutex);
         doconnect = false;
      }
      if (spawnrequest)
      {
         Packet p(outpack, &outsock, &addr);
         p.ack = sendpacketnum;
         p << "S\n";
         p << sendpacketnum << eol;
         ++sendpacketnum;
         p << servplayernum << eol;
         SDL_mutexP(clientmutex);
         p << player[0].unit << eol;
         for (int i = 0; i < numbodyparts; ++i)
         {
            p << player[0].weapons[i] << eol;
         }
         ComboBox *spawnpointsbox = (ComboBox*)loadoutmenu.GetWidget("SpawnPoints");
         int sel = spawnpointsbox->Selected();
         p << spawnpoints[sel].position.x << eol;
         p << spawnpoints[sel].position.y << eol;
         p << spawnpoints[sel].position.z << eol;
         SDL_mutexV(clientmutex);
         SDL_mutexP(sendmutex);
         sendqueue.push_back(p);
         SDL_mutexV(sendmutex);
         spawnrequest = false;
      }
      SDL_mutexP(clientmutex);
      if (chatstring != "")
      {
         Packet p(outpack, &outsock, &addr);
         p.ack = sendpacketnum;
         p << "T\n";
         p << sendpacketnum << eol;
         ++sendpacketnum;
         p << servplayernum << eol;
         p << chatstring << eol;
         chatstring = "";
         SDL_mutexV(clientmutex); // Just to be safe, don't hold both mutexes at once
         SDL_mutexP(sendmutex);
         sendqueue.push_back(p);
         SDL_mutexV(sendmutex);
      }
      SDL_mutexV(clientmutex); // Not sure a double unlock is allowed, but we'll see
      
      if (changeteam)
      {
         Packet p(outpack, &outsock, &addr);
         p.ack = sendpacketnum;
         p << "M\n";
         p << sendpacketnum << eol;
         ++sendpacketnum;
         p << servplayernum << eol;
         p << changeteam << eol;
         SDL_mutexP(sendmutex);
         sendqueue.push_back(p);
         SDL_mutexV(sendmutex);
         changeteam = 0;
      }
      SDL_mutexP(sendmutex);
      list<Packet>::iterator i = sendqueue.begin();
      while (i != sendqueue.end())
      {
         if (i->sendtick <= currnettick)
         {
            i->Send();
            if (!i->ack || i->attempts > 1000) // Non-ack packets get sent once and then are on their own
            {
               i = sendqueue.erase(i);
               continue;
            }
         }
         ++i;
      }
      SDL_mutexV(sendmutex);
      //t.stop();
   }
   
   cout << "NetSend " << runtimes << endl;
   SDLNet_FreePacket(outpack);
   SDLNet_UDP_Close(outsock);
   return 0;
}


string FillUpdatePacket()
{
   stringstream temp;
   
   temp << "U" << eol;
   temp << sendpacketnum << eol;
   temp << servplayernum << eol;
   SDL_mutexP(clientmutex);
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
   SDL_mutexV(clientmutex);
   
   // Quick and dirty checksumming
   unsigned long value = 0;
   for (int i = 0; i < temp.str().length(); ++i)
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
   UDPsocket insock;
   UDPpacket *inpack;
   unsigned int packetnum;
   float oppx, oppy, oppz;
   float opprot, opppitch, opproll, oppfacing;
   unsigned short oppnum;
   string getdata;
   string packettype;
   
   // Debugging
   Timer t;
   unsigned long runtimes = 0;
   
   if (!(insock = SDLNet_UDP_Open(1336)))
   {
      cout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   if (!(inpack = SDLNet_AllocPacket(5000)))
   {
      cout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   netout = SDL_CreateThread(NetSend, NULL); // Start send thread
   cout << "NetListen " << syscall(224) << endl;
   
   while (running)
   {
      ++runtimes;
      //t.start();
      SDL_Delay(1); // See comments for NetSend loop
      
      while (SDLNet_UDP_Recv(insock, inpack))
      {
         getdata = (char*)inpack->data;
         stringstream get(getdata);
         
         string debug = getdata;
         
         get >> packettype;
         get >> packetnum;
         
         if (!connected && (packettype == "U" || packettype == "u")) // Causes problems on reconnect
            continue;
         if (packettype == "U") // Update packet
         {
            if (packetnum > recpacketnum) // Ignore older out of order packets
            {
               recpacketnum = packetnum;
               oppnum = 0;
               SDL_mutexP(clientmutex);
               
               /* Any player that the server does not send an update for must
                  not be connected anymore, so assume all players are not
                  connected, and as we find otherwise update that. */
               // At some point this probably won't work, but for the moment it does
               for (vector<PlayerData>::iterator i = player.begin(); i != player.end(); i++)
                  i->connected = false;
               
               get >> oppnum;
               short oldunit;
               while (oppnum != 0)
               {
                  while (oppnum >= player.size())  // Add new player(s)
                  {
                     PlayerData dummy(meshes);
                     player.push_back(dummy);
                     cout << "Adding player " << (player.size() - 1) << endl;
                  }
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
                  oldunit = player[oppnum].unit;
                  get >> player[oppnum].unit;
                  get >> player[oppnum].ping;
                  
                  /*cout << "Player " << oppnum << endl;
                  //if (player[oppnum].unit != "unittest")
                  //   cout << "Died on packet " << packetnum << endl;*/
                  /*cout << oppnum << ": " << oppx << "  " << oppy << "  " << oppz << endl << flush;
                  cout << oppfacing << "  ";
                  cout << opppitch << "  ";
                  cout << opproll << "  \n\n";*/
                  
                  player[oppnum].pos.x = oppx;
                  player[oppnum].pos.y = oppy;
                  player[oppnum].pos.z = oppz;
                  
                  player[oppnum].connected = true;
                  
#if 0 // This probably doesn't need to go back in, but we'll see
                  if (oppnum != servplayernum)// && player[oppnum].unit != 0)
                  {
                     if (oldunit != player[oppnum].unit)
                     {
                        if (player[oppnum].legs != dynobjects.end())
                           dynobjects.erase(player[oppnum].legs);
                        if (player[oppnum].torso != dynobjects.end())
                           dynobjects.erase(player[oppnum].torso);
                        if (player[oppnum].larm != dynobjects.end())
                           dynobjects.erase(player[oppnum].larm);
                        if (player[oppnum].rarm != dynobjects.end())
                           dynobjects.erase(player[oppnum].rarm);
                        player[oppnum].legs = dynobjects.end();
                        player[oppnum].torso = dynobjects.end();
                        player[oppnum].larm = dynobjects.end();
                        player[oppnum].rarm = dynobjects.end();
                     }
                     UpdatePlayerModel(player[oppnum], dynobjects);
                  }
#endif
                  
                  get >> oppnum;
               }
               
               // Get particles from server
               unsigned long partnum;
               get >> partnum;
               
               while (partnum != 0)
               {
                  unsigned long playerid, playernum;
                  Vector3 getdir, getpos;
                  float getvel, getacc, getweight, getrad;
                  bool getexp;
                  
                  get >> playernum;
                  get >> playerid;
                  get >> getdir.x >> getdir.y >> getdir.z;
                  get >> getpos.x >> getpos.y >> getpos.z;
                  get >> getvel;
                  get >> getacc;
                  get >> getweight;
                  get >> getrad;
                  get >> getexp;
                  
                  //cout << "Received particle " << partnum << " from ";
                  //cout << playernum << endl;
                  // Only add the particle if we don't already have it
                  if ((partids.find(partnum) == partids.end()))
                  {
                     IniReader tempreader("models/projectile/base");
                     Mesh tempmesh(tempreader, resman);
                     Particle temppart(tempmesh);
                     temppart.playerid = playerid;
                     temppart.dir = getdir;
                     temppart.pos = getpos;
                     temppart.velocity = getvel;
                     temppart.accel = getacc;
                     temppart.weight = getweight;
                     temppart.radius = getrad;
                     temppart.explode = getexp;
                     
                     temppart.cd = &coldet;
                     temppart.lasttick = SDL_GetTicks();
                     temppart.id = partnum;
                     temppart.playerid = partnum;
                     temppart.playernum = playernum;
                     temppart.unsent = false;  // Actually meaningless on client
                           
                     partids.insert(partnum);
                     particles.push_back(temppart);
                  }
                  get >> partnum;
               }
               
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
               //cout << endl << value << endl << checksum << endl;
               if (checksum != value)
               {
                  cout << "Client freaking out on packet " << packetnum << endl;
               }
               
               // Remove models for disconnected players
               vector<PlayerData>::iterator i = player.begin();
               ++i;  // Skip first element because that's local player
#if 0
               for (; i != player.end(); ++i)
               {
                  if (!i->spawned)
                  {
                     if (i->legs != dynobjects.end())
                     {
                        dynobjects.erase(i->legs);
                        i->legs = dynobjects.end();
                     }
                  }
               }
#endif
               SDL_mutexV(clientmutex);
            }
         }
         else if (packettype == "u") // Occasional updates
         {
            if (packetnum > recpacketnum)
            {
               oppnum = 0;
               
               get >> oppnum;
               SDL_mutexP(clientmutex);
               while (oppnum != 0)
               {
                  get >> player[oppnum].unit;
                  get >> player[oppnum].kills;
                  get >> player[oppnum].deaths;
                  for (int i = 0; i < numbodyparts; ++i)
                     get >> player[oppnum].hp[i];
                  get >> player[oppnum].ping;
                  get >> player[oppnum].spawned;
                  get >> player[oppnum].name;
                  get >> oppnum;
               }
               player[0].kills = player[servplayernum].kills;
               player[0].deaths = player[servplayernum].deaths;
               for (int i = 0; i < numbodyparts; ++i)
                  player[0].hp[i] = player[servplayernum].hp[i];
               player[0].ping = player[servplayernum].ping;
               SDL_mutexV(clientmutex);
            }
         }
         else if (packettype == "c") // Connect packet
         {
            get >> servplayernum;
            get >> nextmap;
            nextmap = "maps/" + nextmap;
            cout << nextmap << endl;
            doconnect = false;
            connected = true;
            cout << "We are server player " << servplayernum << endl;
            list<Packet>::iterator i;
            SDL_mutexP(sendmutex);
            for (i = sendqueue.begin(); i != sendqueue.end(); ++i)
            {
               if (i->ack == packetnum)
               {
                  sendqueue.erase(i);
                  break;
               }
            }
            SDL_mutexV(sendmutex);
         }
         else if (packettype == "P") // Ping
         {
            Packet p(outpack, &outsock, &addr);
            p << "p\n";
            p << sendpacketnum << eol;
            p << servplayernum << eol;
            SDL_mutexP(sendmutex);
            sendqueue.push_back(p);
            SDL_mutexV(sendmutex);
         }
         else if (packettype == "a") // Server broadcast announcement
         {
            ServerInfo addme;
            addme.address = inpack->address;
            if (knownservers.find(addme) == knownservers.end())
            {
               cout << "Received announcement packet from ";
               string dotteddec = AddressToDD(inpack->address.host);
               cout << dotteddec << endl;
               addme.strip = dotteddec;
               SDL_mutexP(clientmutex);
               servers.push_back(addme);
               SDL_mutexV(clientmutex);
               knownservers.insert(addme); // No need to wrap this, only used here
            }
         }
         else if (packettype == "i")
         {
            vector<ServerInfo>::iterator i;
            SDL_mutexP(clientmutex);
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
            SDL_mutexV(clientmutex);
         }
         else if (packettype == "S")
         {
            bool accepted;
            get >> accepted;
            
            if (accepted)
            {
               ComboBox *spawnpointsbox = (ComboBox*)loadoutmenu.GetWidget("SpawnPoints");
               loadoutmenu.visible = false;
               hud.visible = true;
               player[0].pos = spawnpoints[spawnpointsbox->Selected()].position;
               player[0].size = units[player[0].unit].size;
               player[0].lastmovetick = SDL_GetTicks();
            }
            else
            {
               cout << "Spawn request not accepted.  This is either a program error or you're hacking.  If the latter, shame on you.  If the former, shame on me." << endl;
            }
         }
         else if (packettype == "A") // Ack packet
         {
            unsigned long acknum;
            get >> acknum;
            HandleAck(acknum);
         }
         else if (packettype == "T") // Text packet
         {
            SDL_mutexP(clientmutex);
            string line;
            get >> oppnum;
            if (player[oppnum].acked.find(packetnum) == player[oppnum].acked.end())
            {
               player[oppnum].acked.insert(packetnum);
               getline(get, line);
               getline(get, line);
               newchatlines.push_back(line);
               newchatplayers.push_back(oppnum);
            }
            SDL_mutexV(clientmutex);
            
            // Ack it
            Packet response(outpack, &outsock, &addr);
            response << "A\n";
            response << 0 << eol;
            response << packetnum << eol;
            SDL_mutexP(sendmutex);
            sendqueue.push_back(response);
            SDL_mutexV(sendmutex);
         }
         else if (packettype == "M")
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
               SDL_mutexP(clientmutex);
               player[0].team = newteam;
               SDL_mutexV(clientmutex);
               cout << "Joined team " << newteam << endl;
               spawnschanged = true;
            }
         }
      }
      //t.stop();
   }
   
   cout << "NetListen " << runtimes << endl;
   SDLNet_FreePacket(inpack);
   SDLNet_UDP_Close(insock);
   return 0;
}


void HandleAck(unsigned long acknum)
{
   SDL_mutexP(sendmutex);
   for (list<Packet>::iterator i = sendqueue.begin(); i != sendqueue.end(); ++i)
   {
      if (i->ack == acknum)
      {
         sendqueue.erase(i);
         break;
      }
   }
   SDL_mutexV(sendmutex);
}
