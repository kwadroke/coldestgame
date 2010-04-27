#include "Replayer.h"
#include "Recorder.h"
#include "globals.h"

Replayer::Replayer() : active(false), starttick(0), filetick(0)
{}


void Replayer::SetActive(const string& filename, const bool a)
{
   if (a && !active) // Read header information
   {
      logout << "Loading replay " << filename << endl;
      SDL_mutexP(clientmutex);
      player[0].spectate = true;
      player[0].spawned = true;
      items.clear();
      SDL_mutexV(clientmutex);
      starttick = SDL_GetTicks();

      int version, minor;
      read.close();
      read.open(filename.c_str());
      if (!read)
      {
         logout << "Failed to open replay file " << filename << endl;
         return;
      }
      
      read >> version >> minor;
      if (version != Recorder::version) // minor is for potential future use to differentiate different, but compatible file versions
      {
         logout << "Replay file version mismatch\n";
         read.close();
         return;
      }

      read >> nextmap;
      string dummy;
      read >> dummy;
      read >> filetick;

      replaying = true;
      servplayernum = 0;
      mapname = "";
   }
   else if (!a)
   {
      read.close();
      replaying = false;
   }

   active = a;
}


void Replayer::Update()
{
   if (!active || !read)
      return;

   if (!spectateplayer && player.size() > 1)
      spectateplayer = 1;
   
   Uint32 currtick = SDL_GetTicks();
   Uint32 virtualtick = currtick - starttick;
   while (virtualtick > filetick)
   {
      ReadPlayers();

      ReadShots();

      string dummy;
      read >> dummy;
      if (!(read >> filetick))
         break;
   }
}


void Replayer::ReadPlayers()
{
   size_t numplayers;
   read >> numplayers;

   for (size_t i = 1; i < player.size(); ++i)
      player[i].spawned = false;

   for (size_t i = 0; i < numplayers; ++i)
   {
      size_t pnum;
      read >> pnum;
      while (pnum >= player.size())  // Make sure we have the requisite number of players
      {
         PlayerData dummy(meshes);
         player.push_back(dummy);
         logout << "Replay adding player " << (player.size() - 1) << endl;
      }

      // Position
      read >> player[pnum].pos.x >> player[pnum].pos.y >> player[pnum].pos.z;
      // Rotations
      read >> player[pnum].rotation >> player[pnum].facing >> player[pnum].pitch;

      player[pnum].spawned = true; // Only players updated in the current frame are spawned
   }
}


// Not currently implemented for the sake of testing
void Replayer::ReadShots()
{
   string dummy;
   read >> dummy;

   read >> dummy;
}