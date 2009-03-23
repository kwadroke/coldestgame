// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
#ifndef __NETDEFS_H
#define __NETDEFS_H

#include <string>
#include <list>
#include <vector>
#include <set>
#include <deque>
#include "ServerInfo.h"
#include "CollisionDetection.h"
#include "PlayerData.h"
#include "Particle.h"
#include "SDL.h"
#include "IDGen.h"
#include "tsint.h"

const int netver = 1;

extern tsint running, connected, doconnect, spawnrequest, spawnschanged, sendkill, needsync;
extern unsigned long recpacketnum, ackpack;
extern IDGen sendpacketnum;
extern set<unsigned long> partids;
extern SDL_Thread* netout;
extern SDL_Thread* netin;
extern vector<ServerInfo> servers;
extern set<ServerInfo> knownservers;
extern string chatstring;
extern bool chatteam;
extern vector<string> newchatlines;
extern vector<unsigned short> newchatplayers;
extern tsint changeteam;
extern tsint useitem;
extern vector<Meshlist::iterator> deletemeshes;
extern vector<Item> additems;
extern set<unsigned long> itemsreceived;
extern set<unsigned long> hitsreceived;
extern set<unsigned long> killsreceived;
extern unsigned long lastsyncpacket;
extern tsint lasthit;
extern tsint serverfps;
extern deque<string> killmessages;
extern tsint killschanged;

void HandleAck(unsigned long);
void SendPowerdown();
void SendCommand(const string&);
void SendFire();
void SendMasterListRequest();
void SendPassword(const string&);

#endif
