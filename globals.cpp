#include "globals.h"
#include "renderdefs.h"

SDL_mutex* clientmutex;// Make sure client threads don't interfere with each other
CollisionDetection coldet; // Collision detection handler object
list<Particle> particles; // List of active particles
GUI mainmenu;           // Object that handles the main menu
bool mainmenuvisible;   // Whether the main menu is shown
string nextmap;         // Used to signal the main thread to load a new map
string mapname;         // The name of the current map
GUI hud;                // Handles drawing the HUD
GUI loadprogress;       // Shows loading progress
GUI loadoutmenu;        // The loadout screen
GUI statsdisp;          // Display FPS etc.
GUI consolegui;         // The in-game console
GUIPtr ingamestatus;    // In game status pane triggered by tab key
GUIPtr chat;            // Display and input for chat box

//TextureManager *texman;  // Handles string versions of texture identifiers
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
bool initialized;
bool serverhasmap;
Console console;
