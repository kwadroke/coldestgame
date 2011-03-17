#ifndef NETCODE_H
#define NETCODE_H

#include "Packet.h"
#include "IDGen.h"
#include "Mutex.h"
#include <SDL_net.h>
#include <SDL_thread.h>
#include <list>

using std::list;

class NetCode
{
   public:
      NetCode();
      virtual ~NetCode();
      virtual void Update();
      void SendPacket(Packet&);

   protected:
      // No copying
      NetCode(const NetCode&);
      NetCode& operator=(const NetCode&);
      virtual void PreInit(){}
      virtual void HandlePacket(stringstream&){}
      void HandleAck(const unsigned long);
      void Ack(const unsigned long);
      virtual void Send(){}
      
      void SendThread();
      static int Start(void*);
      
      virtual void Receive();
      virtual void ReceiveExtended(){}

      UDPsocket socket;
      UDPpacket* packet;
      IPaddress address;

      Uint32 lastnettick;
      Uint32 currnettick;
      IDGen sendpacketnum;
      tsint running;
      bool error;

      SDL_Thread* thread;

      stringstream get;
      string getdata;
      string packettype;
      unsigned long packetnum;

   private:
      Mutex sendmutex;
      list<Packet> sendqueue;
};

#endif // NETCODE_H
