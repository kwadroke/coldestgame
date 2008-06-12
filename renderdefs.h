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
#include "Timer.h"
#include "SDL_ttf.h"
#include "Mesh.h"

using std::vector;
using std::list;
using std::string;

void Repaint();
void RenderSkybox();
void RenderObjects();
void RenderParticles();
void RenderHud();
void RenderClouds();
void RenderWater();
void UpdateFBO();
void GenShadows(Vector3, float, FBO&);
void GenClouds();
void SDL_GL_Enter2dMode();
void SDL_GL_Exit2dMode();
int PowerOf2(int);
void Animate();
void GLError();
void UpdateClouds();
void SetReflection(bool);
void UpdateNoise();
void SynchronizePosition();
void LoadMaterials();
void InitShaders();

extern Meshlist meshes;

extern int lasttick, frames, trislastframe;
extern int noiseres;
extern int fbostarts[3];
extern int fbodims[3];
extern float fps;
extern bool consolevisible;
extern float nearclip, farclip, aspect, impdistmulti, mapwidth, mapheight;
extern GLuint noisetex;
extern vector<GLuint> textures;
extern FBO shadowmapfbo, worldshadowmapfbo, cloudfbo, reflectionfbo, noisefbo, minimapfbo;
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

#endif
