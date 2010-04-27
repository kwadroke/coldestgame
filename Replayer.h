#ifndef REPLAYER_H
#define REPLAYER_H

#include <fstream>
#include <SDL.h>
#include <boost/shared_ptr.hpp>
#include "PlayerData.h"
#include "Item.h"

using boost::shared_ptr;

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
      
      bool active;
      Uint32 starttick, filetick;

      ifstream read;
};

typedef shared_ptr<Replayer> ReplayerPtr;

#endif // REPLAYER_H
