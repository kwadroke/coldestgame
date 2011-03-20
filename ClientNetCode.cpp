#include "ClientNetCode.h"
#include "globals.h"
#include "gui/ComboBox.h"
#include <iostream>

using std::endl;

const int ClientNetCode::version = 5;

ClientNetCode::ClientNetCode() : serverfps(0),
                                 serverbps(0),
                                 lasthit(0),
                                 messageschanged(false),
                                 connected(false),
                                 occpacketcounter(0),
                                 recpacketnum(0),
                                 lastsyncpacket(0),
                                 annlisten(true),
                                 currversion(0)
{
   // Note: This socket should be opened before the other, on the off chance that it would choose
   // this port.  No, I didn't learn that the hard way, but I did almost forget.
   if (!(annsocket = SDLNet_UDP_Open(12011)))
   {
      logout << "Announce port SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      annlisten = false;
   }
   
   if (!(socket = SDLNet_UDP_Open(0)))  // Use any open port
   {
      logout << "SDLNet_UDP_Open: " << SDLNet_GetError() << endl;
      error = true;
   }
   
   SendMasterListRequest();
}


ClientNetCode::~ClientNetCode()
{
   SDLNet_UDP_Close(annsocket);
}


void ClientNetCode::Send()
{
   currnettick = SDL_GetTicks();
   if (currnettick - lastnettick >= 1000 / (Uint32)console.GetInt("tickrate"))
   {
      if (connected)
      {
         lastnettick = currnettick;
         Packet p(&address);
         p << FillUpdatePacket();
         SendPacket(p);
      }
      ++occpacketcounter;
   }
   if (occpacketcounter > 100)
   {
      // Send a request for the server's information
      vector<ServerInfo>::iterator i;
      for (i = servers.begin(); i != servers.end(); ++i)
      {
         Packet p(&i->address);
         p << "i\n";
         p << sendpacketnum;
         SendPacket(p);
         i->tick = SDL_GetTicks();
      }
      occpacketcounter = 0;
   }
}


string ClientNetCode::FillUpdatePacket()
{
   stringstream temp;
   
   temp << "U" << eol;
   temp << sendpacketnum << eol;
   temp << player[0].pos.x << eol;
   temp << player[0].pos.y << eol;
   temp << player[0].pos.z << eol;
   temp << player[0].rotation << eol;
   temp << player[0].pitch << eol;
   temp << player[0].roll << eol;
   temp << player[0].facing << eol;
   temp << player[0].moveforward << eol;
   temp << player[0].moveback << eol;
   temp << player[0].moveleft << eol;
   temp << player[0].moveright << eol;
   temp << player[0].leftclick << eol;
   temp << player[0].rightclick << eol;
   temp << player[0].run << eol;
   temp << player[0].unit << eol;
   temp << player[0].currweapon << eol;
   
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


void ClientNetCode::Connect()
{
   connected = false;
   // Get hostname for telling players at the same IP apart
   char hn[256];
   string hostname;
   if (gethostname(hn, 255) == 0)
   {
      hostname = hn;
   }
   else
   {
      hostname = "Failed"; // This is no big deal as long as it doesn't happen to two people from the same public IP
   }
   
   SDLNet_ResolveHost(&address, console.GetString("serveraddr").c_str(), console.GetInt("serverport"));
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "C\n";
   p << p.ack << eol;
   p << hostname << eol;
   p << player[0].unit << eol;
   p << player[0].name << eol;
   p << version << eol;
   SendPacket(p);
   logout << "Sending connect to " << console.GetString("serveraddr") << ":" << console.GetInt("serverport") << endl;
}


void ClientNetCode::SpawnRequest()
{
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "S\n";
   p << p.ack << eol;
   p << player[0].unit << eol;
   for (int i = 0; i < numbodyparts; ++i)
   {
      p << player[0].weapons[i].Id() << eol;
   }
   p << player[0].item.Type() << eol;
   ComboBox *spawnpointsbox = (ComboBox*)gui[loadoutmenu]->GetWidget("SpawnPoints");
   int sel = spawnpointsbox->Selected();
   p << availablespawns[sel].position.x << eol;
   p << availablespawns[sel].position.y << eol;
   p << availablespawns[sel].position.z << eol;
   
   SendPacket(p);
}


void ClientNetCode::SendChat(const string& chatstring, const bool chatteam)
{
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "T\n";
   p << p.ack << eol;
   p << chatteam << eol;
   p << chatstring << eol;
   SendPacket(p);
}


void ClientNetCode::ChangeTeam(const int changeteam)
{
   logout << "Changing team " << endl;
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "M\n";
   p << p.ack << eol;
   p << changeteam << eol;
   SendPacket(p);
}


void ClientNetCode::UseItem()
{
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "I\n";
   p << p.ack << eol;
   SendPacket(p);
}


void ClientNetCode::SendKill()
{
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "K\n";
   p << p.ack << eol;
   SendPacket(p);
}


void ClientNetCode::SendSync()
{
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "Y\n";
   p << p.ack << eol;
   SendPacket(p);
}


void ClientNetCode::SendLoadout()
{
   Packet p(&address);
   p.ack = sendpacketnum;
   p << "L\n";
   p << p.ack << eol;
   SendPacket(p);
}


void ClientNetCode::SendMasterListRequest()
{
   IPaddress masteraddr;
   SDLNet_ResolveHost(&masteraddr, console.GetString("master").c_str(), 12011);
   Packet pack(&masteraddr);
   pack << "r\n0\n";
   SendPacket(pack);
}


void ClientNetCode::SendPowerdown()
{
   Packet pack(&address);
   pack.ack = sendpacketnum;
   pack << "P\n";
   pack << pack.ack << eol;
   SendPacket(pack);
}


void ClientNetCode::SendCommand(const string& command)
{
   Packet pack(&address);
   pack.ack = sendpacketnum;
   pack << "c\n";
   pack << pack.ack << eol;
   pack << command << eol;
   SendPacket(pack);
}


void ClientNetCode::SendFire()
{
   Packet pack(&address);
   pack.ack = sendpacketnum;
   pack << "f\n";
   pack << pack.ack << eol;
   SendPacket(pack);
}


void ClientNetCode::SendPassword(const string& password)
{
   Packet pack(&address);
   pack.ack = sendpacketnum;
   pack << "t\n";
   pack << pack.ack << eol;
   pack << password << eol;
   SendPacket(pack);
}


void ClientNetCode::SendKeepalive()
{
   Packet pack(&address);
   pack << "k\n";
   pack << 0 << eol;
   SendPacket(pack);
}


bool ClientNetCode::SendVersionRequest()
{
   IPaddress masteraddr;
   if (SDLNet_ResolveHost(&masteraddr, console.GetString("master").c_str(), 12011) < 0)
      return false;
   Packet pack(&masteraddr);
   pack.ack = sendpacketnum;
   pack << "v\n";
   pack << pack.ack << eol;
   pack.sendinterval = 5000;
   SendPacket(pack);
   return true;
}


void ClientNetCode::ReceiveExtended()
{
   // Have to listen on a specific port for server announcements.  Since this is only for LAN play
   // it doesn't matter that this won't work with NAT
   if (annlisten)
   {
      string anntype;
      while (SDLNet_UDP_Recv(annsocket, packet))
      {
         getdata = (char*)packet->data;
         stringstream get(getdata);
         
         get >> anntype;
         get >> packetnum;
         if (anntype == "a")
         {
            Uint16 serverport;
            get >> serverport;
            ServerInfo addme;
            addme.address = packet->address;
            SDLNet_Write16(serverport, &addme.address.port);
            if (knownservers.find(addme) == knownservers.end())
            {
               logout << "Received announcement packet from ";
               string dotteddec = AddressToDD(packet->address.host);
               logout << dotteddec << ":" << serverport << endl;
               addme.strip = dotteddec;
               clientmutex->lock();
               servers.push_back(addme);
               clientmutex->unlock();
               knownservers.insert(addme); // No need to wrap this, only used in this thread
            }
         }
      }
   }
}


void ClientNetCode::HandlePacket(stringstream& get)
{
   if (!connected && (packettype == "U" || packettype == "u")) // Causes problems on reconnect
      return;
   if ((address.host != packet->address.host || address.port != packet->address.port) &&
      packettype != "c" && packettype != "f" && packettype != "i" && packettype != "a" && packettype != "v")
      return;

   if (packettype == "U")
      ReadUpdate(get);
   else if (packettype == "u")
      ReadOccUpdate(get);
   else if (packettype == "c")
      ReadConnect(get);
   else if (packettype == "f")
      ReadFailedConnect(get);
   else if (packettype == "P")
      ReadPing(get);
   else if (packettype == "s")
      ReadShot(get);
   else if (packettype == "h")
      ReadHit(get);
   else if (packettype == "D")
      ReadDamage();
   else if (packettype == "i")
      ReadServerInfo(get);
   else if (packettype == "S")
      ReadSpawnRequest(get);
   else if (packettype == "a")
      ReadAck(get);
   else if (packettype == "T")
      ReadText(get);
   else if (packettype == "M")
      ReadTeamChange(get);
   else if (packettype == "m")
      ReadServerMessage(get);
   else if (packettype == "d")
      ReadDeath(get);
   else if (packettype == "I")
      ReadItem(get);
   else if (packettype == "R")
      ReadRemoveItem(get);
   else if (packettype == "Y")
      ReadSync(get);
   else if (packettype == "C")
      ReadReconnect();
   else if (packettype == "O")
      ReadGameOver(get);
   else if (packettype == "r")
      ReadRemovePart(get);
   else if (packettype == "a")
      ReadAnnounce(get);
   else if (packettype == "v")
      ReadVersion(get);
   else if (packettype != "Y")
      logout << "Warning: Unknown packet type received: " << packettype << endl;
}


void ClientNetCode::DeleteMesh(Meshlist::iterator& mesh)
{
   if (mesh != meshes.end())
      meshes.erase(mesh);
}


void ClientNetCode::ReadUpdate(stringstream& get)
{
   if (packetnum > recpacketnum) // Ignore older out of order packets
   {
      recpacketnum = packetnum;
      long oppnum = 0;
      float oppx, oppy, oppz;
      float opprot, opppitch, opproll, oppfacing;
      clientmutex->lock();
      
      get >> oppnum;
      while (oppnum != 0)
      {
         while (oppnum >= player.size())  // Add new player(s)
         {
            PlayerData dummy(meshes);
            player.push_back(dummy);
            logout << "Adding player " << (player.size() - 1) << endl;
         }
         get >> player[oppnum].spawned;
         if (player[oppnum].spawned)
         {
            // It's not necessary to load these into buffers, but for debugging
            // it's handy to.
            get >> oppx >> oppy >> oppz;
            get >> opprot;
            player[oppnum].rotation = opprot;
            get >> opppitch;
            player[oppnum].pitch = opppitch;
            get >> opproll;
            player[oppnum].roll = opproll;
            get >> oppfacing;
            player[oppnum].facing = oppfacing;
            get >> player[oppnum].temperature;
            if (oppnum == servplayernum)
               player[0].temperature = player[oppnum].temperature;
            get >> player[oppnum].moveforward;
            get >> player[oppnum].moveback;
            get >> player[oppnum].moveleft;
            get >> player[oppnum].moveright;
            get >> player[oppnum].speed;
            get >> player[oppnum].powerdowntime;
            
            player[oppnum].pos.x = oppx;
            player[oppnum].pos.y = oppy;
            player[oppnum].pos.z = oppz;
            
         }
         get >> oppnum;
      }
      
      // Freak out if we get a packet whose checksum isn't right
      size_t value = 0;
      string debug = get.str();
      for (size_t i = 0; i < debug.length(); ++i)
      {
         if (debug[i] == '&')
            break;
         value += (char)(debug[i]);
      }
      string dummy;
      get >> dummy;
      size_t checksum;
      get >> checksum;
      if (checksum != value)
      {
         logout << "Client freaking out on packet " << packetnum << endl;
         logout << checksum << endl << value << endl << dummy << endl;
         logout << debug << endl;
      }
      
      // Indicate to main thread that models for unspawned players need to be removed
      bool addemitter;
      for (vector<PlayerData>::iterator i = player.begin(); i != player.end(); ++i)
      {
         if (!i->spawned)
         {
            addemitter = false;
            locks.Read(meshes);
            for (int part = 0; part < numbodyparts; ++part)
            {
               if (i->mesh[part] != meshes.end())
               {
                  DeleteMesh(i->mesh[part]);
                  i->mesh[part] = meshes.end();
                  addemitter = true;
               }
            }
            locks.EndRead(meshes);
            if (addemitter)
            {
               ParticleEmitter newemitter("particles/emitters/explosion", resman);
               newemitter.position = i->pos;
               emitters.push_back(newemitter);
            }
            if (i->indicator)
            {
               i->indicator->ttl = 1;
               i->indicator = NULL; // Oops, don't forget this!
            }
         }
      }
      
      // Adjust our position toward where the server thinks we are
      if (console.GetBool("serversync") && !player[0].spectate && player[0].spawned)
         SynchronizePosition();
      clientmutex->unlock();
   }
}


void ClientNetCode::ReadOccUpdate(stringstream& get)
{
   if (packetnum > recpacketnum)
   {
      long oppnum = 0;
      
      long temp;
      get >> temp;
      serverfps = temp;
      get >> temp;
      serverbps = temp;
      get >> oppnum;
      short getunit, getteam;
      int getkills, getdeaths, getsalvage, getspawntimer;
      vector<int> gethp(numbodyparts);
      int getping;
      bool getspawned, getconnected;
      string getname;
      clientmutex->lock();
      while (oppnum != 0)
      {
         get >> getteam;
         get >> getunit;
         get >> getkills;
         get >> getdeaths;
         for (int i = 0; i < numbodyparts; ++i)
            get >> gethp[i];
         get >> getping;
         get >> getspawned;
         get >> getconnected;
         get.ignore();
         getline(get, getname);
         get >> getsalvage;
         get >> getspawntimer;
         if (oppnum < player.size())
         {
            player[oppnum].team = getteam;
            player[oppnum].unit = getunit; // Check that this hasn't changed?  Probably should, although it's unlikely anyone could respawn fast enough to cause problems.
            player[oppnum].kills = getkills;
            player[oppnum].deaths = getdeaths;
            for (size_t i = 0; i < numbodyparts; ++i)
               player[oppnum].hp[i] = gethp[i];
            player[oppnum].ping = getping;
            player[oppnum].spawned = getspawned;
            player[oppnum].connected = getconnected;
            player[oppnum].name = getname;
            player[oppnum].salvage = getsalvage;
            player[oppnum].spawntimer = getspawntimer;
         }
         get >> oppnum;
      }
      if (servplayernum < player.size())
      {
         player[0].kills = player[servplayernum].kills;
         player[0].deaths = player[servplayernum].deaths;
         for (int i = 0; i < numbodyparts; ++i)
            player[0].hp[i] = player[servplayernum].hp[i];
         player[0].ping = player[servplayernum].ping;
         player[0].salvage = player[servplayernum].salvage;
         player[0].spawntimer = player[servplayernum].spawntimer;
         if (gui[loadoutmenu]->visible)
            Action("updateunitselection");
      }
      clientmutex->unlock();
   }
}


void ClientNetCode::ReadConnect(stringstream& get)
{
   if (!connected)
   {
      string nextmap;
      clientmutex->lock();
      get >> servplayernum;
      get >> nextmap;
      long newteam;
      get >> newteam;
      ChangeTeam(newteam);
      LoadMap(nextmap);
      connected = true;
      logout << "We are server player " << servplayernum << endl;
      logout << "Map is: " << nextmap << endl;
      clientmutex->unlock();
      itemsreceived.clear();
      hitsreceived.clear();
   }
   HandleAck(packetnum);
}


void ClientNetCode::ReadFailedConnect(stringstream& get)
{
   logout << "Error: Server is full or netcode version mismatch\n";
   clientmutex->lock();
   ShowGUI(mainmenu);
   clientmutex->unlock();
   HandleAck(packetnum);
}


void ClientNetCode::ReadPing(stringstream& get)
{
   Packet p(&address);
   p << "p\n";
   p << sendpacketnum << eol;
   SendPacket(p);
}


void ClientNetCode::ReadShot(stringstream& get)
{
   unsigned long id, weapid;
   
   get >> id;
   if (partids.find(id) == partids.end())
   {
      partids.insert(id);
      get >> weapid;
      Weapon dummy(weapid);
      size_t pnum;
      get >> pnum;
      clientmutex->lock();
      ClientCreateShot(player[pnum], dummy);
      recorder->AddShot(pnum, weapid);
      clientmutex->unlock();
   }
   Ack(packetnum);
}


void ClientNetCode::ReadHit(stringstream& get)
{
   Vector3 hitpos;
   int type;
   unsigned long id;
   get >> id;
   if (hitsreceived.find(id) == hitsreceived.end())
   {
      hitsreceived.insert(id);
      get >> hitpos.x >> hitpos.y >> hitpos.z;
      get >> type;
      
      AddHit(hitpos, type);
      recorder->AddHit(hitpos, type);
   }
   
   Ack(packetnum);
}


void ClientNetCode::ReadDamage()
{
   lasthit = SDL_GetTicks();
   Ack(packetnum);
}


void ClientNetCode::ReadServerInfo(stringstream& get)
{
   vector<ServerInfo>::iterator i;
   clientmutex->lock();
   for (i = servers.begin(); i != servers.end(); ++i)
   {
      if (i->address.host == packet->address.host)
      {
         get.ignore();
         getline(get, i->name);
         getline(get, i->map);
         get >> i->players;
         get >> i->maxplayers;
         i->ping = SDL_GetTicks() - i->tick;
         i->haveinfo = true;
         break;
      }
   }
   clientmutex->unlock();
}


void ClientNetCode::ReadSpawnRequest(stringstream& get)
{
   bool accepted;
   unsigned long acknum;
   Vector3 newpos;
   get >> accepted;
   get >> acknum;
   get >> newpos.x >> newpos.y >> newpos.z;
   
   clientmutex->lock();
   if (gui[loadoutmenu]->visible)
   {
      if (accepted)
      {
         gui[loadoutmenu]->visible = false;
         gui[hud]->visible = true;
         player[0].pos = newpos;
         player[0].size = units[player[0].unit].size;
         player[0].lastmovetick = SDL_GetTicks();
         if (player[0].team != 0)
            player[0].spectate = false;
         player[0].spawned = true;
         player[0].Reset();
      }
      else
      {
         logout << "Spawn request not accepted.  This is either a program error or you're hacking.  If the latter, shame on you.  If the former, shame on me." << endl;
      }
   }
   clientmutex->unlock();
   HandleAck(acknum);
}


void ClientNetCode::ReadAck(stringstream& get)
{
   unsigned long acknum;
   get >> acknum;
   HandleAck(acknum);
}


void ClientNetCode::ReadText(stringstream& get)
{
   long oppnum = 0;
   clientmutex->lock();
   string line;
   get >> oppnum;
   if (oppnum < player.size())
   {
      if (player[oppnum].acked.find(packetnum) == player[oppnum].acked.end())
      {
         player[oppnum].acked.insert(packetnum);
         getline(get, line);
         getline(get, line);
         AppendToChat(oppnum, line, false); // TODO Right now all chats appear to be global, this should be fixed
      }
      // Ack it
      Ack(packetnum); // Danger: this grabs the net mutex while we hold the clientmutex
   }
   clientmutex->unlock();
}


void ClientNetCode::ReadTeamChange(stringstream& get)
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
      clientmutex->lock();
      if (player[0].team != newteam)
      {
         logout << "Joined team " << newteam << endl;
         player[0].team = newteam;
         
         teamspawns.clear();
         bool morespawns;
         SpawnPointData read;
         while (get >> morespawns && morespawns)
         {
            get >> read.position.x >> read.position.y >> read.position.z;
            get.ignore(); // Throw out \n
            getline(get, read.name);
            teamspawns.push_back(read);
         }
         spawnschanged = true;
      }
      
      Button* team1button = dynamic_cast<Button*>(gui[loadoutmenu]->GetWidget("Team1"));
      Button* team2button = dynamic_cast<Button*>(gui[loadoutmenu]->GetWidget("Team2"));
      Button* specbutton = dynamic_cast<Button*>(gui[loadoutmenu]->GetWidget("Spectate"));
      if (player[0].team == 1)
      {
         team1button->togglestate = 1;
         team2button->togglestate = 0;
         specbutton->togglestate = 0;
      }
      else if (player[0].team == 2)
      {
         team1button->togglestate = 0;
         team2button->togglestate = 1;
         specbutton->togglestate = 0;
      }
      else if (player[0].team == 0)
      {
         team1button->togglestate = 0;
         team2button->togglestate = 0;
         specbutton->togglestate = 1;
      }
      clientmutex->unlock();
   }
}


void ClientNetCode::ReadServerMessage(stringstream& get)
{
   if (messagesreceived.find(packetnum) == messagesreceived.end())
   {
      messagesreceived.insert(packetnum);
      string message;
      get.ignore();
      getline(get, message);
      clientmutex->lock();
      messageschanged = true;
      servermessages.push_back(message);
      clientmutex->unlock();
   }
   Ack(packetnum);
}


void ClientNetCode::ReadDeath(stringstream& get)
{
   if (killsreceived.find(packetnum) == killsreceived.end())
   {
      killsreceived.insert(packetnum);
      size_t killed, killer;
      get >> killed >> killer;
      
      clientmutex->lock();
      if (killed == servplayernum)
      {
         player[0].weight = -1.f;
         player[0].spectate = true;
         player[0].spawned = false;
         player[0].size = 5.f;
         ResetKeys();
      }
      string message = player[killer].name + " killed " + player[killed].name;
      servermessages.push_back(message);
      clientmutex->unlock();
   }
   // Ack it
   Ack(packetnum);
}


void ClientNetCode::ReadItem(stringstream& get)
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
      Item newitem(type, meshes);
      newitem.id = id;
      newitem.team = team;
      newitem.position = itempos;
      clientmutex->lock();
      AddItem(newitem);
      clientmutex->unlock();
      itemsreceived.insert(id);
   }
   Ack(packetnum);
}


void ClientNetCode::AddItem(Item& newitem)
{
   MeshPtr newmesh = meshcache->GetNewMesh(newitem.ModelFile());
   newmesh->Move(newitem.position);
   newmesh->dynamic = true;
   meshes.push_front(*newmesh);
   items.push_back(newitem);
   Item& curritem = items.back();
   curritem.mesh = meshes.begin();
   spawnschanged = true;
   recorder->AddItem(newitem);
}


void ClientNetCode::ReadRemoveItem(stringstream& get)
{
   unsigned long id;
   get >> id;
   for (vector<Item>::iterator i = items.begin(); i != items.end(); ++i)
   {
      if (i->id == id)
      {
         clientmutex->lock();
         DeleteMesh(i->mesh);
         items.erase(i);
         spawnschanged = true;
         clientmutex->unlock();
         break;
      }
   }
   Ack(packetnum);
}


void ClientNetCode::ReadSync(stringstream& get)
{
   if (packetnum > lastsyncpacket)
   {
      unsigned long acknum;
      logout << "Got sync packet " << packetnum << endl;
      get >> acknum;
      HandleAck(acknum);
      lastsyncpacket = packetnum;
      string buffer;
      clientmutex->lock();
      while (getline(get, buffer) && buffer != "endofcommands")
      {
         console.Parse(buffer, false);
      }
      clientmutex->unlock();
      Ack(packetnum);
   }
}


void ClientNetCode::ReadReconnect()
{
   connected = false;
   Connect();
}


void ClientNetCode::ReadGameOver(stringstream& get)
{
   long getteam;
   get >> getteam;
   winningteam = getteam;
   logout << "Team " << winningteam << " wins!" << endl;
   Ack(packetnum);
}


void ClientNetCode::ReadRemovePart(stringstream& get)
{
   size_t num, part;
   get >> num;
   get >> part;
   
   if (num == servplayernum)
      num = 0;
   
   clientmutex->lock();
   locks.Read(meshes);
   DeleteMesh(player[num].mesh[part]);
   player[num].mesh[part] = meshes.end();
   player[num].hp[part] = 0;
   locks.EndRead(meshes);
   clientmutex->unlock();
   
   Ack(packetnum);
}


void ClientNetCode::ReadAnnounce(stringstream& get)
{
   Uint32 serverhost;
   Uint16 serverport;
   get >> serverhost >> serverport;
   ServerInfo addme;
   addme.address.host = serverhost;
   SDLNet_Write16(serverport, &addme.address.port);
   if (knownservers.find(addme) == knownservers.end())
   {
      logout << "Received master server announcement for ";
      string dotteddec = AddressToDD(addme.address.host);
      logout << dotteddec << ":" << serverport << endl;
      addme.strip = dotteddec;
      clientmutex->lock();
      servers.push_back(addme);
      clientmutex->unlock();
      knownservers.insert(addme); // No need to wrap this, only used in this thread
   }
}


void ClientNetCode::ReadVersion(stringstream& get)
{
   long v;
   unsigned long acknum;
   get >> v;
   get >> acknum;
   currversion = v;
   HandleAck(acknum);
}

