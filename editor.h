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
