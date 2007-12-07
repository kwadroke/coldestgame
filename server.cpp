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

using namespace std;

// Necessary declarations
extern bool running;
extern char eol;
extern const int terrobjsize;
extern string nextmap, mapname;
extern ObjectKDTree kdtree;
extern CollisionDetection coldet;
extern list<WorldObjects> objects;
extern WorldPrimitives worldbounds[6];
extern vector<UnitData> units;
extern vector<WeaponData> weapons;


int ServerSend(void*);
int ServerListen();
void Move(PlayerData&, list<DynamicObject>&, CollisionDetection&);
void ServerLoadMap();
void HandleHit(Particle& p);
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);
void UpdatePlayerModel(PlayerData&, list<DynamicObject>&);
void UpdateDOTree(DynamicPrimitive*);
float Random(float, float);

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
list<DynamicObject> serverdynobjects;
CollisionDetection servercoldet;
ObjectKDTree serverkdtree;
short maxplayers;

int Server(void* dummy)
{
   srand(time(0));
   int choosename = (int)Random(0, 16);
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
      currentmap = "newtest";
   ServerLoadMap();
   PlayerData local; // Dummy placeholder for the local player
   local.legs = local.torso = local.larm = local.rarm = serverdynobjects.end();
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
   Timer t;
   
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
   
   while (running)
   {
      //t.start();
      SDL_Delay(0); // Prevent CPU hogging
      
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
            serverplayers[i].connected = false;
            cout << "Player " << i << " timed out.\n" << flush;
         }
         else if (serverplayers[i].connected)
         {
            //cout << "*****************Moving player " << i << endl;
            Move(serverplayers[i], serverdynobjects, servercoldet);
            UpdatePlayerModel(serverplayers[i], serverdynobjects);
            short currplayerweapon = serverplayers[i].weapons[serverplayers[i].currweapon];
            if (serverplayers[i].leftclick && (SDL_GetTicks() - serverplayers[i].lastfiretick >= weapons[currplayerweapon].reloadtime))
            {
               serverplayers[i].lastfiretick = SDL_GetTicks();
               Vector3 dir(0, 0, -1);
               GraphicMatrix m;
               m.rotatex(-serverplayers[i].pitch);
               m.rotatey(serverplayers[i].facing + serverplayers[i].rotation);
               //m.rotatez(player[0].roll);
               dir.transform(m.members);
               
               list<DynamicObject>::iterator temp = LoadObject(weapons[currplayerweapon].file, serverdynobjects);
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
               Particle part(startpos, dir, vel, acc, w, rad, exp, temp, SDL_GetTicks());
               part.pos += part.dir * 40;
               part.cd = &servercoldet;
               part.playernum = i;
               part.damage = weapons[currplayerweapon].damage;
               part.dmgrad = weapons[currplayerweapon].splashradius;
               part.unsent = true;
               
               servparticles.push_back(part);
            }
         }
      }
      // Update server dynamic objects
      list<DynamicObject>::iterator k;
      for (k = serverdynobjects.begin(); k != serverdynobjects.end(); ++k)
      {
         list<DynamicPrimitive*>::iterator j;
         for (j = k->prims[k->animframe].begin(); j != k->prims[k->animframe].end(); ++j)
         {
            if ((*j)->parentid == "-1")
            {
               UpdateDOTree(*j);
            }
         }
      }
      // Update particles
      list<Particle>::iterator j = servparticles.begin();
      while (j != servparticles.end())
      {
         if (j->Update(&serverdynobjects))
         {
            if (j->damage != 0)
               HandleHit(*j);
            serverdynobjects.erase(j->obj);
            j = servparticles.erase(j);
         }
         else ++j;
      }
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
               get >> dummy;//sserverplayers[oppnum].moveright;
               get >> serverplayers[oppnum].leftclick;
               get >> serverplayers[oppnum].rightclick;
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
            get >> unit;
            bool add = true;
            int respondto = 0;
            SDL_mutexP(servermutex);
            for (int i = 0; i < serverplayers.size(); ++i)
            {
               if (serverplayers[i].addr.host == inpack->address.host)
               {
                  respondto = i;
                  if (serverplayers[i].acked.find(packetnum) != serverplayers[i].acked.end())
                     add = false;
               }
            }
            if (add)
            {
               PlayerData temp;
               temp.recpacketnum = packetnum;
               temp.addr = inpack->address;
               temp.connected = true;
               temp.lastupdate = SDL_GetTicks();
               temp.unit = unit;
               temp.hp = 100;
               temp.kills = 0;
               temp.deaths = 0;
               temp.acked.insert(packetnum);
               temp.lastmovetick = SDL_GetTicks();
               temp.pos = Vector3(100, 100, 200);
               temp.moveleft = temp.moveright = temp.moveforward = temp.moveback = false;
               temp.size = 10;
               temp.lastfiretick = SDL_GetTicks();
               temp.leftclick = temp.rightclick = false;
               temp.legs = LoadObject(units[unit].file + "/legs", serverdynobjects);
               temp.torso = temp.larm = temp.rarm = serverdynobjects.end();
               temp.currweapon = Torso;
               temp.ping = 0;
               for (int i = 0; i < numbodyparts; ++i)
                  temp.weapons.push_back(Empty);
               
               SDLNet_Write16(1336, &(temp.addr.port)); // NBO bites me for the first time...
               serverplayers.push_back(temp);
               respondto = serverplayers.size() - 1;
               cout << "Player " << (serverplayers.size() - 1) << " connected\n" << flush;
            }
            
            Packet fill(servoutpack, &servoutsock);
            fill << "c\n";
            fill << packetnum << eol;
            fill << respondto << eol;
            fill << currentmap << eol;
            cout << "Server Sent ACK" << packetnum << " to player " << respondto << endl;
            
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
            get >> oppnum;
            SDL_mutexP(servermutex);
            get >> serverplayers[oppnum].unit;
            for (int i = 0; i < numbodyparts; ++i)
            {
               get >> serverplayers[oppnum].weapons[i];
            }
            SDL_mutexV(servermutex);
            
            // Need to ack this, but no method in place as yet
            // Also need to validate their configuration
         }
         
      }
      //t.stop();
   }
   
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
   Timer t;
   
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
   
   while (running)
   {
      //t.start();
      SDL_Delay(0);  // Keep the loop from eating too much CPU
      
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
                  occup << serverplayers[i].hp << eol;
                  occup << serverplayers[i].ping << eol;
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
            if (!i->ack) // Non-ack packets get sent once and then are on their own
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
   return 0;
}


void ServerLoadMap()
{
   nextmap = "maps/" + currentmap;
   while (mapname != nextmap)
   {
      SDL_Delay(0); // Wait for main thread to load map
   }
   
   serverkdtree = kdtree;
   
   servercoldet = coldet;
   servercoldet.kdtree = &serverkdtree;
   cout << "Map loaded" << endl;
}


// No need to grab the servermutex in this function because it is only called from code that already has the mutex
void HandleHit(Particle& p)
{
   list<DynamicObject>::iterator curr;
   while (!p.hitobjs.empty())
   {
      curr = p.hitobjs.top();
      for (int i = 1; i < serverplayers.size(); ++i)
      {
         if (curr == serverplayers[i].legs)  // Or other parts of player unit
         {
            serverplayers[i].hp -= p.damage;
            if (serverplayers[i].hp <= 0)
            {
               serverplayers[i].deaths++;
               serverplayers[i].hp = 100;
               serverplayers[p.playernum].kills++;
               cout << "Player " << i << " was killed by Player "
                     << p.playernum << endl;
            }
            break;
         }
      }
      p.hitobjs.pop();
   }
}


void UpdateDOTree(DynamicPrimitive* root)
{
   list<DynamicObject>::iterator parent = root->parentobj;
      
   for (int i = 0; i < 4; ++i)
      root->v[i] = root->orig[i];
   
   root->m = GraphicMatrix();
   
   root->m.rotatex(root->rot2.x);
   root->m.rotatey(root->rot2.y);
   root->m.rotatez(root->rot2.z);
   
   root->m.translate(root->trans.x, root->trans.y, root->trans.z);
   root->m.rotatex(root->rot1.x);
   root->m.rotatey(root->rot1.y);
   root->m.rotatez(root->rot1.z);
   
   if (root->parentid == "-1")  // Move to object position only for root nodes
   {
      root->m.rotatex(-parent->pitch);
      root->m.rotatey(parent->rotation);
      root->m.rotatez(parent->roll);
      root->m.translate(parent->position.x, parent->position.y, parent->position.z);
   }
   else
   {
      root->m *= root->parent->m;
   }
   
   for (int i = 0; i < 4; ++i)
      root->v[i].transform(root->m);
   
   list<DynamicPrimitive*>::iterator i;
   for (i = root->child.begin(); i != root->child.end(); i++)
   {
      UpdateDOTree(*i);
   }
}
