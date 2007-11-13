// Rendering functions

#define NO_SDL_GLEXT
#include <list>
#include <vector>
#include <stack>
#include <deque>
#include <sstream>
#include <algorithm>
#include <GL/glew.h>
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
#include "GUI.h"
#include "Timer.h"
#include "SDL_opengl.h"
#include "SDL_ttf.h"

#define PI 3.14159265

extern list<WorldObjects> objects;
extern vector<PlayerData> player;
extern list<DynamicObject> dynobjects;
extern vector<GLuint> dotextures;
extern int viewdist, screenwidth, screenheight, fov, consoletrans, consoleleft;
extern int consoleright, consoletop, consolebottom, consolebottomline;
extern int lasttick, frames, camdist, shadowmapsize, trislastframe;
extern int cloudres, reflectionres, noiseres, servplayernum;
extern float fps;
extern bool consolevisible, showfps, quiet, thirdperson, showkdtree, shadows, reflection;
extern float nearclip, farclip, aspect;
extern TextureHandler texhand;
extern GLuint noisetex;
extern vector<GLuint> textures;
extern FBO shadowmapfbo, cloudfbo, reflectionfbo, noisefbo;
extern string consoleinput;
extern deque<string> consolebuffer;
extern TTF_Font *lcd;
extern TTF_Font *consolefont;
extern SDL_mutex* clientmutex;
extern GLuint texnum[], shadowmaptex[], worldshadowmaptex[];
//extern PrimitiveOctree *ot;
extern ObjectKDTree kdtree;
extern Light lights;
extern Shader shaderhand;
extern string standardshader, noiseshader, shadowshader, cloudshader, watershader;
extern string terrainshader, cloudgenshader;
extern GraphicMatrix cameraproj, cameraview, lightproj, lightview;
extern GUI mainmenu, hud, loadprogress, loadoutmenu, statsdisp;
extern CollisionDetection coldet;
extern vector<WeaponData> weapons;


void RenderSkybox();
void RenderConsole();
void RenderFPS();
void RenderPrimitives(vector<WorldPrimitives>&, bool distsort = false);
void RenderObjects();
void RenderHud();
void RenderClouds();
void RenderDynamicObjects();
void RenderDOTree(DynamicPrimitive*);
void RenderWater();
void GenShadows(Vector3, float, FBO&);
void GenClouds();
list<DynamicObject>::iterator LoadObject(string, list<DynamicObject>&);
void SDL_GL_Enter2dMode();
void SDL_GL_Exit2dMode();
//void RenderText(string, int, int, int, TTF_Font*, float, bool);
int PowerOf2(int);
void Animate();
void Move(PlayerData&, list<DynamicObject>&, CollisionDetection&);
bool floatzero(float, float error = .00001);
void GLError();
void UpdateClouds();
void SetReflection(bool);
void UpdateNoise();

int rendercount;

template <typename T>
string ToString(const T &input)
{
   stringstream temp;
   temp << input;
   return temp.str();
}

// Structure to aid in sorting objects back to front
// No longer needed because primitives can be sorted directly
/*struct primitivedistance
{
   float dist;
   vector<WorldPrimitives>::iterator prim;
   
   bool operator<(const primitivedistance& r) const
   {
      return dist < r.dist;
   }
   bool operator>(const primitivedistance& r) const
   {
      return dist > r.dist;
   }
};*/

bool shadowrender;      // Whether we are rendering the shadowmap this pass
bool reflectionrender;  // Ditto for reflections
bool billboardrender;   // Indicates whether object is being rendered to billboard
GraphicMatrix cameraproj, cameraview, lightproj, lightview;
PlayerData localplayer;

void Repaint()
{
   //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_ACCUM_BUFFER_BIT);
   // The accum buffer is no longer used (atm anyway), and the color buffer
   // should be overwritten by the skybox because we shut off the depth
   // test (nothing else should be rendered at that time anyway)
   static bool updateclouds = true;
   glClear(GL_DEPTH_BUFFER_BIT);
   glShadeModel(GL_SMOOTH);
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   trislastframe = 0;
   rendercount = 0;
   SDL_mutexP(clientmutex);
   localplayer = player[0];
   SDL_mutexV(clientmutex);
   
   if (!mainmenu.visible && !loadprogress.visible && !loadoutmenu.visible)
   {
      // Update player position
      SDL_mutexP(clientmutex);
      Move(player[0], dynobjects, coldet);
      localplayer = player[0];
      SDL_mutexV(clientmutex);
      
      // Update any animated objects
      Animate();
      if (shadows)
      {
         Vector3 rots = lights.GetRots(0);
         float shadowmapsizeworld = 200 * 1.42;
         float worldperoneshadow = shadowmapsizeworld / shadowmapsize;
         
         // Find out where we're looking, a little rough ATM
         GraphicMatrix rot;
         rot.rotatex(-localplayer.pitch);
         rot.rotatey(localplayer.facing + localplayer.rotation);
         //rot.rotatez(localplayer.roll);
         Vector3 look(0, 0, -100);
         look.transform(rot);
         look += localplayer.pos;
         
         GraphicMatrix invrot;
         rot.identity();
         rot.rotatex(-rots.x);
         rot.rotatey(rots.y);
         invrot.rotatey(-rots.y);
         invrot.rotatex(rots.x);
         
         look.transform(invrot);
         look.x = (int)(look.x / worldperoneshadow);
         look.x *= worldperoneshadow;
         look.y = (int)(look.y / worldperoneshadow);
         look.y *= worldperoneshadow;
         
         look.transform(rot);
         
         GenShadows(look, shadowmapsizeworld / 2.f, shadowmapfbo);
      }
      
      // Set the camera's location and orientation
      //gluLookAt(0, localplayer.size / 2.f, .01, 0, localplayer.size / 2.f, 0, 0, 1, 0);
         
      // For debugging third person view
      if (thirdperson)
      {
         gluLookAt(0, 0, camdist, 0, 0, 0, 0, 1, 0);
         glPushMatrix();
      }
      
      glRotatef(localplayer.pitch, 1, 0, 0);
      glRotatef(localplayer.facing + localplayer.rotation, 0, 1, 0);
      glRotatef(localplayer.roll, 0, 0, 1);
   
      RenderSkybox();
      
      glTranslatef(-localplayer.pos.x, -localplayer.pos.y, -localplayer.pos.z);
      
      // For debugging only
      /*glDisable(GL_FOG);
      for (int i = 0; i < 6; i++)
      {
         glBegin(GL_TRIANGLE_STRIP);
         for (int j = 0; j < 4; j++)
         {
            glColor4f(0, 0, 0, .5);
            glVertex3f(worldbounds[i].v[j].x, worldbounds[i].v[j].y, worldbounds[i].v[j].z);
         }
         glEnd();
      }
      glEnable(GL_FOG);*/
      
      /* This has to be set here instead of in RenderObjects because RenderObjects
         is called when shadowing as well, and that needs a different frustum setup.
      */
      Vector3 look(localplayer.pitch, localplayer.rotation + localplayer.facing, localplayer.roll);
      kdtree.setfrustum(localplayer.pos, look, nearclip, viewdist, fov, aspect);
      
      float diff[4] = {1, 1, 1, 1};
      float spec[4] = {1, 1, 1, 1};
      float amb[4] = {.1, .1, .1, .1};
      lights.SetDiffuse(0, diff);
      lights.SetSpecular(0, spec);
      lights.SetAmbient(0, amb);
      
      // Place the light
      lights.Place();
      
      // Activate shadowing
      if (shadows)
      {
         // This is really buggy for some reason and seems to be unnecessary
         //glPushAttrib(GL_ENABLE_BIT | GL_TEXTURE_BIT);
         
         texhand.ActiveTexture(6);
         
         texhand.BindTexture(shadowmapfbo.GetTexture());
         
         GraphicMatrix biasmat;
         GLfloat bias[16] = {.5, 0, 0, 0, 0, .5, 0, 0, 0, 0, .5, 0, .5, .5, .5, 1};
         for (int i = 0; i < 16; ++i)
            biasmat.members[i] = bias[i];
         glMatrixMode(GL_TEXTURE);
         glLoadMatrixf(biasmat);
         glMultMatrixf(lightproj);
         glMultMatrixf(lightview);
         
         glMatrixMode(GL_MODELVIEW);
         
         glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE_ARB, GL_COMPARE_R_TO_TEXTURE_ARB);
         glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC_ARB, GL_LEQUAL);
         glTexParameteri(GL_TEXTURE_2D, GL_DEPTH_TEXTURE_MODE_ARB, GL_INTENSITY);
         
         texhand.ActiveTexture(0);
   #ifdef NOPSM
         shaderhand.UseShader(standardshader);
   #endif
      }
      
      if (updateclouds)
         UpdateClouds();
      updateclouds = false;
      /*static int updcounter = 0;
      if (updcounter % 10 == 0)
         updateclouds = true;
      updcounter++;*/
      
      RenderClouds();
      
      RenderObjects();
      
      shaderhand.UseShader(standardshader);
      RenderDynamicObjects();
      
      if (reflection && localplayer.pos.y > 0)
      {
         UpdateNoise();
         RenderWater();
      }
      
      //if (shadows)
      //   glPopAttrib();
   } // if !mainmenu.visible
   else
   {
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   }
   
   RenderHud();
   
   RenderConsole();
   
   RenderFPS();
   
   //if (showoctree)
   //   ot->visualize();
   if (showkdtree)
      kdtree.visualize();
   
   // For debugging, third person view
   if (thirdperson)
   {
      glPopMatrix();
      glColor4f(1, 0, 0, .8);
      GLUquadricObj *s = gluNewQuadric();
      gluQuadricTexture(s, GL_TRUE);
      gluSphere(s, localplayer.size, 50, 50);
      gluDeleteQuadric(s);
      glColor4f(1, 1, 1, 1);
   }
   
   // And finally, copy all of this stuff to the screen
   SDL_GL_SwapBuffers();
   //sleep(1);
}


bool objcomp(const WorldObjects* l, const WorldObjects* r)
{
   return l->dist > r->dist;
}


void RenderObjects()
{
   float dist;
   bool debug = false; // Turns off impostoring
   
   list<WorldObjects*> objs = kdtree.getobjs();
   Vector3 playerpos = localplayer.pos;
   //cout << "Rendering " << objs.size() << " objects     \r\n" << flush;
   
   list<WorldObjects*>::iterator iptr;
   if (1)
   {
      for (iptr = objs.begin(); iptr != objs.end(); ++iptr)
      {
         WorldObjects *i = *iptr;
         i->dist = playerpos.distance2(Vector3(i->x, i->y, i->z));
      }
      
      objs.sort(objcomp);
   }
   
   for (iptr = objs.begin(); iptr != objs.end(); ++iptr)
   {
      WorldObjects *i = *iptr;
      i->BindVbo();
      Vector3 currpos(i->x, i->y, i->z);
      Vector3 center = currpos;
      center.y += i->height / 2.f;
      dist = playerpos.distance(center);
      if (dist > viewdist + i->size) continue;
      
      if (i->type == "tree" ||
         i->type == "bush" ||
         i->type == "proctree")
      {
         //glPushAttrib(GL_ENABLE_BIT | GL_COLOR_BUFFER_BIT);
         // Nice alpha textured tree leaves
         //glAlphaFunc(GL_GREATER, 0.5);
         
         glEnable(GL_ALPHA_TEST);
         glBlendFunc(GL_ONE, GL_ZERO);
         glEnable(GL_BLEND);
         
         /* Not really happy with the way this looks
         glEnable(GL_MULTISAMPLE);
         glEnable(GL_SAMPLE_ALPHA_TO_COVERAGE);
         glSampleCoverage(1.f, GL_FALSE);*/
         
         //glDisable(GL_LIGHTING);
      }
      
      SDL_mutexP(clientmutex);
      if (floatzero(i->impdist) || dist < i->impdist || shadowrender || debug)
      {
         if (!floatzero(i->impdist) && i->dynobj != dynobjects.end() && !shadowrender)
            i->dynobj->visible = false;
         if (1)
         {
            RenderPrimitives(i->prims);
         }
         else // Display lists are really buggy for some reason
         {
            if (i->dlcurrent)
            {
               shaderhand.UseShader(i->prims[0].shader);
               i->RenderList();
            }
            else
            {
               texhand.ForgetCurrent();
               shaderhand.ForgetCurrent();
               glNewList(i->displaylist, GL_COMPILE);
               RenderPrimitives(i->prims);
               RenderPrimitives(i->tprims, true);
               glEndList();
               i->dlcurrent = true;
               i->RenderList();
            }
         }
      }
      // Billboarding - this should really be moved elsewhere, possibly to WorldObjects itself
      else if (SDL_GetTicks() - i->lastimpupdate > dist / (1000 / dist) && !reflectionrender)
      {
         //Uint32 t = SDL_GetTicks();
         
         i->impostorfbo.Bind();
         glPushAttrib(GL_VIEWPORT_BIT);
         glViewport(0, 0, FBODIM, FBODIM); // Needs to be dynamic at some point
         
         glPushMatrix();
         glLoadIdentity();
         // Why is the up vector pointing down?  In X at least, framebuffers are y-inverted from
         // normal OpenGL, so everything is upside down.  Need a better fix than this hack since it
         // screws up lighting.  Fixed temporarily by hardcoding inverted texcoords.
         gluLookAt(localplayer.pos.x, localplayer.pos.y, localplayer.pos.z, center.x, center.y, center.z, 0, 1, 0);
         
         glMatrixMode(GL_PROJECTION);
         glPushMatrix();
         glLoadIdentity();
         float tempfov = atan(i->height / 2.f / dist) * 360. / PI;
         float tempaspect = i->width / i->height;
         gluPerspective(tempfov, tempaspect, 10, 10000.0);
         
         glMatrixMode(GL_MODELVIEW);
         glClearColor(0, 0, 0, 0);
         glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
         lights.Place();
         RenderPrimitives(i->prims);
         RenderPrimitives(i->tprims, true);
         
         glMatrixMode(GL_PROJECTION);
         glPopMatrix();
         glMatrixMode(GL_MODELVIEW);
         
         glPopMatrix();
         glPopAttrib();
         i->impostorfbo.Unbind();
         lights.Place();
         
         DynamicPrimitive* primptr;
         //SDL_mutexP(clientmutex);  Already necessarily locked earlier
         if (i->dynobj == dynobjects.end())
         {
            dotextures.push_back(i->imptex);
            i->dynobj = LoadObject("impostor", dynobjects);
            (*(i->dynobj->prims[0].begin()))->texnums[0] = dotextures.size() - 1;
            i->dynobj->position = center;
            i->dynobj->billboard = true;
            primptr = *(i->dynobj->prims[0].begin());
            float width2 = i->width / 2.f;
            float height2 = i->height / 2.f;
            primptr->orig[0].x = -width2;
            primptr->orig[0].y = height2;
            primptr->orig[1].x = -width2;
            primptr->orig[1].y = -height2;
            primptr->orig[2].x = width2;
            primptr->orig[2].y = height2;
            primptr->orig[3].x = width2;
            primptr->orig[3].y = -height2;
            primptr->transparent = true;
         }
         primptr = *(i->dynobj->prims[0].begin());
         primptr->facing = true;
         i->dynobj->visible = true;
         //SDL_mutexV(clientmutex);  Ditto
         // Should really do this last so time to update isn't included
         i->lastimpupdate = SDL_GetTicks();
         
         //cout << (SDL_GetTicks() - t) << endl << flush;
      }
      else if (!floatzero(i->impdist) && i->dynobj != dynobjects.end() && !reflectionrender)
      {
         DynamicPrimitive* primptr = *(i->dynobj->prims[0].begin());
         primptr->facing = false;
      }
      SDL_mutexV(clientmutex);
      i->UnbindVbo();
      if (i->type == "tree" ||
         i->type == "bush" ||
         i->type == "proctree")
      {
         //glAlphaFunc(GL_GREATER, 0.5);
         
         glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
         glDisable(GL_ALPHA_TEST);
         
         //glDisable(GL_BLEND);
         
         //glDisable(GL_SAMPLE_ALPHA_TO_COVERAGE);
      }
   }
}


/* distsort indicates whether the primitives should be sorted before rendering
   This is intended for vectors of transparent primitives that need to be
   rendered in the proper order for blending to work.
   */
void RenderPrimitives(vector<WorldPrimitives> &prims, bool distsort)
{
   if (!prims.size()) return;
   
   list<WorldObjects>::iterator o;
   Vector3 playerpos = localplayer.pos;
   int currindex = 0;
   
   if (distsort)
   {
      for (vector<WorldPrimitives>::iterator i = prims.begin(); i != prims.end(); ++i)
      {
         // At the moment, cylinders won't sort right anyway, so don't bother
         if (i->type == "cylinder")
            i->dist = 0;
         else
         {
            float x = (i->v[0].x + i->v[1].x + i->v[2].x + i->v[3].x) / 4;
            float y = (i->v[0].y + i->v[1].y + i->v[2].y + i->v[3].y) / 4;
            float z = (i->v[0].z + i->v[1].z + i->v[2].z + i->v[3].z) / 4;
            i->dist = (x - playerpos.x) * (x - playerpos.x) +
                  (y - playerpos.y) * (y - playerpos.y) +
                  (z - playerpos.z) * (z - playerpos.z);
         }
      }
      
      if (distsort)
         sort(prims.begin(), prims.end());
      else sort(prims.begin(), prims.end(), greater<WorldPrimitives>());
   }
   
   //glColor4f(1, 1, 1, 1); // Taken care of by a color VBO
   for (vector<WorldPrimitives>::iterator i = prims.begin(); i != prims.end(); ++i)
   {
      o = i->object;
      
      /* Never actually disable the depth test now anyway
      if (prims[i].depthtest == false)
         glDisable(GL_DEPTH_TEST);
      else glEnable(GL_DEPTH_TEST);*/
      if (i->type == "cylinder")
      {
         glPushMatrix();
         glTranslatef(o->x, o->y, o->z);
         glRotatef(o->rotation, 0, 1, 0);
         glRotatef(o->pitch, 1, 0, 0);
         glRotatef(o->roll, 0, 0, 1);
         if (!shadowrender)
            shaderhand.UseShader(i->shader);
         texhand.BindTexture(textures[i->texnums[0]]);
         GLUquadricObj *c = gluNewQuadric();
         gluQuadricTexture(c, GL_TRUE);
         gluCylinder(c, i->rad, i->rad1, i->height, i->slices, i->stacks);
         gluDeleteQuadric(c);
         glPopMatrix();
         trislastframe += i->slices * i->stacks * 2;
         
      }
      else if (i->type == "tristrip" || i->type == "terrain")
      {
         if (1)
         {
            texhand.BindTextureDebug(textures[i->texnums[0]]);
            if (i->type == "terrain" && !shadowrender)
            {
               texhand.ActiveTexture(1);
               texhand.BindTextureDebug(textures[i->texnums[1]]);
               texhand.ActiveTexture(2);
               texhand.BindTextureDebug(textures[i->texnums[2]]);
               texhand.ActiveTexture(3);
               texhand.BindTextureDebug(textures[i->texnums[3]]);
               texhand.ActiveTexture(4);
               texhand.BindTextureDebug(textures[i->texnums[4]]);
               texhand.ActiveTexture(5);
               texhand.BindTextureDebug(textures[i->texnums[5]]);
               texhand.ActiveTexture(0);
            }
            if (!shadowrender)
               shaderhand.UseShader(i->shader);
            else if (shadowrender && i->type == "terrain")
               shaderhand.UseShader(shadowshader);
            else if (shadowrender)
               shaderhand.UseShader("none");
            /*if (o->vbocount[currindex] == 1)
            {
               cout << i->type << endl;
               cout << "Texture: " << i->texnums[0] << endl;
               cout << "Shader: " << i->shader << endl;
            }*/
            if (1)
            {
               o->RenderVbo(i->vboindex, o->vbocount[currindex]);
               i += o->vbocount[currindex] - 1;
               ++currindex;
            }
            else o->RenderVbo(i->vboindex, 1);
         }
         else
         {
            texhand.BindTextureDebug(textures[i->texnums[0]]);
            if (i->type == "terrain" && !shadowrender)
            {
               texhand.ActiveTexture(1);
               texhand.BindTextureDebug(textures[i->texnums[1]]);
               texhand.ActiveTexture(2);
               texhand.BindTextureDebug(textures[i->texnums[2]]);
               texhand.ActiveTexture(3);
               texhand.BindTextureDebug(textures[i->texnums[3]]);
               texhand.ActiveTexture(4);
               texhand.BindTextureDebug(textures[i->texnums[4]]);
               texhand.ActiveTexture(5);
               texhand.BindTextureDebug(textures[i->texnums[5]]);
               texhand.ActiveTexture(0);
            }
            if (!shadowrender)
               shaderhand.UseShader(i->shader);
            glBegin(GL_TRIANGLE_STRIP);
            glTexCoord2f(0, 0);
            glNormal3f(i->n[0].x, i->n[0].y, i->n[0].z);
            glVertex3f(i->v[0].x, i->v[0].y, i->v[0].z);
            glTexCoord2f(0, 1);
            glNormal3f(i->n[1].x, i->n[1].y, i->n[1].z);
            glVertex3f(i->v[1].x, i->v[1].y, i->v[1].z);
            glTexCoord2f(1, 0);
            glNormal3f(i->n[2].x, i->n[2].y, i->n[2].z);
            glVertex3f(i->v[2].x, i->v[2].y, i->v[2].z);
            glTexCoord2f(1, 1);
            glNormal3f(i->n[3].x, i->n[3].y, i->n[3].z);
            glVertex3f(i->v[3].x, i->v[3].y, i->v[3].z);
            glEnd();
         }
         
         trislastframe += 2 * o->vbocount[currindex - 1];
      }
   }
}


#if 0
void RenderPrimitives(vector<WorldPrimitives> &prims)
{
   // Render primitives in prims
   int i = 0;
   
   // Sort primitives back to front so blending works right
   // Non-transparent ones actually go front to back for better
   // performance, only transparent prims need to be back to front
   vector<primitivedistance> v;
   vector<primitivedistance> transv;
   list<WorldObjects>::iterator o;
   Vector3 playerpos = localplayer.pos;
   float dist;
   primitivedistance pd;
   while (i < prims.size())
   {
      dist = 0;
      o = prims[i].object;
      pd.primnum = i; 
      if (prims[i].transparent)
      {
         if (prims[i].type == "cylinder")
         {
            Vector3 center(0, 0, prims[i].height / 2);
            center.rotate(o->pitch, o->rotation, o->roll);
            center.translate(o->x, o->y, o->z);
            dist = (center.x - playerpos.x) * (center.x - playerpos.x) +
                  (center.y - playerpos.y) * (center.y - playerpos.y) +
                  (center.z - playerpos.z) * (center.z - playerpos.z);
         }
         else if (prims[i].type == "tristrip" || prims[i].type == "terrain")
         {
            float x = (prims[i].v[0].x + prims[i].v[1].x + prims[i].v[2].x + prims[i].v[3].x) / 4;
            float y = (prims[i].v[0].y + prims[i].v[1].y + prims[i].v[2].y + prims[i].v[3].y) / 4;
            float z = (prims[i].v[0].z + prims[i].v[1].z + prims[i].v[2].z + prims[i].v[3].z) / 4;
            dist = (x - playerpos.x) * (x - playerpos.x) +
                  (y - playerpos.y) * (y - playerpos.y) +
                  (z - playerpos.z) * (z - playerpos.z);
            // Terrain needs to be adjusted slightly so that steep surfaces
            // don't get mixed up due to rounding errors.  Adding the y
            // translation should add the appropriate layer gap to the 
            // calculated distance, ensuring that lower layers always 
            // stay below upper layers.  Remember the y translation is
            // negative, hence the -= below.
            // The * 100 may cause problems down the road, but we'll cross
            // that bridge when we come to it.  Otherwise we get gaps
            // where there are transparent textures meeting at a steep angle
            if (o->type == "terrain")
               dist -= o->y;// * 100;
         }
         if (dist <= viewdist * viewdist)
         {
            pd.dist = dist;
            transv.push_back(pd);
         }
      }
      else
      {
         pd.dist = prims[i].texnum;  // Probably better to sort these by texture
         v.push_back(pd);
      }
      ++i;
   }
   
   for (int z = 0; z < 2; z++)
   {
      if (z)
         sort(v.begin(), v.end());
      else
         sort(v.begin(), v.end());//, greater<primitivedistance>());
      
      i = 0;
      glColor4f(1, 1, 1, 1);
      while (!v.empty())
      {
         i = v.back().primnum;
         v.pop_back();
         o = prims[i].object;
         
         /* Never actually disable the depth test now anyway
         if (prims[i].depthtest == false)
            glDisable(GL_DEPTH_TEST);
         else glEnable(GL_DEPTH_TEST);*/
         if (prims[i].type == "cylinder")
         {
            glPushMatrix();
            glTranslatef(o->x, o->y, o->z);
            glRotatef(o->rotation, 0, 1, 0);
            glRotatef(o->pitch, 1, 0, 0);
            glRotatef(o->roll, 0, 0, 1);
            texhand.BindTexture(textures[prims[i].texnum]);
            GLUquadricObj *c = gluNewQuadric();
            gluQuadricTexture(c, GL_TRUE);
            gluCylinder(c, prims[i].rad, prims[i].rad1, prims[i].height, prims[i].slices, prims[i].stacks);
            gluDeleteQuadric(c);
            glPopMatrix();
            trislastframe += prims[i].slices * prims[i].stacks * 2;
            
         }
         else if (prims[i].type == "tristrip" || prims[i].type == "terrain")
         {
            // There's no actual difference between tristrip and terrain,
            // but differentiating them lets us handle them differently
            // for collision detection
            
            if (o->type == "tree" ||
                o->type == "bush" ||
                o->type == "proctree")
            {
               //glPushAttrib(GL_ENABLE_BIT | GL_COLOR_BUFFER_BIT);
               // Nice alpha textured tree leaves
               glAlphaFunc(GL_GREATER, 0.5);
               glEnable(GL_ALPHA_TEST);
               glBlendFunc(GL_ONE, GL_ZERO);
               //glDisable(GL_LIGHTING);
            }
            if (1)
            {
               texhand.BindTexture(textures[prims[i].texnum]);
               o->RenderVbo(prims[i].vboindex);
            }
            else
            {
               texhand.BindTexture(textures[prims[i].texnum]);
               glBegin(GL_TRIANGLE_STRIP);
               glTexCoord2f(0, 0);
               glNormal3f(prims[i].n[0].x, prims[i].n[0].y, prims[i].n[0].z);
               glVertex3f(prims[i].v[0].x, prims[i].v[0].y, prims[i].v[0].z);
               glTexCoord2f(0, 1);
               glNormal3f(prims[i].n[1].x, prims[i].n[1].y, prims[i].n[1].z);
               glVertex3f(prims[i].v[1].x, prims[i].v[1].y, prims[i].v[1].z);
               glTexCoord2f(1, 0);
               glNormal3f(prims[i].n[2].x, prims[i].n[2].y, prims[i].n[2].z);
               glVertex3f(prims[i].v[2].x, prims[i].v[2].y, prims[i].v[2].z);
               glTexCoord2f(1, 1);
               glNormal3f(prims[i].n[3].x, prims[i].n[3].y, prims[i].n[3].z);
               glVertex3f(prims[i].v[3].x, prims[i].v[3].y, prims[i].v[3].z);
               glEnd();
            }
            if (o->type == "tree" ||
                o->type == "bush" ||
                o->type == "proctree")
            {
               //glAlphaFunc(GL_GREATER, 0.5);
               glDisable(GL_ALPHA_TEST);
               glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
               //glPopAttrib();
            }
            
            trislastframe += 2;
         }
      }
      v = transv;
   }
}
#endif


void RenderDynamicObjects()
{
   list<DynamicObject>::iterator i;
   SDL_mutexP(clientmutex);
   for (i = dynobjects.begin(); i != dynobjects.end(); ++i)
   {
      if (i->visible && (!shadowrender || !i->billboard))
      {
         list<DynamicPrimitive*>::iterator j;
         for (j = i->prims[i->animframe].begin(); j != i->prims[i->animframe].end(); ++j)
         {
            if ((*j)->parentid == "-1")
            {
               glPushMatrix();
               RenderDOTree(*j);
               glPopMatrix();
               
            }
         }
      }
   }
   SDL_mutexV(clientmutex);
}


// Recursively traverse the tree under *root and render the primitives
void RenderDOTree(DynamicPrimitive* root)
{
//   if (root)
//   {
      list<DynamicObject>::iterator parent = root->parentobj;
      
      /*glPushMatrix();
      glRotatef(root->rot1.x, 1, 0, 0);
      glRotatef(root->rot1.y, 0, 1, 0);
      glRotatef(root->rot1.z, 0, 0, 1);
      glTranslatef(root->trans.x, root->trans.y, root->trans.z);
      glRotatef(root->rot2.x, 1, 0, 0);
      glRotatef(root->rot2.y, 0, 1, 0);
      glRotatef(root->rot2.z, 0, 0, 1);*/
      
      for (int i = 0; i < 4; ++i)
         root->v[i] = root->orig[i];
      
      root->m = GraphicMatrix();
      /*if (root->parentid == "-1")
      {
         root->m.rotatey(parent->rotation);
         root->m.rotatex(-parent->pitch);
         root->m.rotatez(-parent->roll);
      }*/
      
      
      root->m.rotatex(root->rot2.x);
      root->m.rotatey(root->rot2.y);
      root->m.rotatez(root->rot2.z);
      
      root->m.translate(root->trans.x, root->trans.y, root->trans.z);
      root->m.rotatex(root->rot1.x);
      root->m.rotatey(root->rot1.y);
      root->m.rotatez(root->rot1.z);
      
      if (root->parentid == "-1")  // Move to object position only for root nodes
      {
         /*glTranslatef(parent->position.x, parent->position.y, parent->position.z);
         glRotatef(parent->rotation, 0, -1, 0);
         glRotatef(parent->pitch, -1, 0, 0);
         glRotatef(parent->roll, 0, 0, -1);*/
         root->m.rotatex(-parent->pitch);
         root->m.rotatey(parent->rotation);
         root->m.rotatez(parent->roll);
         root->m.translate(parent->position.x, parent->position.y, parent->position.z);
      }
      else
      {
         root->m *= root->parent->m;
      }
      
      texhand.ActiveTexture(0);
      texhand.BindTextureDebug(dotextures[root->texnums[0]]);
      //glGenerateMipmapEXT(GL_TEXTURE_2D);
      
      if (root->transparent)
      {
         //glAlphaFunc(GL_GREATER, 0.5);
         glEnable(GL_ALPHA_TEST);
         glBlendFunc(GL_ONE, GL_ZERO);
         glEnable(GL_BLEND);
      }
      if (root->translucent)
      {
         glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
         glEnable(GL_ALPHA_TEST);
         glAlphaFunc(GL_GREATER, .01);
         glDepthMask(GL_FALSE);
      }
      
      if (root->type == "tristrip")
      {
         float temp[3];
         Vector3 norm;
         
         norm = (root->v[2] - root->v[0]).cross(
            root->v[1] - root->v[0]);
         norm.normalize();
         
         if (root->facing)
         {
            Vector3 dir = localplayer.pos - parent->position;
            Vector3 start = norm; // Initial view direction
            
            dir.y = 0;
            dir.normalize();
            root->rot2.y = acos(start.dot(dir)) * 180.f / 3.14159265;
            if (start.cross(dir).y >= 0)
               root->rot2.y *= -1;
            dir = localplayer.pos - parent->position;
            dir.normalize();
            GraphicMatrix rotm;
            rotm.rotatey(root->rot2.y);
            start.transform(rotm);
            root->rot2.x = acos(start.dot(dir)) * 180.f / 3.14159265;
            if (dir.y <= 0)
               root->rot2.x *= -1;
         }
         if (parent->billboard)
         {
            Vector3 lightn = lights.GetPos(0);
            lightn.normalize();
            norm = lightn;
         }
         
         // Apply the matrix of transforms
         for (int i = 0; i < 4; ++i)
            root->v[i].transform(root->m);
         
         // Temporarily hardcoded flipped texcoords for billboards
         glColor4f(1, 1, 1, 1);
         glBegin(GL_TRIANGLE_STRIP);
         glTexCoord2f(1, 1);
         glNormal3fv(norm.array(temp));
         glVertex3fv(root->v[0].array(temp));
         glTexCoord2f(1, 0);
         glVertex3fv(root->v[1].array(temp));
         glTexCoord2f(0, 1);
         glVertex3fv(root->v[2].array(temp));
         glTexCoord2f(0, 0);
         glVertex3fv(root->v[3].array(temp));
         glEnd();
      }
      else if (root->type == "cylinder")
      {
         glPushMatrix();
         glMultMatrixf(root->m.members);
         
         GLUquadricObj *c = gluNewQuadric();
         gluQuadricTexture(c, GL_TRUE);
         gluCylinder(c, root->rad, root->rad1,
                     root->height, root->slices,
                     root->stacks);
         gluDeleteQuadric(c);
         glPopMatrix();
         
         // For collision detection
         root->v[0].x = root->v[1].x = root->v[2].x = root->v[3].x = 0;
         root->v[0].z = root->v[1].z = root->height;
         root->v[0].y = root->v[1].y = root->v[2].y = root->v[3].y = 0;
         root->v[2].z = root->v[3].z = 0;
         root->v[0].x -= .01;
         root->v[2].x -= .01;
         
         for (int i = 0; i < 4; ++i)
            root->v[i].transform(root->m.members);
      }
      
      if (root->transparent)
      {
         glDisable(GL_ALPHA_TEST);
         //glDisable(GL_BLEND);
      }
      
      if (root->translucent)
      {
         glDisable(GL_ALPHA_TEST);
         glAlphaFunc(GL_GREATER, .5);
         glDepthMask(GL_TRUE);
      }
      
      // Render children, siblings should be taken care of by the parent
      list<DynamicPrimitive*>::iterator i;
      for (i = root->child.begin(); i != root->child.end(); i++)
      {
         RenderDOTree(*i);
      }
      //glPopMatrix();
   //}
}


// Generates the depth texture that will be used in shadowing
void GenShadows(Vector3 center, float size, FBO& fbo)
{
   fbo.Bind();
   
   // Adjust a few global settings
   int saveviewdist = viewdist;
   viewdist = Light::infinity + 10000;
   glDisable(GL_FOG);
   glDisable(GL_LIGHTING);
   
   glViewport(0, 0, shadowmapsize, shadowmapsize);
   
   // Set up light matrices
   lightview = lights.GetView(0, center);
   lightproj = lights.GetProj(0, size);
   
   glMatrixMode(GL_PROJECTION);
   glLoadMatrixf(lightproj);
   
   glMatrixMode(GL_MODELVIEW);
   glLoadMatrixf(lightview);
   
   glShadeModel(GL_FLAT);
#ifndef DEBUGSMT
   glCullFace(GL_FRONT);
   glColorMask(0, 0, 0, 0);
#endif
   
   // Need to reset kdtree frustum...
   //Vector3 dir = lights.GetDir(num);
   Vector3 p = lights.GetPos(0);
   Vector3 rots = lights.GetRots(0);
   
   float lightfov = tan(size * 1.42f / Light::infinity) * 180.f / PI;
   kdtree.setfrustum(p + center, rots, Light::infinity - 5000, Light::infinity + 5000, lightfov, 1);
   
   glEnable(GL_POLYGON_OFFSET_FILL);
   glPolygonOffset(2.0f, 2.0f);
   
   // Render objects to depth map
   glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
   shadowrender = true;
   RenderObjects();
   RenderDynamicObjects();
   shadowrender = false;
   glDisable(GL_POLYGON_OFFSET_FILL);
   
   // Reset globals
   glViewport(0, 0, screenwidth, screenheight);
   //glCullFace(GL_BACK);
   glShadeModel(GL_SMOOTH);
   glColorMask(1, 1, 1, 1);
   
   glEnable(GL_FOG);
   glEnable(GL_LIGHTING);
   viewdist = saveviewdist;
   
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   gluPerspective(fov, aspect, nearclip, farclip);
   
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   fbo.Unbind();
}


void UpdateClouds()
{
   UpdateNoise();
   
   cloudfbo.Bind();
   texhand.BindTexture(noisefbo.GetTexture());
   shaderhand.UseShader(cloudgenshader);
   
   glViewport(0, 0, cloudres, cloudres);
   
   glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
   
   glMatrixMode(GL_PROJECTION);
   glPushMatrix();
   glLoadIdentity();
   glOrtho(0, cloudres, cloudres, 0, -1, 1);
   
   glMatrixMode(GL_MODELVIEW);
   glPushMatrix();
   glLoadIdentity();
   
   //glEnable(GL_BLEND);
   //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   
   glDisable(GL_TEXTURE_2D);
   glColor4f(1, 1, 1, 1);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex2f(0, 0);
   glVertex2f(0, cloudres);
   glVertex2f(cloudres, 0);
   glVertex2f(cloudres, cloudres);
   glEnd();
   glEnable(GL_TEXTURE_2D);
   
   //glDisable(GL_BLEND);
   
   glPopMatrix();
   
   glMatrixMode(GL_PROJECTION);
   glPopMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   
   glViewport(0, 0, screenwidth, screenheight);
   shaderhand.UseShader("none");
   cloudfbo.Unbind();
}


void UpdateNoise()
{
   noisefbo.Bind();
   shaderhand.UseShader(noiseshader);
   texhand.BindTexture(noisetex);
   shaderhand.SetUniform1i(noiseshader, "time", SDL_GetTicks());
   
   glViewport(0, 0, noiseres, noiseres);
   
   glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
   
   glMatrixMode(GL_PROJECTION);
   glPushMatrix();
   glLoadIdentity();
   glOrtho(0, noiseres, noiseres, 0, -1, 1);
   
   glMatrixMode(GL_MODELVIEW);
   glPushMatrix();
   glLoadIdentity();
   
   //glEnable(GL_BLEND);
   //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   
   glDisable(GL_TEXTURE_2D);
   glColor4f(1, 1, 1, 1);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex2f(0, 0);
   glVertex2f(0, noiseres);
   glVertex2f(noiseres, 0);
   glVertex2f(noiseres, noiseres);
   glEnd();
   glEnable(GL_TEXTURE_2D);
   
   //glDisable(GL_BLEND);
   
   glPopMatrix();
   
   glMatrixMode(GL_PROJECTION);
   glPopMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   
   glViewport(0, 0, screenwidth, screenheight);
   shaderhand.UseShader("none");
   noisefbo.Unbind();
}


void RenderClouds()
{
   shaderhand.UseShader(cloudshader);
   glFogf(GL_FOG_START, 5000);
   glFogf(GL_FOG_END, 10000);
   glDisable(GL_DEPTH_TEST);
   
   glMatrixMode(GL_PROJECTION);
   glPushMatrix();
   glLoadIdentity();
   gluPerspective(fov, aspect, 100, 10000);
   glMatrixMode(GL_MODELVIEW);
   
   float height = 1000;
   glEnable(GL_BLEND);
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   texhand.BindTexture(cloudfbo.GetTexture());
   glColor4f(1, 1, 1, 1);
   
   glBegin(GL_TRIANGLE_STRIP);
   glTexCoord2i(0, 0);
   glVertex3f(-10000, height, -10000);
   glTexCoord2i(1, 0);
   glVertex3f(10000, height, -10000);
   glTexCoord2i(0, 1);
   glVertex3f(-10000, height, 10000);
   glTexCoord2i(1, 1);
   glVertex3f(10000, height, 10000);
   glEnd();
   
   glMatrixMode(GL_PROJECTION);
   glPopMatrix();
   glMatrixMode(GL_MODELVIEW);
   
   glFogf(GL_FOG_START, viewdist * .8);
   glFogf(GL_FOG_END, viewdist);
   glEnable(GL_DEPTH_TEST);
   shaderhand.UseShader("none");
}


// We may yet come up with a better way to do this
// Or maybe this works pretty well
void RenderSkybox()
{
   shaderhand.UseShader("none");
   // Render ourselves a gigantic sphere to serve as the skybox
   glDisable(GL_FOG);
   glDisable(GL_LIGHTING);
   glDisable(GL_DEPTH_TEST);
   glDisable(GL_BLEND);
   
   //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
   texhand.BindTexture(textures[1]);
   //SetTextureParams();
   glTexCoord3f(0, 0, 0);
   GLUquadricObj *s = gluNewQuadric();
   gluQuadricTexture(s, GL_TRUE);
   
   glPushMatrix();
   glRotatef(90, 1, 0, 0);
   gluSphere(s, viewdist, 10, 10);
   glPopMatrix();
   
   gluDeleteQuadric(s);
   
   glEnable(GL_FOG);
   glEnable(GL_LIGHTING);
   glEnable(GL_DEPTH_TEST);
}


void RenderWater()
{
   reflectionfbo.Bind();
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   glPushMatrix();
   {
      glScalef(1, -1, 1);
      glViewport(0, 0, reflectionres, reflectionres);
      
      glPushMatrix();
      {
         glLoadIdentity();
         glRotatef(localplayer.pitch, 1, 0, 0);
         glRotatef(localplayer.facing + localplayer.rotation, 0, 1, 0);
         glRotatef(localplayer.roll, 0, 0, 1);
         glScalef(1, -1, 1);
         glViewport(0, 0, reflectionres, reflectionres);
         RenderSkybox();
      }
      glPopMatrix();
      
      RenderClouds();
      
      // Remember, rotations not vector
      Vector3 invlook(-localplayer.pitch, localplayer.rotation + localplayer.facing, localplayer.roll);
      Vector3 invpos = localplayer.pos;
      invpos.y *= -1;
      kdtree.setfrustum(invpos, invlook, nearclip, viewdist, fov, aspect);
      
      lights.Place();
      SetReflection(true);
      
      glFrontFace(GL_CW);
      RenderObjects();
      shaderhand.UseShader(standardshader);
      RenderDynamicObjects();
      glFrontFace(GL_CCW);
      
      SetReflection(false);
      
      GraphicMatrix biasmat, camproj, camview;
      GLfloat bias[16] = {.5, 0, 0, 0, 0, .5, 0, 0, 0, 0, .5, 0, .5, .5, .5, 1};
      for (int i = 0; i < 16; ++i)
         biasmat.members[i] = bias[i];
      
      glMatrixMode(GL_PROJECTION);
      glGetFloatv(GL_PROJECTION_MATRIX, camproj);
      glMatrixMode(GL_MODELVIEW);
      glGetFloatv(GL_MODELVIEW_MATRIX, camview);
      
      glMatrixMode(GL_TEXTURE);
      glPushMatrix();
      glLoadMatrixf(biasmat);
      glMultMatrixf(camproj);
      glMultMatrixf(camview);
      
      glMatrixMode(GL_MODELVIEW);
      glViewport(0, 0, screenwidth, screenheight);
   }
   glPopMatrix();
   lights.Place();
   reflectionfbo.Unbind();
   
   glEnable(GL_BLEND);
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   
   shaderhand.UseShader(watershader);
   //glColor4f(.7, .7, .9, .2);
   //glEnable(GL_POLYGON_OFFSET_FILL);
   glPolygonOffset(.1f, .1f);
   
   float height = 0;
   Vector3 norm = lights.GetPos(0);
   norm.normalize();
   
   texhand.BindTexture(reflectionfbo.GetTexture());
   texhand.ActiveTexture(1);
   texhand.BindTexture(noisefbo.GetTexture());
   texhand.ActiveTexture(0);
   
   glBegin(GL_TRIANGLE_STRIP);
   glNormal3f(norm.x, norm.y, norm.z);
   glMultiTexCoord2i(GL_TEXTURE1, 0, 0);
   glVertex3f(-10000, height, -10000);
   glMultiTexCoord2i(GL_TEXTURE1, 0, 1);
   glVertex3f(-10000, height, 10000);
   glMultiTexCoord2i(GL_TEXTURE1, 1, 0);
   glVertex3f(10000, height, -10000);
   glMultiTexCoord2i(GL_TEXTURE1, 1, 1);
   glVertex3f(10000, height, 10000);
   glEnd();
   glColor4f(1, 1, 1, 1);
   glDisable(GL_POLYGON_OFFSET_FILL);
   glDisable(GL_CULL_FACE);
   
   glMatrixMode(GL_TEXTURE);
   glPopMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   shaderhand.UseShader("none");
}


// This needs to be rewritten into a GUI so that it doesn't need to use RenderText
void RenderConsole()
{
   // Display console
   if (0)//consolevisible)
   {
      SDL_GL_Enter2dMode();
      
      glDisable(GL_TEXTURE_2D);
      glColor4f(0, 0, 0, consoletrans / 255.);
      glBegin(GL_TRIANGLE_STRIP);
      glVertex2f(consoleleft, consoletop);
      glVertex2f(consoleleft, consolebottom);
      glVertex2f(consoleright, consoletop);
      glVertex2f(consoleright, consolebottom);
      glEnd();
      glEnable(GL_TEXTURE_2D);
      glColor4f(1, 1, 1, 1);
      
      // Output the current input line
      //GUI::RenderText(consoleinput, consoleleft + 2, consolebottom -  TTF_FontHeight(consolefont) - 2, 0, consolefont, textures[0]);
      
      stack<string> flipbuffer;
      // Remove bottom lines if we scrolled
      for (int i = 0; i < consolebottomline; i++)
      {
         string buffer = consolebuffer.front();
         flipbuffer.push(buffer);
         consolebuffer.pop_front();
      }
      // Output visible lines
      int s = consolebuffer.size();
      for (int i = 0; i < s; i++)
      {
         string buffer = consolebuffer.front();
         flipbuffer.push(buffer);
         int loc = consolebottom - (TTF_FontHeight(consolefont) + 2) * (i + 2);
         if (loc > consoletop)
         {
            //GUI::RenderText(buffer, consoleleft + 2, loc, 0, consolefont, textures[0]);
         }
         consolebuffer.pop_front();
      }
      // Put everything back in the right order
      s = flipbuffer.size();
      for (int i = 0; i < s; i++)
      {
         string buffer = flipbuffer.top();
         consolebuffer.push_front(buffer);
         flipbuffer.pop();
      }
      
      SDL_GL_Exit2dMode();
   }
}


void RenderFPS()
{
   // Render FPS if desired
   /*if (frames >= 30)
   {
      int currtick = SDL_GetTicks();
      fps = (float) frames / ((currtick - lasttick) / 1000.);
      frames = 0;
      lasttick = currtick;
   }
   if (showfps)
   {
      float trispersec = trislastframe * fps;
      SDL_GL_Enter2dMode();
      RenderText(ToString(fps), 0, 0, 0, lcd);
      RenderText(string("Tris/frame: ") + ToString(trislastframe), 0, 20, 0, lcd);
      string tps = ToString(trispersec / 1000000.f);
      tps += " million";
      RenderText(string("Tris/sec: ") + tps, 0, 40, 0, lcd);
      SDL_GL_Exit2dMode();
   }
   if (!quiet)
      cout << "FPS: " << fps << "      \r";*/
   //frames++;
}


void RenderHud()
{
   static GUI* fpslabel = statsdisp.GetWidget("fps");
   static GUI* tpslabel = statsdisp.GetWidget("trispersec");
   static GUI* tpflabel = statsdisp.GetWidget("trisperframe");
   static GUI* pinglabel = statsdisp.GetWidget("ping");
   static GUI* mpflabel = statsdisp.GetWidget("msperframe");
   static GUI* hplabel = hud.GetWidget("hp");
   static GUI* killslabel = hud.GetWidget("kills");
   static GUI* deathslabel = hud.GetWidget("deaths");
   static GUI* torsoweaponlabel = hud.GetWidget("torsoweapon");
   static GUI* larmweaponlabel = hud.GetWidget("larmweapon");
   static GUI* rarmweaponlabel = hud.GetWidget("rarmweapon");
   static GUI* torsoselectedlabel = hud.GetWidget("torsoselected");
   static GUI* larmselectedlabel = hud.GetWidget("larmselected");
   static GUI* rarmselectedlabel = hud.GetWidget("rarmselected");
   
   if (frames >= 30) // Update FPS
   {
      int currtick = SDL_GetTicks();
      fps = (float) frames / ((currtick - lasttick) / 1000.);
      mpflabel->text = "ms/frame: " + ToString(1000. / fps);
      frames = 0;
      lasttick = currtick;
   }
   ++frames;
   
   // Display hud
   SDL_GL_Enter2dMode();
   fpslabel->text = ToString(fps);
   tpslabel->text = "Tris/sec: " + ToString(trislastframe * fps / 1000000.f) + " million";
   tpflabel->text = "Tris/frame: " + ToString(trislastframe);
   pinglabel->text = "Ping: " + ToString(localplayer.ping);
   hplabel->text = "HP: " + ToString(localplayer.hp);
   killslabel->text = "Kills: " + ToString(localplayer.kills);
   deathslabel->text = "Deaths: " + ToString(localplayer.deaths);
   SDL_mutexP(clientmutex);
   torsoweaponlabel->text = weapons[player[0].weapons[Torso]].name;
   larmweaponlabel->text = weapons[player[0].weapons[LArm]].name;
   rarmweaponlabel->text = weapons[player[0].weapons[RArm]].name;
   if (player[0].currweapon == Torso)
      torsoselectedlabel->visible = true;
   else torsoselectedlabel->visible = false;
   if (player[0].currweapon == LArm)
      larmselectedlabel->visible = true;
   else larmselectedlabel->visible = false;
   if (player[0].currweapon == RArm)
      rarmselectedlabel->visible = true;
   else rarmselectedlabel->visible = false;
   SDL_mutexV(clientmutex);
   
   
#ifdef DEBUGSMT
   // Debug the shadowmap texture
   texhand.BindTexture(shadowmapfbo.GetTexture());
   
   glColor4f(1, 1, 1, 1);//.9);
   glBegin(GL_TRIANGLE_STRIP);
   glTexCoord2f(0, 1);
   glVertex2f(0, 0);
   glTexCoord2f(0, 0);
   glVertex2f(0, 500);
   glTexCoord2f(1, 1);
   glVertex2f(500, 0);
   glTexCoord2f(1, 0);
   glVertex2f(500, 500);
   glEnd();
   glColor4f(1, 1, 1, 1);
#endif
   
   mainmenu.Render();
   hud.Render();
   loadprogress.Render();
   loadoutmenu.Render();
   statsdisp.Render();
   
   SDL_GL_Exit2dMode();
}


void SetReflection(bool on)
{
   if (!reflection) on = false;
   reflectionrender = on;
   if (on)
   {
      shaderhand.SetUniform1f(standardshader, "reflectval", 1.f);
      shaderhand.SetUniform1f(terrainshader, "reflectval", 1.f);
   }
   else
   {
      shaderhand.SetUniform1f(standardshader, "reflectval", 0.f);
      shaderhand.SetUniform1f(terrainshader, "reflectval", 0.f);
   }
}
