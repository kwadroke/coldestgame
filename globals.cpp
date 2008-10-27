#include "globals.h"
#include "renderdefs.h"

SDL_mutex* clientmutex;// Make sure client threads don't interfere with each other
CollisionDetection coldet; // Collision detection handler object
list<Particle> particles; // List of active particles
vector<ParticleEmitter> emitters;
vector<Item> items;
vector<GUIPtr> gui(numguis);
string nextmap;         // Used to signal the main thread to load a new map
string mapname;         // The name of the current map

ResourceManager resman; // Handles loading and organizing different resources
vector<PlayerData> player;
vector<UnitData> units;
bool server;            // Indicates whether we're running a server
int servplayernum;
SDL_Thread* serverthread;
ObjectKDTree kdtree;
vector<floatvec> heightmap;  // Smoothed heightmap data
int tilesize;
vector<SpawnPointData> spawnpoints;
vector<SpawnPointData> availablespawns;
vector<SpawnPointData> mapspawns;
bool initialized;
tsint serverhasmap;
Console console;
tsint winningteam;
vector<BodyParts> weaponslots;
MeshCachePtr meshcache;
tsint spectateplayer;
ALSourcePtr musicsource;
