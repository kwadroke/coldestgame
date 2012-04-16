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


#include "Bot.h"

// Static initialization
vector<PlayerData> Bot::players = vector<PlayerData>();
MutexPtr Bot::playermutex = MutexPtr();
vector<PathNodePtr> Bot::pathnodes = vector<PathNodePtr>();
tsint Bot::lastserverupdate;

// Should leave thread to be initialized last so that all other data has been initialized first
Bot::Bot() : botrunning(true),
             netcode(new BotNetCode()),
             targetplayer(0),
             targetspawn(-1),
             heading(Vector3(0, 0, -1.f)),
             lastupdate(0)
{
   // More difficult bots will try to get closer
   float min = 1000.f + (SkillAverage() - Skill()) * 100.f;
   closingdistance = Random(min, min + 500.f);
   
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
      while (updatetimer.elapsed() < 1000 / console.GetInt("tickrate") || lastserverupdate == lastupdate && botrunning)
      {
         SDL_Delay(1);
      }
      updatetimer.start();
      Update();
      netcode->Update();
      lastupdate = lastserverupdate;
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
      FindCurrPathNode();
      
      if (targettimer.elapsed() > 3000)
      {
         if (baseattacker)
         {
            if (baseattacker == netcode->PlayerNum())
               logout << "Error: baseattacker set to self " << baseattacker << "  " << netcode->PlayerNum() << endl;
            targetplayer = baseattacker;
            baseattacker = 0;
         }
         else if (netcode->attacker)
         {
            if (netcode->attacker == netcode->PlayerNum())
               logout << "Error: attacker set to self " << netcode->attacker << "  " << netcode->PlayerNum() << endl;
            targetplayer = netcode->attacker;
            netcode->attacker = 0;
         }
         targettimer.start();
      }
      
      if (!targetplayer || !localplayers[targetplayer].spawned || targetplayer == netcode->PlayerNum())
         targetplayer = SelectTarget();
      if (targetplayer == netcode->PlayerNum())
         logout << "Error: target selected is self " << targetplayer << "  " << netcode->PlayerNum() << endl;
      
      if (!targetplayer && targetspawn == -1)
         targetspawn = SelectTargetSpawn();
      
      UpdateHeading();
      TurnToHeading();
         
      if (targetplayer)
         AimAtTarget(localplayers[targetplayer].pos);
      else
         AimAtTarget(allspawns[targetspawn].position);
         
      // Weapons fire
      if (firetimer.elapsed() > netcode->bot.CurrentWeapon().ReloadTime() + 50 &&
         BotPlayer().temperature < 99.f - netcode->bot.CurrentWeapon().Heat()
         )
      {
         netcode->SendFire();
         firetimer.start();
      }
   }
   else if (!netcode->bot.spawned)
   {
      currpathnode = PathNodePtr();
   }
}


size_t Bot::SelectTarget()
{
   // Build list of players on the other team
   intvec otherteam;
   for (int i = 1; i < localplayers.size(); ++i)
   {
      if (i != netcode->PlayerNum())
      {
         if (localplayers[i].team != BotPlayer().team && localplayers[i].spawned)
         {
            otherteam.push_back(i);
         }
      }
   }
   
   if (!otherteam.size())
      return 0;

   // I think this random should always return valid indices, but clamp just to be safe
   size_t index = clamp(size_t(0), otherteam.size() - 1, size_t(Random(0, otherteam.size() - 1e-5f)));
   return otherteam[index];
}


size_t Bot::SelectTargetSpawn()
{
   intvec otherteam;
   for (size_t i = 0; i < allspawns.size(); ++i)
   {
      if (allspawns[i].team != Team())
      {
         otherteam.push_back(i);
      }
   }
   
   // I think this random should always return valid indices, but clamp just to be safe
   size_t index = clamp(size_t(0), otherteam.size() - 1, size_t(Random(0, otherteam.size() - 1e-5f)));
   return otherteam[index];
}


void Bot::AimAtTarget(const Vector3& target)
{
   Vector3 aimvec = target - BotPlayer().pos;
   
   Vector3 facingvec(0.f, 0.f, -1.f);
   GraphicMatrix m;
   m.rotatey(netcode->bot.facing);
   facingvec.transform(m);
   
   Vector3 rots = RotateBetweenVectors(facingvec, aimvec);
   
   float mult = SkillAverage() / Skill();
   mult *= mult;
   float r = Random(-1.f, 1.f);
   float slop = r * r;
   slop *= mult;
   if (r < 0)
      slop *= -1.f;
   netcode->bot.rotation = rots.y + 3.f * slop;
   netcode->bot.pitch = rots.x + .5f * slop;
}


void Bot::FindCurrPathNode()
{
   // Brute force it the first time - if we try to be clever there's a good chance we'll get it wrong.
   if (!currpathnode)
   {
      currpathnode = pathnodes[0];
      float currdist = pathnodes[0]->position.distance2(BotPlayer().pos);
      for (size_t j = 1; j < pathnodes.size(); ++j)
      {
         float checkdist = pathnodes[j]->position.distance2(BotPlayer().pos);
         if (checkdist < currdist)
         {
            currdist = checkdist;
            currpathnode = pathnodes[j];
         }
      }
   }
   
   list<PathNodePtr> candidates;
   float currdist = currpathnode->position.distance2(BotPlayer().pos);
   PathNodePtr current = currpathnode;
   candidates.push_back(current);
   while (candidates.size())
   {
      current = candidates.front();
      candidates.pop_front();
      
      float currcheck = current->position.distance2(BotPlayer().pos);
      if (currcheck < currdist)
      {
         currdist = currcheck;
         currpathnode = current;
      }
      
      for (size_t i = 0; i < 8; ++i)
      {
         if (current->nodes[i])
         {
            float checkdist = current->nodes[i]->position.distance2(BotPlayer().pos);
            if (checkdist < currdist)
            {
               if (std::find(candidates.begin(), candidates.end(), current->nodes[i]) == candidates.end())
                  candidates.push_back(current->nodes[i]);
            }
         }
      }
   }
}


void Bot::UpdateHeading()
{
   Vector3 start = BotPlayer().pos;
   Vector3 direct;
   if (targetplayer)
      direct = localplayers[targetplayer].pos - start;
   else
      direct = allspawns[targetspawn].position - start;
   Vector3 perp = direct.cross(Vector3(0.f, 1.f, 0.f));
   perp.normalize();
   perp *= closingdistance;
   
   direct += perp;
   direct.normalize();
   direct *= checkdist;
   
   if (heading.magnitude() < 1e-4f)
      heading = Vector3(0, 0, -checkdist);
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
         heading.y = 0.f;
         return;
      }
   }
   
   current = savecurrent;
   
   size_t count = 0;
   while (!currpathnode->Validate(start, current, netcode->bot.size))
   {
      if (angle > -1e-5f)
         angle += 20.f;
      angle *= -1.f;
      current = heading;
      GraphicMatrix m;
      m.rotatey(angle);
      current.transform(m);
      
      if (count > 18)
      {
         logout << "Failed to find valid path: " << start << "  " << current << endl;
         netcode->bot.moveforward = false;
         return;
      }
      ++count;
   }
   
   heading = current;
   heading.y = 0.f;
}


void Bot::TurnToHeading()
{
   netcode->bot.moveleft = false;
   netcode->bot.moveright = false;
   
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
   
   facing *= 250.f;
   if (currpathnode->Validate(BotPlayer().pos, facing, netcode->bot.size))
      netcode->bot.moveforward = true;
   else
      netcode->bot.moveforward = false;
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
   // We don't care about player meshes, and if we leave the iterators then it's possible for us to try to copy an iterator that has been invalidated
   for (size_t i = 0; i < players.size(); ++i)
   {
      players[i].ClearMeshes(false);
   }
   lastserverupdate = SDL_GetTicks();
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

