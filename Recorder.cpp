#include "Recorder.h"
#include "globals.h"
#include <ctime>

const int Recorder::version = 1;
const int Recorder::minor = 0;

Recorder::Recorder() : starttick(0), active(false)
{
}


void Recorder::SetActive(bool a)
{
   if (a)
   {
      starttick = SDL_GetTicks();
      shots.clear();
      items.clear();
      write.close();
      write.open(GetFilename().c_str());
      write << version << endl;
      write << minor << endl;
      write << mapname << endl;
   }
   else
   {
      write.close();
   }
   active = a;
}

void Recorder::AddShot(size_t p, unsigned long weapid)
{
   if (!active)
      return;
   
   shotplayer.push_back(p);
   shots.push_back(weapid);
}

void Recorder::AddHit(const Vector3& pos, const int type)
{
   if (!active)
      return;

   hitpos.push_back(pos);
   hittype.push_back(type);
}


// TODO: Clean up the unnecessary headings once this is all working
void Recorder::WriteFrame(bool reset)
{
   if (!active || frametimer.elapsed() < 50)
      return;
   
   Uint32 currtick = SDL_GetTicks();
   Uint32 virtualtick = currtick - starttick;
   write << virtualtick << endl;

   WritePlayers();

   WriteOccasional();

   WriteShots();

   WriteHits();
   
   if (reset)
      Reset();
   frametimer.start();
}


void Recorder::WritePlayers()
{
   write << CountSpawnedPlayers() << endl;
   for (size_t i = 1; i < player.size(); ++i)
   {
      if (player[i].spawned)
      {
         write << i << endl;
         write << player[i].pos.x << endl;
         write << player[i].pos.y << endl;
         write << player[i].pos.z << endl;
         write << player[i].rotation << endl;
         write << player[i].facing << endl;
         write << player[i].pitch << endl;
         write << player[i].speed << endl;
      }
   }
}

void Recorder::WriteOccasional()
{
   if (occtimer.elapsed() > 1000)
   {
      write << player.size() << endl;
      for (size_t i = 1; i < player.size(); ++i)
      {
         write << player[i].team << endl;
         write << player[i].unit << endl;
         write << player[i].kills << endl;
         write << player[i].deaths << endl;
         write << player[i].name << endl;
      }
      occtimer.start();
   }
   else
   {
      write << 0 << endl;
   }
}

void Recorder::WriteShots()
{
   write << shots.size() << endl;
   for (size_t i = 0; i < shots.size(); ++i)
   {
      write << shotplayer[i] << endl;
      write << shots[i] << endl;
   }
}

void Recorder::WriteHits()
{
   write << hitpos.size() << endl;
   for (size_t i = 0; i < hitpos.size(); ++i)
   {
      write << hitpos[i].x << endl << hitpos[i].y << endl << hitpos[i].z << endl;
      write << hittype[i] << endl;
   }
}


void Recorder::Reset()
{
   shotplayer.clear();
   shots.clear();
   hitpos.clear();
   hittype.clear();
   items.clear();
}


// Convert the current time and date into a filename for replays
string Recorder::GetFilename()
{
   time_t rawtime;
   struct tm* timeinfo;

   time(&rawtime);
   timeinfo = localtime(&rawtime);

   const size_t buffersize = 80;
   char buffer[buffersize];
   strftime(buffer, buffersize - 1, "%Y-%m-%d-%H%M%S", timeinfo);

   string retval = "Coldest";
   retval += buffer;
   retval += ".cor";
   return retval;
}

// static
size_t Recorder::CountSpawnedPlayers()
{
   size_t retval = 0;
   for (size_t i = 1; i < player.size(); ++i)
   {
      if (player[i].spawned)
         ++retval;
   }
   return retval;
}
