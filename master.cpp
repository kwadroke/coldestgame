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


#include <iostream>
#include <list>
#include <set>
#include <vector>
#include <SDL/SDL_net.h>
#include "Packet.h"
#include "ServerInfo.h"
#include "util.h"
#include "IDGen.h"

using std::cout;
using std::list;
using std::set;
using std::vector;
using std::ifstream;

void InitSDL();
void Receive(UDPsocket&);
void Send(UDPsocket&);
void Ack(unsigned long, UDPpacket*);

// Packet handlers
void GetAnnounce(stringstream&, UDPpacket*);
void GetRequest(stringstream&, UDPpacket*);
void GetVersionRequest(stringstream&, UDPpacket*, unsigned long);

tsint running;
list<Packet> queue;
vector<ServerInfo> servers;
set<ServerInfo> knownservers;
IDGen masterpacketnum;

int main()
{
   logout.SetFile("console.log");
   InitSDL();
   UDPsocket socket;
   
   if (!(socket = SDLNet_UDP_Open(12011)))
   {
      logout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   running = true;
   setsighandler();
   
   logout << "Coldest master server started successfully" << endl;
   
   while (running)
   {
      SDL_Delay(500);
      
      // Receive
      Receive(socket);
      
      // Send
      Send(socket);
   }
   logout << "Coldest master server ending" << endl;
   return 0;
}


void InitSDL()
{
   if (SDL_Init(SDL_INIT_TIMER) < 0) 
   {
      logout << "Couldn't initialize SDL: " << SDL_GetError() << endl;
      exit(1);
   }
   atexit(SDL_Quit);
   
   if (SDLNet_Init() == -1)
   {
      logout << "SDLNet_Init: " << SDLNet_GetError() << endl;
      exit(1);
   }
   atexit(SDLNet_Quit);
}


void Receive(UDPsocket& socket)
{
   UDPpacket *pack;
   if (!(pack = SDLNet_AllocPacket(5000)))
   {
      logout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return;
   }
   
   while (SDLNet_UDP_Recv(socket, pack))
   {
      string packettype;
      unsigned long packetnum;
      string getdata = (char*)pack->data;
      stringstream get(getdata);
         
      get >> packettype >> packetnum;
         
      if (packettype == "a")
      {
         GetAnnounce(get, pack);
      }
      else if (packettype == "r")
      {
         GetRequest(get, pack);
      }
      else if (packettype == "v")
      {
         GetVersionRequest(get, pack, packetnum);
      }
   }
   SDLNet_FreePacket(pack);
}


void GetAnnounce(stringstream& get, UDPpacket* pack)
{
   Uint16 serverport;
   get >> serverport;
   ServerInfo addme;
   addme.address = pack->address;
   SDLNet_Write16(serverport, &addme.address.port);
   if (knownservers.find(addme) == knownservers.end())
   {
      logout << "Received announcement packet from ";
      string dotteddec = AddressToDD(pack->address.host);
      logout << dotteddec << ":" << serverport << endl;
      addme.strip = dotteddec;
      servers.push_back(addme);
      knownservers.insert(addme); // No need to wrap this, only used here
   }
}


void GetRequest(stringstream& get, UDPpacket* pack)
{
   logout << "Sending list to " << AddressToDD(pack->address.host) << ":" << SDLNet_Read16(&pack->address.port) << endl;
   for (size_t i = 0; i < servers.size(); ++i)
   {
      Packet response(&pack->address);
      response << "a\n0\n";
      response << servers[i].address.host << eol;
      response << SDLNet_Read16(&servers[i].address.port) << eol;
      queue.push_back(response);
   }
}


void GetVersionRequest(stringstream& get, UDPpacket* pack, unsigned long packetnum)
{
   logout << "Got version request" << endl;
   ifstream verfile("version");
   unsigned long version;
   verfile >> version;
   
   Packet response(&pack->address);
   response.ack = masterpacketnum;
   response << "v\n";
   response << response.ack << eol;
   response << version << eol;
   queue.push_back(response);
   Ack(packetnum, pack);
}


void Send(UDPsocket& socket)
{
   UDPpacket *pack;
   if (!(pack = SDLNet_AllocPacket(5000)))
   {
      logout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return;
   }
   
   list<Packet>::iterator i = queue.begin();
   while (i != queue.end())
   {
      i->Send(pack, socket);
      if (!i->ack || i->attempts > 5000) // Non-ack packets get sent once and then are on their own
      {
         i = queue.erase(i);
         continue;
      }
      ++i;
   }
   SDLNet_FreePacket(pack);
}


void Ack(unsigned long acknum, UDPpacket* inpack)
{
   Packet response(&inpack->address);
   response << "A\n";
   response << 0 << eol;
   response << acknum << eol;
   queue.push_back(response);
}
