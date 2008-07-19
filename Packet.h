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
      Packet(IPaddress* address = NULL, string s = "");
      template <typename T>
      Packet& operator<<(const T&);
      
      template <typename T>
      Packet& operator<<(T&);
      void Send(UDPpacket*, UDPsocket&);
      IPaddress addr;
      string data;
      unsigned long ack;
      int attempts;
      Uint32 sendtick;
      static int laghax;
};

// Need both a const and non-const version of this function.
// The full reasons are not clear to me, but I need to be able to pass in non-const objects
// (IDGen is nonsensical as a const object) and const built-ins such as 0 seem to require
// that there be a const version as well.
template <typename T>
Packet& Packet::operator<<(const T& s)
{
   stringstream write;
   write << s;
   data += write.str();
   return *this;
}

template <typename T>
Packet& Packet::operator<<(T& s)
{
   stringstream write;
   write << s;
   data += write.str();
   return *this;
}

#endif
