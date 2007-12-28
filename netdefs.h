#ifndef __NETDEFS_H
#define __NETDEFS_H

#include <string>
#include <list>
#include <vector>
#include <set>
#include "ServerInfo.h"
#include "CollisionDetection.h"
#include "PlayerData.h"
#include "Particle.h"
#include "SDL.h"

const char eol = '\n';

extern bool running, connected, doconnect, pingresponse, spawnrequest;
extern int tickrate;
extern unsigned long sendpacketnum, recpacketnum, ackpack;
extern set<unsigned long> partids;
extern SDL_Thread* netout;
extern SDL_Thread* netin;
extern vector<ServerInfo> servers;
extern set<ServerInfo> knownservers;
extern string serveraddr;

#endif
