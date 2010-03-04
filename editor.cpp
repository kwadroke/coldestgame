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


#include "editor.h"
#include "globals.h"
#include "renderdefs.h"

using std::vector;

map<Mesh*, ProceduralTree> treemap;
vector<Mesh*> spawnmeshes;
MeshPtr copymesh;
ProceduralTree copytree;
bool copyistree;
GUIPointers guip;

Mesh* selected;
bool clicked = false;
bool rotating = false;
bool lockx = false;
bool locky = false;

void EditorLoop(const string editmap)
{
   SDL_Event event;
   
   editor = true;
   SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);
   SDL_ShowCursor(SDL_DISABLE);
   gui[mainmenu]->visible = false;
   gui[updateprogress]->visible = false;
   gui[loadprogress]->visible = true;
   GetMap("maps/" + editmap);
   for (list<Mesh>::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      if (!i->terrain)
      {
         i->dynamic = true; // Because we could be moving anything else around
      }
   }
   gui[loadprogress]->visible = false;
   gui[editormain]->visible = false;
   
   player[0].pos = Vector3(500, 500, 500);
   
   PopulateGUIPointers();
   
   while (1)
   {
      if (!running)
         Quit();
      
      while(SDL_PollEvent(&event)) 
      {
         if (!EditorGUIEventHandler(event))
         {
            EditorEventHandler(event);
         }
      }
      
      EditorMove();
      
      gui[editormain]->visible = true;
      
      Repaint();
   }
}


void EditorEventHandler(SDL_Event event)
{
   switch(event.type)
   {
      case SDL_KEYDOWN:
         if (event.key.keysym.sym == SDLK_SPACE)
         {
            if (SDL_ShowCursor(SDL_QUERY) == SDL_ENABLE)
               SDL_ShowCursor(SDL_DISABLE);
            else
               SDL_ShowCursor(SDL_ENABLE);
         }
         else if (event.key.keysym.sym == SDLK_a)
         {
            player[0].moveleft = true;
         }
         else if (event.key.keysym.sym == SDLK_d)
         {
            player[0].moveright = true;
         }
         else if (event.key.keysym.sym == SDLK_w)
         {
            player[0].moveforward = true;
         }
         else if (event.key.keysym.sym == SDLK_s)
         {
            if (SDL_GetModState() & KMOD_LCTRL)
            {
               SaveMap();
            }
            else
               player[0].moveback = true;
         }
         else if (event.key.keysym.sym == SDLK_r)
         {
            rotating = true;
         }
         else if (event.key.keysym.sym == SDLK_x)
         {
            if (rotating)
               lockx = !lockx;
         }
         else if (event.key.keysym.sym == SDLK_y)
         {
            if (rotating)
               locky = !locky;
         }
         else if (event.key.keysym.sym == SDLK_c)
         {
            if (SDL_GetModState() & KMOD_CTRL)
            {
               Copy();
            }
         }
         else if (event.key.keysym.sym == SDLK_v)
         {
            if (SDL_GetModState() & KMOD_CTRL)
            {
               Paste();
            }
         }
         else if (event.key.keysym.sym == SDLK_LSHIFT)
         {
            player[0].run = true;
         }
         else if (event.key.keysym.sym == SDLK_TAB)
         {
            if (!gui[editobject]->visible)
               ShowGUI(editobject);
            else
            {
               gui[editobject]->visible = false;
               SDL_ShowCursor(SDL_DISABLE);
            }
         }
         else if (event.key.keysym.sym == SDLK_DELETE)
         {
            DeleteObject();
         }
         else if (event.key.keysym.sym == SDLK_ESCAPE)
         {
            Quit();
         }
            
         break;
      case SDL_KEYUP:
         if (event.key.keysym.sym == SDLK_a)
         {
            player[0].moveleft = false;
         }
         else if (event.key.keysym.sym == SDLK_d)
         {
            player[0].moveright = false;
         }
         else if (event.key.keysym.sym == SDLK_w)
         {
            player[0].moveforward = false;
         }
         else if (event.key.keysym.sym == SDLK_s)
         {
            player[0].moveback = false;
         }
         else if (event.key.keysym.sym == SDLK_r)
         {
            rotating = false;
            lockx = locky = false;
         }
         else if (event.key.keysym.sym == SDLK_LSHIFT)
         {
            player[0].run = false;
         }
         break;
      case SDL_MOUSEMOTION:
         if (SDL_ShowCursor(SDL_QUERY) == SDL_DISABLE)
         {
            int screenwidth = console.GetInt("screenwidth");
            int screenheight = console.GetInt("screenheight");
            if ((event.motion.x != screenwidth / 2 || 
                 event.motion.y != screenheight / 2) && !gui[consolegui]->visible)
            {
               float zoomfactor = 1.f;
               float mousespeed = console.GetFloat("mousespeed") / 100.f;
               
               player[0].pitch += event.motion.yrel / mousespeed / zoomfactor;
               if (player[0].pitch < -90) player[0].pitch = -90;
               if (player[0].pitch > 90) player[0].pitch = 90;
               
               player[0].rotation += event.motion.xrel / mousespeed / zoomfactor;
               if (player[0].rotation < 0) player[0].rotation += 360;
               if (player[0].rotation > 360) player[0].rotation -= 360;
               SDL_WarpMouse(screenwidth / 2, screenheight / 2);
            }
         }
         else
         {
            MoveObject(event);
         }
         break;
      case SDL_MOUSEBUTTONDOWN:
         if (event.button.button == SDL_BUTTON_LEFT)
         {
            GetSelectedMesh(event);
            clicked = true;
         }
         break;
      case SDL_MOUSEBUTTONUP:
         if (event.button.button == SDL_BUTTON_LEFT)
         {
            // Trees have a tendency to slide around while being rotated, this resets them
            if (treemap.find(selected) != treemap.end())
            {
               selected->Move(selected->GetPosition() - Vector3(0.f, selected->GetHeight() / 2.f, 0.f));
               selected->Clear();
               treemap[selected].GenTree(selected, &resman.LoadMaterial(treemap[selected].barkfile), &resman.LoadMaterial(treemap[selected].leavesfile));
            }
            clicked = false;
         }
         break;
      case SDL_QUIT:
         Quit();
      default:
         break;
   }
}


// Returns whether the GUI ate the event (IOW should the event not be passed to the engine)
bool EditorGUIEventHandler(SDL_Event event)
{
   if (gui[editobject]->visible)
   {
      switch(event.type)
      {
         case SDL_KEYDOWN:
            if (event.key.keysym.sym == SDLK_r)
            {
               rotating = true;
               lockx = locky = false;
            }
            else if (event.key.keysym.sym == SDLK_x)
            {
               if (rotating)
                  lockx = !lockx;
            }
            else if (event.key.keysym.sym == SDLK_y)
            {
               if (rotating)
                  locky = !locky;
            }
            else if (event.key.keysym.sym == SDLK_o && (SDL_GetModState() & KMOD_LCTRL))
            {
               SaveObject();
               return true;
            }
            else if (event.key.keysym.sym == SDLK_LSHIFT)
            {
               player[0].run = true;
            }
            if (event.key.keysym.sym == SDLK_TAB)
            {
               if (!gui[editobject]->visible)
                  ShowGUI(editobject);
               else
               {
                  gui[editobject]->visible = false;
                  SDL_ShowCursor(SDL_DISABLE);
               }
               return true;
            }
            else if (event.key.keysym.sym == SDLK_ESCAPE)
            {
               Quit();
            }
            break;
         case SDL_KEYUP:
            if (event.key.keysym.sym == SDLK_r)
            {
               rotating = false;
            }
            else if (event.key.keysym.sym == SDLK_LSHIFT)
            {
               player[0].run = false;
            }
            break;
         case SDL_MOUSEMOTION:
            if (MoveObject(event))
               return true;
            break;
         case SDL_MOUSEBUTTONDOWN:
            {
               GUI* eobase = gui[editobject]->GetWidget("Base");
               GUI* mainsv = gui[editormain]->GetWidget("EditorMain");
               if (event.button.button == SDL_BUTTON_LEFT &&  
                  !eobase->InWidget(&event) && !mainsv->InWidget(&event))
               {
                  GetSelectedMesh(event);
                  clicked = true;
                  return true;
               }
            }
            break;
         case SDL_MOUSEBUTTONUP:
            {
               GUI* eobase = gui[editobject]->GetWidget("Base");
               GUI* mainsv = gui[editormain]->GetWidget("EditorMain");
               if (event.button.button == SDL_BUTTON_LEFT && 
                  !eobase->InWidget(&event) && !mainsv->InWidget(&event))
               {
                  // Trees have a tendency to slide around while being rotated, this resets them
                  if (treemap.find(selected) != treemap.end())
                  {
                     selected->Move(selected->GetPosition() - Vector3(0.f, selected->GetHeight() / 2.f, 0.f));
                     selected->Clear();
                     treemap[selected].GenTree(selected, &resman.LoadMaterial(treemap[selected].barkfile), &resman.LoadMaterial(treemap[selected].leavesfile));
                  }
                  clicked = false;
                  return true;
               }
            }
            break;
      };
   
      SDL_ShowCursor(SDL_ENABLE);
      gui[editobject]->ProcessEvent(&event);
      return true;
   }
   
   if (SDL_ShowCursor(SDL_QUERY) == SDL_ENABLE)
   {
      gui[editormain]->ProcessEvent(&event);
      GUI* mainsv = gui[editormain]->GetWidget("EditorMain");
      if (mainsv->InWidget(&event))
      {
         return true;
      }
   }
   return false;
}


bool MoveObject(SDL_Event& event)
{
   if (clicked && selected)
   {
      if (!rotating)
      {
         float modifier = 1.f;
         if (player[0].run)
            modifier = 5.f;
         
         // Move relative to view, or it gets really confusing
         Vector3 d = Vector3(0, 0, 1);
         GraphicMatrix rot;
         if (player[0].pitch > 89.99)
            rot.rotatex(89.99);
         else if (player[0].pitch < -89.99)
            rot.rotatex(-89.99);
         else rot.rotatex(-player[0].pitch);
         rot.rotatey(player[0].rotation);
         d.transform(rot);
         d.y = 0.f;
         d.normalize();
   
         Vector3 sideways = d.cross(Vector3(0, -1, 0));
         sideways.normalize();
         
         Vector3 oldpos = selected->GetPosition();
         if (SDL_GetModState() & KMOD_CTRL)
            selected->Move(oldpos + Vector3(0.f, -event.motion.yrel * modifier, 0.f), true);
         else
            selected->Move(oldpos + 
                  d * event.motion.yrel * modifier +
                  sideways * event.motion.xrel * modifier, true);
         UpdateEditorGUI();
      }
      else
      {
         float modifier = 1.f;
         float ax = event.motion.xrel * modifier;
         float ay = event.motion.yrel * modifier;
         if (lockx)
            ax = 0.f;
         if (locky)
            ay = 0.f;
         selected->Rotate(selected->GetRotation() + Vector3(ay, ax, 0.f), true);
         UpdateEditorGUI();
      }
      return true;
   }
   return false;
}


void EditorMove()
{
   static Uint32 lasttick = SDL_GetTicks();
   
   Vector3 d = Vector3(0, 0, 1);
   GraphicMatrix rot;
   if (player[0].pitch > 89.99)
      rot.rotatex(89.99);
   else if (player[0].pitch < -89.99)
      rot.rotatex(-89.99);
   else rot.rotatex(-player[0].pitch);
   rot.rotatey(player[0].rotation);
   d.transform(rot);
   d.normalize();
   
   Vector3 sideways = d.cross(Vector3(0, 1, 0));
   sideways.normalize();
   
   Uint32 currtick = SDL_GetTicks();
   if (currtick != lasttick)
   {
      d *= float(currtick - lasttick) * .1f;
      sideways *= float(currtick - lasttick) * .1f;
   }
   lasttick = currtick;
   
   float movespeed = 5.f;
   if (player[0].run)
      movespeed *= 3.f;
   
   if (player[0].moveforward)
   {
      player[0].pos -= d * movespeed;
   }
   if (player[0].moveback)
   {
      player[0].pos += d * movespeed;
   }
   if (player[0].moveleft)
   {
      player[0].pos += sideways * movespeed;
   }
   if (player[0].moveright)
   {
      player[0].pos -= sideways * movespeed;
   }
}


void GetSelectedMesh(SDL_Event event)
{
   GLdouble x, y, z;
   GLdouble modelview[16];
   GLdouble projection[16];
   GLint view[4];
   Vector3 start, end;
   
   // Get world coordinates from screen coordinates
   glGetDoublev(GL_MODELVIEW_MATRIX, modelview);
   glGetDoublev(GL_PROJECTION_MATRIX, projection);
   glGetIntegerv(GL_VIEWPORT, view);
   
   gluUnProject(event.button.x, console.GetInt("screenheight") - event.button.y, 0.f,
                modelview, projection, view,
                &x, &y, &z);
   
   start.x = x, start.y = y, start.z = z;
   
   gluUnProject(event.button.x, console.GetInt("screenheight") - event.button.y, .99f,
                modelview, projection, view,
                &x, &y, &z);
   end.x = x, end.y = y, end.z = z;
   
   Vector3 v = end - start;
   v.normalize();
   v *= 10000.f; // Check 10000 units into the screen, should be enough
   end = start + v;
   
   // Get nearest mesh touched by click
   vector<Mesh*> check;// = GetMeshesWithoutPlayer(&player[0], meshes, kdtree, start, end, 1.f);
   AppendDynamicMeshes(check, meshes);
   
   Vector3 dummy;
   selected = NULL;
   coldet.CheckSphereHit(start, end, 1.f, check, dummy, selected, NULL);
   
   UpdateEditorGUI();
}


void UpdateEditorGUI()
{
   if (selected)
   {
      guip.objectname->text = selected->name;
      guip.objectx->text = ToString(selected->GetPosition().x);
      guip.objecty->text = ToString(selected->GetPosition().y);
      guip.objectz->text = ToString(selected->GetPosition().z);
      guip.rotx->text = ToString(selected->GetRotation().x);
      guip.roty->text = ToString(selected->GetRotation().y);
      guip.rotz->text = ToString(selected->GetRotation().z);
      guip.scale->text = ToString(selected->GetScale());
      guip.file->text = selected->GetFile();
      guip.objecttris->text = ToString(selected->NumTris());
      
      if (treemap.find(selected) != treemap.end())
      {
         ProceduralTree& tree = treemap[selected];
         guip.seed->text = ToString(tree.seed);
         guip.impdist->text = ToString(selected->impdist);
         guip.trunkradius->text = ToString(tree.trunkrad);
         guip.trunksegments->text = ToString(tree.trunknumsegs);
         guip.trunkslices->text = ToString(tree.trunknumslices);
         guip.trunktaper->text = ToString(tree.trunktaper);
         guip.maxtrunkangle->text = ToString(tree.maxtrunkangle);
         
         guip.maxbranchangle->text = ToString(tree.maxbranchangle);
         guip.initialheight->text = ToString(tree.initheight);
         guip.heightreduction->text = ToString(tree.heightreductionperc);
         guip.initialradius->text = ToString(tree.initrad);
         guip.radiustaper->text = ToString(tree.radreductionperc);
         guip.numlevels->text = ToString(tree.numlevels);
         guip.numslices->text = ToString(tree.numslices);
         guip.numsegments->text = ToString(tree.numsegs);
         guip.numbranches0->text = ToString(tree.numbranches[0]);
         guip.numbranches1->text = ToString(tree.numbranches[1]);
         guip.numbranches2->text = ToString(tree.numbranches[2]);
         guip.curvecoeff->text = ToString(tree.curvecoeff);
         guip.maxangle->text = ToString(tree.maxangle);
         guip.minangle->text = ToString(tree.minangle);
         
         guip.sidebranches->text = ToString(tree.sidebranches);
         guip.minsidebranchangle->text = ToString(tree.minsidebranchangle);
         guip.maxsidebranchangle->text = ToString(tree.maxsidebranchangle);
         guip.branchafter->text = ToString(tree.branchafter);
         guip.sidetaper->text = ToString(tree.sidetaper);
         guip.sidesizeperc->text = ToString(tree.sidesizeperc);
         
         guip.numleaves->text = ToString(tree.numleaves);
         guip.leafsize->text = ToString(tree.leafsize);
         guip.leafsegs->text = ToString(tree.leafsegs);
         guip.leafcurve->text = ToString(tree.leafcurve);
         guip.firstleaflevel->text = ToString(tree.firstleaflevel);
         
         guip.barkmat->text = ToString(tree.barkfile);
         guip.leavesmat->text = ToString(tree.leavesfile);
      }
   }
   else
      guip.objectname->text = "No Selection";
}


void SaveMap()
{
   string saveto = mapname + ".map";
   logout << "Saving to " << saveto << endl;
   string olddata;
   string getdata;
   ifstream oldmap(saveto.c_str());
   while(getline(oldmap, getdata))
   {
      olddata += getdata + '\n';
      if (getdata.find("SpawnPoints") != string::npos)
         break;
   }
   oldmap.close();
   
   // Make a backup of the previous version
   ofstream bakmap((saveto + ".old").c_str());
   oldmap.open(saveto.c_str());
   while (getline(oldmap, getdata))
   {
      bakmap << getdata << endl;
   }
   oldmap.close();
   bakmap.close();
   
   // Output new map
   ofstream newmap(saveto.c_str(), ios::trunc);
   newmap << olddata;
   
   // Write spawn points
   for (size_t i = 0; i < spawnmeshes.size(); ++i)
   {
      Vector3 pos = spawnmeshes[i]->GetPosition();
      newmap << "   Node\n";
      newmap << "      Team " << spawnpoints[i].team << endl;
      newmap << "      Location " << pos.x << " " << pos.y << " " << pos.z << endl;
      newmap << "      Name " << spawnpoints[i].name << endl;
   }
   
   // Write objects
   newmap << "\nNode\n";
   newmap << "   Objects\n";
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      if (!i->terrain && 
           find(spawnmeshes.begin(), spawnmeshes.end(), &(*i)) == spawnmeshes.end())
      {
         newmap << "   Node\n";
         if (treemap.find(&(*i)) == treemap.end()) // Not a proctree
         {
            newmap << "      Type External\n";
            newmap << "      Name " << i->name << endl;
            newmap << "      BaseFile " << i->GetFile() << endl;
            Vector3 temp = i->GetPosition();
            newmap << "      Position " << temp.x << " " << temp.y << " " << temp.z << endl;
            temp = i->GetRotation();
            newmap << "      Rotations " << temp.x << " " << temp.y << " " << temp.z << endl;
            newmap << "      AnimSpeed " << i->GetAnimSpeed() << endl;
            newmap << "      Scale " << i->GetScale() << endl;
         }
         else
         {
            ProceduralTree t = treemap[&(*i)];
            Vector3 currpos = i->GetPosition();
            currpos -= Vector3(0, i->GetHeight() / 2.f, 0);
            Vector3 currrot = i->GetRotation();
            newmap << "      Type proctree\n";
            newmap << "      Position " << currpos.x << " " << currpos.y << " " << currpos.z << endl;
            newmap << "      Rotations " << currrot.x << " " << currrot.y << " " << currrot.z << endl;
            newmap << "      Name " << i->name << endl;
            newmap << "      Materials " << t.barkfile << " " << t.leavesfile << endl;
            newmap << "      seed " << t.seed << endl;
            newmap << "      ImpostorDistance " << i->impdist << endl;
            newmap << "      trunkrad " << t.trunkrad << endl;
            newmap << "      trunknumsegs " << t.trunknumsegs << endl;
            newmap << "      trunknumslices " << t.trunknumslices << endl;
            newmap << "      trunktaper " << t.trunktaper << endl;
            newmap << "      maxtrunkangle " << t.maxtrunkangle << endl;
            
            newmap << "      maxbranchangle " << t.maxbranchangle << endl;
            newmap << "      initheight " << t.initheight << endl;
            newmap << "      heightreductionperc " << t.heightreductionperc << endl;
            newmap << "      initrad " << t.initrad << endl;
            newmap << "      radreductionperc " << t.radreductionperc << endl;
            newmap << "      numlevels " << t.numlevels << endl;
            newmap << "      numslices " << t.numslices << endl;
            newmap << "      numsegs " << t.numsegs << endl;
            newmap << "      numbranches0 " << t.numbranches[0] << endl;
            newmap << "      numbranches1 " << t.numbranches[1] << endl;
            newmap << "      numbranches2 " << t.numbranches[2] << endl;
            newmap << "      curvecoeff " << t.curvecoeff << endl;
            newmap << "      maxangle " << t.maxangle << endl;
            newmap << "      minangle " << t.minangle << endl;
            
            newmap << "      sidebranches " << t.sidebranches << endl;
            newmap << "      minsidebranchangle " << t.minsidebranchangle << endl;
            newmap << "      maxsidebranchangle " << t.maxsidebranchangle << endl;
            newmap << "      branchafter " << t.branchafter << endl;
            newmap << "      sidetaper " << t.sidetaper << endl;
            newmap << "      sidesizeperc " << t.sidesizeperc << endl;
            
            newmap << "      numleaves " << t.numleaves << endl;
            newmap << "      leafsize " << t.leafsize << endl;
            newmap << "      leafsegs " << t.leafsegs << endl;
            newmap << "      leafcurve " << t.leafcurve << endl;
            newmap << "      firstleaflevel " << t.firstleaflevel << endl;
         }
      }
   }
   newmap.close();
}


void SaveObject()
{
   if (selected && !selected->terrain)
   {
      Vector3 pos(atof(guip.objectx->text.c_str()), atof(guip.objecty->text.c_str()), atof(guip.objectz->text.c_str()));
      Vector3 rot(atof(guip.rotx->text.c_str()), atof(guip.roty->text.c_str()), atof(guip.rotz->text.c_str()));
      if (treemap.find(selected) != treemap.end())
      {
         MeshPtr newmesh = meshcache->GetNewMesh("models/empty");
         
         newmesh->Move(pos - Vector3(0.f, selected->GetHeight() / 2.f, 0.f));
         newmesh->Rotate(rot);
         newmesh->name = guip.objectname->text;
         newmesh->dynamic = true;
         
         ProceduralTree t;
         t.seed = atoi(guip.seed->text.c_str());
         t.barkfile = treemap[selected].barkfile;
         t.leavesfile = treemap[selected].leavesfile;
         newmesh->impdist = atoi(guip.impdist->text.c_str());
         t.trunkrad = atof(guip.trunkradius->text.c_str());
         t.trunknumsegs = atoi(guip.trunksegments->text.c_str());
         t.trunknumslices = atoi(guip.trunkslices->text.c_str());
         t.trunktaper = atof(guip.trunktaper->text.c_str());
         t.maxtrunkangle = atof(guip.maxtrunkangle->text.c_str());
         
         t.maxbranchangle = atoi(guip.maxbranchangle->text.c_str());
         t.initheight = atof(guip.initialheight->text.c_str());
         t.heightreductionperc = atof(guip.heightreduction->text.c_str());
         t.initrad = atof(guip.initialradius->text.c_str());
         t.radreductionperc = atof(guip.radiustaper->text.c_str());
         t.numlevels = atoi(guip.numlevels->text.c_str());
         t.numslices = atoi(guip.numslices->text.c_str());
         t.numsegs = atoi(guip.numsegments->text.c_str());
         t.numbranches[0] = atoi(guip.numbranches0->text.c_str());
         t.numbranches[1] = atoi(guip.numbranches1->text.c_str());
         t.numbranches[2] = atoi(guip.numbranches2->text.c_str());
         t.curvecoeff = atof(guip.curvecoeff->text.c_str());
         t.maxangle = atof(guip.maxangle->text.c_str());
         t.minangle = atof(guip.minangle->text.c_str());
         
         t.sidebranches = atoi(guip.sidebranches->text.c_str());
         t.minsidebranchangle = atof(guip.minsidebranchangle->text.c_str());
         t.maxsidebranchangle = atof(guip.maxsidebranchangle->text.c_str());
         t.branchafter = atoi(guip.branchafter->text.c_str());
         t.sidetaper = atof(guip.sidetaper->text.c_str());
         t.sidesizeperc = atof(guip.sidesizeperc->text.c_str());
         
         t.numleaves = atoi(guip.numleaves->text.c_str());
         t.leafsize = atof(guip.leafsize->text.c_str());
         t.leafsegs = atoi(guip.leafsegs->text.c_str());
         t.leafcurve = atof(guip.leafcurve->text.c_str());
         t.firstleaflevel = atoi(guip.firstleaflevel->text.c_str());
         
         t.barkfile = guip.barkmat->text;
         t.leavesfile = guip.leavesmat->text;
         
         t.GenTree(newmesh.get(), &resman.LoadMaterial(t.barkfile), &resman.LoadMaterial(t.leavesfile));
         
         meshes.push_back(*newmesh);
         meshes.back().GenVbo();
         treemap[&meshes.back()] = t;
      }
      else
      {
         MeshPtr newmesh = meshcache->GetNewMesh(guip.file->text);
         
         newmesh->Move(pos);
         newmesh->Rotate(rot);
         if (newmesh->GetFile() == selected->GetFile()) // If we changed models then just use the new model's scale
            newmesh->Scale(atof(guip.scale->text.c_str()) / newmesh->GetScale());
         newmesh->name = guip.objectname->text;
         newmesh->dynamic = true;
         newmesh->GenVbo();
         
         meshes.push_back(*newmesh);
      }
      kdtree.erase(selected);
      for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
      {
         if (&(*i) == selected)
         {
            meshes.erase(i);
            break;
         }
      }
      selected = &meshes.back();
   }
   UpdateEditorGUI();
   RegenFBOList(); // Might be too slow to always do...
}


void AddObject()
{
   GLdouble x, y, z;
   GLdouble modelview[16];
   GLdouble projection[16];
   GLint view[4];
   Vector3 start, end;
   
   // Get world coordinates from screen coordinates
   glGetDoublev(GL_MODELVIEW_MATRIX, modelview);
   glGetDoublev(GL_PROJECTION_MATRIX, projection);
   glGetIntegerv(GL_VIEWPORT, view);
   
   gluUnProject(console.GetInt("screenwidth") / 2, 
                console.GetInt("screenheight") / 2, 0.f,
                modelview, projection, view,
                &x, &y, &z);
   
   start.x = x, start.y = y, start.z = z;
   
   gluUnProject(console.GetInt("screenwidth") / 2,
                console.GetInt("screenheight") / 2, .99f,
                modelview, projection, view,
                &x, &y, &z);
   end.x = x, end.y = y, end.z = z;
   
   Vector3 v = end - start;
   v.normalize();
   v *= 300.f;
   end = start + v;
   
   MeshPtr newmesh = meshcache->GetNewMesh("models/teapot");
   newmesh->name = "Unnamed";
   newmesh->dynamic = true;
   newmesh->GenVbo();
   newmesh->Move(end);
   meshes.push_back(*newmesh);
}


void AddTree()
{
   GLdouble x, y, z;
   GLdouble modelview[16];
   GLdouble projection[16];
   GLint view[4];
   Vector3 start, end;
   
   // Get world coordinates from screen coordinates
   glGetDoublev(GL_MODELVIEW_MATRIX, modelview);
   glGetDoublev(GL_PROJECTION_MATRIX, projection);
   glGetIntegerv(GL_VIEWPORT, view);
   
   gluUnProject(console.GetInt("screenwidth") / 2, 
                console.GetInt("screenheight") / 2, 0.f,
                               modelview, projection, view,
                               &x, &y, &z);
   
   start.x = x, start.y = y, start.z = z;
   
   gluUnProject(console.GetInt("screenwidth") / 2,
                console.GetInt("screenheight") / 2, .99f,
                               modelview, projection, view,
                               &x, &y, &z);
   end.x = x, end.y = y, end.z = z;
   
   Vector3 v = end - start;
   v.normalize();
   v *= 300.f;
   end = start + v;
   
   MeshPtr newmesh = meshcache->GetNewMesh("models/empty");
   newmesh->name = "Unnamed";
   newmesh->dynamic = true;
   newmesh->Move(end);
   ProceduralTree t;
   t.barkfile = "materials/bark";
   t.leavesfile = "materials/leaves";
   
   t.GenTree(newmesh.get(), &resman.LoadMaterial("materials/bark"), &resman.LoadMaterial("materials/leaves"));
   newmesh->CalcBounds();
   
   meshes.push_back(*newmesh);
   meshes.back().GenVbo();
   treemap[&meshes.back()] = t;
}


void DeleteObject()
{
   if (selected)
   {
      for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
      {
         if (&(*i) == selected)
         {
            if (treemap.find(selected) != treemap.end())
               treemap.erase(selected);
            meshes.erase(i);
            kdtree.erase(selected);
            selected = NULL;
            break;
         }
      }
   }
   else logout << "No object selected" << endl;
}


void Copy()
{
   if (selected)
   {
      copymesh = MeshPtr(new Mesh(*selected));
      if (treemap.find(selected) != treemap.end())
      {
         copytree = treemap[selected];
         copyistree = true;
      }
      else copyistree = false;
   }
}

void Paste()
{
   if (copymesh)
   {
      // Okay, this is the third copy of this code, it should probably be a function...
      GLdouble x, y, z;
      GLdouble modelview[16];
      GLdouble projection[16];
      GLint view[4];
      Vector3 start, end;
   
      // Get world coordinates from screen coordinates
      glGetDoublev(GL_MODELVIEW_MATRIX, modelview);
      glGetDoublev(GL_PROJECTION_MATRIX, projection);
      glGetIntegerv(GL_VIEWPORT, view);
   
      gluUnProject(console.GetInt("screenwidth") / 2, 
                   console.GetInt("screenheight") / 2, 0.f,
                                  modelview, projection, view,
                                  &x, &y, &z);
   
      start.x = x, start.y = y, start.z = z;
   
      gluUnProject(console.GetInt("screenwidth") / 2,
                   console.GetInt("screenheight") / 2, .99f,
                                  modelview, projection, view,
                                  &x, &y, &z);
      end.x = x, end.y = y, end.z = z;
   
      Vector3 v = end - start;
      v.normalize();
      v *= 300.f;
      end = start + v;
   
      MeshPtr newmesh(new Mesh(*copymesh));
      newmesh->Move(end, true);
      meshes.push_back(*newmesh);
      meshes.back().GenVbo();
      selected = &meshes.back();
      
      if (copyistree)
      {
         treemap[&meshes.back()] = copytree;
      }
   }
}


void PopulateGUIPointers()
{
   guip.objectname = gui[editobject]->GetWidget("ObjectName");
   guip.objectx = gui[editobject]->GetWidget("ObjectX");
   guip.objecty = gui[editobject]->GetWidget("ObjectY");
   guip.objectz = gui[editobject]->GetWidget("ObjectZ");
   guip.rotx = gui[editobject]->GetWidget("ObjectRotX");
   guip.roty = gui[editobject]->GetWidget("ObjectRotY");
   guip.rotz = gui[editobject]->GetWidget("ObjectRotZ");
   guip.scale = gui[editobject]->GetWidget("ObjectScale");
   guip.file = gui[editobject]->GetWidget("ObjectFile");
   guip.objecttris = gui[editobject]->GetWidget("ObjectTris");
   
   // Tree GUI elements
   guip.seed = gui[editobject]->GetWidget("Seed");
   guip.impdist = gui[editobject]->GetWidget("ImpostorDistance");
   guip.trunkradius = gui[editobject]->GetWidget("TrunkRadius");
   guip.trunksegments = gui[editobject]->GetWidget("TrunkSegments");
   guip.trunkslices = gui[editobject]->GetWidget("TrunkSlices");
   guip.trunktaper = gui[editobject]->GetWidget("TrunkTaper");
   guip.maxtrunkangle = gui[editobject]->GetWidget("MaxTrunkAngle");
   
   guip.maxbranchangle = gui[editobject]->GetWidget("MaxBranchAngle");
   guip.initialheight = gui[editobject]->GetWidget("InitialHeight");
   guip.heightreduction = gui[editobject]->GetWidget("HeightReduction");
   guip.initialradius = gui[editobject]->GetWidget("InitialRadius");
   guip.radiustaper = gui[editobject]->GetWidget("RadiusTaper");
   guip.numlevels = gui[editobject]->GetWidget("NumLevels");
   guip.numslices = gui[editobject]->GetWidget("NumSlices");
   guip.numsegments = gui[editobject]->GetWidget("NumSegments");
   guip.numbranches0 = gui[editobject]->GetWidget("NumBranches0");
   guip.numbranches1 = gui[editobject]->GetWidget("NumBranches1");
   guip.numbranches2 = gui[editobject]->GetWidget("NumBranches2");
   guip.curvecoeff = gui[editobject]->GetWidget("CurveCoeff");
   guip.maxangle = gui[editobject]->GetWidget("MaxAngle");
   guip.minangle = gui[editobject]->GetWidget("MinAngle");
   
   guip.sidebranches = gui[editobject]->GetWidget("SideBranches");
   guip.minsidebranchangle = gui[editobject]->GetWidget("MinSideAngle");
   guip.maxsidebranchangle = gui[editobject]->GetWidget("MaxSideAngle");
   guip.branchafter = gui[editobject]->GetWidget("BranchAfter");
   guip.sidetaper = gui[editobject]->GetWidget("SideTaper");
   guip.sidesizeperc = gui[editobject]->GetWidget("SideSizePerc");
   
   guip.numleaves = gui[editobject]->GetWidget("NumLeaves");
   guip.leafsize = gui[editobject]->GetWidget("LeafSize");
   guip.leafsegs = gui[editobject]->GetWidget("LeafSegs");
   guip.leafcurve = gui[editobject]->GetWidget("LeafCurve");
   guip.firstleaflevel = gui[editobject]->GetWidget("FirstLeafLevel");
   
   guip.barkmat = gui[editobject]->GetWidget("BarkMat");
   guip.leavesmat = gui[editobject]->GetWidget("LeavesMat");
}
