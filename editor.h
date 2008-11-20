#ifndef __EDITOR_H
#define __EDITOR_H

#include <map>
#include <string>
#include "SDL.h"
#include "ProceduralTree.h"

using std::vector;
using std::string;

void EditorEventHandler(SDL_Event);
void GetMap(string);
void EditorMove();
void GetSelectedMesh(SDL_Event);
void SaveMap();

extern map<Mesh*, ProceduralTree> treemap;

#endif
