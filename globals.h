#ifndef __GLOBALS
#define __GLOBALS

#include <string>
#include <sstream>
#include "Particle.h"
#include "ServerInfo.h"
#include "GUI.h"
#include "PlayerData.h"
#include "types.h"

#define PI 3.14159265

using std::string;
using std::stringstream;
using std::list;
using std::vector;
using std::set;

const int terrobjsize = 8;
const string objectfilever = "Version2";

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
extern int partupdateinterval; // Update particles every this many frames
extern TextureManager *texman;  // Handles string versions of texture identifiers
extern vector<PlayerData> player;
extern vector<UnitData> units;
extern vector<WeaponData> weapons;
extern bool server;
extern list<DynamicObject> dynobjects;
extern int servplayernum;
extern SDL_Thread* serverthread;
extern ObjectKDTree kdtree;
extern vector<floatvec> heightmap;  // Smoothed heightmap data
extern int tilesize;

template <typename T>
string ToString(const T &input)
{
   stringstream temp;
   temp << input;
   return temp.str();
}

void UpdatePlayerModel(PlayerData&, list<DynamicObject>&);
float GetTerrainHeight(const float x, const float y);

bool floatzero(float, float error = .00001);
float Random(float min, float max);

#endif
