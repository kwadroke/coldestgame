// Rendering functions

#include "globals.h"
#include "renderdefs.h"
#include "util.h"

bool shadowrender;      // Whether we are rendering the shadowmap this pass
bool reflectionrender;  // Ditto for reflections
GraphicMatrix cameraproj, cameraview, lightproj, lightview;
set<Mesh*> implist;
set<Mesh*> visiblemeshes;

void Repaint()
{
   static Timer t, ts;
   static bool updateclouds = true;
   float fov = console.GetFloat("fov");
   if (guncam)
      fov /= console.GetFloat("zoomfactor");
   bool shadows = console.GetBool("shadows");
   PlayerData localplayer(meshes);
   t.start();
   
   // Apparently if this is turned off even glClear doesn't override it, so we end up never
   // clearing the depth buffer (because particles are rendered last without depth writes)
   glDepthMask(GL_TRUE);
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
   glShadeModel(GL_SMOOTH);
   
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   gluPerspective(fov, aspect, nearclip, console.GetFloat("viewdist"));
   
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   trislastframe = 0;
   SDL_mutexP(clientmutex);
   localplayer = player[0];
   SDL_mutexV(clientmutex);
   
   if (!gui[mainmenu]->visible && !gui[loadprogress]->visible && !gui[loadoutmenu]->visible &&
      !gui[settings]->visible && !gui[endgame]->visible)
   {
      // So a bunch of this stuff doesn't belong here (not rendering related), but it's not
      // causing problems ATM so it stays.
      gui[chat]->visible = true;
      
      // Update any animated objects
      Animate();
      
      // Update player position
      SDL_mutexP(clientmutex);
      
      Move(player[0], meshes, kdtree);
      if (console.GetBool("serversync"))
         SynchronizePosition();
      localplayer = player[0];
      
      // Update the local model so there isn't a frame of lag.
      UpdatePlayerModel(player[0], meshes);
      for (size_t i = 0; i < numbodyparts; ++i)
      {
         if (player[0].mesh[i] != meshes.end())
            player[0].mesh[i]->AdvanceAnimation();
      }
      
      SDL_mutexV(clientmutex);
      
      int weaponslot = weaponslots[localplayer.currweapon];
      Weapon& currplayerweapon = localplayer.weapons[weaponslot];
      if (localplayer.leftclick && 
          (SDL_GetTicks() - localplayer.lastfiretick[weaponslot] >= currplayerweapon.ReloadTime()) &&
          (currplayerweapon.ammo != 0) && localplayer.hp[weaponslot] > 0)
      {
         SendFire();
         SDL_mutexP(clientmutex);
         player[0].lastfiretick[weaponslot] = SDL_GetTicks();
         if (player[0].weapons[weaponslot].ammo > 0) // Negative ammo value indicated infinite ammo
            player[0].weapons[weaponslot].ammo--;
         
         Vector3 startpos = localplayer.pos;
         Vector3 rot(localplayer.pitch, localplayer.facing + localplayer.rotation, 0.f);
         Vector3 offset = units[localplayer.unit].weaponoffset[weaponslot];
         Particle part = CreateShot(currplayerweapon, rot, startpos, offset);
         // Add tracer if necessary
         if (currplayerweapon.Tracer() != "")
         {
            part.tracer = MeshPtr(new Mesh("models/" + currplayerweapon.Tracer() + "/base", resman));
            part.tracertime = currplayerweapon.TracerTime();
         }
         particles.push_back(part);
         SDL_mutexV(clientmutex);
      }
      
      if (shadows)
      {
         Vector3 rots = lights.GetRots(0);
         float detailmapsize = console.GetFloat("detailmapsize");
         float shadowres = console.GetFloat("shadowres");
         float shadowmapsizeworld = detailmapsize * 1.42;
         float worldperoneshadow = shadowmapsizeworld / shadowres;
         
         // Find out where we're looking, a little rough ATM
         GraphicMatrix rot;
         rot.rotatex(-localplayer.pitch);
         rot.rotatey(localplayer.facing + localplayer.rotation);
         //rot.rotatez(localplayer.roll);
         Vector3 look(0, 0, -detailmapsize / 2.f);
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
         
         GenShadows(look, shadowmapsizeworld / 2.f, shadowmapfbo, localplayer);
      }
      
      // Set the camera's location and orientation
      Vector3 viewoff;
      if (!guncam)
      {
         viewoff = units[localplayer.unit].viewoffset + Vector3(0, 0, console.GetFloat("viewoffset"));
         gluLookAt(viewoff.x, viewoff.y, viewoff.z + .01f, viewoff.x, viewoff.y, viewoff.z, 0, 1, 0);
      }
      else
      {
         viewoff = units[localplayer.unit].weaponoffset[weaponslots[localplayer.currweapon]];
         gluLookAt(viewoff.x, viewoff.y + 1.5f, viewoff.z + .01f, viewoff.x, viewoff.y + 1.5f, viewoff.z, 0, 1, 0);
      }
      
      Vector3 rawoffset = viewoff;
      GraphicMatrix viewm;
      viewm.rotatex(localplayer.pitch);
      viewm.rotatey(localplayer.facing + localplayer.rotation);
      viewoff.transform(viewm);
      
      Vector3 actualaim = Vector3(0, 0, -console.GetFloat("weaponfocus"));
      Vector3 difference = actualaim + rawoffset;
      Vector3 rot = RotateBetweenVectors(Vector3(0, 0, -1), difference);
         
      // For debugging third person view
      if (console.GetBool("thirdperson"))
      {
         gluLookAt(0, 0, console.GetFloat("camdist"), 0, 0, 0, 0, 1, 0);
         glPushMatrix();
      }
      
      glRotatef(localplayer.pitch - rot.x, 1, 0, 0);
      glRotatef(localplayer.facing + localplayer.rotation - rot.y, 0, 1, 0);
      glRotatef(localplayer.roll, 0, 0, 1);
   
      RenderSkybox();
      
      glTranslatef(-localplayer.pos.x, -localplayer.pos.y, -localplayer.pos.z);
      
      localplayer.pos += viewoff;
      Vector3 look(localplayer.pitch, localplayer.rotation + localplayer.facing, localplayer.roll);
      kdtree.setfrustum(localplayer.pos, look, nearclip, console.GetFloat("viewdist"), fov, aspect);
      
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
      
      lights.Place();
      
      RenderObjects(localplayer);
      
      if ((localplayer.pos - viewoff).y > 0)
      {
         UpdateNoise();
         UpdateReflection(localplayer);
         RenderWater();
      }
      
      // Must be rendered last to blend correctly
      RenderParticles();
      
      //if (shadows)
      //   glPopAttrib();
   } // if !mainmenu.visible
   else
   {
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
      resman.shaderman.UseShader("none");
      gui[chat]->visible = false;
   }
   
   RenderHud(localplayer);
   
   if (console.GetBool("showkdtree"))
      kdtree.visualize();
   
   // For debugging, third person view
   if (console.GetBool("thirdperson"))
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


bool meshptrcomp(const Mesh* l, const Mesh* r)
{
   return l->dist < r->dist;
}


void RenderObjects(const PlayerData& localplayer)
{
   float dist;
   bool debug = false; // Turns off impostoring if true
   //debug = true;
   
   list<Mesh*> m = kdtree.getmeshes();
   
   list<Mesh*>::iterator iptr;
   implist.clear();
   visiblemeshes.clear();
   for (iptr = m.begin(); iptr != m.end(); ++iptr)
   {
      Mesh* i = *iptr;
      i->dist = localplayer.pos.distance2(i->GetPosition());
      visiblemeshes.insert(i);
   }
   
   m.sort(meshptrcomp);
   
   MeshPtr impostormesh = meshcache->GetNewMesh("models/empty/base");
   Material* override = NULL;
   if (shadowrender) override = shadowmat;
   float impmod = 1000.f;//10.f;
   
   int viewdist = console.GetInt("viewdist");
   int currdrawdist = viewdist;
   int localdrawdist = 0;
   if (!staticdrawdist)
   {
      glFogf(GL_FOG_START, float(viewdist) * .5f);
      glFogf(GL_FOG_END, float(viewdist));
   }
   
   for (iptr = m.begin(); iptr != m.end(); ++iptr)
   {
      Mesh* i = *iptr;
      float adjustedimpdist = i->impdist * console.GetFloat("impdistmulti");
      adjustedimpdist *= adjustedimpdist;
      if (i->drawdistmult > 0.f)
         localdrawdist = int(viewdist * i->drawdistmult);
      else localdrawdist = viewdist;
      
      if (i->dist > (localdrawdist + i->size) * (localdrawdist + i->size)
          && !staticdrawdist && !shadowrender)
      {
         continue; // Skip it if it's too far away
      }
      
      if (localdrawdist != currdrawdist && !staticdrawdist)
      {
         currdrawdist = localdrawdist;
         glFogf(GL_FOG_START, float(localdrawdist) * .5f);
         glFogf(GL_FOG_END, float(localdrawdist));
      }
      
      if (floatzero(i->impdist) || i->dist < adjustedimpdist || shadowrender || debug)
      {
         i->Render(override);
         trislastframe += i->Size();
      }
      else
      {
         Uint32 ticks = SDL_GetTicks() - i->lastimpupdate;
         dist = i->dist;
         i->RenderImpostor(*impostormesh, impfbolist[i->impostorfbo], localplayer.pos);
         if ((ticks * ticks) > dist / (impmod * impmod / dist) && !reflectionrender)
         {
            implist.insert(i);
         }
      }
   }
   if (!staticdrawdist)
   {
      glFogf(GL_FOG_START, float(viewdist) * .5f);
      glFogf(GL_FOG_END, float(viewdist));
   }
   
   UpdateFBO(localplayer);
   
   // Render all dynamic meshes (since they won't show up in the KDTree)
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      if (i->dynamic)
      {
         i->Render(override);
         trislastframe += i->Size();
      }
   }
   
   impostormesh->GenVbo();
   impostormesh->Render(override);
   trislastframe += impostormesh->Size();
   
   glDepthMask(GL_TRUE); // Otherwise we may screw up rendering elsewhere
}

void RenderParticles()
{
   // Particles are all coalesced into a single mesh (could be a problem at some point?) so we don't
   // have to madly switch VBO's while rendering them
   if (particlemesh)
   {
      Material* override = NULL;
      if (shadowrender) override = shadowmat;
      particlemesh->GenVbo();
      particlemesh->Render(override);
      trislastframe += particlemesh->Size();
   }
}


// This needs to sort descending, hence the >
bool sortbyimpdim(const Mesh* l, const Mesh* r)
{
   return impfbolist[l->impostorfbo].GetWidth() > impfbolist[r->impostorfbo].GetWidth();
}


void UpdateFBO(const PlayerData& localplayer)
{
   if (!impfbolist.size()) return;
   vector<Mesh*>::iterator iptr;
   vector<Mesh*> sortedbyimpdim;
   vector<Mesh*> needsupdate;
   Mesh* i;
   FBO* currfbo = &(impfbolist[0]);
   int counter = 0;
   int desireddim = fbostarts[2];
   Vector3 playerpos = localplayer.pos;
   
   sortedbyimpdim = impmeshes;
   
   sort(sortedbyimpdim.begin(), sortedbyimpdim.end(), sortbyimpdim);
   sort(impmeshes.begin(), impmeshes.end(), meshptrcomp);
   
   for (iptr = impmeshes.begin(); iptr != impmeshes.end(); ++iptr)
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
         Mesh* toswap;
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
            if (visiblemeshes.find(toswap) != visiblemeshes.end())
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
      
      Vector3 currpos = i->GetPosition();
      Vector3 center = currpos;
      center.y += i->GetHeight() / 2.f;
      float dist = playerpos.distance(center);
         
      glPushAttrib(GL_VIEWPORT_BIT);
      glViewport(0, 0, currfbo->GetWidth(), currfbo->GetHeight());
      
      glPushMatrix();
      glLoadIdentity();
      gluLookAt(localplayer.pos.x, localplayer.pos.y, localplayer.pos.z, center.x, center.y, center.z, 0, 1, 0);
      
      glMatrixMode(GL_PROJECTION);
      glPushMatrix();
      glLoadIdentity();
      float tempfov = atan(i->GetHeight() / 2.f / dist) * 360. / PI;
      float tempaspect = i->GetWidth() / i->GetHeight();
      gluPerspective(tempfov, tempaspect, 10, 10000.0);
      
      glMatrixMode(GL_MODELVIEW);
      glClearColor(0, 0, 0, 0);
      glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
      lights.Place();
      
      i->Render();
      trislastframe += i->Size();
      
      glMatrixMode(GL_PROJECTION);
      glPopMatrix();
      glMatrixMode(GL_MODELVIEW);
      
      glPopMatrix();
      glPopAttrib();
      currfbo->Unbind();
      lights.Place();
      
      // Should really do this last so time to update isn't included
      i->lastimpupdate = SDL_GetTicks();
   }
}


// Generates the depth texture that will be used in shadowing
void GenShadows(Vector3 center, float size, FBO& fbo, const PlayerData& localplayer)
{
   fbo.Bind();
   
   // Adjust a few global settings
   glDisable(GL_FOG);
   glDisable(GL_LIGHTING);
   
   int shadowres = console.GetInt("shadowres");
   glViewport(0, 0, shadowres, shadowres);
   
   // Set up light matrices
   lightview = lights.GetView(0, center);
   lightproj = lights.GetProj(0, size);
   
   glMatrixMode(GL_PROJECTION);
   glPushMatrix();
   glLoadMatrixf(lightproj);
   
   glMatrixMode(GL_MODELVIEW);
   glPushMatrix();
   glLoadMatrixf(lightview);
   
   glShadeModel(GL_FLAT);
#ifndef DEBUGSMT
   glCullFace(GL_FRONT);
   glColorMask(0, 0, 0, 0);
#endif
   
   // Need to reset kdtree frustum...
   Vector3 p = lights.GetPos(0);
   Vector3 rots = lights.GetRots(0);
   
   // 1.5 is to leave some room for error since we're approximating an ortho view with
   // a perspective projection
   float lightfov = tan(size * 1.5f / Light::infinity) * 180.f / PI;
   kdtree.setfrustum(p + center, rots, Light::infinity - 5000, Light::infinity + 5000, lightfov, 1);
   
   glEnable(GL_POLYGON_OFFSET_FILL);
   glPolygonOffset(2.0f, 2.0f);
   
   // Render objects to depth map
   glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
   shadowrender = true;
   RenderObjects(localplayer);
   shadowrender = false;
   glDisable(GL_POLYGON_OFFSET_FILL);
   
   // Reset globals
   glViewport(0, 0, console.GetInt("screenwidth"), console.GetInt("screenheight"));
   glCullFace(GL_BACK);
   glShadeModel(GL_SMOOTH);
   glColorMask(1, 1, 1, 1);
   
   glEnable(GL_FOG);
   glEnable(GL_LIGHTING);
   
   glMatrixMode(GL_PROJECTION);
   glPopMatrix();
   //glLoadIdentity();
   //gluPerspective(console.GetFloat("fov"), aspect, nearclip, console.GetFloat("viewdist"));
   
   glMatrixMode(GL_MODELVIEW);
   glPopMatrix();
   //glLoadIdentity();
   fbo.Unbind();
   
   // These calls don't need to be made for generating shadows, but it makes sure that they'll be
   // set before we try to use the shadow map
   resman.shaderman.GlobalSetUniform1f("detailmapsize", console.GetFloat("detailmapsize"));
   resman.shaderman.GlobalSetUniform1f("shadowres", console.GetFloat("shadowres"));
}


void UpdateClouds()
{
   int cloudres = console.GetInt("cloudres");
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
   
   glViewport(0, 0, console.GetInt("screenwidth"), console.GetInt("screenheight"));
   resman.shaderman.UseShader("none");
   cloudfbo.Unbind();
}


void UpdateNoise()
{
   noisefbo.Bind();
   resman.shaderman.UseShader(noiseshader);
   // Don't remove this, it's not the texture we're trying to render to, it's used in the noise shader
   resman.texhand.BindTexture(noisetex);
   resman.shaderman.SetUniform1f(noiseshader, "time", float(SDL_GetTicks()));
   
   glViewport(0, 0, noiseres, noiseres);
   
   //glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
   glBlendFunc(GL_ONE, GL_ZERO);
   
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
   
   resman.shaderman.SetUniform1f(noiseshader, "speed", 3000.f);
   glBegin(GL_TRIANGLE_STRIP);
   glVertex2f(0, 0);
   glVertex2f(0, noiseres);
   glVertex2f(noiseres, 0);
   glVertex2f(noiseres, noiseres);
   glEnd();
   
   resman.shaderman.SetUniform1f(noiseshader, "speed", 700.f);
   fastnoisefbo.Bind();
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
   
   glViewport(0, 0, console.GetInt("screenwidth"), console.GetInt("screenheight"));
   resman.shaderman.UseShader("none");
   fastnoisefbo.Unbind();
}


void UpdateReflection(const PlayerData& localplayer)
{
   int reflectionres = console.GetInt("reflectionres");
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
      
      if (console.GetBool("reflection"))
      {
         // Remember, rotations not vector
         Vector3 invlook(-localplayer.pitch, localplayer.rotation + localplayer.facing, localplayer.roll);
         Vector3 invpos = localplayer.pos;
         invpos.y *= -1;
         kdtree.setfrustum(invpos, invlook, nearclip, console.GetFloat("viewdist"), console.GetFloat("fov"), aspect);
         
         lights.Place();
         SetReflection(true);
         
         glFrontFace(GL_CW);
         RenderObjects(localplayer);
         RenderParticles();
         glFrontFace(GL_CCW);
         
         SetReflection(false);
      }
      
      glMatrixMode(GL_MODELVIEW);
      glViewport(0, 0, console.GetInt("screenwidth"), console.GetInt("screenheight"));
   }
   glPopMatrix();
   reflectionfbo.Unbind();
}


void RenderClouds()
{
   resman.shaderman.UseShader(cloudshader);
   if (!staticdrawdist)
   {
      glFogf(GL_FOG_START, 5000);
      glFogf(GL_FOG_END, 10000);
   }
   glDisable(GL_DEPTH_TEST);
   
   glMatrixMode(GL_PROJECTION);
   glPushMatrix();
   glLoadIdentity();
   if (!guncam)
   {
      gluPerspective(console.GetFloat("fov"), aspect, 100, 10000);
   }
   else
   {
      gluPerspective(console.GetFloat("fov") / console.GetFloat("zoomfactor"), aspect, 100, 10000);
   }
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
   
   float viewdist = console.GetFloat("viewdist");
   if (!staticdrawdist)
   {
      glFogf(GL_FOG_START, viewdist * .5);
      glFogf(GL_FOG_END, viewdist);
   }
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
   gluSphere(s, console.GetFloat("viewdist"), 10, 10);
   glPopMatrix();
   
   gluDeleteQuadric(s);
   
   glEnable(GL_FOG);
   glEnable(GL_LIGHTING);
   glEnable(GL_DEPTH_TEST);
}


void RenderWater()
{
   lights.Place();
   
   glEnable(GL_BLEND);
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   
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
   
   resman.texhand.ActiveTexture(1);
   resman.texhand.BindTexture(noisefbo.GetTexture());
   resman.texhand.ActiveTexture(2);
   resman.texhand.BindTexture(fastnoisefbo.GetTexture());
   resman.texhand.ActiveTexture(0);
   resman.texhand.BindTexture(reflectionfbo.GetTexture());
   resman.shaderman.SetUniform1f("shaders/water", "time", float(SDL_GetTicks()));
   
   watermesh->Render();
   
   glMatrixMode(GL_TEXTURE);
   glPopMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   resman.shaderman.UseShader("none");
}


void RenderHud(const PlayerData& localplayer)
{
   // These don't have to be static, but since we only ever create the GUI once
   // and GetWidget could be a bit time-consuming, it's not a bad idea
   static GUI* fpslabel = gui[statsdisp]->GetWidget("fps");
   static GUI* tpslabel = gui[statsdisp]->GetWidget("trispersec");
   static GUI* tpflabel = gui[statsdisp]->GetWidget("trisperframe");
   static GUI* pinglabel = gui[statsdisp]->GetWidget("ping");
   static GUI* mpflabel = gui[statsdisp]->GetWidget("msperframe");
   static GUI* poslabel = gui[statsdisp]->GetWidget("position");
   static GUI* partlabel = gui[statsdisp]->GetWidget("particles");
   static GUI* torsohplabel = gui[hud]->GetWidget("torsohp");
   static GUI* legshplabel = gui[hud]->GetWidget("legshp");
   static GUI* leftarmhplabel = gui[hud]->GetWidget("leftarmhp");
   static GUI* rightarmhplabel = gui[hud]->GetWidget("rightarmhp");
   static GUI* torsoweaponlabel = gui[hud]->GetWidget("torsoweapon");
   static GUI* larmweaponlabel = gui[hud]->GetWidget("larmweapon");
   static GUI* rarmweaponlabel = gui[hud]->GetWidget("rarmweapon");
   static GUI* torsoselectedlabel = gui[hud]->GetWidget("torsoselected");
   static GUI* larmselectedlabel = gui[hud]->GetWidget("larmselected");
   static GUI* rarmselectedlabel = gui[hud]->GetWidget("rarmselected");
   static ProgressBar* tempbar = (ProgressBar*)gui[hud]->GetWidget("temperature");
   static ProgressBar* rotbar = (ProgressBar*)gui[hud]->GetWidget("facing");
   static GUI* minimaplabel = gui[hud]->GetWidget("minimap");
   static GUI* loadoutmaplabel = gui[loadoutmenu]->GetWidget("Map");
   
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
   if (particlemesh)
      partlabel->text = "Particles: " + ToString(particlemesh->Size());
   torsohplabel->text = "Torso: " + ToString(localplayer.hp[Torso]);
   legshplabel->text = "Legs: " + ToString(localplayer.hp[Legs]);
   leftarmhplabel->text = "Left Arm: " + ToString(localplayer.hp[LArm]);
   rightarmhplabel->text = "Right Arm: " + ToString(localplayer.hp[RArm]);
   
   torsoweaponlabel->text = localplayer.weapons[Torso].Name();
   larmweaponlabel->text = localplayer.weapons[LArm].Name();
   rarmweaponlabel->text = localplayer.weapons[RArm].Name();
   if (weaponslots[localplayer.currweapon] == Torso)
      torsoselectedlabel->visible = true;
   else torsoselectedlabel->visible = false;
   if (weaponslots[localplayer.currweapon] == LArm)
      larmselectedlabel->visible = true;
   else larmselectedlabel->visible = false;
   if (weaponslots[localplayer.currweapon] == RArm)
      rarmselectedlabel->visible = true;
   else rarmselectedlabel->visible = false;
   
   tempbar->SetRange(0, 100);
   tempbar->value = (int)localplayer.temperature;
   rotbar->SetRange(-90, 90);
   rotbar->value = (int)localplayer.rotation;
   
   minimaplabel->SetTextureID(Normal, minimapfbo.GetTexture());
   minimaplabel->ClearChildren();
   
   SDL_mutexP(clientmutex);
   for (size_t i = 1; i < player.size(); ++i)
   {
      GUIPtr playerposlabel(new Button(minimaplabel, &resman.texman));
      if (i == servplayernum)
         playerposlabel->SetTexture(Normal, "textures/miniplayer.png");
      else if (player[i].team == player[servplayernum].team)
         playerposlabel->SetTexture(Normal, "textures/minifriend.png");
      else
         playerposlabel->SetTexture(Normal, "textures/minienemy.png");
      playerposlabel->width = 10;
      playerposlabel->height = 16;
      playerposlabel->x = player[i].pos.x / mapwidth;
      playerposlabel->x *= minimaplabel->width;
      playerposlabel->x -= playerposlabel->width / 2.f;
      playerposlabel->y = player[i].pos.z / mapheight;
      playerposlabel->y *= minimaplabel->height;
      playerposlabel->y -= playerposlabel->height / 2.f;
      if (player[i].spawned)
         minimaplabel->Add(playerposlabel);
   }
   SDL_mutexV(clientmutex);
   
   loadoutmaplabel->SetTextureID(Normal, minimapfbo.GetTexture());
   
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
   for (size_t i = 0; i < gui.size(); ++i)
   {
      gui[i]->Render();
   }
   
   SDL_GL_Exit2dMode();
}


void SetReflection(bool on)
{
   if (!console.GetBool("reflection")) on = false;
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
