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
vector<string> newchatlines;
vector<unsigned short> newchatplayers;
short changeteam;
bool useitem;
vector<Meshlist::iterator> deletemeshes;
set<unsigned long> itemsreceived;  // TODO: These need to be reset when loading new maps
set<unsigned long> hitsreceived;
unsigned long lastsyncpacket;

