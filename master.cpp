#include <iostream>
#include <list>
#include <set>
#include <vector>
#include "SDL_net.h"
#include "Packet.h"
#include "ServerInfo.h"
#include "util.h"

using std::cout;
using std::list;
using std::set;
using std::vector;

void InitSDL();
void Receive(UDPsocket&);
void Send(UDPsocket&);

// Packet handlers
void GetAnnounce(stringstream&, UDPpacket*);
void GetRequest(stringstream&, UDPpacket*);

tsint running;
list<Packet> queue;
vector<ServerInfo> servers;
set<ServerInfo> knownservers;

const char eol = '\n';

int main()
{
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
      cout << dotteddec << ":" << serverport << endl;
      addme.strip = dotteddec;
      servers.push_back(addme);
      knownservers.insert(addme); // No need to wrap this, only used here
   }
}


void GetRequest(stringstream& get, UDPpacket* pack)
{
   cout << "Sending list to " << AddressToDD(pack->address.host) << ":" << SDLNet_Read16(&pack->address.port) << endl;
   for (size_t i = 0; i < servers.size(); ++i)
   {
      Packet response(&pack->address);
      response << "a\n0\n";
      response << servers[i].address.host << eol;
      response << SDLNet_Read16(&servers[i].address.port) << eol;
      queue.push_back(response);
   }
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
