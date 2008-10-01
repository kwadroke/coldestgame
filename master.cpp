#include <iostream>
#include <list>
#include <set>
#include "SDL_net.h"
#include "Packet.h"

using std::cout;
using std::list;
using std::set;

void InitSDL();

bool running;
list<Packet> queue;
vector<ServerInfo> servers;
set<ServerInfo> knownservers;

int main()
{
   InitSDL();
   UDPpacket *inpack;
   
   if (!(servsock = SDLNet_UDP_Open(12011)))
   {
      cout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   if (!(pack = SDLNet_AllocPacket(5000)))
   {
      cout << "SDLNet_AllocPacket: " << SDLNet_GetError() << endl;
      return -1;
   }
   
   running = true;
   setsighandler();
   
   while (running)
   {
      SDL_Delay(1);
      
      // Receive
      while (SDLNet_UDP_Recv(servsock, pack))
      {
         string packettype;
         unsigned long packetnum;
         string getdata = (char*)inpack->data;
         stringstream get(getdata);
         
         get >> packettype >> packetnum;
         
         if (packettype == "a")
         {
            Uint16 serverport;
            get >> serverport;
            ServerInfo addme;
            addme.address = pack->address;
            SDLNet_Write16(serverport, &addme.address.port);
            if (knownservers.find(addme) == knownservers.end())
            {
               cout << "Received announcement packet from ";
               string dotteddec = AddressToDD(pack->address.host);
               cout << dotteddec << ":" << serverport << endl;
               addme.strip = dotteddec;
               servers.push_back(addme);
               knownservers.insert(addme); // No need to wrap this, only used here
            }
         }
      }
      
      // Send
      
   }
}


void InitSDL()
{
   if (SDL_Init(SDL_INIT_TIMER) < 0) 
   {
      cout << "Couldn't initialize SDL: " << SDL_GetError() << endl;
      exit(1);
   }
   atexit(SDL_Quit);
   
   if (SDLNet_Init() == -1)
   {
      cout << "SDLNet_Init: " << SDLNet_GetError() << endl;
      exit(1);
   }
   atexit(SDLNet_Quit);
}
