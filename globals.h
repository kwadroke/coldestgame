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

#define PI 3.14159265

using std::string;
using std::stringstream;
using std::list;
using std::vector;
using std::set;

const int terrobjsize = 8; // Terrain objects are terrobjsize x terrobjsize tiles
const string objectfilever = "Version3";

extern bool fly;               // Allow flying
extern bool ghost;             // Walk through walls
extern bool quiet;             // Limit output to console (system, not in-game)
extern bool fullscreen;        // Indicate whether to run in a window
extern int movestep;           // Keep movement equal at all framerates
extern int aalevel;            // How much antialiasing to apply
extern SDL_mutex* clientmutex;// Make sure client threads don't interfere with each other
extern CollisionDetection coldet; // Collision detection handler object
extern list<Particle> particles; // List of active particles
extern GUI mainmenu;           // Object that handles the main menu
extern bool mainmenuvisible;   // Whether the main menu is shown
extern string nextmap;         // Used to signal the main thread to load a new map
extern string mapname;         // The name of the current map

extern GUI hud;                // Handles drawing the HUD
extern GUI loadprogress;       // Shows loading progress
extern GUI loadoutmenu;        // The loadout screen
extern GUI statsdisp;          // Display FPS etc.
extern GUI console;            // The in-game console
extern GUIPtr ingamestatus;
extern GUIPtr chat;
extern int partupdateinterval; // Update particles every this many frames
//extern TextureManager *texman;  // Handles string versions of texture identifiers
extern ResourceManager resman; // Handles loading and organizing different resources
extern vector<PlayerData> player;
extern vector<UnitData> units;
extern vector<WeaponData> weapons;
extern bool server;
extern int servplayernum;
extern SDL_Thread* serverthread;
extern ObjectKDTree kdtree;
extern vector<floatvec> heightmap;  // Smoothed heightmap data
extern int tilesize;
extern vector<SpawnPointData> spawnpoints;
extern vector<SpawnPointData> availablespawns;
extern bool initialized;
extern Meshlist meshes;
extern bool serverhasmap;

template <typename T>
string ToString(const T &input)
{
   stringstream temp;
   temp << input;
   return temp.str();
}


template <typename T>
T lerp(T x, T y, float a)
{
   return (x * a + y * (1 - a));
}

void UpdatePlayerModel(PlayerData&, Meshlist&, bool gl = true);
float GetTerrainHeight(const float x, const float y);
void AppendToChat(int, string);
void UpdateParticles(list<Particle>&, int&, ObjectKDTree&, Meshlist&, const Vector3& campos = Vector3(),
                     void (*HitHandler)(Particle&, vector<Mesh*>&) = NULL, void (*Rewind)(int) = NULL);
void Move(PlayerData&, Meshlist&, ObjectKDTree&);
void AppendDynamicMeshes(vector<Mesh*>&, Meshlist&);

bool floatzero(float, float error = .00001);
float Random(float min, float max);
string PadNum(int, int);
int gettid();

#endif
