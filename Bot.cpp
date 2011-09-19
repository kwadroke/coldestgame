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
// Copyright 2008, 2011 Ben Nemec
// @End License@


#include "Bot.h"

// Static initialization
vector<PlayerData> Bot::players = vector<PlayerData>();
MutexPtr Bot::playermutex = MutexPtr();

// Should leave thread to be initialized last so that all other data has been initialized first
Bot::Bot() : botrunning(true),
             netcode(new BotNetCode())
{
   timer.start();
   movetimer.start();
   thread = SDL_CreateThread(Start, this);
}


Bot::~Bot()
{
   logout << "Bot id " << netcode->id << " shutting down." << endl;
   botrunning = false;
   SDL_WaitThread(thread, NULL);
}


// static
int Bot::Start(void* obj)
{
   setsighandler();
   
   logout << "Bot id " << gettid() << " started." << endl;
   
   ((Bot*)obj)->Loop();
   return 0;
}


void Bot::Loop()
{
   netcode->id = gettid();
   while (botrunning)
   {
      Update();
      netcode->Update();
      SDL_Delay(1);
   }
}


void Bot::Update()
{
   // Movement
   if (netcode->bot.moveleft)
      netcode->bot.facing -= .1f * movetimer.elapsed();
   if (netcode->bot.moveright)
      netcode->bot.facing += .1f * movetimer.elapsed();
   movetimer.start();
   if (console.GetBool("botsmove"))
   {
      if (timer.elapsed() > Random(0, 2000))
      {
         if (Random(0, 1) > .2)
            netcode->bot.moveforward = true;
         else
            netcode->bot.moveforward = false;
         
         if (Random(0, 1) > .5)
            netcode->bot.moveleft = true;
         else
            netcode->bot.moveleft = false;
         
         if (Random(0, 1) > .5)
            netcode->bot.moveright = true;
         else
            netcode->bot.moveright = false;
         timer.start();
      }
      
      vector<PlayerData> p = GetPlayers();
      if (p.size() > 2)
      {
         Vector3 aimvec = p[1].pos - p[2].pos;//netcode->bot.pos;
         
         Vector3 facingvec(0.f, 0.f, -1.f);
         GraphicMatrix m;
         m.rotatey(netcode->bot.facing);
         facingvec.transform(m);
         
         Vector3 rots = RotateBetweenVectors(facingvec, aimvec);
         logout << rots << endl;
         logout << facingvec << endl;
         logout << p[1].pos << endl;
         logout << aimvec << endl << endl;

         netcode->bot.rotation = rots.y;
         netcode->bot.pitch = rots.x;
      }
      
   }
   
   // Weapons fire
   if (firetimer.elapsed() > netcode->bot.CurrentWeapon().ReloadTime() &&
      netcode->bot.temperature < 100.f - netcode->bot.CurrentWeapon().Heat()
   )
   {
      netcode->SendFire();
      firetimer.start();
   }
}

// This must be called before creating bots
//static
void Bot::Initialize()
{
   if (!playermutex)
      playermutex = MutexPtr(new Mutex);
}

//static
void Bot::SetPlayers(vector<PlayerData>& in)
{
   playermutex->lock();
   players = in;
   playermutex->unlock();
}

//static
vector<PlayerData> Bot::GetPlayers()
{
   playermutex->lock();
   vector<PlayerData> retval = players;
   playermutex->unlock();
   return retval;
}

