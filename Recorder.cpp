// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008-2012 Ben Nemec
// @End License@
#include "Recorder.h"
#include "globals.h"
#include <ctime>
#ifndef _WIN32
#include <boost/filesystem.hpp>
#endif

const int Recorder::version = 2;
const int Recorder::minor = 0;
const string Recorder::savepath = "replays/";

Recorder::Recorder() : starttick(0), active(false)
{
   string path = userpath + savepath;
#ifndef WIN32
   if (!boost::filesystem::is_directory(path))
      boost::filesystem::create_directory(path);
#else
   CreateDirectory((TCHAR*)path.c_str(), NULL);
#endif
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
      write << currmap->MapName() << endl;
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

void Recorder::AddItem(const Item& item)
{
   if (!active)
      return;
   
   newitem.push_back(item);
}


// TODO: Clean up the unnecessary headings once this is all working
void Recorder::WriteFrame(bool reset)
{
   if (!active || frametimer.elapsed() < 1000.f / console.GetFloat("recordfps"))
      return;
   
   Uint32 currtick = SDL_GetTicks();
   Uint32 virtualtick = currtick - starttick;
   write << virtualtick << endl;

   WritePlayers();

   WriteOccasional();

   WriteShots();

   WriteHits();

   WriteItems();
   
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

void Recorder::WriteItems()
{
   write << newitem.size() << endl;
   for (size_t i = 0; i < newitem.size(); ++i)
   {
      write << newitem[i].position.x << endl << newitem[i].position.y << endl << newitem[i].position.z << endl;
      write << newitem[i].Type() << endl;
      write << newitem[i].team << endl;
      write << newitem[i].id << endl;
   }
}


void Recorder::Reset()
{
   shotplayer.clear();
   shots.clear();
   hitpos.clear();
   hittype.clear();
   newitem.clear();
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

   string retval = userpath + savepath + currmap->MapName();
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
