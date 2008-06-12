#ifndef __GLOBALS
#define __GLOBALS

#include <string>
#include <sstream>
#include "Particle.h"
#include "ServerInfo.h"
#include "gui/GUI.h"
#include "PlayerData.h"
#include "types.h"
#include "ResourceManager.h"
#include "CollisionDetection.h"
#include "Particle.h"
#include "ObjectKDTree.h"
#include "Console.h"
#include "ParticleEmitter.h"

#define PI 3.14159265

using std::string;
using std::stringstream;
using std::list;
using std::vector;
using std::set;

const int terrobjsize = 8; // Terrain objects are terrobjsize x terrobjsize tiles

enum GUINames {mainmenu, loadprogress, loadoutmenu, settings, hud, statsdisp, consolegui, ingamestatus, chat, endgame, numguis};

extern SDL_mutex* clientmutex;// Make sure client threads don't interfere with each other
extern CollisionDetection coldet; // Collision detection handler object
extern list<Particle> particles; // List of active particles
extern vector<ParticleEmitter> emitters;
extern vector<Item> items;
extern vector<GUIPtr> gui;
extern string nextmap;         // Used to signal the main thread to load a new map
extern string mapname;         // The name of the current map
extern ResourceManager resman; // Handles loading and organizing different resources
extern vector<PlayerData> player;
extern vector<UnitData> units;
extern bool server;
extern int servplayernum;
extern SDL_Thread* serverthread;
extern ObjectKDTree kdtree;
extern vector<floatvec> heightmap;  // Smoothed heightmap data
extern int tilesize;
extern vector<SpawnPointData> spawnpoints;
extern vector<SpawnPointData> availablespawns;
extern vector<SpawnPointData> mapspawns;
extern bool initialized;
extern Meshlist meshes;
extern bool serverhasmap;
extern Console console;
extern int winningteam;

void UpdatePlayerModel(PlayerData&, Meshlist&, bool gl = true);
float GetTerrainHeight(const float x, const float y);
void AppendToChat(int, string);
void UpdateParticles(list<Particle>&, int&, ObjectKDTree&, Meshlist&, const Vector3& campos = Vector3(),
                     void (*HitHandler)(Particle&, vector<Mesh*>&, const Vector3&) = NULL, void (*Rewind)(int) = NULL);
void Move(PlayerData&, Meshlist&, ObjectKDTree&);
void AppendDynamicMeshes(vector<Mesh*>&, Meshlist&);
int Server(void* dummy);
void ShowGUI(int);
void ResetKeys();
int CalculatePlayerWeight(const PlayerData&);

#endif
