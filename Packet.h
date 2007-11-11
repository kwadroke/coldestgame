#ifndef __PACKET_H
#define __PACKET_H

#include <string>
#include <sstream>
#include <SDL_net.h>
#include <iostream> // For debugging

using namespace std;

class Packet
{
   public:
      Packet(UDPpacket* outpack = NULL, UDPsocket* outsock = NULL, IPaddress* address = NULL, string s = "");
      template <typename T>
      Packet& operator<<(const T&);
      void Send();
      IPaddress addr;
      string data;
      bool ack;
      int attempts;
      unsigned long num;
   
   private:
      UDPpacket* packet;
      UDPsocket* socket;
};

template <typename T>
Packet& Packet::operator<<(const T& s)
{
   stringstream write;
   write << s;
   data += write.str();
   return *this;
}

#endif
