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

#ifndef __DEFINES_H
#define __DEFINES_H

// Odds are that a lot of these includes are no longer needed since globals were
// moved to different files
#include "glinc.h"
#include "SDL.h"
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

#include "TextureHandler.h"
#include "Vector3.h"
#include "GraphicMatrix.h"
#include "ObjectKDTree.h"
#include "CollisionDetection.h"
#include "ProceduralTree.h"
#include "Particle.h"
#include "Hit.h"
#include "PlayerData.h"
#include "Light.h"
#include "Shader.h"
#include "FBO.h"
#include "gui/GUI.h"
#include "gui/ProgressBar.h"
#include "ServerInfo.h"
#include "gui/Table.h"
#include "types.h"
#include "IniReader.h"
#include "gui/TextArea.h"
#include "gui/ComboBox.h"

/* Sorry bwkaz, the hassle just isn't worth it :-)
using std::endl;
using std::flush;*/
using namespace std;

// Function definitions
void OutputDiagnosticData();
void SetupSDL();
void SetupOpenGL();
void SetupOpenAL();
void InitNoise();
static void MainLoop();
void GetMap(string);
void InitGlobals();
void InitGUI();
void InitUnits();
void SDL_GL_Enter2dMode();
void SDL_GL_Exit2dMode();
void GenShadows(Vector3, float, FBO&);
void Animate();
void ReadConfig();
int NetListen(void*);
int NetSend(void*);
void Cleanup();
void Quit();
void Fire();
void UpdateServerList();
void GLError();
void SynchronizePosition();
void UpdatePlayerList();
void GUIUpdate();
bool GUIEventHandler(SDL_Event&);
void GameEventHandler(SDL_Event&);
void AddTracer(const Particle&);
void StartBGMusic();
void UpdatePlayer();

#endif
