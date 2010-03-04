// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2010 Ben Nemec
// @End License@


#ifndef __GLOBALS
#define __GLOBALS

#include <string>
#include <sstream>
#include "Mesh.h"
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
#include "MeshCache.h"
#include "logout.h"
#include "KeyMap.h"
#include "LockManager.h"


#define PI 3.14159265

using std::string;
using std::stringstream;
using std::list;
using std::vector;
using std::set;

const int terrobjsize = 16; // Terrain objects are terrobjsize x terrobjsize tiles

// If you add to this and it's a primary GUI, don't forget to add it to GUIEventHandler or it won't get events
// Also note that fullscreen GUI's should be added before statsdisp so they don't cover it up
// Another also: fullscreen GUI's need to be added to PrimaryGUIVisible or crashes will result
enum GUINames {mainmenu, loadprogress, loadoutmenu, settings, hud, serverbrowser, credits, updateprogress, statsdisp, consolegui, 
   ingamestatus, chat, endgame, loadoutmessage, editobject, editormain, numguis};

extern SDL_mutex* clientmutex;// Make sure client threads don't interfere with each other
extern CollisionDetection coldet; // Collision detection handler object
extern list<Particle> particles; // List of active particles
extern vector<ParticleEmitter> emitters;
extern vector<Item> items;
extern string nextmap;         // Used to signal the main thread to load a new map
extern string mapname;         // The name of the current map
extern ResourceManager resman; // Handles loading and organizing different resources
#ifndef DEDICATED
extern vector<GUIPtr> gui;
#endif
extern vector<PlayerData> player;
extern vector<UnitData> units;
extern bool server;
extern size_t servplayernum;
extern SDL_Thread* serverthread;
extern ObjectKDTree kdtree;
extern vector<floatvec> heightmap;  // Smoothed heightmap data
extern int tilesize;
extern vector<SpawnPointData> spawnpoints;
extern vector<SpawnPointData> availablespawns;
extern vector<SpawnPointData> mapspawns;
extern bool initialized;
extern Meshlist meshes;
extern tsint serverhasmap;
extern Console console;
extern tsint winningteam;
extern vector<BodyParts> weaponslots;
extern MeshCachePtr meshcache;
extern tsint spectateplayer;
extern ALSourcePtr musicsource;
extern bool editor;
extern KeyMap keys;
extern bool reloadgui;
extern string userpath;
extern LockManager locks;

void UpdatePlayerModel(PlayerData&, Meshlist&, bool gl = true);
float GetTerrainHeight(const float x, const float y);
void AppendToChat(int, string);
void UpdateParticles(list<Particle>&, int&, ObjectKDTree&, Meshlist&, vector<PlayerData>&, const Vector3& campos = Vector3(),
                     void (*HitHandler)(Particle&, Mesh*, const Vector3&) = NULL,
                     void (*Rewind)(Uint32, const Vector3&, const Vector3&, const float) = NULL);
void Move(PlayerData&, Meshlist&, ObjectKDTree&);
bool ValidateMove(PlayerData&, Vector3, Meshlist&, ObjectKDTree&);
void AppendDynamicMeshes(vector<Mesh*>&, Meshlist&);
int Server(void* dummy);
void ShowGUI(int);
void ResetKeys();
int CalculatePlayerWeight(const PlayerData&);
Particle CreateShot(const Weapon&, const Vector3&, const Vector3&, Vector3, const Vector3&, int pnum = 0);
void CacheMeshes();
void UpdateSettings();
void SaveSettings();
bool PrimaryGUIVisible();
void SpectateNext();
void SpectatePrev();
void EditorLoop(const string);
vector<Mesh*> GetMeshesWithoutPlayer(const PlayerData*, Meshlist&, ObjectKDTree&, const Vector3&, const Vector3&, const float);
void RegenFBOList();
PlayerData* PlayerFromMesh(Mesh*, vector<PlayerData>&, Meshlist::iterator);
void StartBGMusic();
bool NearSpawn(PlayerData&, vector<SpawnPointData>&);
vector<SpawnPointData> GetSpawns(vector<Item>&);

#endif
