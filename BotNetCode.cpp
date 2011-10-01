#include "BotNetCode.h"

using std::getline;

BotNetCode::BotNetCode() : bot(dummymeshes),
                           id(0),
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
   else if (sendtimer.elapsed() > 1000 / (Uint32)console.GetInt("tickrate"))
   {
      Packet p(&address);
      p << FillUpdatePacket();
      SendPacket(p);
      sendtimer.start();
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
   
   SendPacket(p);
}


void BotNetCode::SendFire()
{
   Packet pack(&address);
   pack.ack = sendpacketnum;
   pack << "f\n";
   pack << pack.ack << eol;
   SendPacket(pack);
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
   else if (packettype == "O")
      running = false;
   else if (acktypes.find(packettype) == acktypes.end() && packettype != "U" && packettype != "u")
      logout << "Got unhandled packet: " << packettype << endl;
   
   if (acktypes.find(packettype) != acktypes.end())
      Ack(packetnum);
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
      /*itemsreceived.clear();
       hitsreceived.clear*();*/
      
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
            spawns.push_back(read);
         }
         
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
      // We're dead so we can't do anything - wait until the spawn timer is up
      SDL_Delay(console.GetInt("respawntime"));
      SendSpawnRequest();
      bot.spawned = false;
   }
}


