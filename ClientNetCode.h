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
#ifndef CLIENTNETCODE_H
#define CLIENTNETCODE_H

#include "NetCode.h"
#include "ServerInfo.h"
#include "Mesh.h"
#include "Item.h"
#include "tsint.h"
#include <boost/shared_ptr.hpp>
#include <set>
#include <deque>

extern tsint serverfps;
using std::set;
using std::deque;

class ClientNetCode : public NetCode
{
   public:
      ClientNetCode();
      virtual ~ClientNetCode();
      bool Connected(){return connected;}
      int CurrVersion(){return currversion;}
      void AddItem(Item&);

      void Connect();
      void SpawnRequest();
      void SendChat(const string&, const bool);
      void ChangeTeam(const int);
      void UseItem();
      void SendKill();
      void SendSync();
      void SendLoadout();
      void SendMasterListRequest();
      void SendPowerdown();
      void SendCommand(const string&);
      void SendFire();
      void SendPassword(const string&);
      void SendKeepalive();
      bool SendVersionRequest();

      vector<ServerInfo> servers;
      int serverfps;
      int serverbps;
      Uint32 lasthit;
      deque<string> servermessages;
      bool messageschanged;

   protected:
      virtual void Send();
      string FillUpdatePacket();

      virtual void ReceiveExtended();
      virtual void HandlePacket(stringstream&);
      virtual void DeleteMesh(Meshlist::iterator&);
      // Functions to read from individual packets
      void ReadUpdate(stringstream&);
      void ReadOccUpdate(stringstream&);
      void ReadConnect(stringstream&);
      void ReadFailedConnect(stringstream&);
      void ReadPing(stringstream&);
      void ReadShot(stringstream&);
      void ReadHit(stringstream&);
      void ReadDamage(stringstream&);
      void ReadServerInfo(stringstream&);
      void ReadSpawnRequest(stringstream&);
      void ReadAck(stringstream&);
      void ReadText(stringstream&);
      void ReadTeamChange(stringstream&);
      void ReadServerMessage(stringstream&);
      void ReadDeath(stringstream&);
      void ReadItem(stringstream&);
      void ReadRemoveItem(stringstream&);
      void ReadSync(stringstream&);
      void ReadReconnect();
      void ReadGameOver(stringstream&);
      void ReadRemovePart(stringstream&);
      void ReadAnnounce(stringstream&, bool);
      void ReadVersion(stringstream&);

      bool connected;
      int occpacketcounter;
      unsigned long recpacketnum;
      unsigned long lastsyncpacket;

      UDPsocket annsocket;
      bool annlisten;

      int currversion;  // The version we get from the master server
      
      set<ServerInfo> knownservers;
      set<unsigned long> partids;
      set<unsigned long> itemsreceived;
      set<unsigned long> hitsreceived;
      set<unsigned long> killsreceived;
      set<unsigned long> messagesreceived;
};

typedef boost::shared_ptr<ClientNetCode> ClientNetCodePtr;

#endif // CLIENTNETCODE_H
