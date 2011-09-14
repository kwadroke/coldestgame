#ifndef BOTNETCODE_H
#define BOTNETCODE_H

#include "NetCode.h"
#include "Timer.h"
#include "types.h"
#include "globals.h"
#include <boost/shared_ptr.hpp>


class BotNetCode : public NetCode
{
   public:
      BotNetCode();
      
      PlayerData bot;
      pid_t id;

   protected:
      virtual void HandlePacket(stringstream&);
      virtual void Send();
      
      string FillUpdatePacket();
      void SendSpawnRequest();
      
      void ReadConnect(stringstream&);
      void ReadTeamChange(stringstream&);
      void ReadAck(stringstream&);
      void ReadSpawnRequest(stringstream&);
      void ReadPing();
      void ReadDeath(stringstream&);
      
      bool connected, needconnect;
      Meshlist dummymeshes;
      int playernum;
      string map;
      Timer sendtimer;
      vector<SpawnPointData> spawns;
};

typedef boost::shared_ptr<BotNetCode> BotNetCodePtr;

#endif // BOTNETCODE_H
