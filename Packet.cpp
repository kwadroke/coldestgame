#include "Packet.h"

int Packet::laghax = 0;

Packet::Packet(IPaddress* inaddr, string s) : ack(0), data(s),
               attempts(0), lastsent(0), sendinterval(100)
{
   if (inaddr)
      addr = *inaddr;
   else addr.host = INADDR_NONE;
   sendtick = SDL_GetTicks() + laghax;
}


void Packet::Send(UDPpacket* packet, UDPsocket& socket)
{
   if (!packet)
   {
      logout << "Send Error: null packet" << endl;
      return;
   }
   
   Uint32 currtick = SDL_GetTicks();
   if (currtick - lastsent < sendinterval) // Don't swamp the receiver with ack packets
      return;
   lastsent = currtick;
   
   packet->address = addr;
   strcpy((char*)packet->data, data.c_str());
   packet->len = data.length() + 1;
   
   SDLNet_UDP_Send(socket, -1, packet);
   ++attempts;
}

