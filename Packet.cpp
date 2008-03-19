#include "Packet.h"

int Packet::laghax = 0;

Packet::Packet(UDPpacket* outpack, UDPsocket* outsock, IPaddress* inaddr, string s) : ack(0), data(s),
               attempts(0), packet(outpack), socket(outsock)
{
   if (inaddr)
      addr = *inaddr;
   else addr.host = INADDR_NONE;
   sendtick = SDL_GetTicks() + laghax;
}


void Packet::Send()
{
   if (!packet || !socket)
   {
      cout << "Error: Packet has null packet or socket" << endl;
      return;
   }
   packet->address = addr;
   strcpy((char*)packet->data, data.c_str());
   packet->len = data.length() + 1;
   
   SDLNet_UDP_Send(*socket, -1, packet);
   ++attempts;
}

