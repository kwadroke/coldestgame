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
Bot::Bot() : botrunning(true), needconnect(true), botconnected(false), bot(dummymeshes), id(0)
{
   if (!(socket = SDLNet_UDP_Open(0)))
   {
      logout << "Bot failed to open socket: " << SDLNet_GetError() << endl;
      return;
   }
   if (!(packet = SDLNet_AllocPacket(5000)))
   {
      logout << "Bot failed to allocate packet: " << SDLNet_GetError() << endl;
      return;
   }
   thread = SDL_CreateThread(Start, this);
   timer.start();
   movetimer.start();
}


Bot::~Bot()
{
   logout << "Bot id " << id << " shutting down." << endl;
   botrunning = false;
   SDL_WaitThread(thread, NULL);
   SDLNet_FreePacket(packet);
   SDLNet_UDP_Close(socket);
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
   id = gettid();
   while (botrunning)
   {
      Update();
      Send();
      Listen();
      SDL_Delay(1);
   }
}


void Bot::Update()
{
   if (bot.moveleft)
      bot.facing -= .1f * movetimer.elapsed();
   if (bot.moveright)
      bot.facing += .1f * movetimer.elapsed();
   movetimer.start();
   if (timer.elapsed() > 2000)
   {
      if (Random(0, 1) > .2)
         bot.moveforward = true;
      else
         bot.moveforward = false;
      
      if (Random(0, 1) > .5)
         bot.moveleft = true;
      else
         bot.moveleft = false;
      
      if (Random(0, 1) > .5)
         bot.moveright = true;
      else
         bot.moveright = false;
      timer.start();
   }
}


void Bot::Send()
{
   Uint32 currtick = SDL_GetTicks();
   
   if (needconnect)
   {
      SDLNet_ResolveHost(&addr, "localhost", console.GetInt("serverport"));
      Packet p(&addr);
      p.ack = sendpacketnum;
      p << "C\n";
      p << p.ack << eol;
      p << "Bot " << id << eol;
      p << 0 << eol; // Unit
      p << "Bot " << id << eol; // Name
      p << netver << eol;
      sendqueue.push_back(p);
      needconnect = false;
   }
   else if (currtick - lasttick > 1000 / (Uint32)console.GetInt("tickrate"))
   {
      lasttick = currtick;
      Packet p(&addr);
      p << FillUpdatePacket();
      sendqueue.push_back(p);
   }
   
   list<Packet>::iterator i = sendqueue.begin();
   while (i != sendqueue.end())
   {
      if (i->sendtick <= currtick)
      {
         i->Send(packet, socket);
         if (!i->ack || i->attempts > 100000) // Non-ack packets get sent once and then are on their own
         {
            i = sendqueue.erase(i);
            continue;
         }
      }
      ++i;
   }
}


string Bot::FillUpdatePacket()
{
   stringstream temp;
   
   temp << "U" << eol;
   temp << sendpacketnum << eol;
   temp << bot.pos.x << eol;
   temp << bot.pos.y << eol;
   temp << bot.pos.z << eol;
   temp << bot.rotation << eol;
   temp << bot.pitch << eol;
   temp << bot.roll << eol;
   temp << bot.facing << eol;
   temp << bot.moveforward << eol;
   temp << bot.moveback << eol;
   temp << bot.moveleft << eol;
   temp << bot.moveright << eol;
   temp << bot.leftclick << eol;
   temp << bot.rightclick << eol;
   temp << bot.run << eol;
   temp << bot.unit << eol;
   temp << bot.currweapon << eol;
   
   // Quick and dirty checksumming
   unsigned long value = 0;
   for (size_t i = 0; i < temp.str().length(); ++i)
   {
      value += (char)(temp.str()[i]);
   }
   temp << "&\n";
   temp << value << eol;
   return temp.str();
}


void Bot::Listen()
{
   string packetdata, packettype;
   unsigned long packetnum;
   
   string map;
   
   while (SDLNet_UDP_Recv(socket, packet))
   {
      packetdata = (char*)packet->data;
      stringstream get(packetdata);
      
      get >> packettype >> packetnum;
      
      if (packettype == "c") // Connect packet
      {
         if (!botconnected)
         {
            short newteam;
            get >> playernum;
            get >> map;
            get >> newteam;
            botconnected = true;
            /*itemsreceived.clear();
            hitsreceived.clear();*/
            
            // Immediately send the team change request
            Packet p(&addr);
            p.ack = sendpacketnum;
            p << "M\n";
            p << p.ack << eol;
            p << newteam << eol;
            sendqueue.push_back(p);
         }
         HandleAck(packetnum);
      }
      else if (packettype == "M")
      {
         unsigned long acknum;
         bool accepted;
         short newteam;
         get >> acknum;
         HandleAck(acknum);
         get >> accepted;
         if (accepted)
         {
            get >> newteam;
            if (bot.team != newteam)
            {
               bot.team = newteam;
                  
               spawns.clear();
               bool morespawns;
               SpawnPointData read;
               while (get >> morespawns && morespawns)
               {
                  get >> read.position.x >> read.position.y >> read.position.z;
                  get.ignore(); // Throw out \n
                  getline(get, read.name);
                  spawns.push_back(read);
               }
               
               // Immediately send a spawn request
               Packet p(&addr);
               p.ack = sendpacketnum;
               p << "S\n";
               p << p.ack << eol;
               bot.unit = 0;
               p << bot.unit << eol;
               for (int i = 0; i < numbodyparts; ++i)
               {
                  p << bot.weapons[i].Id() << eol;
               }
               p << bot.item.Type() << eol;
               p << spawns[0].position.x << eol;
               p << spawns[0].position.y << eol;
               p << spawns[0].position.z << eol;
               // Otherwise the bots bog the server down something terrible - and since they're
               // running on the same machine as the server it's highly unlikely the packet will
               // actually get lost and need to be resent
               p.sendinterval = 5000;
         
               sendqueue.push_back(p);
            }
         }
      }
      else if (packettype == "A") // Ack packet
      {
         unsigned long acknum;
         get >> acknum;
         HandleAck(acknum);
      }
      else if (packettype == "S") // Spawn request ack
      {
         bool accepted;
         unsigned long acknum;
         Vector3 newpos;
         get >> accepted;
         get >> acknum;
         get >> newpos.x >> newpos.y >> newpos.z;
            
         if (!bot.spawned)
         {
            if (accepted)
            {
               bot.pos = newpos;
               bot.size = units[bot.unit].size;
               bot.lastmovetick = SDL_GetTicks();
               if (bot.team != 0)
                  bot.spectate = false;
               bot.spawned = true;
               bot.Reset();
            }
            else
            {
               logout << "Spawn request not accepted.  This is a bot so it's not your fault." << endl;
            }
         }
         HandleAck(acknum);
      }
      else if (packettype == "P") // Ping
      {
         Packet p(&addr);
         p << "p\n";
         p << sendpacketnum << eol;
         sendqueue.push_back(p);
      }
   }
}


void Bot::HandleAck(unsigned long acknum)
{
   for (list<Packet>::iterator i = sendqueue.begin(); i != sendqueue.end(); ++i)
   {
      if (i->ack == acknum)
      {
         sendqueue.erase(i);
         break;
      }
   }
}
