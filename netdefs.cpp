#include "netdefs.h"

bool running, connected, doconnect, pingresponse, spawnrequest;
int tickrate;
unsigned long sendpacketnum, recpacketnum, ackpack;
set<unsigned long> partids;
vector<ServerInfo> servers;
set<ServerInfo> knownservers;
SDL_Thread* netout;
SDL_Thread* netin;
string serveraddr;

