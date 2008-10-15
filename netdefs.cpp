#include "netdefs.h"

bool running, connected, doconnect, pingresponse, spawnrequest, spawnschanged, sendkill, needsync;
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
short changeteam;
bool useitem;
vector<Meshlist::iterator> deletemeshes;
vector<Item> additems;
set<unsigned long> itemsreceived;
set<unsigned long> hitsreceived;
unsigned long lastsyncpacket;
Uint32 lasthit;
int serverfps;

