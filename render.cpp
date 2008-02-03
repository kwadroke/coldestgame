// Rendering functions

#include "globals.h"
#include "renderdefs.h"

bool shadowrender;      // Whether we are rendering the shadowmap this pass
bool reflectionrender;  // Ditto for reflections
bool billboardrender;   // Indicates whether object is being rendered to billboard
GraphicMatrix cameraproj, cameraview, lightproj, lightview;
PlayerData localplayer(dynobjects);
set<WorldObjects*> implist;
set<WorldObjects*> visibleobjs;

void Repaint()
{
   static Timer t, ts;
   t.start();
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_ACCUM_BUFFER_BIT);
   // The accum buffer is no longer used (atm anyway), and the color buffer
   // should be overwritten by the skybox because we shut off the depth
   // test (nothing else should be rendered at that time anyway)
   static bool updateclouds = true;
   glClear(GL_DEPTH_BUFFER_BIT);
   glShadeModel(GL_SMOOTH);
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   trislastframe = 0;
   SDL_mutexP(clientmutex);
   localplayer = player[0];
   SDL_mutexV(clientmutex);
   if (!mainmenu.visible && !loadprogress.visible && !loadoutmenu.visible)
   {
      // Update player position
      SDL_mutexP(clientmutex);
      Move(player[0], dynobjects, coldet);
      if (serversync)
         SynchronizePosition();
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
      
      /* This has to be set here instead of in RenderObjects because RenderObjects
         is called when shadowing as well, and that needs a different frustum setup.
      */
      Vector3 look(localplayer.pitch, localplayer.rotation + localplayer.facing, localplayer.roll);
      kdtree.setfrustum(localplayer.pos, look, nearclip, viewdist, fov, aspect);
      
      // Place the light(s)
      lights.Place();
      
      // Activate shadowing
      if (shadows)
      {
         // This is really buggy for some reason and seems to be unnecessary
         //glPushAttrib(GL_ENABLE_BIT | GL_TEXTURE_BIT);
         
         resman.texhand.ActiveTexture(6);
         
         resman.texhand.BindTexture(shadowmapfbo.GetTexture());
         
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
         
         resman.texhand.ActiveTexture(0);
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
      
      resman.shaderman.UseShader(standardshader);
      RenderDynamicObjects();
      
      if (localplayer.pos.y > 0)
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
      resman.shaderman.UseShader("none");
   }
   
   RenderHud();
   
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
   if (t.elapsed() > (1000.f / fps) * 2.f)
   {
      //cout << "Average ms/frame: " << (1000.f / fps) << endl;
      //t.stop();
   }
   //sleep(1);
}


bool objcomp(const WorldObjects* l, const WorldObjects* r)
{
   return l->dist < r->dist;
}


void RenderObjects()
{
   float dist;
   bool debug = false; // Turns off impostoring if true
   //debug = true;
   
   list<WorldObjects*> objs = kdtree.getobjs();
   Vector3 playerpos = localplayer.pos;
   implist.clear();
   visibleobjs.clear();
   //cout << "Rendering " << objs.size() << " objects     \r\n" << flush;
   
   list<WorldObjects*>::iterator iptr;
   for (iptr = objs.begin(); iptr != objs.end(); ++iptr)
   {
      WorldObjects *i = *iptr;
      i->dist = playerpos.distance2(Vector3(i->x, i->y, i->z));
      visibleobjs.insert(i);
   }
   
   objs.sort(objcomp);
   
   for (iptr = objs.begin(); iptr != objs.end(); ++iptr)
   {
      WorldObjects *i = *iptr;
      if (i->type == "water" || i->type == "dynobj") continue;
      i->BindVbo();
      Vector3 currpos(i->x, i->y, i->z);
      Vector3 center = currpos;
      center.y += i->height / 2.f;
      dist = playerpos.distance(center);
      if (dist > viewdist + i->size) continue;
      
      SDL_mutexP(clientmutex);
      
      InitGLState(i);
      
      if (floatzero(i->impdist) || dist < i->impdist || shadowrender || debug)
      {
         if (!floatzero(i->impdist) && i->dynobj != dynobjects.end() && !shadowrender)
            i->dynobj->visible = false;
         RenderPrimitives(i->prims);
      }
      else 
      {
         if (SDL_GetTicks() - i->lastimpupdate > dist / (1000 / dist) && !reflectionrender)
         {
            implist.insert(i);
            
         }
         else if (!floatzero(i->impdist) && i->dynobj != dynobjects.end() && !reflectionrender)
         {
            DynamicPrimitive* primptr = *(i->dynobj->prims[0].begin());
            primptr->facing = false;
         }
      }
      
      RestoreGLState(i);
      
      SDL_mutexV(clientmutex);
   }
   
   if (!shadowrender && !reflectionrender && !debug)
      UpdateFBO();
   
   WorldObjects::UnbindVbo();
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
   
   for (vector<WorldPrimitives>::iterator i = prims.begin(); i != prims.end(); ++i)
   {
      o = i->object;
      
      i->material->Use();
      if (shadowrender)
         resman.shaderman.UseShader(shadowshader);
      if (i->type == "cylinder")
      {
         glPushMatrix();
         glTranslatef(o->x, o->y, o->z);
         glRotatef(o->rotation, 0, 1, 0);
         glRotatef(o->pitch, 1, 0, 0);
         glRotatef(o->roll, 0, 0, 1);
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
            o->RenderVbo(i->vboindex, o->vbocount[currindex]);
            i += o->vbocount[currindex] - 1;
            ++currindex;
         }
         trislastframe += 2 * o->vbocount[currindex - 1];
      }
   }
}


void InitGLState(WorldObjects *i)
{
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
      
      /* Not entirely happy with the way this looks, but it could be worse*/
      glEnable(GL_SAMPLE_ALPHA_TO_COVERAGE);
      glSampleCoverage(1.f, GL_FALSE);
      glDisable(GL_BLEND);
      //glAlphaFunc(GL_GREATER, 0.5);
      
      //glDisable(GL_LIGHTING);
   }
}


void RestoreGLState(WorldObjects *i)
{
   if (i->type == "tree" ||
      i->type == "bush" ||
      i->type == "proctree")
   {
      //glAlphaFunc(GL_GREATER, 0.5);
      
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
      glDisable(GL_ALPHA_TEST);
      
      //glDisable(GL_BLEND);
      
      glDisable(GL_SAMPLE_ALPHA_TO_COVERAGE);
      glEnable(GL_BLEND);
   }
}


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
            if ((*j)->parentid == "-1" || (*j)->parentid == "-2")
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
   list<DynamicObject>::iterator parent = root->parentobj;
   
   for (int i = 0; i < 4; ++i)
      root->v[i] = root->orig[i];
   
   root->m = GraphicMatrix();
   
   root->m.rotatex(root->rot2.x);
   root->m.rotatey(root->rot2.y);
   root->m.rotatez(root->rot2.z);
   
   root->m.translate(root->trans.x, root->trans.y, root->trans.z);
   root->m.rotatex(root->rot1.x);
   root->m.rotatey(root->rot1.y);
   root->m.rotatez(root->rot1.z);
   
   if (root->parentid == "-1")  // Move to object position only for root nodes
   {
      root->m.rotatex(-parent->pitch);
      root->m.rotatey(parent->rotation);
      root->m.rotatez(parent->roll);
      root->m.translate(parent->position.x, parent->position.y, parent->position.z);
   }
   else
   {
      root->m *= root->parent->m;
   }
   
   resman.texhand.ActiveTexture(0);
   resman.texhand.BindTextureDebug(root->texnums[0]);
   resman.texhand.ActiveTexture(1);
   resman.texhand.BindTextureDebug(root->texnums[1]);
   resman.texhand.ActiveTexture(0);
   resman.shaderman.UseShader(root->shader);
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
      //glDepthMask(GL_FALSE);
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
         Vector3 start = norm * -1; // Initial view direction
         
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
         if (dir.y >= 0)
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
      
      // Just for testing bumpmapping
      norm = (root->v[2] - root->v[0]).cross(
               root->v[1] - root->v[0]);
      norm.normalize();
      Vector3 tangent = root->v[1] - root->v[0];
      tangent.normalize();
      
      GLint loc = resman.shaderman.GetAttribLocation(bumpshader, "tangent");
      
      glColor4f(1, 1, 1, 1);
      glBegin(GL_TRIANGLE_STRIP);
      glTexCoord2fv(&root->texcoords[0][0][0]);
      glNormal3fv(norm.array(temp));
      glVertexAttrib3fv(loc, tangent.array(temp));
      glVertex3fv(root->v[0].array(temp));
      glTexCoord2fv(&root->texcoords[0][1][0]);
      glVertex3fv(root->v[1].array(temp));
      glTexCoord2fv(&root->texcoords[0][2][0]);
      glVertex3fv(root->v[2].array(temp));
      glTexCoord2fv(&root->texcoords[0][3][0]);
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
}


// This needs to sort descending, hence the >
bool sortbyimpdim(const WorldObjects* l, const WorldObjects* r)
{
   return impfbolist[l->impostorfbo].GetWidth() > impfbolist[r->impostorfbo].GetWidth();
}


void UpdateFBO()
{
   vector<WorldObjects*>::iterator iptr;
   vector<WorldObjects*> sortedbyimpdim;
   vector<WorldObjects*> needsupdate;
   WorldObjects* i;
   FBO* currfbo = &(impfbolist[0]);
   int counter = 0;
   int desireddim = fbostarts[2];
   Vector3 playerpos = localplayer.pos;
   
   sortedbyimpdim = impobjs;
   
   sort(sortedbyimpdim.begin(), sortedbyimpdim.end(), sortbyimpdim);
   sort(impobjs.begin(), impobjs.end(), objcomp);
   
   for (iptr = impobjs.begin(); iptr != impobjs.end(); ++iptr)
   {
      i = *iptr;
      if (implist.find(i) != implist.end())
      {
         needsupdate.push_back(i);
         
         currfbo = &(impfbolist[i->impostorfbo]);
         
         if (counter >= fbostarts[2])
            desireddim = fbodims[2];
         else if (counter >= fbostarts[1])
            desireddim = fbodims[1];
         else desireddim = fbodims[0];
         
         int current = 0;
         int count = 0;
         WorldObjects* toswap;
         while (desireddim > currfbo->GetWidth())
         {
            if (desireddim == fbodims[1] ||
               (desireddim == fbodims[0] && currfbo->GetWidth() == fbodims[2]))
            {
               current = fbostarts[1];
               count = fbostarts[2] - fbostarts[1];
            }
            else if (desireddim == fbodims[0])
            {
               current = fbostarts[0];
               count = fbostarts[1] - fbostarts[0];
            }
            else if (desireddim == fbodims[2])
            {
               current = fbostarts[2];
               count = sortedbyimpdim.size() - fbostarts[2] + 1;
            }
            
            toswap = sortedbyimpdim[current];
            // Find the object we want to swap with
            while (count > 0 && current < sortedbyimpdim.size())
            {
               if (sortedbyimpdim[current]->dist > toswap->dist)
               {
                  toswap = sortedbyimpdim[current];
                  //cout << "Swapping " << counter << " for " << current << endl;
               }
               --count;
               ++current;
            }
            
            // Do the swap and add the swapped object to our list of things to update (maybe)
            //cout << "Swapping for " << impfbolist[toswap->impostorfbo].GetWidth() << endl;
            //cout << desireddim << "  " << currfbo->GetWidth() << endl;
            int tempfbo = i->impostorfbo;
            i->impostorfbo = toswap->impostorfbo;
            toswap->impostorfbo = tempfbo;
            if (visibleobjs.find(toswap) != visibleobjs.end())
               needsupdate.push_back(toswap);
            currfbo = &(impfbolist[i->impostorfbo]);
            sort(sortedbyimpdim.begin(), sortedbyimpdim.end(), sortbyimpdim);
         }
      }
      ++counter;
   }
   
   // Now go through and update the impostor for any objects that need it
   for (iptr = needsupdate.begin(); iptr != needsupdate.end(); ++iptr)
   {
      i = *iptr;
      currfbo = &(impfbolist[i->impostorfbo]);
      currfbo->Bind();
      
      Vector3 currpos(i->x, i->y, i->z);
      Vector3 center = currpos;
      center.y += i->height / 2.f;
      float dist = playerpos.distance(center);
         
      glPushAttrib(GL_VIEWPORT_BIT);
      glViewport(0, 0, currfbo->GetWidth(), currfbo->GetHeight());
      
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
      
      i->BindVbo();
      InitGLState(i);
      
      RenderPrimitives(i->prims);
      RenderPrimitives(i->tprims, true);
      
      RestoreGLState(i);
      
      glMatrixMode(GL_PROJECTION);
      glPopMatrix();
      glMatrixMode(GL_MODELVIEW);
      
      glPopMatrix();
      glPopAttrib();
      currfbo->Unbind();
      lights.Place();
      
      DynamicPrimitive* primptr;
      if (i->dynobj == dynobjects.end())
      {
         i->dynobj = LoadObject("impostor", dynobjects);
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
         // Have to flip texture coordinates vertically because FBO's in X are upside down
         // This may have to be ifdef'd for a Windows port because it's platform-specific
         primptr->texcoords[0][0][1] = 1;
         primptr->texcoords[0][1][1] = 0;
         primptr->texcoords[0][2][1] = 1;
         primptr->texcoords[0][3][1] = 0;
      }
      (*(i->dynobj->prims[0].begin()))->texnums[0] = currfbo->GetTexture();
      primptr = *(i->dynobj->prims[0].begin());
      primptr->facing = true;
      i->dynobj->visible = true;
      // Should really do this last so time to update isn't included
      i->lastimpupdate = SDL_GetTicks();
   }
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
   //glCullFace(GL_FRONT); // Breaks tree shadows
   //glEnable(GL_CULL_FACE);
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
   //glDisable(GL_CULL_FACE);
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
   resman.texhand.BindTexture(noisefbo.GetTexture());
   resman.shaderman.UseShader(cloudgenshader);
   
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
   resman.shaderman.UseShader("none");
   cloudfbo.Unbind();
}


void UpdateNoise()
{
   noisefbo.Bind();
   resman.shaderman.UseShader(noiseshader);
   // Don't remove this, it's not the texture we're trying to render to, it's used in the noise shader
   resman.texhand.BindTexture(noisetex);
   resman.shaderman.SetUniform1f(noiseshader, "time", (float)SDL_GetTicks() / 700.f);
   
   glViewport(0, 0, noiseres, noiseres);
   
   //glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
   
   glMatrixMode(GL_PROJECTION);
   glPushMatrix();
   glLoadIdentity();
   glOrtho(0, noiseres, noiseres, 0, -1, 1);
   
   glMatrixMode(GL_MODELVIEW);
   glPushMatrix();
   glLoadIdentity();
   
   //glEnable(GL_BLEND);
   //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   
   glDisable(GL_DEPTH_TEST);
   glDisable(GL_TEXTURE_2D);
   glColor4f(1, 1, 1, 1);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex2f(0, 0);
   glVertex2f(0, noiseres);
   glVertex2f(noiseres, 0);
   glVertex2f(noiseres, noiseres);
   glEnd();
   glEnable(GL_TEXTURE_2D);
   glEnable(GL_DEPTH_TEST);
   
   //glDisable(GL_BLEND);
   
   glPopMatrix();
   
   glMatrixMode(GL_PROJECTION);
   glPopMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   
   glViewport(0, 0, screenwidth, screenheight);
   resman.shaderman.UseShader("none");
   noisefbo.Unbind();
}


void RenderClouds()
{
   resman.shaderman.UseShader(cloudshader);
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
   resman.texhand.BindTexture(cloudfbo.GetTexture());
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
   resman.shaderman.UseShader("none");
}


// We may yet come up with a better way to do this
// Or maybe this works pretty well
void RenderSkybox()
{
   //resman.shaderman.UseShader("none");
   skyboxmat->Use();
   // Render ourselves a gigantic sphere to serve as the skybox
   glDisable(GL_FOG);
   glDisable(GL_LIGHTING);
   glDisable(GL_DEPTH_TEST);
   glDisable(GL_BLEND);
   
   //resman.texhand.BindTexture(textures[0]);
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
      glViewport(0, 0, reflectionres, reflectionres);
      
      glScalef(1, -1, 1);
      
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
      
      if (reflection)
      {
         // Remember, rotations not vector
         Vector3 invlook(-localplayer.pitch, localplayer.rotation + localplayer.facing, localplayer.roll);
         Vector3 invpos = localplayer.pos;
         invpos.y *= -1;
         kdtree.setfrustum(invpos, invlook, nearclip, viewdist, fov, aspect);
         
         lights.Place();
         SetReflection(true);
         
         glFrontFace(GL_CW);
         RenderObjects();
         resman.shaderman.UseShader(standardshader);
         RenderDynamicObjects();
         glFrontFace(GL_CCW);
         
         SetReflection(false);
      }
      
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
   reflectionfbo.Unbind();
   lights.Place();
   
   glEnable(GL_BLEND);
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   
   float height = 0;
   Vector3 norm = lights.GetPos(0);
   norm.normalize();
   
   resman.texhand.ActiveTexture(1);
   resman.texhand.BindTexture(noisefbo.GetTexture());
   resman.texhand.ActiveTexture(0);
   
   waterobj->BindVbo();
   RenderPrimitives(waterobj->prims);
   WorldObjects::UnbindVbo();
   
   glMatrixMode(GL_TEXTURE);
   glPopMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   resman.shaderman.UseShader("none");
}


void RenderHud()
{
   static GUI* fpslabel = statsdisp.GetWidget("fps");
   static GUI* tpslabel = statsdisp.GetWidget("trispersec");
   static GUI* tpflabel = statsdisp.GetWidget("trisperframe");
   static GUI* pinglabel = statsdisp.GetWidget("ping");
   static GUI* mpflabel = statsdisp.GetWidget("msperframe");
   static GUI* poslabel = statsdisp.GetWidget("position");
   static GUI* torsohplabel = hud.GetWidget("torsohp");
   static GUI* legshplabel = hud.GetWidget("legshp");
   static GUI* leftarmhplabel = hud.GetWidget("leftarmhp");
   static GUI* rightarmhplabel = hud.GetWidget("rightarmhp");
   static GUI* killslabel = hud.GetWidget("kills");
   static GUI* deathslabel = hud.GetWidget("deaths");
   static GUI* torsoweaponlabel = hud.GetWidget("torsoweapon");
   static GUI* larmweaponlabel = hud.GetWidget("larmweapon");
   static GUI* rarmweaponlabel = hud.GetWidget("rarmweapon");
   static GUI* torsoselectedlabel = hud.GetWidget("torsoselected");
   static GUI* larmselectedlabel = hud.GetWidget("larmselected");
   static GUI* rarmselectedlabel = hud.GetWidget("rarmselected");
   static ProgressBar* tempbar = (ProgressBar*)hud.GetWidget("temperature");
   static ProgressBar* rotbar = (ProgressBar*)hud.GetWidget("facing");
   
   if (frames >= 30) // Update FPS
   {
      int currtick = SDL_GetTicks();
      fps = (float) frames / ((currtick - lasttick) / 1000.);
      mpflabel->text = "ms/frame: " + ToString(1000. / fps);
      frames = 0;
      lasttick = currtick;
   }
   ++frames;
   
   // Update GUI values
   SDL_GL_Enter2dMode();
   fpslabel->text = ToString(fps);
   tpslabel->text = "Tris/sec: " + ToString(trislastframe * fps / 1000000.f) + " million";
   tpflabel->text = "Tris/frame: " + ToString(trislastframe);
   pinglabel->text = "Ping: " + ToString(localplayer.ping);
   poslabel->text = "Position: " + ToString(localplayer.pos.x) + " " + ToString(localplayer.pos.y) + " " + ToString(localplayer.pos.z);
   torsohplabel->text = "Torso: " + ToString(localplayer.hp[Torso]);
   legshplabel->text = "Legs: " + ToString(localplayer.hp[Legs]);
   leftarmhplabel->text = "Left Arm: " + ToString(localplayer.hp[LArm]);
   rightarmhplabel->text = "Right Arm: " + ToString(localplayer.hp[RArm]);
   killslabel->text = "Kills: " + ToString(localplayer.kills);
   deathslabel->text = "Deaths: " + ToString(localplayer.deaths);
   
   torsoweaponlabel->text = weapons[localplayer.weapons[Torso]].name;
   larmweaponlabel->text = weapons[localplayer.weapons[LArm]].name;
   rarmweaponlabel->text = weapons[localplayer.weapons[RArm]].name;
   if (localplayer.currweapon == Torso)
      torsoselectedlabel->visible = true;
   else torsoselectedlabel->visible = false;
   if (localplayer.currweapon == LArm)
      larmselectedlabel->visible = true;
   else larmselectedlabel->visible = false;
   if (localplayer.currweapon == RArm)
      rarmselectedlabel->visible = true;
   else rarmselectedlabel->visible = false;
   
   tempbar->SetRange(0, 100);
   tempbar->value = (int)localplayer.temperature;
   rotbar->SetRange(-90, 90);
   rotbar->value = (int)localplayer.rotation;
   
   
#ifdef DEBUGSMT
   // Debug the shadowmap texture
   resman.texhand.BindTexture(shadowmapfbo.GetTexture());
   
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
   
   // Render all of the GUI objects, they know whether they're visible or not
   resman.shaderman.UseShader("none");
   glColor4f(1, 1, 1, 1);
   mainmenu.Render();
   hud.Render();
   loadprogress.Render();
   loadoutmenu.Render();
   if (showfps)
      statsdisp.Render();
   console.Render();
   ingamestatus->Render();
   
   SDL_GL_Exit2dMode();
}


// Still need this, even though we don't mess with the shaders anymore
void SetReflection(bool on)
{
   if (!reflection) on = false;
   reflectionrender = on;
   if (on)
   {
      resman.shaderman.SetUniform1f(standardshader, "reflectval", 1.f);
      resman.shaderman.SetUniform1f(terrainshader, "reflectval", 1.f);
   }
   else
   {
      resman.shaderman.SetUniform1f(standardshader, "reflectval", 0.f);
      resman.shaderman.SetUniform1f(terrainshader, "reflectval", 0.f);
   }
}
