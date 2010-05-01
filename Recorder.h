#ifndef RECORDER_H
#define RECORDER_H

#include <vector>
#include <set>
#include <fstream>
#include <boost/shared_ptr.hpp>
#include "SDL.h"
#include "PlayerData.h"
#include "Particle.h"
#include "Timer.h"

using std::vector;
using std::set;
using boost::shared_ptr;

class Recorder
{
   public:
      Recorder();
      void SetActive(bool);
      void AddShot(const size_t, const unsigned long);
      void AddHit(const Vector3&, const int);

      void WriteFrame(bool reset = true);
      void Reset();

      static size_t CountSpawnedPlayers();

      static const int version, minor;

   private:
      string GetFilename();
      void WritePlayers();
      void WriteOccasional();
      void WriteShots();
      void WriteHits();

      vector<size_t> shotplayer;
      vector<unsigned long> shots;
      Vector3vec hitpos;
      intvec hittype;
      
      Uint32 starttick;
      bool active;
      Timer frametimer, occtimer;

      ofstream write;
      ifstream read;
};

typedef shared_ptr<Recorder> RecorderPtr;

#endif // RECORDER_H
