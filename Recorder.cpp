#include "Recorder.h"
#include <ctime>

const int Recorder::version = 1;
const int Recorder::minor = 0;

Recorder::Recorder(vector<PlayerData>& p, vector<Item>& i) : players(p), items(i), starttick(0)
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
   }
   else
   {
      write.close();
   }
   active = a;
}

void Recorder::AddShot(unsigned long weapid)
{
   shots.push_back(weapid);
}


// TODO: Clean up the unnecessary headings once this is all working
void Recorder::WriteFrame(bool reset)
{
   if (!active)
      return;
   
   write << "Frame start\n";

   Uint32 currtick = SDL_GetTicks();
   Uint32 virtualtick = currtick - starttick;
   write << virtualtick << endl;
   
   for (size_t i = 1; i < players.size(); ++i)
   {
      if (players[i].spawned)
      {
         write << i << endl;
         write << players[i].pos.x << endl;
         write << players[i].pos.y << endl;
         write << players[i].pos.z << endl;
         write << players[i].rotation << endl;
         write << players[i].facing << endl;
         write << players[i].pitch << endl;
      }
   }

   write << "Shots" << endl;
   write << shots.size() << endl;
   for (size_t i = 0; i < shots.size(); ++i)
   {
      write << shots[i] << endl;
   }
   
   if (reset)
      Reset();
}


void Recorder::Reset()
{
   shots.clear();
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
