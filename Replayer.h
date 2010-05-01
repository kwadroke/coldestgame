#ifndef REPLAYER_H
#define REPLAYER_H

#include <fstream>
#include <SDL.h>
#include <boost/shared_ptr.hpp>
#include "PlayerData.h"
#include "Item.h"
#include "Timer.h"

using boost::shared_ptr;

// For the most part, this class does not need to grab the clientmutex because there will be nothing going on in the network threads
// while replays are going on.
class Replayer
{
   public:
      Replayer();
      void SetActive(const string&, const bool a = true);
      bool Active() {return active;}
      void Update();

   private:
      void ReadPlayers();
      void ReadShots();
      void ReadHits();
      void EnsurePlayerSize(const size_t);
      
      bool active;
      Uint32 starttick, filetick;
      Timer timer;
      size_t framecount;

      ifstream read;
};

typedef shared_ptr<Replayer> ReplayerPtr;

#endif // REPLAYER_H
