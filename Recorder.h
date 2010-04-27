#ifndef RECORDER_H
#define RECORDER_H

#include <vector>
#include <fstream>
#include <boost/shared_ptr.hpp>
#include "SDL.h"
#include "PlayerData.h"
#include "Particle.h"

using std::vector;
using boost::shared_ptr;

class Recorder
{
   public:
      Recorder();
      void SetActive(bool);
      void AddShot(unsigned long);

      void WriteFrame(bool reset = true);
      void Reset();

      static size_t CountSpawnedPlayers();

      static const int version, minor;

   private:
      string GetFilename();
      
      vector<unsigned long> shots;
      Uint32 starttick;
      bool active;

      ofstream write;
      ifstream read;
};

typedef shared_ptr<Recorder> RecorderPtr;

#endif // RECORDER_H
