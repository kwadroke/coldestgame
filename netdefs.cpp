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
unsigned long lastsyncpacket;
tsint lasthit;
tsint serverfps;

