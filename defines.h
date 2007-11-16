#ifndef __DEFINES_H
#define __DEFINES_H

#define NO_SDL_GLEXT
#include <GL/glew.h>  // Take that, OpenGL Extensions;-)
#include "SDL.h"
#include "SDL_opengl.h"
#include "SDL_image.h"
#include "SDL_ttf.h"
#include "SDL_net.h"
#include "SDL_thread.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <string>
#include <deque>
#include <stack>
#include <vector>
#include <list>
#include <algorithm>
#include <functional>
#include <queue>
#include <set>

#define PI 3.14159265

#include "GenericPrimitive.h"
#include "TextureHandler.h"
#include "Vector3.h"
#include "GraphicMatrix.h"
//#include "Quaternion.h" // Not actually used atm
#include "DynamicObject.h"
#include "WorldPrimitives.h"
#include "WorldObjects.h"
//#include "PrimitiveOctree.h" // No longer used
#include "ObjectKDTree.h"
#include "CollisionDetection.h"
#include "ProceduralTree.h"
#include "Particle.h"
#include "Hit.h"
#include "PlayerData.h"
#include "Light.h"
#include "Shader.h"
#include "FBO.h"
#include "GUI.h"
#include "ProgressBar.h"
#include "ServerInfo.h"
#include "Table.h"
#include "types.h"

/* Sorry bwkaz, the hassle just isn't worth it :-)
using std::cout;
using std::endl;
using std::flush;*/
using namespace std;

// Function definitions
void SetupSDL();
void SetupOpenGL();
void LoadShaders();
void InitNoise();
static void LoadFonts();
static void MainLoop();
void Repaint();
void GetMap(string);
void InitGlobals();
void InitGUI();
void InitUnits();
void InitWeapons();
void Move(PlayerData&, list<DynamicObject>&, CollisionDetection&);
void HitTerrain();
void CheckFall();
int PowerOf2(int);
void SDL_GL_Enter2dMode();
void SDL_GL_Exit2dMode();
void ConsoleHandler(string);
void ConsoleBufferToGUI();
int NumTokens(string);
string Token(string, int);
string SimplifyWhitespace(string);
/*void RenderSkybox();
void RenderConsole();
void RenderFPS();
void RenderObjects();
void RenderHud();
void RenderDynamicObjects();
void RenderDOTree(DynamicPrimitive*);*/
void GenShadows(Vector3, float, FBO&);
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);
void Animate();
void ReadConfig();
void LoadDOTextures(string);
int NetListen(void*);
int NetSend(void*);
string FillUpdatePacket();
string PadNum(int, int);
void Cleanup();
void Quit();
void Fire();
void HandleHit(Particle);
void UpdatePlayerModel(PlayerData&, list<DynamicObject>&);
int Server(void* dummy);
void UpdateServerList();
bool floatzero(float, float error = .00001);
float Random(float, float);
void GLError();
string AddressToDD(Uint32);

template <typename T>
string ToString(const T &input)
{
   stringstream temp;
   temp << input;
   return temp.str();
}

const int maxtexlayers = 2;
const int fpstexnum = 0;  // Also used for other text - pretty sure this is obsolete too
const string objectfilever = "Version1";
extern const int terrobjsize = 8;

int shadowmapsize = 1024;
float nearclip = 1;
float farclip = 2000;  // Why didn't I just use viewdist?

// Global variable definitions
// In retrospect a lot of these could have been static in their local functions - 
// Live and Learn
int screenwidth, screenheight;  // Current resolution
float aspect;
int tilesize;           // How much to scale terrain in the x and z directions
TTF_Font *lcd;          // The font for FPS display
TTF_Font *consolefont;  // The font for the console
int lasttick, frames;   // For FPS calculation
float fps;              // Previously calculated FPS value
bool showfps, fly;      // Display FPS and allow flying
bool ghost;             // Walk through walls
vector<GLuint> textures;// Vector to hold texture numbers from glGenTextures
bool quiet;             // Limit output to console (system, not in-game)
bool fullscreen;        // Indicate whether to run in a window
bool consolevisible;    // Show in-game console
bool thirdperson;       // Use a third person perspective
int camdist;           // Camera distance for third person
deque<string> consolebuffer; // Output from in-game console commands
string consoleinput;    // Contains the current input line
int consoletop, consolebottom, consoleleft, consoleright; // Console location
int consolebottomline;  // Bottom line visible in the console
int consoletrans;       // Console transparency from 0 to 255
int movestep;           // Keep movement equal at all framerates
Uint32 lastdelaytick;   // Ditto
int nummaplayers;       // How many layers of textures the current map has
int fov;                // What field of view to use
int viewdist;           // How far the player can see
int nextprim;           // Next available primitive in the array
//int intmethod;          // Which method to use for collision detection
int aalevel;            // How much antialiasing to apply
vector<GLuint> dotextures; // Dynamic object textures
//PrimitiveOctree *ot;
bool terrainlistvalid;  // Is display list for terrain up to date?
GLuint terrainlist;     // Terrain display list
bool showkdtree;        // Visualize the kdtree for debugging?
ObjectKDTree kdtree;    // kd-tree for collision detection and frustum culling
int tickrate;           // How many updates per second for networking
SDL_Thread* netin;      // Pointers to the threads created for networking
SDL_Thread* netout;
bool running;           // Set to false to tell threads to end
unsigned long sendpacketnum; // Next packet number to send
unsigned long recpacketnum; // Last packet number received
string serveraddr;     // Server address
bool doconnect;        // Signals network threads to connect to connecthost
unsigned long ackpack; // Acknowledge packet
SDL_mutex* clientmutex;// Make sure client threads don't interfere with each other
bool server;            // Determines whether to start a server
SDL_Thread* serverthread; // Self-explanatory
short servplayernum; // Which player # the server has assigned us
bool connected;         // Are we connected to the server?
set<unsigned long> partids;  // Particle ids we have received from the server
GLuint texnum[2];          // Possibly to be used for rendering text
list<Hit> hits;         // Weapon hits that have occurred but not ack'd by server
TextureHandler texhand; // Handy texture functions
CollisionDetection coldet; // Collision detection handler object
list<Particle> particles; // List of active particles
Light lights;           // Container for the data to set OpenGL lights
GLuint shadowmaptex[2]; // GL identifier for the shadow map textures
GLuint worldshadowmaptex[2]; // Static shadow map textures
//GLuint shadowmapfbo;    // GL id for the shadow map fbo
//GLuint worldshadowmapfbo; // GL id for static shadow map
FBO shadowmapfbo, worldshadowmapfbo; // Shadowmap framebuffer objects
bool shadows;           // Whether to render shadows
Shader shaderhand;      // Encapsulate shaders
string standardshader;  // The basic shader
string noiseshader;     // Perlin Noise shader
string terrainshader;   // Separate shader for terrain
string shadowshader;    // Used to render shadow map
string cloudshader;     // Clouds need slightly different fogging
string watershader;     // Used to render water
string cloudgenshader;  // To actually generate the cloud texture
long trislastframe;     // Performance stats
GLuint noisetex;        // Texture to hold perms and grads for noise generation
FBO cloudfbo;           // FBO to render cloud texture
int cloudres;           // Size of the cloud texture
bool reflection;        // Indicate whether to render reflections for water
FBO reflectionfbo;      // To render the reflection texture
int reflectionres;      // Size of the reflection texture
FBO noisefbo;           // To generate our base noise texture
int noiseres;           // How large to generate the base noise texture
GUI mainmenu;           // Object that handles the main menu
bool mainmenuvisible;   // Whether the main menu is shown
string nextmap;         // Used to signal the main thread to load a new map
string mapname;         // The name of the current map
GUI hud;                // Handles drawing the HUD
GUI loadprogress;       // Shows loading progress
GUI loadoutmenu;        // The loadout screen
GUI statsdisp;          // Display FPS etc.
GUI console;            // The in-game console
vector<ServerInfo> servers; // List of what we know about available servers
set<ServerInfo> knownservers; // Quick way to check whether we already know about a server
int partupdateinterval; // Update particles every this many frames
bool spawnrequest;      // Tell net thread to send spawn request

list<WorldObjects> objects;
WorldPrimitives worldbounds[6];
list<DynamicObject> dynobjects;
vector<PlayerData> player;
vector<UnitData> units;
vector<WeaponData> weapons;
#endif
