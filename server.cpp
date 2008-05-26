/* Gets started as a separate thread whenever it is requested to start
   a server from the main progam file.*/

#include <list>
#include <queue>
#include <sstream>
#include <string>
#include <vector>
#include <deque>
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
#include "ServerState.h"
#include "IDGen.h"

using namespace std;

// Necessary declarations
int ServerSend(void*);
int ServerListen();
void ServerLoadMap();
void HandleHit(Particle& p, vector<Mesh*>& hitobjs);
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);
void UpdateDOTree(DynamicPrimitive*);
void ServerUpdatePlayer(int);
void Rewind(int);
void SaveState();
void AddItem(const Item&, int);
void SendItem(const Item&, const int);
vector<Item>::iterator RemoveItem(const vector<Item>::iterator&);
void SendKill(int);
void RemoveTeam(int);
void SendSyncPacket(PlayerData&);
string AddressToDD(Uint32);

SDL_Thread* serversend;
vector<PlayerData> serverplayers;
list<Particle> servparticles;
vector<Item> serveritems;
SDL_mutex* servermutex;
IDGen servsendpacketnum;
IDGen nextservparticleid;
IDGen serveritemid;
unsigned short servertickrate;
string currentmap;
string servername;
list<Packet> servqueue;
UDPsocket servoutsock;
UDPpacket *servoutpack;
Meshlist servermeshes;
ObjectKDTree serverkdtree;
short maxplayers;
deque<ServerState> oldstate;

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
   nextservparticleid.next(); // 0 has special meaning
   servertickrate = 30;
   maxplayers = 32;
   if (console.GetString("map") == "")
      console.Parse("set map newtest");
   ServerLoadMap();
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
      if ("maps/" + console.GetString("map") != mapname) // If the server changed maps load the new one
      {
         ServerLoadMap();
      }
      for (int i = 1; i < serverplayers.size(); ++i)
      {
         if (serverplayers[i].connected && currtick - serverplayers[i].lastupdate > 5000)
         {
            validaddrs.erase(SortableIPaddress(serverplayers[i].addr));
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
      UpdateParticles(servparticles, updinterval, serverkdtree, servermeshes, Vector3(), &HandleHit, &Rewind);
      SDL_mutexV(servermutex);
      
      // Save state so we can recall it for collision detection
      SaveState();
      
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
         
         // Packet from an address that is not connected.  Inform them that they need to connect.
         if (packettype != "C" && packettype != "i" && validaddrs.find(SortableIPaddress(inpack->address)) == validaddrs.end())
         {
            Packet p(servoutpack, &servoutsock, &inpack->address);
            p << "C\n";
            p << 0 << eol;
            
            SDL_mutexP(servermutex);
            servqueue.push_back(p);
            SDL_mutexV(servermutex);
            continue;
         }
         
         if (packettype == "U") // Update packet
         {
            get >> oppnum;
            SDL_mutexP(servermutex);
            if (oppnum < serverplayers.size() && (packetnum > serverplayers[oppnum].recpacketnum)) // Ignore out of order packets
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
            get.ignore();
            getline(get, name);
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
               temp.addr = inpack->address;
               temp.unit = unit;
               temp.acked.insert(packetnum);
               UpdatePlayerModel(temp, servermeshes, false);
               
               serverplayers.push_back(temp);
               respondto = serverplayers.size() - 1;
               validaddrs.insert(SortableIPaddress(inpack->address));
            }
            
            if (!serverplayers[respondto].connected)
            {
               serverplayers[respondto].lastupdate = SDL_GetTicks();
               serverplayers[respondto].recpacketnum = packetnum;
               serverplayers[respondto].spawnpacketnum = 0;
               validaddrs.erase(SortableIPaddress(serverplayers[respondto].addr));
               serverplayers[respondto].addr = inpack->address;
               validaddrs.insert(SortableIPaddress(serverplayers[respondto].addr));
               SendSyncPacket(serverplayers[respondto]);
               for (size_t i = 0; i < serveritems.size(); ++i)
                  SendItem(serveritems[i], respondto);
               cout << "Player " << respondto << " connected\n" << flush;
            }
            serverplayers[respondto].connected = true;
            serverplayers[respondto].name = name;
            
            Packet fill(servoutpack, &servoutsock);
            fill << "c\n";
            fill << packetnum << eol;
            fill << respondto << eol;
            fill << console.GetString("map") << eol;
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
            response << console.GetString("map") << eol;
            response << serverplayers.size() << eol;
            response << maxplayers << eol;
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "S")
         {
            bool accepted = true;
            get >> oppnum;
            if (packetnum > serverplayers[oppnum].spawnpacketnum)
            {
               cout << "Player " << oppnum << " is spawning" << endl;
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
            response << "S\n";
            response << 0 << eol;  // Not sure this is okay either...
            if (accepted)
               response << 1 << eol;
            else response << 0 << eol;
            response << packetnum << eol;
            
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "T")  // Chat packet
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
                     unsigned long packid = servsendpacketnum;
                     Packet temp(servoutpack, &servoutsock);
                     temp.ack = packid;
                     temp << "T\n";
                     temp << packid << eol;
                     temp << oppnum << eol;
                     temp << line << eol;
                     temp.addr = serverplayers[i].addr;
                     servqueue.push_back(temp);
                  }
               }
            }
            Packet response(servoutpack, &servoutsock, &inpack->address);
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
         else if (packettype == "M")  // Team switch request
         {
            // For the moment just ack it, we probably want to ensure even teams at some point
            short newteam;
            get >> oppnum;
            get >> newteam;
            
            Packet response(servoutpack, &servoutsock, &inpack->address);
            response << "M\n";
            response << servsendpacketnum << eol;
            response << packetnum << eol;
            response << 1 << eol;
            response << newteam << eol;
            serverplayers[oppnum].team = newteam;
            for (int i = 0; i < spawnpoints.size(); ++i)
            {
               if ((spawnpoints[i].team == serverplayers[oppnum].team - 1) || serverplayers[oppnum].team == 1)
               {
                  response << "1\n"; // Indicate that there are more spawn points to be read
                  response << spawnpoints[i].position.x << eol;
                  response << spawnpoints[i].position.y << eol;
                  response << spawnpoints[i].position.z << eol;
                  response << spawnpoints[i].name << eol;
               }
            }
            response << 0 << eol; // No more spawn points
            SDL_mutexP(servermutex);
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
            Packet response(servoutpack, &servoutsock, &inpack->address);
            response << "A\n";
            response << servsendpacketnum << eol;
            response << packetnum << eol;
            servqueue.push_back(response);
            SDL_mutexV(servermutex);
         }
         else if (packettype == "K")
         {
            SDL_mutexP(servermutex);
            SendKill(oppnum);
            Packet response(servoutpack, &servoutsock, &inpack->address);
            response << "A\n";
            response << 0 << eol;
            response << packetnum << eol;
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
            if (serverplayers[i].spawned)
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
   nextmap = "maps/" + console.GetString("map");
   while (mapname != nextmap)
   {
      SDL_Delay(1); // Wait for main thread to load map
   }
   
   servermeshes.clear(); // This is just because right now operator= is not safe on Meshes
   servermeshes = meshes;
   
   serveritems.clear();
   
   serverplayers.clear();
   PlayerData local(servermeshes); // Dummy placeholder for the local player
   serverplayers.push_back(local);
   validaddrs.clear();
   
   // Generate main base items
   for (int i = 0; i < spawnpoints.size(); ++i)
   {
      Item newitem(Item::Base, servermeshes);
      IniReader loadmesh(newitem.ModelFile());
      Mesh newmesh(loadmesh, resman, false);
      newmesh.Move(spawnpoints[i].position);
      servermeshes.push_front(newmesh);
      serveritems.push_back(newitem);
      Item& curritem = serveritems.back();
      curritem.mesh = servermeshes.begin();
      curritem.id = serveritemid;
      curritem.team = spawnpoints[i].team;
   }
   
   Vector3vec points(8, Vector3());
   for (int i = 0; i < 4; ++i)
   {
      points[i] = coldet.worldbounds[0].GetVertex(i);// + Vector3(0, 10, 0);
   }
   for (int i = 0; i < 4; ++i)
   {
      points[i + 4] = coldet.worldbounds[5].GetVertex(i);
   }
   serverkdtree = ObjectKDTree(&servermeshes, points);
   serverkdtree.refine(0);
   
   cout << "Map loaded" << endl;
   serverhasmap = true;
   SDL_mutexV(servermutex);
}


// No need to grab the servermutex in this function because it is only called from code that already has the mutex
void HandleHit(Particle& p, vector<Mesh*>& hitobjs)
{
   Mesh* curr;
   bool dead;
   // Should only hit each body part once per projectile
   sort(hitobjs.begin(), hitobjs.end());
   hitobjs.erase(unique(hitobjs.begin(), hitobjs.end()), hitobjs.end());
   for (int j = 0; j < hitobjs.size(); ++j)
   {
      curr = hitobjs[j];
      for (int i = 1; i < serverplayers.size(); ++i)
      {
         dead = false;
         for (int part = 0; part < numbodyparts; ++part)
         {
            if (serverplayers[i].mesh[part] != servermeshes.end())
            {
               if (curr == &(*serverplayers[i].mesh[part]))
               {
                  cout << "Hit " << part << endl;
                  serverplayers[i].hp[part] -= p.damage;
                  if (serverplayers[i].hp[part] <= 0)
                     dead = true;
               }
            }
         }
         if (dead)
         {
            serverplayers[i].deaths++;
            serverplayers[p.playernum].kills++;
            cout << "Player " << i << " was killed by Player " << p.playernum << endl;
            serverplayers[i].Kill();
         }
      }
      vector<Item>::iterator i = serveritems.begin();
      while (i != serveritems.end())
      {
         if (&(*i->mesh) == curr)
         {
            i->hp -= p.damage;
            if (i->hp < 0)
            {
               for (size_t j = 0; j < spawnpoints.size(); ++j)
               {
                  if (&(*serveritems[j].mesh) == curr)
                     RemoveTeam(spawnpoints[j].team);
               }
               i = RemoveItem(i);
            }
            else ++i;
         }
         else ++i;
      }
   }
}


// Note: must be called from within mutex'd code
void ServerUpdatePlayer(int i)
{
   // TODO: Hmm, this doesn't really make sense.  We should move and then update the model, but we have to do
   // this first to make sure the model has actually been loaded.  Slight refactoring is probably needed.
   UpdatePlayerModel(serverplayers[i], servermeshes, false);
   // Movement and necessary model updates
   Rewind(serverplayers[i].ping);
   Move(serverplayers[i], servermeshes, serverkdtree);
   Rewind(0);
   
   // Cooling
   float coolrate = .01f;
   coolrate *= serverplayers[i].item.CoolMult();
   if (serverplayers[i].pos.y < 0)
      coolrate *= 1.5f;
   Uint32 ticks = SDL_GetTicks() - serverplayers[i].lastcoolingtick;
   serverplayers[i].lastcoolingtick += ticks;
   serverplayers[i].temperature -= ticks * coolrate;
   if (serverplayers[i].temperature < 0)
      serverplayers[i].temperature = 0;
   
   // Shots fired!
   Weapon& currplayerweapon = serverplayers[i].weapons[serverplayers[i].currweapon];
   if (serverplayers[i].leftclick && 
       (SDL_GetTicks() - serverplayers[i].lastfiretick >= currplayerweapon.ReloadTime()) &&
       (currplayerweapon.ammo != 0))
   {
      serverplayers[i].lastfiretick = SDL_GetTicks();
      serverplayers[i].temperature += currplayerweapon.Heat();
      if (currplayerweapon.ammo > 0) // Negative ammo value indicated infinite ammo
         currplayerweapon.ammo--;
      Vector3 dir(0, 0, -1);
      GraphicMatrix m;
      m.rotatex(-serverplayers[i].pitch);
      m.rotatey(serverplayers[i].facing + serverplayers[i].rotation);
      //m.rotatez(player[0].roll);
      dir.transform(m.members);
               
      float vel = currplayerweapon.Velocity();
      float acc = currplayerweapon.Acceleration();
      float w = currplayerweapon.Weight();
      float rad = currplayerweapon.Radius();
      bool exp = currplayerweapon.Explode();
      Vector3 startpos = serverplayers[i].pos;
      /* Use the client position if it's within ten units of the serverpos.  This avoids the need to
      slide the player around as much because this way they see their shots going exactly where
      they expect, even if the positions don't match exactly (and they rarely will:-).*/
      if (serverplayers[i].pos.distance2(serverplayers[i].clientpos) < 100)
         startpos = serverplayers[i].clientpos;
      IniReader readweapon("models/" + currplayerweapon.ModelFile() + "/base");
      Mesh weaponmesh(readweapon, resman);
      Particle part(nextservparticleid, startpos, dir, vel, acc, w, rad, exp, SDL_GetTicks(), weaponmesh);
      part.pos += part.dir * 50;
      part.playernum = i;
      part.damage = currplayerweapon.Damage();
      part.dmgrad = currplayerweapon.Splash();
      part.unsent = true;
      part.rewind = serverplayers[i].ping;
      part.collide = true;
               
      servparticles.push_back(part);
   }
}


void Rewind(int ticks)
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
   
   for (size_t j = 0; j < oldstate[i].index.size(); ++j)
   {
      size_t p = oldstate[i].index[j];
      if (serverplayers[p].spawned)
      {
         for (size_t k = 0; k < numbodyparts; ++k)
         {
            serverplayers[p].mesh[k]->SetState(oldstate[i].position[j][k], oldstate[i].rots[j][k],
                                             oldstate[i].frame[j][k], oldstate[i].animtime[j][k],
                                             oldstate[i].animspeed[j][k]);
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


// Grab the servermutex before calling
void AddItem(const Item& it, int oppnum)
{
   if (it.Type() == Item::SpawnPoint)
   {
      IniReader loadmesh(it.ModelFile());
      Mesh newmesh(loadmesh, resman, false);
      newmesh.Move(serverplayers[oppnum].pos);
      newmesh.dynamic = true;
      servermeshes.push_front(newmesh);
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
   Packet p(servoutpack, &servoutsock, &serverplayers[oppnum].addr);
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
         Packet p(servoutpack, &servoutsock, &serverplayers[i].addr);
         p.ack = servsendpacketnum;
         p << "R\n";
         p << p.ack << eol;
         p << it->id << eol;
         
         cout << "Removing " << it->id << endl;
            
         servqueue.push_back(p);
      }
   }
   servermeshes.erase(it->mesh);
   return serveritems.erase(it);
}


// Note: Must grab mutex first
void SendKill(int num)
{
   Packet deadpacket(servoutpack, &servoutsock);
   deadpacket.ack = servsendpacketnum;
   deadpacket.addr = serverplayers[num].addr;
            
   deadpacket << "d\n";
   deadpacket << deadpacket.ack << eol; // This line is kind of strange looking, but it's okay
   servqueue.push_back(deadpacket);
}


// At this time just ends the game because only two teams are supported.  Will more be in the future?  Who knows.
void RemoveTeam(int num)
{
   cout << "Team " << num << " has been defeated" << endl;
}


void SendSyncPacket(PlayerData& p)
{
   Packet pack(servoutpack, &servoutsock, &p.addr);
   pack.ack = servsendpacketnum;
   pack << "Y\n";
   pack << pack.ack << eol;
   pack << "set movestep " << console.GetInt("movestep") << eol;
   pack << "set ghost " << console.GetBool("ghost") << eol;
   pack << "set fly " << console.GetBool("fly") << eol;
   pack << "set tickrate " << console.GetInt("tickrate") << eol;
   pack << "endofcommands\n";
   
   servqueue.push_back(pack);
}

