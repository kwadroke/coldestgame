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
#ifndef SERVERDEFS_H
#define SERVERDEFS_H

#include "Mesh.h"
#include "Map.h"
#include "ObjectKDTree.h"
#include "PlayerData.h"
#include "Particle.h"
#include "Item.h"

void ServerLoop();
int ServerInput(void*);
void HandleHit(Particle&, Mesh*, const Vector3&);
void SplashDamage(const Vector3&, const float, const float, const int, const bool teamdamage = false);
void ApplyDamage(Mesh*, const float, const size_t, const bool teamdamage = false);
void ServerUpdatePlayer(int);
void Rewind(Uint32, const Vector3&, const Vector3&, const float);
void SaveState();
vector<Item>::iterator RemoveItem(const vector<Item>::iterator&);
void SendKill(size_t, size_t);
void RemoveTeam(int);
void LoadMapList();
void KillPlayer(const int, const int);
void ServerLoadMap(const string&);
int CountPlayers();
void AddItem(const Item&, int);

extern Meshlist servermeshes;
extern MapPtr servermap;
extern tsint serverloadmap;
extern tsint consoleloadmap;
extern string servermapname;
extern ObjectKDTree serverkdtree;
extern vector<PlayerData> serverplayers;
extern list<Particle> servparticles;
extern vector<Item> serveritems;
extern string servername;
extern int servfps;

#endif
