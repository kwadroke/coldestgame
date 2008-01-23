#include "renderdefs.h"

// Variables that need to be shared for rendering
int shadowmapsize;
float nearclip = 1;
float farclip = 2000;  // Why didn't I just use viewdist?
int fbostarts[3] = {0, 10, 20};

list<WorldObjects> objects;
//list<DynamicObject> dynobjects;
vector<GLuint> dotextures;
int viewdist, screenwidth, screenheight, fov, consoletrans, consoleleft;
int consoleright, consoletop, consolebottom, consolebottomline;
int lasttick, frames, camdist, trislastframe;
int cloudres, reflectionres, noiseres;
float fps;
bool showfps, thirdperson, showkdtree, shadows, reflection;
bool serversync;
float aspect;
TextureHandler texhand;
GLuint noisetex;
vector<GLuint> textures;
FBO worldshadowmapfbo, shadowmapfbo, cloudfbo, reflectionfbo, noisefbo;
Light lights;
Shader shaderhand;
string standardshader, noiseshader, shadowshader, cloudshader, watershader;
string terrainshader, cloudgenshader, bumpshader;
vector<FBO> impfbolist;
vector<WorldObjects*> impobjs;
list<WorldObjects>::iterator waterobj;
