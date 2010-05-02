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
      read >> filetick;

      timer.start();

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

      ReadHits();

      ReadItems();

      if (!(read >> filetick))
      {
         // Output performance stats
         logout << "Time: " << (timer.elapsed() / 1000.f) << " seconds" << endl;;
         logout << "Frames: " << framecount << endl;
         logout << "Avg. FPS: " << ((float)framecount / (float)timer.elapsed() * 1000.f) << endl;
         break;
      }
   }
   ++framecount;
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
      EnsurePlayerSize(pnum);

      // Position
      read >> player[pnum].pos.x >> player[pnum].pos.y >> player[pnum].pos.z;
      // Rotations
      read >> player[pnum].rotation >> player[pnum].facing >> player[pnum].pitch;
      read >> player[pnum].speed;

      player[pnum].spawned = true; // Only players updated in the current frame are spawned
   }

   // Occasional updates
   size_t occ;
   read >> occ;
   if (occ)
   {
      for (size_t i = 1; i < occ; ++i)
      {
         EnsurePlayerSize(i);
         read >> player[i].team;
         read >> player[i].unit;
         read >> player[i].kills;
         read >> player[i].deaths;
         read.ignore(); // Skip \n
         getline(read, player[i].name);
      }
   }
}


void Replayer::ReadShots()
{
   size_t numshots;
   read >> numshots;

   for (size_t i = 0; i < numshots; ++i)
   {
      size_t pnum;
      int weapid;
      read >> pnum >> weapid;

      ClientCreateShot(player[pnum], weapid);
   }
}

void Replayer::ReadHits()
{
   size_t numhits;
   read >> numhits;
   for (size_t i = 0; i < numhits; ++i)
   {
      Vector3 pos;
      int type;
      read >> pos.x >> pos.y >> pos.z;
      read >> type;

      AddHit(pos, type);
   }
}

void Replayer::ReadItems()
{
   size_t numitems;
   read >> numitems;
   for (size_t i = 0; i < numitems; ++i)
   {
      Vector3 pos;
      unsigned long id;
      int type, team;

      read >> pos.x >> pos.y >> pos.z;
      read >> type >> team >> id;

      Item newitem(type, meshes);
      newitem.position = pos;
      newitem.team = team;
      newitem.id = id;
      additems.push_back(newitem);
   }
}


// Make sure that there are at least s players in the player vector
void Replayer::EnsurePlayerSize(const size_t s)
{
   while (s >= player.size())  // Make sure we have the requisite number of players
   {
      PlayerData dummy(meshes);
      player.push_back(dummy);
      logout << "Replay adding player " << (player.size() - 1) << endl;
   }
}