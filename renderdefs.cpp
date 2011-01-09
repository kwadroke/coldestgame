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


#include "renderdefs.h"

// Variables that need to be shared for rendering
float nearclip = 1;
int fbostarts[3] = {0, 10, 20};
int fbodims[3] = {128, 64, 32};

Meshlist meshes;

float mapwidth, mapheight;

#ifndef DEDICATED
int lasttick, frames, trislastframe;
int noiseres;
float fps;
float aspect;
bool staticdrawdist, guncam;
GLuint noisetex;
vector<GLuint> textures;
FBO worldshadowmapfbo, shadowmapfbo, cloudfbo, reflectionfbo, noisefbo, fastnoisefbo, minimapfbo;
Light lights;
string standardshader, noiseshader, shadowshader, cloudshader, watershader;
string terrainshader, cloudgenshader, bumpshader, flatshader;
vector<FBO> impfbolist;
vector<Mesh*> impmeshes;
Mesh* watermesh;
Material* skyboxmat;
Material* shadowmat;
MeshPtr particlemesh;
vector<GUIPtr> spawnbuttons;
Camera maincam;
#endif
