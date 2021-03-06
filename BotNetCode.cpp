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
#include "BotNetCode.h"

using std::getline;

BotNetCode::BotNetCode() : bot(dummymeshes),
                           id(0),
                           attacker(0),
                           connected(false),
                           needconnect(true),
                           playernum(0)
{
   if (!(socket = SDLNet_UDP_Open(0)))
   {
      logout << "Bot failed to open socket: " << SDLNet_GetError() << endl;
      return;
   }
   
   bot.weapons[1] = Weapon(Weapon::Laser);
}


void BotNetCode::Send()
{
   if (needconnect)
   {
      SDLNet_ResolveHost(&address, "localhost", console.GetInt("serverport"));
      Packet p(&address);
      p.ack = sendpacketnum;
      p << "C\n";
      p << p.ack << eol;
      p << "Bot " << id << eol;
      p << 0 << eol; // Unit
      p << "Bot " << id << eol; // Name
      p << NetCode::Version() << eol;
      SendPacket(p);
      needconnect = false;
   }
   else 
   {
      if (sendtimer.elapsed() > 1000 / (Uint32)console.GetInt("tickrate"))
      {
         Packet p(&address);
         p << FillUpdatePacket();
         SendPacket(p);
         sendtimer.start();
      }
      if (respawntimer.elapsed() > console.GetInt("respawntime") && !bot.spawned && spawns.size())
      {
         SendSpawnRequest();
      }
   }
   
}


string BotNetCode::FillUpdatePacket()
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


void BotNetCode::SendSpawnRequest()
{
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "S\n";
   p << p.ack << eol;
   
   // Select unit and item based on salvage
   bot.unit = 0;
   bot.item = Item(Item::NoItem, dummymeshes);
   if (bot.salvage > 100)
      bot.unit = 1;
   if (bot.salvage > 115)
   {
      if (bot.salvage % 2 == 0)
         bot.item = Item(Item::HeatSink, dummymeshes);
      else 
         bot.item = Item(Item::Armor, dummymeshes);
   }
   
   p << bot.unit << eol;
   for (int i = 0; i < numbodyparts; ++i)
   {
      p << bot.weapons[i].Id() << eol;
   }
   p << bot.item.Type() << eol;
   p << selectedspawn.position.x << eol;
   p << selectedspawn.position.y << eol;
   p << selectedspawn.position.z << eol;
   // Otherwise the bots bog the server down something terrible - and since they're
   // running on the same machine as the server it's highly unlikely the packet will
   // actually get lost and need to be resent
   p.sendinterval = 5000;
   
   SendPacket(p);
}


void BotNetCode::SendFire()
{
   // Bots are local so this doesn't need to be acked, and if the server gets bogged down making this
   // an ack packet can cause it to be sent twice, and possibly overheat the bot.
   Packet pack(&address);
   pack << "f\n";
   pack << sendpacketnum << eol;
   SendPacket(pack);
}


vector<SpawnPointData> BotNetCode::GetBotSpawns(int team)
{
   vector<SpawnPointData> retval;
   vector<SpawnPointData> itemspawns = GetSpawns(items);
   for (size_t i = 0; i < spawns.size(); ++i)
   {
      if (spawns[i].team == team)
         retval.push_back(spawns[i]);
   }
   for (size_t i = 0; i < itemspawns.size(); ++i)
   {
      if (itemspawns[i].team == team)
         retval.push_back(itemspawns[i]);
   }
   return retval;
}


void BotNetCode::HandlePacket(stringstream& get)
{
   if (packettype == "c")
      ReadConnect(get);
   else if (packettype == "M")
      ReadTeamChange(get);
   else if (packettype == "A")
      ReadAck(get);
   else if (packettype == "S")
      ReadSpawnRequest(get);
   else if (packettype == "P")
      ReadPing();
   else if (packettype == "d")
      ReadDeath(get);
   else if (packettype == "D")
      ReadDamage(get);
   else if (packettype == "I")
      ReadItem(get);
   else if (packettype == "R")
      ReadRemoveItem(get);
   else if (acktypes.find(packettype) == acktypes.end() && packettype != "U" && packettype != "u")
      logout << "Got unhandled packet: " << packettype << endl;
}


void BotNetCode::ReadConnect(stringstream& get)
{
   if (!connected)
   {
      short newteam;
      get >> playernum;
      get >> map;
      get >> newteam;
      connected = true;
      
      // Immediately send the team change request
      Packet p(&address);
      p.ack = sendpacketnum;
      p << "M\n";
      p << p.ack << eol;
      p << newteam << eol;
      SendPacket(p);
   }
   HandleAck(packetnum);
}


void BotNetCode::ReadTeamChange(stringstream& get)
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
            read.team = newteam;
            spawns.push_back(read);
         }
         selectedspawn = spawns[0];
         
         // Immediately send a spawn request
         SendSpawnRequest();
      }
   }
}


void BotNetCode::ReadAck(stringstream& get)
{
   unsigned long acknum;
   get >> acknum;
   HandleAck(acknum);
}


void BotNetCode::ReadSpawnRequest(stringstream& get)
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


void BotNetCode::ReadPing()
{
   Packet p(&address);
   p << "p\n";
   p << sendpacketnum << eol;
   SendPacket(p);
}


void BotNetCode::ReadDeath(stringstream& get)
{
   size_t killed, killer;
   get >> killed >> killer;
   
   // Ack it
   Ack(packetnum);
   
   if (killed == playernum && bot.spawned)
   {
      respawntimer.start();
      bot.spawned = false;
   }
}


void BotNetCode::ReadDamage(stringstream& get)
{
   bool hitme;
   get >> hitme;
   if (hitme)
   {
      get >> attacker;
   }
}


void BotNetCode::ReadItem(stringstream& get)
{
   Vector3 itempos;
   unsigned long id;
   int type, team;
   get >> type;
   get >> id;
   get >> itempos.x >> itempos.y >> itempos.z;
   get >> team;
   
   if (itemsreceived.find(id) == itemsreceived.end())
   {
      Item newitem(type, dummymeshes);
      newitem.id = id;
      newitem.team = team;
      newitem.position = itempos;
      
      MeshPtr newmesh = meshcache->GetNewMesh(newitem.ModelFile());
      newmesh->Move(newitem.position);
      dummymeshes.push_front(*newmesh);
      items.push_back(newitem);
      Item& curritem = items.back();
      curritem.mesh = dummymeshes.begin();
      
      itemsreceived.insert(id);
   }
}


void BotNetCode::ReadRemoveItem(stringstream& get)
{
   unsigned long id;
   get >> id;
   for (vector<Item>::iterator i = items.begin(); i != items.end(); ++i)
   {
      if (i->id == id)
      {
         if (i->mesh != dummymeshes.end())
            dummymeshes.erase(i->mesh);
         items.erase(i);
         break;
      }
   }
}


