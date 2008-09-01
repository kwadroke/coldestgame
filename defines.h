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
using std::cout;
using std::endl;
using std::flush;*/
using namespace std;

// Function definitions
void OutputDiagnosticData();
void SetupSDL();
void SetupOpenGL();
void InitNoise();
static void MainLoop();
void GetMap(string);
void InitGlobals();
void InitGUI();
void InitUnits();
vector<Mesh*> GetMeshesWithoutPlayer(const PlayerData*, Meshlist&, ObjectKDTree&, const Vector3&, const Vector3&, const float);
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

#endif
