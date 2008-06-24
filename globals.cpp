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
bool server;            // Determines whether to start a server
int servplayernum;
SDL_Thread* serverthread;
ObjectKDTree kdtree;
vector<floatvec> heightmap;  // Smoothed heightmap data
int tilesize;
vector<SpawnPointData> spawnpoints;
vector<SpawnPointData> availablespawns;
vector<SpawnPointData> mapspawns;
bool initialized;
bool serverhasmap;
Console console;
int winningteam;
vector<BodyParts> weaponslots;
