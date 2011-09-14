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
   if (netcode->bot.moveleft)
      netcode->bot.facing -= .1f * movetimer.elapsed();
   if (netcode->bot.moveright)
      netcode->bot.facing += .1f * movetimer.elapsed();
   movetimer.start();
   if (console.GetBool("botsmove") && timer.elapsed() > 2000)
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
}

