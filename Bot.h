#ifndef __BOT_H
#define __BOT_H

#include <list>
#include <boost/shared_ptr.hpp>
#include "SDL_net.h"
#include "IDGen.h"
#include "Packet.h"
#include "util.h"
#include "globals.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Bot{
   public:
      Bot();
      ~Bot();
   
   private:
      bool botrunning;
      UDPsocket socket;
      UDPpacket* packet;
      IPaddress addr;
      IDGen sendpacketnum;
      
      Uint32 lasttick;
      bool needconnect, botconnected;
      list<Packet> sendqueue;
      
      int playernum;
      Meshlist dummymeshes;
      PlayerData bot;
      vector<SpawnPointData> spawns;
      
      int id;
      SDL_Thread* thread;
      
      // Don't really want to copy this object because threads would need
      // to be restarted every time.  To use in an STL container use
      // smart pointers
      Bot(const Bot&);
      Bot& operator=(const Bot&);
      
      static int Start(void*);
      void Loop();
      void Send();
      void Listen();
      void HandleAck(unsigned long);
      string FillUpdatePacket();
};

typedef boost::shared_ptr<Bot> BotPtr;

#endif
