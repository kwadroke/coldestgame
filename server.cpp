/* Gets started as a separate thread whenever it is requested to start
   a server from the main progam file.*/

#include <list>
#include <queue>
#include <sstream>
#include <string>
#include <vector>
#include "Particle.h"
#include "SDL_net.h"
#include "PlayerData.h"
#include "Vector3.h"
#include "Packet.h"
#include "ObjectKDTree.h"
#include "CollisionDetection.h"
#include "ProceduralTree.h"
#include "DynamicObject.h"
#include "Timer.h"
#include "globals.h"
#include "netdefs.h"

#include <sys/types.h>
#include <linux/unistd.h>
#include <errno.h>

using namespace std;

// Necessary declarations
int ServerSend(void*);
int ServerListen();
void ServerLoadMap();
void HandleHit(Particle& p, stack<Mesh*>& hitobjs);
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);
void UpdateDOTree(DynamicPrimitive*);
void ServerUpdatePlayer(int);

SDL_Thread* serversend;
vector<PlayerData> serverplayers;
list<Particle> servparticles;
SDL_mutex* servermutex;
unsigned long servsendpacketnum;
unsigned short servertickrate;
unsigned long nextservparticleid;
string currentmap;
string servername;
list<Packet> servqueue;
UDPsocket servoutsock;
UDPpacket *servoutpack;
//list<DynamicObject> serverdynobjects;
Meshlist servermeshes;
CollisionDetection servercoldet;
ObjectKDTree serverkdtree;
short maxplayers;

int Server(void* dummy)
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
   cout << "Chose name " << servername << " which is #" << choosename << endl;
   servsendpacketnum = 0;
   nextservparticleid = 1;  // 0 has special meaning
   servertickrate = 30;
   maxplayers = 32;
   if (currentmap == "")
      currentmap = "mini";
   ServerLoadMap();
   PlayerData local(servermeshes); // Dummy placeholder for the local player
   serverplayers.push_back(local);
   servermutex = SDL_CreateMutex();
   serversend = SDL_CreateThread(ServerSend, NULL);
   
   ServerListen();
   
   SDL_WaitThread(serversend, NULL);
   return 0;
}


int ServerListen()
{
   UDPsocket insock;
   UDPpacket *inpack;
   unsigned long packetnum;
   string getdata;
   string packettype;
   float oppx, oppy, oppz;
   float dummy;
   unsigned short oppnum;
   Uint32 currtick;
   
   // Debugging
   Timer t;
   unsigned long runtimes = 0;
   
   if (!(insock = SDLNet_UDP_Open(1337)))
   {
      cout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   if (!(inpack = SDLNet_AllocPacket(5000)))
   {
      cout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   cout << "ServerListen " << gettid() << endl;
   
   while (running)
   {
      ++runtimes;
      SDL_Delay(1); // Prevent CPU hogging
      
      currtick = SDL_GetTicks();
      SDL_mutexP(servermutex);
      if ("maps/" + currentmap != mapname) // If the server changed maps load the new one
      {
         ServerLoadMap();
      }
      for (int i = 1; i < serverplayers.size(); ++i)
      {
         if (serverplayers[i].connected && currtick - serverplayers[i].lastupdate > 5000)
         {
            serverplayers[i].Disconnect();
            cout << "Player " << i << " timed out.\n" << flush;
         }
         else if (serverplayers[i].spawned)
         {
            ServerUpdatePlayer(i);
         }
      }
      
      // Update server meshes
      for (Meshlist::iterator i = servermeshes.begin(); i != servermeshes.end(); ++i)
      {
         i->AdvanceAnimation();
      }
      
      // Update particles
      int updinterval = 100;
      UpdateParticles(servparticles, updinterval, serverkdtree, servermeshes, &HandleHit);
      SDL_mutexV(servermutex);
      
      /* While loop FTW!  (showing my noobness to networking, I was only allowing it to process one
         packet per outer loop, which meant it did the entire ~20 ms particle/player update
         process between every single packet it received.  Needless to say, this caused serious
         ping problems.)
      
         Note: Having this blindly loop as long as there are packets could cause problems under
         extremely heavy network loads.  It remains to be seen whether that's actually an issue
         (or whether the server would be usable under such circumstances, loop or not)
      */
      while (SDLNet_UDP_Recv(insock, inpack))
      {
         getdata = (char*)inpack->data;
         stringstream get(getdata);
         
         string debug = getdata;
         
         get >> packettype;
         get >> packetnum;
         if (packettype == "U") // Update packet
         {
            get >> oppnum;
            SDL_mutexP(servermutex);
            if (packetnum > serverplayers[oppnum].recpacketnum) // Ignore out of order packets
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
               
               //cout << oppx << "  " << oppy << "  " << oppz << endl << flush;
               
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
                  cout << "Freaking out on packet " << packetnum << endl;
                  cout << debug << endl;
                  cout << checksum << "  " << value << endl;
               }
            }
            SDL_mutexV(servermutex);
         }
         else if (packettype == "C")
         {
            short unit;
            string name;
            get >> unit;
            get >> name;
            bool add = true;
            int respondto = 0;
            SDL_mutexP(servermutex);
            for (int i = 0; i < serverplayers.size(); ++i)
            {
               if (serverplayers[i].addr.host == inpack->address.host)
               {
                  respondto = i;
                  add = false;
               }
            }
            if (add)
            {
               PlayerData temp(servermeshes);
               temp.recpacketnum = packetnum;
               temp.addr = inpack->address;
               temp.connected = true;
               temp.lastupdate = SDL_GetTicks();
               temp.unit = unit;
               temp.acked.insert(packetnum);
               UpdatePlayerModel(temp, servermeshes, false);
               
               SDLNet_Write16(1336, &(temp.addr.port)); // NBO bites me for the first time...
               serverplayers.push_back(temp);
               respondto = serverplayers.size() - 1;
               cout << "Player " << (serverplayers.size() - 1) << " connected\n" << flush;
            }
            
            if (!serverplayers[respondto].connected)
            {
               serverplayers[respondto].lastupdate = SDL_GetTicks();
               serverplayers[respondto].recpacketnum = packetnum;
            }
            serverplayers[respondto].connected = true;
            serverplayers[respondto].name = name;
            
            Packet fill(servoutpack, &servoutsock);
            fill << "c\n";
            fill << packetnum << eol;
            fill << respondto << eol;
            fill << currentmap << eol;
            //cout << "Server Sent ACK" << packetnum << " to player " << respondto << endl;
            
            fill.addr = serverplayers[respondto].addr;
            servqueue.push_back(fill);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "p")
         {
            get >> oppnum;
            SDL_mutexP(servermutex);
            serverplayers[oppnum].ping = SDL_GetTicks() - serverplayers[oppnum].pingtick;
            //cout << oppnum << " ping: " << serverplayers[oppnum].ping << endl;
            SDL_mutexV(servermutex);
         }
         else if (packettype == "i")
         {
            Packet response(servoutpack, &servoutsock, &inpack->address);
            response << "i\n";
            response << 0 << eol; // Don't care about the packet number
            SDL_mutexP(servermutex);
            response << servername << eol;
            response << currentmap << eol;
            response << serverplayers.size() << eol;
            response << maxplayers << eol;
            SDLNet_Write16(1336, &(response.addr.port));
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "S")
         {
            bool accepted = true;
            get >> oppnum;
            if (packetnum > serverplayers[oppnum].spawnpacketnum)
            {
               SDL_mutexP(servermutex);
               get >> serverplayers[oppnum].unit;
               for (int i = 0; i < numbodyparts; ++i)
               {
                  get >> serverplayers[oppnum].weapons[i];
               }
               Vector3 spawnpointreq;
               get >> spawnpointreq.x;
               get >> spawnpointreq.y;
               get >> spawnpointreq.z;
               serverplayers[oppnum].pos = spawnpointreq;
               serverplayers[oppnum].spawned = true;
               serverplayers[oppnum].lastmovetick = SDL_GetTicks();
               serverplayers[oppnum].spawnpacketnum = packetnum;
               for (int i = 0; i < numbodyparts; ++i)
                  serverplayers[oppnum].hp[i] = 100;
            }
            
            Packet response(servoutpack, &servoutsock, &inpack->address);
            SDLNet_Write16(1336, &(response.addr.port));
            response << "S\n";
            response << 0 << eol;  // Not sure this is okay either...
            if (accepted)
               response << 1 << eol;
            else response << 0 << eol;
            response << packetnum << eol;
            
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "T")
         {
            string line;
            get >> oppnum;
            getline(get, line); // \n is still in buffer
            getline(get, line);
            SDL_mutexP(servermutex);
            if (serverplayers[oppnum].acked.find(packetnum) == serverplayers[oppnum].acked.end())
            {
               serverplayers[oppnum].acked.insert(packetnum);
               
               // Propogate that chat text to all other connected players
               for (int i = 1; i < serverplayers.size(); ++i)
               {
                  if (serverplayers[i].connected && i != oppnum)
                  {
                     ++servsendpacketnum;
                     Packet temp(servoutpack, &servoutsock);
                     temp.ack = servsendpacketnum;
                     temp << "T\n";
                     temp << servsendpacketnum << eol;
                     temp << oppnum << eol;
                     temp << line << eol;
                     temp.addr = serverplayers[i].addr;
                     servqueue.push_back(temp);
                  }
               }
               ++servsendpacketnum; // Make sure we can't end up with dup packet ids
            }
            Packet response(servoutpack, &servoutsock, &inpack->address);
            SDLNet_Write16(1336, &(response.addr.port));
            response << "A\n";
            response << 0 << eol; // Or this for that matter (see duplicate line above)
            response << packetnum << eol;
            servqueue.push_back(response);
            
            SDL_mutexV(servermutex);
         }
         else if (packettype == "A")
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
         else if (packettype == "M")
         {
            // For the moment just ack it, we probably want to ensure even teams at some point
            short newteam;
            get >> oppnum;
            get >> newteam;
            
            Packet response(servoutpack, &servoutsock, &inpack->address);
            SDLNet_Write16(1336, &(response.addr.port));
            response << "M\n";
            response << servsendpacketnum << eol;
            ++servsendpacketnum;
            response << packetnum << eol;
            response << 1 << eol;
            response << newteam << eol;
            SDL_mutexP(servermutex);
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         
      }
      //t.stop();
   }
   
   cout << "Server Listen " << runtimes << endl;
   
   // Clean up
   SDLNet_FreePacket(inpack);
   SDLNet_UDP_Close(insock);
}


int ServerSend(void* dummy)  // Thread for sending updates
{
   Uint32 lastnettick = SDL_GetTicks();
   Uint32 currnettick = 0;
   short int pingtick = 0;
   UDPsocket broadcastsock;
   
   // Debugging
   Timer t;
   unsigned long runtimes = 0;
   
   if (!(servoutsock = SDLNet_UDP_Open(0)))  // Use any open port
   {
      cout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   if (!(servoutpack = SDLNet_AllocPacket(5000)))  // 5000 is arbitrary at this point
   {
      cout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   if (!(broadcastsock = SDLNet_UDP_Open(0)))
   {
      cout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   cout << "ServerSend " << gettid() << endl;
   
   while (running)
   {
      ++runtimes;
      //t.start();
      SDL_Delay(1);  // Keep the loop from eating too much CPU
      
      currnettick = SDL_GetTicks();
      if (currnettick - lastnettick >= 1000 / servertickrate)
      {
         lastnettick = currnettick;
         // Send out an update packet
         Packet temp(servoutpack, &servoutsock);
   
         temp << "U" << eol;
         temp << servsendpacketnum << eol;
         SDL_mutexP(servermutex);
         for (int i = 1; i < serverplayers.size(); ++i)
         {
            if (serverplayers[i].connected)
            {
               temp << i << eol;
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
               temp << serverplayers[i].unit << eol;
               temp << serverplayers[i].ping << eol;
            }
            
#if 0
            // This was just for debugging, only worry if it happens a lot or happens
            // for a player who hasn't just joined
            if (serverplayers[i].unit != 0)
            {
               /*cout << "Server failed packet:\n";
               cout << debug;
               cout << "End server packet\n";*/
               cout << "Server error" << i << endl;
               cout << serverplayers[i].unit << endl;
            }
#endif
         }
         temp << 0 << eol; // Indicates end of player data
         
         list<Particle>::iterator i;
         for (i = servparticles.begin(); i != servparticles.end(); ++i)
         {
            if (i->unsent)
            {
               //cout << "Server sending particle " << i->id;
               //cout << " from " << i->playernum << endl;
               temp << i->id << eol;
               temp << i->playernum << eol;
               temp << i->playerid << eol;
               temp << i->dir.x << eol << i->dir.y << eol << i->dir.z << eol;
               temp << i->pos.x << eol << i->pos.y << eol << i->pos.z << eol;
               temp << i->velocity << eol;
               temp << i->accel << eol;
               temp << i->weight << eol;
               temp << i->radius << eol;
               temp << i->explode << eol;
               i->senttimes++;
               if (i->senttimes > 10)
                  i->unsent = false;
            }
         }
         temp << 0 << eol;
         
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
            servsendpacketnum++;
         }
         else cout << "Error: data too long\n" << flush;
         
         // Send pings to monitor network performance
         // Also use this opportunity to send occasional updates
         pingtick++;
         if (pingtick > 30)
         {
            Packet pingpack(servoutpack, &servoutsock);
            
            pingpack << "P\n";
            pingpack << servsendpacketnum << eol;
            SDL_mutexP(servermutex);
            for (int i = 1; i < serverplayers.size(); ++i)
            {
               pingpack.addr = serverplayers[i].addr;
               servqueue.push_back(pingpack);
               serverplayers[i].pingtick = SDL_GetTicks();
            }
            servsendpacketnum++;
            pingtick = 0;
            
            // Occasional update packet
            Packet occup(servoutpack, &servoutsock);
            
            occup << "u\n";
            occup << servsendpacketnum << eol;
            for (int i = 1; i < serverplayers.size(); ++i)
            {
               if (serverplayers[i].connected)
               {
                  occup << i << eol;
                  occup << serverplayers[i].unit << eol;
                  occup << serverplayers[i].kills << eol;
                  occup << serverplayers[i].deaths << eol;
                  for (int j = 0; j < numbodyparts; ++j)
                     occup << serverplayers[i].hp[j] << eol;
                  occup << serverplayers[i].ping << eol;
                  occup << serverplayers[i].spawned << eol;
                  occup << serverplayers[i].name << eol;
               }
            }
            occup << 0 << eol;
            for (int i = 1; i < serverplayers.size(); ++i)
            {
               occup.addr = serverplayers[i].addr;
               servqueue.push_back(occup);
            }
            
            // Broadcast announcement packets to the subnet for LAN servers
            IPaddress bc;
            bc.host = INADDR_BROADCAST;
            SDLNet_Write16(1336, &(bc.port));
            Packet bcpack(servoutpack, &broadcastsock, &bc);
            bcpack << "a\n";
            bcpack << servsendpacketnum << eol;
            bcpack.Send();
            
            servsendpacketnum++;
            SDL_mutexV(servermutex);
         }
      }
      
      SDL_mutexP(servermutex);
      list<Packet>::iterator i = servqueue.begin();
      while (i != servqueue.end())
      {
         if (i->sendtick <= currnettick)
         {
            i->Send();
            if (!i->ack || i->attempts > 1000) // Non-ack packets get sent once and then are on their own
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
   cout << "Server Send " << runtimes << endl;
   return 0;
}


// Unfortunately SDL_Image is not thread safe, so we have to signal the main thread to do this
void ServerLoadMap()
{
   SDL_mutexP(servermutex); // Grab this so the send thread doesn't do something funny on us
   serverhasmap = false;
   nextmap = "maps/" + currentmap;
   while (mapname != nextmap)
   {
      SDL_Delay(1); // Wait for main thread to load map
   }
   
   servercoldet = coldet;
   
   servermeshes = meshes;
   Vector3vec points(8, Vector3());
   for (int i = 0; i < 4; ++i)
   {
      points[i] = servercoldet.worldbounds[0].GetVertex(i);// + Vector3(0, 10, 0);
   }
   for (int i = 0; i < 4; ++i)
   {
      points[i + 4] = servercoldet.worldbounds[5].GetVertex(i);
   }
   serverkdtree = ObjectKDTree(&servermeshes, points);
   serverkdtree.refine(0);
   
   cout << "Map loaded" << endl;
   serverhasmap = true;
   SDL_mutexV(servermutex);
}


// No need to grab the servermutex in this function because it is only called from code that already has the mutex
void HandleHit(Particle& p, stack<Mesh*>& hitobjs)
{
   Mesh* curr;
   bool dead;
   while (!hitobjs.empty())
   {
      curr = hitobjs.top();
      for (int i = 1; i < serverplayers.size(); ++i)
      {
         dead = false;
         // Note that some of this code is placeholder until I get a proper spawn system implemented
         for (int part = 0; part < numbodyparts; ++part)
         {
            if (curr == &(*serverplayers[i].mesh[part]))
            {
               cout << "Hit " << curr << endl;
               serverplayers[i].hp[part] -= p.damage;
               if (serverplayers[i].hp[part] <= 0)
                  dead = true;
            }
         }
         if (dead)
         {
            serverplayers[i].deaths++;
            serverplayers[p.playernum].kills++;
            cout << "Player " << i << " was killed by Player " << p.playernum << endl;
            serverplayers[i].Kill();
            
            Packet deadpacket(servoutpack, &servoutsock);
            deadpacket.ack = servsendpacketnum;
            deadpacket.addr = serverplayers[i].addr;
            SDLNet_Write16(1336, &(deadpacket.addr.port));
            
            deadpacket << "d\n";
            deadpacket << servsendpacketnum << eol;
            servqueue.push_back(deadpacket);
         }
      }
      hitobjs.pop();
   }
}


// Note: must be called from within mutex'd code
void ServerUpdatePlayer(int i)
{
   // Movement and necessary model updates
   UpdatePlayerModel(serverplayers[i], servermeshes, false);
   Move(serverplayers[i], servermeshes, serverkdtree);
   
   // Cooling
   Uint32 ticks = SDL_GetTicks() - serverplayers[i].lastcoolingtick;
   serverplayers[i].lastcoolingtick += ticks;
   serverplayers[i].temperature -= ticks * .01;
   if (serverplayers[i].temperature < 0)
      serverplayers[i].temperature = 0;
   
   // Shots fired!
   short currplayerweapon = serverplayers[i].weapons[serverplayers[i].currweapon];
   if (serverplayers[i].leftclick && (SDL_GetTicks() - serverplayers[i].lastfiretick >= weapons[currplayerweapon].reloadtime))
   {
      serverplayers[i].lastfiretick = SDL_GetTicks();
      serverplayers[i].temperature += weapons[currplayerweapon].heat;
      Vector3 dir(0, 0, -1);
      GraphicMatrix m;
      m.rotatex(-serverplayers[i].pitch);
      m.rotatey(serverplayers[i].facing + serverplayers[i].rotation);
      //m.rotatez(player[0].roll);
      dir.transform(m.members);
               
      float vel = weapons[currplayerweapon].velocity;
      float acc = weapons[currplayerweapon].acceleration;
      float w = weapons[currplayerweapon].weight;
      float rad = weapons[currplayerweapon].radius;
      bool exp = weapons[currplayerweapon].explode;
      Vector3 startpos = serverplayers[i].pos;
      /* Use the client position if it's within ten units of the serverpos.  This avoids the need to
      slide the player around as much because this way they see their shots going exactly where
      they expect, even if the positions don't match exactly (and they rarely will:-).*/
      if (serverplayers[i].pos.distance2(serverplayers[i].clientpos) < 100)
         startpos = serverplayers[i].clientpos;
      IniReader readweapon("models/" + weapons[currplayerweapon].file + "/base");
      Mesh weaponmesh(readweapon, resman);
      Particle part(startpos, dir, vel, acc, w, rad, exp, SDL_GetTicks(), weaponmesh);
      part.pos += part.dir * 50;
      part.playernum = i;
      part.damage = weapons[currplayerweapon].damage;
      part.dmgrad = weapons[currplayerweapon].splashradius;
      part.unsent = true;
               
      servparticles.push_back(part);
   }
}
