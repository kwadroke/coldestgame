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
// Copyright 2008, 2009 Ben Nemec
// @End License@


#include "netdefs.h"

tsint running, connected, doconnect, spawnrequest, spawnschanged, sendkill, needsync;
unsigned long recpacketnum, ackpack;
IDGen sendpacketnum;
set<unsigned long> partids;
vector<ServerInfo> servers;
set<ServerInfo> knownservers;
SDL_Thread* netout;
SDL_Thread* netin;
string chatstring;
bool chatteam;
vector<string> newchatlines;
vector<unsigned short> newchatplayers;
tsint changeteam;
tsint useitem;
vector<Meshlist::iterator> deletemeshes;
vector<Item> additems;
set<unsigned long> itemsreceived;
set<unsigned long> hitsreceived;
set<unsigned long> killsreceived;
unsigned long lastsyncpacket;
tsint lasthit;
tsint serverfps;
tsint serverbps;
deque<string> killmessages;
tsint killschanged;
