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
// Copyright 2008-2012 Ben Nemec
// @End License@


#ifndef __RENDERDEFS_H
#define __RENDERDEFS_H

#include "glinc.h"
#include <list>
#include <vector>
#include <stack>
#include <deque>
#include <sstream>
#include <algorithm>
#include "PlayerData.h"
#include "TextureHandler.h"
#include "ObjectKDTree.h"
#include "CollisionDetection.h"
#include "Light.h"
#include "Shader.h"
#include "FBO.h"
#include "gui/GUI.h"
#include "gui/ProgressBar.h"
#include "gui/Button.h"
#include "Timer.h"
#include <SDL/SDL_ttf.h>
#include "Mesh.h"
#include "RWLock.h"

using std::vector;
using std::list;
using std::string;

void Repaint();
void SetMainCamera(PlayerData&);
void RenderSkybox(const PlayerData&);
void RenderObjects(const PlayerData&);
void RenderParticles();
void RenderHud(const PlayerData&);
void RenderClouds();
void RenderWater();
void UpdateFBO(const PlayerData&);
void GenShadows(const Vector3&, float, FBO&, const PlayerData&);
void GenClouds();
void SDL_GL_Enter2dMode();
void SDL_GL_Exit2dMode();
int PowerOf2(int);
void GLError();
void UpdateClouds();
void SetReflection(bool);
void UpdateNoise();
void UpdateReflection(const PlayerData&);
void SynchronizePosition(); // These two do not really belong here
void UpdateSpectatePosition();
void LoadMaterials();
void InitShaders();
vector<Mesh*> GetDynamicMeshes(const PlayerData&);
void SetShadowFrustum(const float, const Vector3&, const PlayerData&);
Vector3 GetShadowLook(const float, const PlayerData&);
void SetReflectionFrustum(const PlayerData&);
Vector3 GetShotVector(const float, const Vector3&, const Vector3&, const Vector3&);
string GetColorCode(const PlayerData&, const int);

extern Meshlist meshes;

extern float mapwidth, mapheight;

#ifndef DEDICATED
extern int lasttick, frames, trislastframe;
extern int noiseres;
extern int fbostarts[3];
extern int fbodims[3];
extern float fps;
extern float nearclip, aspect, impdistmulti;
extern bool staticdrawdist, guncam;
extern GLuint noisetex;
extern vector<GLuint> textures;
extern FBO shadowmapfbo, worldshadowmapfbo, cloudfbo, reflectionfbo, noisefbo, fastnoisefbo, minimapfbo;
extern GLuint texnum[], shadowmaptex[], worldshadowmaptex[];
extern Light lights;
extern string standardshader, noiseshader, shadowshader, cloudshader, watershader;
extern string terrainshader, cloudgenshader, bumpshader, flatshader;
extern vector<FBO> impfbolist;
extern vector<Mesh*> impmeshes;
extern Mesh* watermesh;
extern Material* skyboxmat;
extern Material* shadowmat;
extern MeshPtr particlemesh;
extern vector<GUIPtr> spawnbuttons;
extern Camera maincam;
#endif

#endif
