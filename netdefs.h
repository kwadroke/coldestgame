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

const char eol = '\n';
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
