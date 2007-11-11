#include "Packet.h"

Packet::Packet(UDPpacket* outpack, UDPsocket* outsock, IPaddress* inaddr, string s)
{
   packet = outpack;
   socket = outsock;
   if (inaddr)
      addr = *inaddr;
   else addr.host = INADDR_NONE;
   data = s;
   ack = false;
   attempts = 0;
}


void Packet::Send()
{
   if (!packet || !socket)
   {
      cout << "**********************NULL!!!111" << endl;
      return;
   }
   packet->address = addr;
   strcpy((char*)packet->data, data.c_str());
   packet->len = data.length() + 1;
   
   SDLNet_UDP_Send(*socket, -1, packet);
}

