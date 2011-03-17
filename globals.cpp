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
// Copyright 2008, 2011 Ben Nemec
// @End License@


#include "globals.h"
#include "renderdefs.h"

MutexPtr clientmutex;// Make sure client threads don't interfere with each other
CollisionDetection coldet; // Collision detection handler object
list<Particle> particles; // List of active particles
vector<ParticleEmitter> emitters;
vector<Item> items;
vector<GUIPtr> gui(numguis);
string nextmap;         // Used to signal the main thread to load a new map
string mapname;         // The name of the current map
MapPtr currmap;

ResourceManager resman; // Handles loading and organizing different resources
vector<PlayerData> player;
vector<UnitData> units;
bool server;            // Indicates whether we're running a server
size_t servplayernum;
SDL_Thread* serverthread;
ObjectKDTree kdtree;
vector<floatvec> heightmap;  // Smoothed heightmap data
int tilesize;
vector<SpawnPointData> teamspawns;
vector<SpawnPointData> availablespawns;
bool initialized;
Console console;
tsint winningteam;
vector<BodyParts> weaponslots;
MeshCachePtr meshcache;
tsint spectateplayer;
ALSourcePtr musicsource;
bool editor;
KeyMap keys;
bool reloadgui;
string userpath;
LockManager locks;
RecorderPtr recorder;
ReplayerPtr replayer;
bool replaying;
bool spawnschanged;
