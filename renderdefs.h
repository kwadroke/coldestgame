#ifndef __RENDERDEFS_H
#define __RENDERDEFS_H

#include "glinc.h"
#include <list>
#include <vector>
#include <stack>
#include <deque>
#include <sstream>
#include <algorithm>
#include "WorldObjects.h"
#include "PlayerData.h"
#include "DynamicObject.h"
#include "TextureHandler.h"
#include "PrimitiveOctree.h"
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
void RenderPrimitives(vector<WorldPrimitives>&, bool distsort = false);
void RenderObjects();
void RenderHud();
void RenderClouds();
void RenderDynamicObjects();
void RenderDOTree(DynamicPrimitive*);
void RenderWater();
void UpdateFBO();
void GenShadows(Vector3, float, FBO&);
void GenClouds();
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);
void SDL_GL_Enter2dMode();
void SDL_GL_Exit2dMode();
int PowerOf2(int);
void Animate();
void Move(PlayerData&, Meshlist&, CollisionDetection&);
void GLError();
void UpdateClouds();
void SetReflection(bool);
void UpdateNoise();
void SynchronizePosition();
void InitGLState(WorldObjects*);
void RestoreGLState(WorldObjects*);
void InitShaders();

typedef list<Mesh> Meshlist;
extern Meshlist meshes;

//extern list<WorldObjects> objects;
//extern vector<GLuint> dotextures;
extern int viewdist, screenwidth, screenheight, fov, consoletrans, consoleleft;
extern int consoleright, consoletop, consolebottom, consolebottomline;
extern int lasttick, frames, camdist, shadowmapsize, trislastframe;
extern int cloudres, reflectionres, noiseres;
extern int fbostarts[3];
extern int fbodims[3];
extern float fps;
extern bool consolevisible, showfps, quiet, thirdperson, showkdtree, shadows, reflection;
extern bool serversync;
extern float nearclip, farclip, aspect;
extern GLuint noisetex;
extern vector<GLuint> textures;
extern FBO shadowmapfbo, worldshadowmapfbo, cloudfbo, reflectionfbo, noisefbo;
extern GLuint texnum[], shadowmaptex[], worldshadowmaptex[];
extern Light lights;
extern string standardshader, noiseshader, shadowshader, cloudshader, watershader;
extern string terrainshader, cloudgenshader, bumpshader;
extern vector<FBO> impfbolist;
extern vector<Mesh*> impmesh;
extern Mesh* watermesh;
extern Material* skyboxmat;
extern Material* shadowmat;

#endif
