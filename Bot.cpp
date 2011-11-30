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
vector<PathNodePtr> Bot::pathnodes = vector<PathNodePtr>();

// Should leave thread to be initialized last so that all other data has been initialized first
Bot::Bot() : botrunning(true),
             netcode(new BotNetCode()),
             targetplayer(0),
             closingdistance(Random(300, 1000))
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
      while (updatetimer.elapsed() < 1000 / console.GetInt("tickrate"))
      {
         SDL_Delay(1);
      }
      updatetimer.start();
      Update();
      netcode->Update();
   }
}


void Bot::Update()
{
   localplayers = GetPlayers();
   
   // Movement
   if (netcode->bot.moveleft)
      netcode->bot.facing -= .1f * movetimer.elapsed();
   if (netcode->bot.moveright)
      netcode->bot.facing += .1f * movetimer.elapsed();
   movetimer.start();
   if (console.GetBool("botsmove") && netcode->bot.spawned)
   {
      //if (!currpathnode)
         FindCurrPathNode();
      
      if (!targetplayer || !localplayers[targetplayer].spawned)
         targetplayer = SelectTarget();
      
      if (targetplayer)
      {
         UpdateHeading();
         TurnToHeading();
         
         AimAtTarget(targetplayer);
         
         // Weapons fire
         if (firetimer.elapsed() > netcode->bot.CurrentWeapon().ReloadTime() &&
            netcode->bot.temperature < 100.f - netcode->bot.CurrentWeapon().Heat()
         )
         {
            netcode->SendFire();
            firetimer.start();
         }
      }
   }
   else if (!netcode->bot.spawned)
   {
      currpathnode = PathNodePtr();
   }
}


int Bot::SelectTarget()
{
   // Build list of players on the other team
   intvec otherteam;
   for (int i = 1; i < localplayers.size(); ++i)
   {
      if (i != netcode->PlayerNum())
      {
         if (localplayers[i].team != localplayers[netcode->PlayerNum()].team && localplayers[i].spawned)
         {
            otherteam.push_back(i);
         }
      }
   }
   
   if (!otherteam.size())
      return 0;

   size_t index = Random(0, otherteam.size() - 1e-5f);
   return otherteam[index];
}


void Bot::AimAtTarget(int target)
{
   Vector3 aimvec = localplayers[target].pos - localplayers[netcode->PlayerNum()].pos;
   
   Vector3 facingvec(0.f, 0.f, -1.f);
   GraphicMatrix m;
   m.rotatey(netcode->bot.facing);
   facingvec.transform(m);
   
   Vector3 rots = RotateBetweenVectors(facingvec, aimvec);
   
   netcode->bot.rotation = rots.y + Random(-3.f, 3.f);
   netcode->bot.pitch = rots.x + Random(-1.f, 1.f);
}


// This will probably be a touch slow, but it won't need to be done much so that should be okay
void Bot::FindCurrPathNode()
{
   float currdist = 100000.f;
   for (size_t i = 0; i < pathnodes.size(); ++i)
   {
      float checkdist = pathnodes[i]->position.distance2(localplayers[netcode->PlayerNum()].pos);
      if (checkdist < currdist)
      {
         currdist = checkdist;
         currpathnode = pathnodes[i];
      }
   }
}


void Bot::UpdateHeading()
{
   float checkdist = 500.f;
   Vector3 start = localplayers[netcode->PlayerNum()].pos;
   Vector3 direct = localplayers[targetplayer].pos - start;
   Vector3 perp = direct.cross(Vector3(0.f, 1.f, 0.f));
   perp.normalize();
   perp *= closingdistance;
   direct += perp;
   
   direct.normalize();
   direct *= checkdist;
   Vector3 current = heading;
   current.normalize();
   current *= checkdist;
   Vector3 savecurrent = current;
   float angle = 0.f;
   
   if (current.distance2(direct) > 1.f)
   {
      current = (heading + direct) / 2.f;
      current.normalize();
      current *= checkdist;
      if (currpathnode->Validate(start, current, netcode->bot.size))
      {
         heading = current;
         return;
      }
   }
   
   current = savecurrent;
   
   size_t count = 0;
   while (!currpathnode->Validate(start, current, netcode->bot.size))
   {
      if (angle > -1e-5f)
         angle += 10.f;
      angle *= -1.f;
      current = heading;
      GraphicMatrix m;
      m.rotatey(angle);
      current.transform(m);
      
      if (count > 20)
      {
         logout << "Failed to find valid path: " << start << "  " << current << endl;
         return;
      }
      ++count;
   }
   
   heading = current;
}


void Bot::TurnToHeading()
{
   netcode->bot.moveleft = false;
   netcode->bot.moveright = false;
   netcode->bot.moveforward = true;
   
   Vector3 facing(0.f, 0.f, -1.f);
   GraphicMatrix m;
   m.rotatey(netcode->bot.facing);
   facing.transform(m);
   
   Vector3 rots = RotateBetweenVectors(heading, facing);
   if (fabs(rots.y) < 2.f)
      netcode->bot.facing += rots.y;
   else if (rots.y > 0.f)
      netcode->bot.moveleft = true;
   else if (rots.y < 0.f)
      netcode->bot.moveright = true;
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

