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
#include "ServerNetCode.h"
#include "globals.h"
#include "serverdefs.h"

using std::endl;

ServerNetCode::ServerNetCode() : playernum(0),
                                 pingtick(0)
{
   if (!(socket = SDLNet_UDP_Open(console.GetInt("serverport"))))
   {
      logout << "Server SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      error = true;
   }
}

void ServerNetCode::HandlePacket(std::stringstream& get)
{
   if (packettype != "C" && packettype != "i" && validaddrs.find(SortableIPaddress(packet->address)) == validaddrs.end())
   {
      Packet p(&packet->address, "C");
      SendPacket(p);
      return;
   }

   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].addr.host == packet->address.host &&
         serverplayers[i].addr.port == packet->address.port)
      {
         //logout << "Packet " << packettype << " " << packetnum << " from " << i << endl;
         playernum = i;
         break;
      }
   }

   if (packettype == "U")
   {
      ReadUpdate(get);
   }
   else if (packettype == "C")
   {
      ReadConnect(get);
   }
   else if (packettype == "p")
   {
      serverplayers[playernum].ping = SDL_GetTicks() - serverplayers[playernum].pingtick;
   }
   else if (packettype == "i")
   {
      HandleInfo();
   }
   else if (packettype == "S")
   {
      ReadSpawn(get);
   }
   else if (packettype == "T")
   {
      ReadChat(get);
   }
   else if (packettype == "A")
   {
      ReadAck(get);
   }
   else if (packettype == "M")
   {
      ReadTeamChange(get);
   }
   else if (packettype == "I")
   {
      HandleUseItem();
   }
   else if (packettype == "K")
   {
      HandleKill();
   }
   else if (packettype == "Y")
   {
      HandleSync();
   }
   else if (packettype == "P")
   {
      HandlePowerDown();
   }
   else if (packettype == "c")
   {
      ReadCommand(get);
   }
   else if (packettype == "f")
   {
      HandleFire();
   }
   else if (packettype == "t")
   {
      ReadAuthentication(get);
   }
   else if (packettype == "L")
   {
      HandleLoadout();
   }
   else if (packettype == "k")
   {
      serverplayers[playernum].lastupdate = SDL_GetTicks();
   }
   else
   {
      logout << "Unknown packet type received on server: " << packettype << endl;
   }
}


void ServerNetCode::ReadUpdate(stringstream& get)
{
   if (playernum < serverplayers.size() && (packetnum > serverplayers[playernum].recpacketnum))  // Ignore out of order packets
   {
      float oppx, oppy, oppz;
      string dummy;
      serverplayers[playernum].recpacketnum = packetnum;
      get >> oppx >> oppy >> oppz;
      get >> serverplayers[playernum].rotation;
      get >> serverplayers[playernum].pitch;
      get >> serverplayers[playernum].roll;
      get >> serverplayers[playernum].facing;//dummy; // We tell them their facing now Edit: or not
      get >> serverplayers[playernum].moveforward;
      get >> serverplayers[playernum].moveback;
      get >> dummy;//serverplayers[playernum].moveleft;
      get >> dummy;//serverplayers[playernum].moveright;
      get >> serverplayers[playernum].leftclick;
      get >> serverplayers[playernum].rightclick;
      get >> serverplayers[playernum].run;
      get >> serverplayers[playernum].unit;
      get >> serverplayers[playernum].currweapon;
      serverplayers[playernum].clientpos.x = oppx; // Keep track of where the player thinks they are
      serverplayers[playernum].clientpos.y = oppy;
      serverplayers[playernum].clientpos.z = oppz;
      serverplayers[playernum].lastupdate = SDL_GetTicks();
      
      //logout << oppx << "  " << oppy << "  " << oppz << endl << flush;
      
      // Freak out if we get a packet whose checksum isn't right
      size_t value = 0;
      getdata = get.str();
      for (size_t i = 0; i < getdata.length(); ++i)
      {
         if (getdata[i] == '&')
            break;
         value += (char)(getdata[i]);
      }
      get >> dummy;
      size_t checksum;
      get >> checksum;
      if (checksum != value)
      {
         logout << "Freaking out on packet " << packetnum << endl;
         logout << getdata << endl;
         logout << checksum << "  " << value << endl;
      }
   }
}


void ServerNetCode::ReadConnect(stringstream& get)
{
   short unit;
   string name, hostname;
   int clientver;
   get.ignore();
   getline(get, hostname);
   get >> unit;
   get.ignore();
   getline(get, name);
   get >> clientver;
   bool add = true;
   int respondto = 0;
   
   if (CountPlayers() < console.GetInt("maxplayers") && clientver == NetCode::Version())
   {
      for (size_t i = 1; i < serverplayers.size(); ++i)
      {
         if (serverplayers[i].addr.host == packet->address.host && serverplayers[i].hostname == hostname)
         {
            respondto = i;
            add = false;
         }
      }
      // Always do this, in case a player is reconnecting from a different port
      validaddrs.insert(SortableIPaddress(packet->address));
      if (add)
      {
         PlayerData temp(servermeshes);
         temp.addr = packet->address;
         temp.hostname = hostname;
         temp.unit = unit;
         temp.acked.insert(packetnum);
         temp.salvage = console.GetInt("startsalvage");
         UpdatePlayerModel(temp, servermeshes, false);
         
         serverplayers.push_back(temp);
         respondto = serverplayers.size() - 1;
         
         // Choose a team for them
         vector<int> teamcount(2, 0);
         for (size_t i = 1; i < serverplayers.size(); ++i)
         {
            if (serverplayers[i].team != 0 && serverplayers[i].connected)
               ++teamcount[serverplayers[i].team - 1];
         }
         logout << "Team 1: " << teamcount[0] << " Team 2: " << teamcount[1] << endl;
         int newteam = teamcount[0] > teamcount[1] ? 2 : 1;
         serverplayers[respondto].team = newteam;
      }
      
      if (!serverplayers[respondto].connected)
      {
         serverplayers[respondto].lastupdate = SDL_GetTicks();
         serverplayers[respondto].recpacketnum = packetnum;
         validaddrs.erase(SortableIPaddress(serverplayers[respondto].addr));
         serverplayers[respondto].addr = packet->address;
         validaddrs.insert(SortableIPaddress(serverplayers[respondto].addr));
         serverplayers[respondto].needsync = true;
      }
      serverplayers[respondto].connected = true;
      serverplayers[respondto].name = name;
      
      Packet fill(&serverplayers[respondto].addr, "c", packetnum);
      fill << respondto << eol;
      fill << servermap->MapName() << eol;
      fill << serverplayers[respondto].team << eol;
      SendPacket(fill);
      
      if (add)
      {
         SendMessage(name + " connected"); // Has to happen after connection is completed
      }
   }
   else
   {
      Packet respond(&packet->address, "f", packetnum);
      SendPacket(respond);
   }
}


void ServerNetCode::HandleInfo()
{
   Packet response(&packet->address, "i");
   response << servername << eol;
   response << servermap->MapName() << eol;
   response << CountPlayers() << eol;
   response << console.GetInt("maxplayers") << eol;
   SendPacket(response);
}


void ServerNetCode::ReadSpawn(stringstream& get)
{
   bool accepted = false;
   Vector3 spawnpointreq;
   
   logout << "Player " << playernum << " is spawning" << endl;
   get >> serverplayers[playernum].unit;
   int weapid;
   for (int i = 0; i < numbodyparts; ++i)
   {
      get >> weapid;
      serverplayers[playernum].weapons[i] = Weapon(weapid);
   }
   int itemtype;
   get >> itemtype;
   serverplayers[playernum].item = Item(itemtype, servermeshes);
   get >> spawnpointreq.x;
   get >> spawnpointreq.y;
   get >> spawnpointreq.z;
   
   vector<SpawnPointData> allspawns = servermap->SpawnPoints();
   vector<SpawnPointData> itemspawns = GetSpawns(serveritems);
   allspawns.insert(allspawns.end(), itemspawns.begin(), itemspawns.end());
   for (size_t i = 0; i < allspawns.size(); ++i)
   {
      if (spawnpointreq.distance(allspawns[i].position) < 1.f && allspawns[i].team == serverplayers[playernum].team)
      {
         accepted = true;
         break;
      }
   }
   
   // Make sure we don't spawn some place invalid
   vector<Mesh*> check;
   check = serverkdtree.getmeshes(spawnpointreq, spawnpointreq, 150.f);
   AppendDynamicMeshes(check, servermeshes);
   Vector3 checkvec;
   bool found = false;
   spawnpointreq.y += 50.f;
   float maxsize = 100.f;
   
   if (coldet.CheckSphereHit(spawnpointreq, spawnpointreq, 30.f, check, servermap))
   {
      for (float ycheck = spawnpointreq.y; ycheck <= 100000.f; ycheck += 100.f)
      {
         for (float xcheck = spawnpointreq.x - maxsize; xcheck <= spawnpointreq.x + maxsize + 1.f; xcheck += maxsize)
         {
            for (float zcheck = spawnpointreq.z - maxsize; zcheck <= spawnpointreq.z + maxsize + 1.f; zcheck += maxsize)
            {
               checkvec = Vector3(xcheck, ycheck, zcheck);
               if (!coldet.CheckSphereHit(checkvec, checkvec, 30.f, check, servermap) && GetTerrainHeight(xcheck, zcheck) < ycheck - 1.f)
               {
                  spawnpointreq = checkvec;
                  found = true;
                  break;
               }
            }
            if (found)
               break;
         }
         if (found)
            break;
      }
   }
   
   if (serverplayers[playernum].spawntimer)
      accepted = false;
   
   // Weight of weapons and items
   int maxweight = units[serverplayers[playernum].unit].weight;
   int totalweight = 0;
   for (size_t i = 0; i < numbodyparts; ++i)
      totalweight += serverplayers[playernum].weapons[i].Weight();
   totalweight += serverplayers[playernum].item.Weight();
   
   if (totalweight > maxweight || CalculatePlayerWeight(serverplayers[playernum]) > serverplayers[playernum].salvage)
      accepted = false;
   
   if (accepted)
   {
      if (!serverplayers[playernum].spawned)
      {
         if (serverplayers[playernum].team != 0)
         {
            serverplayers[playernum].salvage -= CalculatePlayerWeight(serverplayers[playernum]);
            serverplayers[playernum].spawned = true;
         }
         serverplayers[playernum].pos = spawnpointreq;
         serverplayers[playernum].lastmovetick = 0;
         serverplayers[playernum].Reset();
         for (int i = 0; i < numbodyparts; ++i)
         {
            serverplayers[playernum].hp[i] = units[serverplayers[playernum].unit].maxhp[i];
            serverplayers[playernum].weapons[i].ammo = int(float(serverplayers[playernum].weapons[i].ammo) * serverplayers[playernum].item.AmmoMult());
         }
         UpdatePlayerModel(serverplayers[playernum], servermeshes, false);
         for (size_t i = 0; i < numbodyparts; ++i)
         {
            if (serverplayers[playernum].mesh[i] != servermeshes.end())
               serverplayers[playernum].mesh[i]->Update();
         }
      }
   }
   
   Packet response(&packet->address, "S", 0);
   if (accepted)
      response << 1 << eol;
   else response << 0 << eol;
   response << packetnum << eol;
   response << spawnpointreq.x << eol << spawnpointreq.y << eol << spawnpointreq.z << eol;

   SendPacket(response);
}


void ServerNetCode::ReadChat(stringstream& get)
{
   string line;
   bool team;
   get >> team;
   get.ignore(); // \n is still in buffer
   getline(get, line);
   if (serverplayers[playernum].acked.find(packetnum) == serverplayers[playernum].acked.end())
   {
      serverplayers[playernum].acked.insert(packetnum);
      
      // Propogate that chat text to all other connected players
      for (size_t i = 1; i < serverplayers.size(); ++i)
      {
         if (serverplayers[i].connected && i != playernum && (!team || serverplayers[i].team == serverplayers[playernum].team))
         {
            Packet temp(&serverplayers[i].addr, "T", sendpacketnum, true);
            temp << playernum << eol;
            if (team)
               temp << "[Team]";
            temp << line << eol;
            SendPacket(temp);
         }
      }
   }
   Ack(packetnum, packet);
}


void ServerNetCode::ReadAck(stringstream& get)
{
   unsigned long acknum;
   get >> acknum;
   HandleAck(acknum);
}


void ServerNetCode::ReadTeamChange(stringstream& get)
{
   // For the moment just ack it, we probably want to ensure even teams at some point
   short newteam;
   get >> newteam;
   
   Packet response(&packet->address, "M", sendpacketnum);
   response << packetnum << eol;
   response << 1 << eol;
   response << newteam << eol;
   serverplayers[playernum].team = newteam;
   for (size_t i = 0; i < servermap->SpawnPoints().size(); ++i)
   {
      if ((servermap->SpawnPoints(i).team == serverplayers[playernum].team) || serverplayers[playernum].team == 0)
      {
         response << "1\n"; // Indicate that there are more spawn points to be read
         response << servermap->SpawnPoints(i).position.x << eol;
         response << servermap->SpawnPoints(i).position.y << eol;
         response << servermap->SpawnPoints(i).position.z << eol;
         response << servermap->SpawnPoints(i).name << eol;
      }
   }
   response << 0 << eol; // No more spawn points

   SendPacket(response);
}


void ServerNetCode::HandleUseItem()
{
   if (serverplayers[playernum].item.usesleft > 0)
   {
      AddItem(serverplayers[playernum].item, playernum);
      serverplayers[playernum].item.usesleft--;
      if (serverplayers[playernum].item.Type() == Item::SpawnPoint)
         serverplayers[playernum].item = Item(Item::NoItem, servermeshes);
   }
   Ack(packetnum, packet);
}


void ServerNetCode::HandleKill()
{
   if (serverplayers[playernum].spawned)
   {
      serverplayers[playernum].spawned = false;
      serverplayers[playernum].Kill();
      if (serverplayers[playernum].salvage < 100)
         serverplayers[playernum].salvage = 100;
      SendKill(playernum, playernum);
   }
   Ack(packetnum, packet);
}


void ServerNetCode::HandleSync()
{
   if (serverplayers[playernum].needsync)
   {
      logout << "Syncing with " << playernum << endl;
      SendSyncPacket(serverplayers[playernum], packetnum);
      for (size_t i = 0; i < serveritems.size(); ++i)
         SendItem(serveritems[i], playernum);
      serverplayers[playernum].needsync = false;
   }
}


void ServerNetCode::HandlePowerDown()
{
   // Note: Theoretically this could cause someone to accidentally power down when they don't
   // want to, but if their packets are delayed 5+ seconds then the game is probably not
   // playable anyway.  I suppose a single packet could for some reason get delayed, but
   // we'll see if that's actually a realistic problem.
   if (!serverplayers[playernum].powerdowntime)
   {
      serverplayers[playernum].powerdowntime = 5000;
      for (int i = 0; i < numbodyparts; ++i)
      {
         if (serverplayers[playernum].hp[i] > 0)
         {
            int maxhp = units[serverplayers[playernum].unit].maxhp[i];
            serverplayers[playernum].hp[i] += maxhp * 3 / 4;
            if (serverplayers[playernum].hp[i] > maxhp)
               serverplayers[playernum].hp[i] = maxhp;
         }
      }
   }
   Ack(packetnum, packet);
}


void ServerNetCode::ReadCommand(stringstream& get)
{
   if (serverplayers[playernum].commandids.find(packetnum) == serverplayers[playernum].commandids.end() && serverplayers[playernum].admin)
   {
      serverplayers[playernum].commandids.insert(packetnum);
      string command;
      get.ignore();
      getline(get, command);
      console.Parse(command, false);
      for (size_t i = 0; i < serverplayers.size(); ++i)
         SendSyncPacket(serverplayers[i], 0);
      
   }
   else if (!serverplayers[playernum].admin)
   {
      logout << "Command received from non-admin player" << endl;
   }
   Ack(packetnum, packet);
}


void ServerNetCode::HandleFire()
{
   if (serverplayers[playernum].fireids.find(packetnum) == serverplayers[playernum].fireids.end())
   {
      serverplayers[playernum].fireids.insert(packetnum);
      serverplayers[playernum].firerequests.push_back(packetnum);
   }
   Ack(packetnum, packet);
}


void ServerNetCode::ReadAuthentication(stringstream& get)
{
   string password;
   get >> password;
   if (password == console.GetString("serverpwd"))
   {
      if (!serverplayers[playernum].admin)
         logout << "Player " << playernum << " authenticated from " << AddressToDD(packet->address.host) << endl;
      serverplayers[playernum].admin = true;
   }
   else
   {
      logout << "Password incorrect" << endl;
   }
   Ack(packetnum, packet);
}


void ServerNetCode::HandleLoadout()
{
   vector<SpawnPointData> allspawns = servermap->SpawnPoints();
   vector<SpawnPointData> itemspawns = GetSpawns(items);
   allspawns.insert(allspawns.end(), itemspawns.begin(), itemspawns.end());
   if (serverplayers[playernum].spawned && NearSpawn(serverplayers[playernum], allspawns))
   {
      serverplayers[playernum].salvage += CalculatePlayerWeight(serverplayers[playernum]);
      serverplayers[playernum].Kill();
      serverplayers[playernum].spawntimer = console.GetInt("respawntime");
   }
   Ack(packetnum, packet);
}

void ServerNetCode::Send()
{
   Timer frametimer;
   frametimer.start();
   
   currnettick = SDL_GetTicks();
   if (currnettick - lastnettick >= 1000 / console.GetInt("tickrate"))
   {
      lastnettick = currnettick;
      // Send out an update packet
      Packet temp(NULL, "U", sendpacketnum);
      
      for (size_t i = 1; i < serverplayers.size(); ++i)
      {
         temp << i << eol;
         temp << serverplayers[i].spawned << eol;
         if (serverplayers[i].spawned)
         {
            temp << serverplayers[i].pos.x << eol;
            temp << serverplayers[i].pos.y << eol;
            temp << serverplayers[i].pos.z << eol;
            temp << serverplayers[i].rotation << eol;
            temp << serverplayers[i].pitch << eol;
            temp << serverplayers[i].roll << eol;
            temp << serverplayers[i].facing << eol;
            temp << serverplayers[i].temperature << eol;
            temp << serverplayers[i].moveforward << eol;
            temp << serverplayers[i].moveback << eol;
            temp << serverplayers[i].moveleft << eol;
            temp << serverplayers[i].moveright << eol;
            temp << serverplayers[i].speed << eol;
            temp << serverplayers[i].powerdowntime << eol; // This may not belong here
         }
      }
      temp << 0 << eol; // Indicates end of player data
      
      // Quick and dirty checksumming
      unsigned long value = 0;
      for (size_t i = 0; i < temp.data.length(); ++i)
      {
         value += (char)(temp.data[i]);
      }
      temp << "&\n";
      temp << value << eol;
      
      // Add updates to send queue
      if (temp.data.length() < 5000)
      {
         for (size_t i = 1; i < serverplayers.size(); ++i)
         {
            if (serverplayers[i].connected)
            {
               temp.addr = serverplayers[i].addr;
               SendPacket(temp);
            }
         }
      }
      else logout << "Error: data too long" << endl;
      
      // Send pings to monitor network performance
      // Also use this opportunity to send occasional updates
      pingtick++;
      if (pingtick > 30)
      {
         Packet pingpack(NULL, "P", sendpacketnum);
         
         for (size_t i = 1; i < serverplayers.size(); ++i)
         {
            if (serverplayers[i].connected)
            {
               pingpack.addr = serverplayers[i].addr;
               SendPacket(pingpack);
               serverplayers[i].pingtick = SDL_GetTicks();
            }
         }
         pingtick = 0;
         
         // Occasional update packet
         Packet occup(NULL, "u", sendpacketnum);
         
         occup << servfps << eol;
         occup << sendbps << eol;
         for (size_t i = 1; i < serverplayers.size(); ++i)
         {
            if (serverplayers[i].connected)
            {
               occup << i << eol;
               occup << serverplayers[i].team << eol;
               occup << serverplayers[i].unit << eol;
               occup << serverplayers[i].kills << eol;
               occup << serverplayers[i].deaths << eol;
               for (int j = 0; j < numbodyparts; ++j)
                  occup << serverplayers[i].hp[j] << eol;
               occup << serverplayers[i].ping << eol;
               occup << serverplayers[i].spawned << eol;
               occup << serverplayers[i].connected << eol;
               occup << serverplayers[i].name << eol;
               occup << serverplayers[i].salvage << eol;
               occup << serverplayers[i].spawntimer << eol;
            }
         }
         occup << 0 << eol;
         for (size_t i = 1; i < serverplayers.size(); ++i)
         {
            if (serverplayers[i].connected)
            {
               occup.addr = serverplayers[i].addr;
               SendPacket(occup);
            }
         }
         
         // Broadcast announcement packets to the subnet for LAN servers
         IPaddress bc;
         bc.host = INADDR_BROADCAST;
         SDLNet_Write16(12011, &(bc.port));
         Packet bcpack(&bc, "a", sendpacketnum);
         bcpack.sendinterval = 0;
         bcpack << console.GetString("serverport") << eol;
         bcpack.Send(packet, socket);
         
         // Resend to just master server
         SDLNet_ResolveHost(&bcpack.addr, console.GetString("master").c_str(), 12011);
         bcpack.Send(packet, socket);
      }
   }
}


void ServerNetCode::SendItem(const Item& curritem, int oppnum)
{
   Packet p(&serverplayers[oppnum].addr, "I", sendpacketnum, true);
   p << curritem.Type() << eol;
   p << curritem.id << eol;
   Vector3 mpos = curritem.mesh->GetPosition();
   p << mpos.x << eol;
   p << mpos.y << eol;
   p << mpos.z << eol;
   p << curritem.team << eol;

   SendPacket(p);
}


void ServerNetCode::SendKill(size_t killed, size_t killer)
{
   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].connected)
      {
         Packet deadpacket(&serverplayers[i].addr, "d", sendpacketnum, true);
         deadpacket << killed << eol;
         deadpacket << killer << eol;
         SendPacket(deadpacket);
      }
   }
}


void ServerNetCode::SendToAll(Packet p, const size_t exclude)
{
   for (size_t i = 1; i < serverplayers.size(); ++i)
   {
      if (serverplayers[i].connected && i != exclude)
      {
         p.addr = serverplayers[i].addr;
         SendPacket(p);
      }
   }
}


void ServerNetCode::SendSyncPacket(PlayerData& p, unsigned long packetnum)
{
   Packet pack(&p.addr, "Y", sendpacketnum, true);
   pack << packetnum << eol;
   pack << "set movestep " << console.GetInt("movestep") << eol;
   pack << "set ghost " << console.GetBool("ghost") << eol;
   pack << "set fly " << console.GetBool("fly") << eol;
   pack << "set tickrate " << console.GetInt("tickrate") << eol;
   pack << "endofcommands\n";

   SendPacket(pack);
}


void ServerNetCode::SendGameOver(PlayerData& p, const int winner)
{
   Packet pack(&p.addr, "O", sendpacketnum, true);
   pack << winner << eol;

   SendPacket(pack);
}


void ServerNetCode::SendShot(const Particle& p)
{
   Packet pack(NULL, "s", sendpacketnum, true);
   pack << p.id << eol;
   pack << p.weapid << eol;
   pack << p.playernum << eol;
   
   SendToAll(pack, p.playernum);
}


void ServerNetCode::SendHit(const Vector3& hitpos, const Particle& p)
{
   unsigned long hid = nexthitid;
   Packet pack(NULL, "h", sendpacketnum, true);
   pack << hid << eol;
   pack << hitpos.x << eol << hitpos.y << eol << hitpos.z << eol;
   pack << p.weapid << eol;
   
   SendToAll(pack);
}


void ServerNetCode::SendDamage(const int i)
{
   Packet pack(&serverplayers[i].addr, "D", sendpacketnum, true);
   SendPacket(pack);
}


void ServerNetCode::SendRemove(const int i, const int part)
{
   Packet pack(NULL, "r", sendpacketnum, true);
   pack << i << eol;
   pack << part << eol;
   
   SendToAll(pack);
}


void ServerNetCode::SendMessage(const string& message)
{
   Packet pack(NULL, "m", sendpacketnum, true);
   pack << message << eol;
   
   logout << message << endl;
   
   SendToAll(pack);
}


void ServerNetCode::Ack(const unsigned long num, UDPpacket* pack)
{
   Packet response(&pack->address, "A", 0);
   response << num << eol;
   SendPacket(response);
}


