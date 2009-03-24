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
// Copyright 2008, 2009 Ben Nemec
// @End License@

#ifndef __EDITOR_H
#define __EDITOR_H

#include <map>
#include <string>
#include <set>
#include "SDL.h"
#include "ProceduralTree.h"
#include "gui/GUI.h"

using std::vector;
using std::string;

void EditorEventHandler(SDL_Event);
bool EditorGUIEventHandler(SDL_Event);
void GetMap(string);
void EditorMove();
void GetSelectedMesh(SDL_Event);
void SaveMap();
void UpdateEditorGUI();
bool MoveObject(SDL_Event&);
void Copy();
void Paste();
void PopulateGUIPointers();

// Actions called from action.cpp
void SaveObject();
void AddObject();
void AddTree();
void DeleteObject();

extern map<Mesh*, ProceduralTree> treemap;
extern vector<Mesh*> spawnmeshes;

struct GUIPointers
{
   GUI* objectname;
   GUI* objectx;
   GUI* objecty;
   GUI* objectz;
   GUI* rotx;
   GUI* roty;
   GUI* rotz;
   GUI* scale;
   GUI* file;
   GUI* objecttris;
   
   // Tree GUI elements
   GUI* seed;
   GUI* impdist;
   GUI* trunkradius;
   GUI* trunksegments;
   GUI* trunkslices;
   GUI* trunktaper;
   GUI* maxtrunkangle;
   
   GUI* maxbranchangle;
   GUI* initialheight;
   GUI* heightreduction;
   GUI* initialradius;
   GUI* radiustaper;
   GUI* numlevels;
   GUI* numslices;
   GUI* numsegments;
   GUI* numbranches0;
   GUI* numbranches1;
   GUI* numbranches2;
   GUI* curvecoeff;
   GUI* maxangle;
   GUI* minangle;
   
   GUI* sidebranches;
   GUI* minsidebranchangle;
   GUI* maxsidebranchangle;
   GUI* branchafter;
   GUI* sidetaper;
   GUI* sidesizeperc;
   
   GUI* numleaves;
   GUI* leafsize;
   GUI* leafsegs;
   GUI* leafcurve;
   GUI* firstleaflevel;
   
   GUI* barkmat;
   GUI* leavesmat;
};

#endif
