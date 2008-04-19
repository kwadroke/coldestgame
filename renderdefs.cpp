#include "renderdefs.h"

// Variables that need to be shared for rendering
int shadowmapsize;
float nearclip = 1;
float farclip = 2000;  // Why didn't I just use viewdist?
int fbostarts[3] = {0, 10, 20};
int fbodims[3] = {128, 64, 32};

Meshlist meshes;

vector<GLuint> dotextures;
int viewdist, screenwidth, screenheight, fov, consoletrans, consoleleft;
int consoleright, consoletop, consolebottom, consolebottomline;
int lasttick, frames, camdist, trislastframe;
int cloudres, reflectionres, noiseres;
float fps;
bool showfps, thirdperson, showkdtree, shadows, reflection;
bool serversync;
float aspect;
float impdistmulti;
GLuint noisetex;
vector<GLuint> textures;
FBO worldshadowmapfbo, shadowmapfbo, cloudfbo, reflectionfbo, noisefbo;
Light lights;
string standardshader, noiseshader, shadowshader, cloudshader, watershader;
string terrainshader, cloudgenshader, bumpshader;
vector<FBO> impfbolist;
vector<Mesh*> impmeshes;
Mesh* watermesh;
Material* skyboxmat;
Material* shadowmat;
MeshPtr particlemesh;
