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

using namespace std;

extern string serveraddr, mapname, nextmap;
extern bool running, connected, doconnect, pingresponse, spawnrequest;
extern int tickrate;
extern unsigned long sendpacketnum, recpacketnum, ackpack;
extern vector<PlayerData> player;
extern short servplayernum;
extern list<Particle> particles;
extern list<Hit> hits;
extern SDL_mutex* clientmutex;
extern list<DynamicObject> dynobjects;
extern CollisionDetection coldet;
extern set<unsigned long> partids;
extern vector<ServerInfo> servers;
extern set<ServerInfo> knownservers;
extern SDL_Thread* netout;

int NetSend(void*);
int NetListen(void*);
//void SendPacket(UDPpacket*, string, IPaddress, UDPsocket);
string FillUpdatePacket();
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);
void UpdatePlayerModel(PlayerData&, list<DynamicObject>&);
string AddressToDD(Uint32);

list<Packet> sendqueue;
char eol = '\n';
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
   Timer t;
      
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
   
   while (running)
   {
      //t.start();
      /* If we allow this to be a very tight loop (which is what it will
      be since most of the iterations are going to skip this section), it
      kills the performance of the main thread so we do the delay to
      force it to give up CPU time.*/
      SDL_Delay(0);
      
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
            
            //cout << "Sending " << outpack->data << endl << flush;
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
         p.ack = true;
         p.num = sendpacketnum;
         SDL_mutexP(sendmutex);
         sendqueue.push_back(p);
         SDL_mutexV(sendmutex);
         doconnect = false;
      }
      if (spawnrequest)
      {
         Packet p(outpack, &outsock, &addr);
         //p.ack = true;  No ack method in place yet
         p << "S\n";
         p << sendpacketnum << eol;
         p << servplayernum << eol;
         SDL_mutexP(clientmutex);
         p << player[0].unit << eol;
         for (int i = 0; i < numbodyparts; ++i)
         {
            p << player[0].weapons[i] << eol;
         }
         SDL_mutexV(clientmutex);
         SDL_mutexP(sendmutex);
         sendqueue.push_back(p);
         SDL_mutexV(sendmutex);
         spawnrequest = false;
      }
      SDL_mutexP(sendmutex);
      list<Packet>::iterator i = sendqueue.begin();
      while (i != sendqueue.end())
      {
         i->Send();
         if (!i->ack)// || i->attempts > 30) // Non-ack packets get sent once and then are on their own
         {
            i = sendqueue.erase(i);
         }
         else ++i;
      }
      SDL_mutexV(sendmutex);
      //t.stop();
   }
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
   temp << player[0].unit << eol;
   temp << player[0].currweapon << eol;
   SDL_mutexV(clientmutex);
   
   /*list<Particle>::iterator i;
   for (i = particles.begin(); i != particles.end(); ++i)
   {
      if (i->unsent)
      {
         temp << i->id << eol;
         temp << i->dir.x << eol << i->dir.y << eol << i->dir.z << eol;
         temp << i->pos.x << eol << i->pos.y << eol << i->pos.z << eol;
         temp << i->velocity << eol;
         temp << i->accel << eol;
         temp << i->radius << eol;
         temp << i->explode << eol;
      }
   }*/
   //temp << 0 << eol;
   
   /*list<Hit>::iterator j;
   for (j = hits.begin(); j != hits.end(); ++j)
   {
      temp << j->id << eol;
      temp << j->player << eol;
      temp << j->damage << eol;
   }*/
   //temp << 0 << eol;
   
   
   //cout << "Client Update Size: " << (sizeof(temp.str()) * temp.str().length()) << "\r" << flush;
   //strcpy((char*)pack->data, temp.str().c_str());
   
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
   Timer t;
   
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
   
   while (running)
   {
      //t.start();
      SDL_Delay(0); // See comments for NetSend loop
      
      while (SDLNet_UDP_Recv(insock, inpack))
      {
         getdata = (char*)inpack->data;
         stringstream get(getdata);
         
         string debug = getdata;
         
         get >> packettype;
         get >> packetnum;
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
               for (vector<PlayerData>::iterator i = player.begin(); i != player.end(); i++)
                  i->connected = false;
               
               get >> oppnum;
               short oldunit;
               while (oppnum != 0)
               {
                  /* Warning: race condition.  Because we can't be sure that the
                     packets from the server will arrive in the correct order
                     it's possible for us to add the player and not have it be
                     in the vector slot that matches their playernum.  Whether
                     this matters remains to be seen (this problem may sort itself
                     out as we get more update packets)
                  
                     I think this has been taken care of by simply making this
                     a while loop instead of a one-shot if.*/
                  while (oppnum >= player.size())  // Add new player(s)
                  {
                     PlayerData dummy;
                     dummy.unit = UnitTest;
                     dummy.legs = dummy.torso = dummy.rarm = dummy.larm = dynobjects.end();
                     player.push_back(dummy);
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
                  get >> player[oppnum].moveforward;
                  get >> player[oppnum].moveback;
                  get >> player[oppnum].moveleft;
                  get >> player[oppnum].moveright;
                  oldunit = player[oppnum].unit;
                  get >> player[oppnum].unit;
                  get >> player[oppnum].ping;
                  
                  /*cout << "Player " << oppnum << endl;
                  if (player[oppnum].unit != "unittest")
                     cout << "Died on packet " << packetnum << endl;*/
                  /*cout << oppnum << ": " << oppx << "  " << oppy << "  " << oppz << endl << flush;
                  cout << oppfacing << "  ";
                  cout << opppitch << "  ";
                  cout << opproll << "  \n\n";*/
                  
                  player[oppnum].pos.x = oppx;
                  player[oppnum].pos.y = oppy;
                  player[oppnum].pos.z = oppz;
                  /*if (oppnum == servplayernum)
                  {
                     player[0].pos.x = (oppx + player[0].pos.x * 2.f) / 3.f;
                     player[0].pos.y = (oppy + player[0].pos.y * 2.f) / 3.f;
                     player[0].pos.z = (oppz + player[0].pos.z * 2.f) / 3.f;
                     //player[0].pos.x = oppx;
                     //player[0].pos.y = oppy;
                     //player[0].pos.z = oppz;
                     float interpamount = fabs(player[0].facing - oppfacing) + .0001; // This cannot be zero
                     interpamount = 1.f / interpamount * player[0].ping;
                     player[0].facing = (oppfacing + player[0].facing * interpamount) / (1.f + interpamount);
                     player[0].ping = player[oppnum].ping;
                  }*/
                  player[oppnum].connected = true;
                  
                  if (oppnum != servplayernum && player[oppnum].unit != 0)
                  {
                     if (oldunit != player[oppnum].unit)
                     {
                        if (player[oppnum].legs != dynobjects.end())
                           dynobjects.erase(player[oppnum].legs);
                        player[oppnum].legs = dynobjects.end();
                     }
                     UpdatePlayerModel(player[oppnum], dynobjects);
                  }
                  
                  get >> oppnum;
               }
               
               // Get particles from server
               unsigned long partnum, playernum;
               get >> partnum;
               Particle temppart;
               while (partnum != 0)
               {
                  get >> playernum;
                  get >> temppart.playerid;
                  get >> temppart.dir.x >> temppart.dir.y >> temppart.dir.z;
                  get >> temppart.pos.x >> temppart.pos.y >> temppart.pos.z;
                  get >> temppart.velocity;
                  get >> temppart.accel;
                  get >> temppart.weight;
                  get >> temppart.radius;
                  get >> temppart.explode;
                  
                  //cout << "Received particle " << partnum << " from ";
                  //cout << playernum << endl;
                  // Only add the particle if we don't already have it
                  if ((partids.find(partnum) == partids.end()))
                  {
                     temppart.cd = &coldet;
                     temppart.lasttick = SDL_GetTicks();
                     temppart.id = partnum;
                     temppart.playerid = partnum;
                     temppart.playernum = playernum;
                     temppart.obj = LoadObject("projectile", dynobjects);
                     temppart.obj->position = temppart.pos;
                     temppart.unsent = false;  // Actually meaningless on client
                           
                     partids.insert(partnum);
                     particles.push_back(temppart);
                  }
                  // If it's our particle, note that it was received by server
                  /*else if (playernum == servplayernum)
                  {
                     list<Particle>::iterator i;
                     for (i = particles.begin(); i != particles.end(); ++i)
                     {
                        if (i->playernum == 0 && i->id == temppart.playerid)
                        {
                           i->unsent = false;
                        }
                     }
                  }*/
                  get >> partnum;
               }
               
               // Find out which hits the server has ack'd
               /*unsigned long hitnum;
               list<Hit>::iterator j;
               get >> hitnum;
               while (hitnum != 0)
               {
                  get >> playernum;
                  if (playernum == servplayernum)
                  {
                     for (j = hits.begin(); j != hits.end(); ++j)
                     {
                        if (j->id == hitnum)
                        {
                           hits.erase(j);
                           break;
                        }
                     }
                  }
                  get >> hitnum;
               }*/
               
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
               for (; i != player.end(); ++i)
               {
                  if (!i->connected)
                  {
                     if (i->legs != dynobjects.end())
                     {
                        dynobjects.erase(i->legs);
                        i->legs = dynobjects.end();
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
               
               get >> oppnum;
               SDL_mutexP(clientmutex);
               while (oppnum != 0)
               {
                  get >> player[oppnum].unit;
                  get >> player[oppnum].kills;
                  get >> player[oppnum].deaths;
                  get >> player[oppnum].hp;
                  get >> player[oppnum].ping;
                  get >> oppnum;
               }
               player[0].kills = player[servplayernum].kills;
               player[0].deaths = player[servplayernum].deaths;
               player[0].hp = player[servplayernum].hp;
               player[0].ping = player[servplayernum].ping;
               SDL_mutexV(clientmutex);
            }
         }
         /*else if (packettype == "A") // Acknowledge packet
         {
            cout << "Received Acknowledge packet\n" << flush;
            ackpack = packetnum;
         }*/
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
               if (i->num == packetnum)
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
      }
      //t.stop();
   }
   SDLNet_FreePacket(inpack);
   SDLNet_UDP_Close(insock);
   return 0;
}
