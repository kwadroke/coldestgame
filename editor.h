#ifndef __EDITOR_H
#define __EDITOR_H

#include <map>
#include <string>
#include <set>
#include "SDL.h"
#include "ProceduralTree.h"

using std::vector;
using std::string;

void EditorEventHandler(SDL_Event);
bool EditorGUIEventHandler(SDL_Event);
void GetMap(string);
void EditorMove();
void GetSelectedMesh(SDL_Event);
void SaveMap();
void UpdateEditorGUI();

// Actions called from action.cpp
void SaveObject();
void AddObject();

extern map<Mesh*, ProceduralTree> treemap;
extern vector<Mesh*> spawnmeshes;

#endif
