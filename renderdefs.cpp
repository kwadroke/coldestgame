#include "renderdefs.h"

// Variables that need to be shared for rendering
float nearclip = 1;
float farclip = 2000;  // Why didn't I just use viewdist?
int fbostarts[3] = {0, 10, 20};
int fbodims[3] = {128, 64, 32};

Meshlist meshes;

vector<GLuint> dotextures;
int lasttick, frames, trislastframe;
int noiseres;
float fps;
float aspect;
float mapwidth, mapheight;
GLuint noisetex;
vector<GLuint> textures;
FBO worldshadowmapfbo, shadowmapfbo, cloudfbo, reflectionfbo, noisefbo, minimapfbo;
FBO shadowblurfbo, worldshadowblurfbo;
Light lights;
string standardshader, noiseshader, shadowshader, cloudshader, watershader;
string terrainshader, cloudgenshader, bumpshader, blurshader;
vector<FBO> impfbolist;
vector<Mesh*> impmeshes;
Mesh* watermesh;
Material* skyboxmat;
Material* shadowmat;
MeshPtr particlemesh;
