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
#include "util.h"

using namespace std;

int NetSend(void*);
int NetListen(void*);
string FillUpdatePacket();
string AddressToDD(Uint32);
void Ack(unsigned long);

// From actions.cpp
void Action(const string&);

list<Packet> sendqueue;
UDPsocket socket;
UDPpacket *outpack;
IPaddress addr;
// netmutex protects both the send queue and the socket shared by the send and receive threads
SDL_mutex* netmutex;
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
      if (currnettick - lastnettick >= 1000 / console.GetInt("tickrate"))
      {
         if (connected)
         {
            lastnettick = currnettick;
            Packet p(&addr);
            p << FillUpdatePacket();
            SDL_mutexP(netmutex);
            sendqueue.push_back(p);
            SDL_mutexV(netmutex);
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
            Packet p(&i->address);
            p << "i\n";
            p << sendpacketnum;
            SDL_mutexP(netmutex);
            sendqueue.push_back(p);
            SDL_mutexV(netmutex);
            i->tick = SDL_GetTicks();
         }
         SDL_mutexV(clientmutex);
         occpacketcounter = 0;
      }
      if (doconnect)
      {
         SDLNet_ResolveHost(&addr, console.GetString("serveraddr").c_str(), console.GetInt("serverport"));
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "C\n";
         p << p.ack << eol;
         p << player[0].unit << eol;
         p << player[0].name << eol;
         SDL_mutexP(netmutex);
         sendqueue.push_back(p);
         SDL_mutexV(netmutex);
         doconnect = false;
         logout << "Sending connect to " << console.GetString("serveraddr") << ":" << console.GetInt("serverport") << endl;
      }
      if (spawnrequest)
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "S\n";
         p << p.ack << eol;
         SDL_mutexP(clientmutex);
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
         
         SDL_mutexV(clientmutex);
         SDL_mutexP(netmutex);
         sendqueue.push_back(p);
         SDL_mutexV(netmutex);
         spawnrequest = false;
      }
      SDL_mutexP(clientmutex);
      if (chatstring != "")
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "T\n";
         p << p.ack << eol;
         p << chatteam << eol;
         p << chatstring << eol;
         chatstring = "";
         SDL_mutexV(clientmutex); // Just to be safe, don't hold both mutexes at once
         SDL_mutexP(netmutex);
         sendqueue.push_back(p);
         SDL_mutexV(netmutex);
      }
      SDL_mutexV(clientmutex); // Not sure a double unlock is allowed, but we'll see (so far so good)
      
      if (changeteam != -1)
      {
         logout << "Changing team " << endl;
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "M\n";
         p << p.ack << eol;
         p << changeteam << eol;
         SDL_mutexP(netmutex);
         sendqueue.push_back(p);
         SDL_mutexV(netmutex);
         changeteam = -1;
      }
      if (useitem)
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "I\n";
         p << p.ack << eol;
         SDL_mutexP(netmutex);
         sendqueue.push_back(p);
         SDL_mutexV(netmutex);
         useitem = false;
      }
      if (sendkill)
      {
         Packet p(&addr);
         p.ack = sendpacketnum;
         p << "K\n";
         p << p.ack << eol;
         SDL_mutexP(netmutex);
         sendqueue.push_back(p);
         SDL_mutexV(netmutex);
         sendkill = false;
      }
      if (needsync)
      {
         Packet p(&addr);
         p << "Y\n";
         p << sendpacketnum << eol;
         SDL_mutexP(netmutex);
         sendqueue.push_back(p);
         SDL_mutexV(netmutex);
      }
      
      
      SDL_mutexP(netmutex);
      list<Packet>::iterator i = sendqueue.begin();
      while (i != sendqueue.end())
      {
         if (i->sendtick <= currnettick)
         {
            i->Send(outpack, socket);
            if (!i->ack || i->attempts > 100000) // Non-ack packets get sent once and then are on their own
            {
               i = sendqueue.erase(i);
               continue;
            }
         }
         ++i;
      }
      SDL_mutexV(netmutex);
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
   
   netmutex = SDL_CreateMutex();
   
   // Note: This socket should be opened before the other, on the off chance that it would choose
   // this port.  No, I didn't learn that the hard way, but I did almost forget.
   if (!(annsock = SDLNet_UDP_Open(12011)))
   {
      logout << "Announce port SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      annlisten = false;
      //return -1;
   }
   
   if (!(socket = SDLNet_UDP_Open(0)))  // Use any open port
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
      
      while ((SDL_mutexP(netmutex) == 0) && 
              SDLNet_UDP_Recv(socket, inpack) && 
              (SDL_mutexV(netmutex) == 0))
      {
         getdata = (char*)inpack->data;
         stringstream get(getdata);
         
         string debug = getdata;
         
         get >> packettype;
         get >> packetnum;
         
         if (!connected && (packettype == "U" || packettype == "u")) // Causes problems on reconnect
            continue;
         if ((connectedaddr.host != inpack->address.host || connectedaddr.port != inpack->address.port) &&
              packettype != "c" && packettype != "f" && packettype != "i" && packettype != "a")
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
               {
                  i->connected = false;
               }
               
               get >> oppnum;
               short oldunit;
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
                     
                     /*logout << "Player " << oppnum << endl;
                     //if (player[oppnum].unit != "unittest")
                     //   logout << "Died on packet " << packetnum << endl;*/
                     /*logout << oppnum << ": " << oppx << "  " << oppy << "  " << oppz << endl << flush;
                     logout << oppfacing << "  ";
                     logout << opppitch << "  ";
                     logout << opproll << "  \n\n";*/
                     
                     player[oppnum].pos.x = oppx;
                     player[oppnum].pos.y = oppy;
                     player[oppnum].pos.z = oppz;
                     
                     player[oppnum].connected = true;
                  }
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
                     for (int part = 0; part < numbodyparts; ++part)
                     {
                        if (i->mesh[part] != meshes.end())
                        {
                           deletemeshes.push_back(i->mesh[part]);
                           i->mesh[part] = meshes.end();
                           addemitter = true;
                        }
                     }
                     if (addemitter)
                     {
                        ParticleEmitter newemitter("particles/emitters/explosion", resman);
                        newemitter.position = i->pos;
                        emitters.push_back(newemitter);
                     }
                  }
               }
               SDL_mutexV(clientmutex);
            }
         }
         else if (packettype == "u") // Occasional updates
         {
            if (packetnum > recpacketnum)
            {
               oppnum = 0;
               
               get >> serverfps;
               get >> oppnum;
               short getunit, getteam;
               int getkills, getdeaths, getsalvage, getspawntimer;
               vector<int> gethp(numbodyparts);
               int getping, getsvfps;
               bool getspawned;
               string getname;
               SDL_mutexP(clientmutex);
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
                  get >> getname;
                  get >> getsalvage;
                  get >> getspawntimer;
                  if (oppnum < player.size())
                  {
                     player[oppnum].team = getteam;
                     player[oppnum].unit = getunit; // Check that this hasn't changed?
                     player[oppnum].kills = getkills;
                     player[oppnum].deaths = getdeaths;
                     for (size_t i = 0; i < numbodyparts; ++i)
                        player[oppnum].hp[i] = gethp[i];
                     player[oppnum].ping = getping;
                     player[oppnum].spawned = getspawned;
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
               SDL_mutexV(clientmutex);
            }
         }
         else if (packettype == "c") // Connect packet
         {
            if (!connected)
            {
               connectedaddr = inpack->address;
               SDL_mutexP(clientmutex);
               get >> servplayernum;
               get >> nextmap;
               get >> changeteam;
               if (!server)
                  mapname = ""; // Force reload of the map even if same name
               nextmap = "maps/" + nextmap;
               doconnect = false;
               connected = true;
               needsync = false; // Set to true after map is loaded
               winningteam = 0;
               logout << "We are server player " << servplayernum << endl;
               logout << "Map is: " << nextmap << endl;
               SDL_mutexV(clientmutex);
               itemsreceived.clear();
               hitsreceived.clear();
            }
            HandleAck(packetnum);
         }
         else if (packettype == "f") // Server was full
         {
            logout << "Server is full\n";
            SDL_mutexP(clientmutex);
            ShowGUI(mainmenu);
            SDL_mutexV(clientmutex);
            HandleAck(packetnum);
         }
         else if (packettype == "P") // Ping
         {
            Packet p(&addr);
            p << "p\n";
            p << sendpacketnum << eol;
            SDL_mutexP(netmutex);
            sendqueue.push_back(p);
            SDL_mutexV(netmutex);
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
               MeshPtr tempmesh = meshcache->GetNewMesh("models/" + dummy.ModelFile() + "/base");
               Particle temppart(*tempmesh);
               temppart.id = id;
               temppart.weapid = weapid;  // Not sure this is necessary, but it won't hurt
               get >> temppart.pos.x >> temppart.pos.y >> temppart.pos.z;
               get >> temppart.dir.x >> temppart.dir.y >> temppart.dir.z;
               get >> temppart.playernum;
               temppart.velocity = dummy.Velocity();
               temppart.accel = dummy.Acceleration();
               temppart.weight = dummy.ProjectileWeight();
               temppart.radius = dummy.Radius();
               temppart.explode = dummy.Explode();
               temppart.collide = true;
               temppart.lasttick = SDL_GetTicks();
               
               // Add tracer if necessary
               if (dummy.Tracer() != "")
               {
                  temppart.tracer = MeshPtr(new Mesh("models/" + dummy.Tracer() + "/base", resman));
                  temppart.tracertime = dummy.TracerTime();
               }
               SDL_mutexP(clientmutex);
               particles.push_back(temppart);
               SDL_mutexV(clientmutex);
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
               
               Weapon dummy(type);
               ParticleEmitter newemitter(dummy.ExpFile(), resman);
               newemitter.position = hitpos;
               SDL_mutexP(clientmutex);
               emitters.push_back(newemitter);
               SDL_mutexV(clientmutex);
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
         else if (packettype == "S") // Spawn request ack
         {
            bool accepted;
            unsigned long acknum;
            Vector3 newpos;
            get >> accepted;
            get >> acknum;
            get >> newpos.x >> newpos.y >> newpos.z;
            
            SDL_mutexP(clientmutex);
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
            SDL_mutexV(clientmutex);
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
            SDL_mutexP(clientmutex);
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
            SDL_mutexV(clientmutex);
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
               SDL_mutexP(clientmutex);
               if (player[0].team != newteam)
               {
                  logout << "Joined team " << newteam << endl;
                  player[0].team = newteam;
                  
                  mapspawns.clear();
                  bool morespawns;
                  SpawnPointData read; // Come to think of it, I don't think this is strictly necessary
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
               SDL_mutexV(clientmutex);
            }
         }
         else if (packettype == "d") // We died:-(
         {
            player[0].weight = -1.f;
            player[0].spectate = true;
            player[0].spawned = false;
            player[0].size = 5.f;
            ResetKeys();
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
               MeshPtr newmesh = meshcache->GetNewMesh(newitem.ModelFile());
               newmesh->Move(itempos);
               newmesh->SetGL();
               newmesh->dynamic = true;
               SDL_mutexP(clientmutex);
               meshes.push_front(*newmesh);
               items.push_back(newitem);
               Item& curritem = items.back();
               curritem.mesh = meshes.begin();
               SDL_mutexV(clientmutex);
               itemsreceived.insert(id);
               spawnschanged = true;
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
                  SDL_mutexP(clientmutex);
                  deletemeshes.push_back(i->mesh);
                  items.erase(i);
                  spawnschanged = true;
                  SDL_mutexV(clientmutex);
                  break;
               }
            }
            Ack(packetnum);
         }
         else if (packettype == "Y" && packetnum > lastsyncpacket) // Sync packet
         {
            logout << "Got sync packet " << packetnum << endl;
            lastsyncpacket = packetnum;
            string buffer;
            SDL_mutexP(clientmutex);
            while (getline(get, buffer) && buffer != "endofcommands")
            {
               console.Parse(buffer, false);
            }
            SDL_mutexV(clientmutex);
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
            get >> winningteam;
            logout << "Team " << winningteam << " wins!" << endl;
            Ack(packetnum);
         }
         else if (packettype == "r") // Remove body part
         {
            int num, part;
            get >> num;
            get >> part;
            
            if (num == servplayernum)
               num = 0;
            
            SDL_mutexP(clientmutex);
            deletemeshes.push_back(player[num].mesh[part]);
            player[num].mesh[part] = meshes.end();
            player[num].hp[part] = 0;
            SDL_mutexV(clientmutex);
            
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
               SDL_mutexP(clientmutex);
               servers.push_back(addme);
               SDL_mutexV(clientmutex);
               knownservers.insert(addme); // No need to wrap this, only used in this thread
            }
         }
         else if (packettype != "Y") // It's okay to get here on a Y packet
         {
            logout << "Warning: Unknown packet type received: " << packettype << endl;
         }
      }
      // After the while loop we have to unlock the mutex, since we didn't get to that stage before
      SDL_mutexV(netmutex);
      //t.stop();
      
      // Have to listen on a specific port for server announcements.  Since this is only for LAN play
      // it doesn't matter that this won't work with NAT
      if (annlisten)
      {
         while (SDLNet_UDP_Recv(annsock, inpack))
         {
            getdata = (char*)inpack->data;
            stringstream get(getdata);
            
            get >> packettype;
            get >> packetnum;
            if (packettype == "a")
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
                  SDL_mutexP(clientmutex);
                  servers.push_back(addme);
                  SDL_mutexV(clientmutex);
                  knownservers.insert(addme); // No need to wrap this, only used in this thread
               }
            }
         }
      }
   }
   
   logout << "NetListen " << runtimes << endl;
   SDLNet_FreePacket(inpack);
   SDLNet_UDP_Close(socket);
   return 0;
}


void HandleAck(unsigned long acknum)
{
   SDL_mutexP(netmutex);
   for (list<Packet>::iterator i = sendqueue.begin(); i != sendqueue.end(); ++i)
   {
      if (i->ack == acknum)
      {
         sendqueue.erase(i);
         break;
      }
   }
   SDL_mutexV(netmutex);
}


// This grabs the send mutex, it should probably not be called while holding the client mutex
void Ack(unsigned long acknum)
{
   Packet response(&addr);
   response << "A\n";
   response << 0 << eol;
   response << acknum << eol;
   SDL_mutexP(netmutex);
   sendqueue.push_back(response);
   SDL_mutexV(netmutex);
}


void SendPowerdown()
{
   Packet pack(&addr);
   pack.ack = sendpacketnum;
   pack << "P\n";
   pack << pack.ack << eol;
   SDL_mutexP(netmutex);
   sendqueue.push_back(pack);
   SDL_mutexV(netmutex);
}


void SendCommand(const string& command)
{
   Packet pack(&addr);
   pack.ack = sendpacketnum;
   pack << "c\n";
   pack << pack.ack << eol;
   pack << command << eol;
   SDL_mutexP(netmutex);
   sendqueue.push_back(pack);
   SDL_mutexV(netmutex);
}


void SendFire()
{
   Packet pack(&addr);
   pack.ack = sendpacketnum;
   pack << "f\n";
   pack << pack.ack << eol;
   SDL_mutexP(netmutex);
   sendqueue.push_back(pack);
   SDL_mutexV(netmutex);
}


void SendMasterListRequest()
{
   IPaddress masteraddr;
   SDLNet_ResolveHost(&masteraddr, console.GetString("master").c_str(), 12011);
   Packet pack(&masteraddr);
   pack << "r\n0\n";
   SDL_mutexP(netmutex);
   sendqueue.push_back(pack);
   SDL_mutexV(netmutex);
}
