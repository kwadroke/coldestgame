#include "editor.h"
#include "globals.h"
#include "renderdefs.h"

using std::vector;

map<Mesh*, ProceduralTree> treemap;
vector<Mesh*> spawnmeshes;

Mesh* selected = NULL;
bool clicked = false;
bool rotating = false;

void EditorLoop(const string editmap)
{
   SDL_Event event;
   
   editor = true;
   SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);
   gui[mainmenu]->visible = false;
   gui[loadprogress]->visible = true;
   GetMap("maps/" + editmap);
   for (list<Mesh>::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      if (!i->terrain)
         i->dynamic = true; // Because we could be moving anything around
   }
   gui[loadprogress]->visible = false;
   
   player[0].pos = Vector3(500, 500, 500);
   
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
         else if (event.key.keysym.sym == SDLK_LSHIFT)
         {
            player[0].run = true;
         }
         else if (event.key.keysym.sym == SDLK_TAB)
         {
            if (!gui[editobject]->visible)
               ShowGUI(editobject);
            else
               gui[editobject]->visible = false;
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
            if (clicked && selected)
            {
               if (!rotating)
               {
                  float modifier = 1.f;
                  if (player[0].run)
                     modifier = 5.f;
                  if (SDL_GetModState() & KMOD_CTRL)
                     selected->Move(selected->GetPosition() + Vector3(0.f, event.motion.yrel * modifier, 0.f));
                  else
                     selected->Move(selected->GetPosition() + Vector3(event.motion.xrel * modifier, 0.f, event.motion.yrel * modifier));
                  UpdateEditorGUI();
               }
               else
               {
                  float modifier = 1.f;
                  selected->Rotate(selected->GetRotation() + Vector3(event.motion.xrel * modifier, event.motion.yrel * modifier, 0.f));
                  UpdateEditorGUI();
               }
            }
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
   switch(event.type)
   {
      case SDL_KEYDOWN:
         if (event.key.keysym.sym == SDLK_r) // Right now rotation and translation are not allowed while GUI shown
         {
            rotating = true;
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
               gui[editobject]->visible = false;
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
         if (clicked && selected)
         {
            if (!rotating)
            {
               float modifier = 1.f;
               if (player[0].run)
                  modifier = 5.f;
               if (SDL_GetModState() & KMOD_CTRL)
                  selected->Move(selected->GetPosition() + Vector3(0.f, event.motion.yrel * modifier, 0.f));
               else
                  selected->Move(selected->GetPosition() + Vector3(event.motion.xrel * modifier, 0.f, event.motion.yrel * modifier));
               UpdateEditorGUI();
            }
            else
            {
               float modifier = 1.f;
               selected->Rotate(selected->GetRotation() + Vector3(event.motion.xrel * modifier, event.motion.yrel * modifier, 0.f));
               UpdateEditorGUI();
            }
            return true;
         }
         break;
      case SDL_MOUSEBUTTONDOWN:
         {
            GUI* sv = gui[editobject]->GetWidget("Base");
            GUI* mainsv = gui[editormain]->GetWidget("EditorMain");
            if (event.button.button == SDL_BUTTON_LEFT &&  
                !sv->InWidget(&event) && !mainsv->InWidget(&event))
            {
               GetSelectedMesh(event);
               clicked = true;
            }
         }
         break;
      case SDL_MOUSEBUTTONUP:
         {
            GUI* sv = gui[editobject]->GetWidget("Base");
            GUI* mainsv = gui[editormain]->GetWidget("EditorMain");
            if (event.button.button == SDL_BUTTON_LEFT && 
                !sv->InWidget(&event) && !mainsv->InWidget(&event))
            {
               clicked = false;
               return true;
            }
         }
         break;
   };
   
   if (gui[editobject]->visible)
   {
      SDL_ShowCursor(SDL_ENABLE);
      gui[editobject]->ProcessEvent(&event);
      return true;
   }
   if (SDL_ShowCursor(SDL_QUERY) == SDL_ENABLE)
   {
      gui[editormain]->ProcessEvent(&event);
   }
   return false;
}


void EditorMove()
{
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
   
   float movespeed = 5.f;
   if (player[0].run)
      movespeed *= 2.f;
   
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
   vector<Mesh*> check = GetMeshesWithoutPlayer(&player[0], meshes, kdtree, start, end, 1.f);
   
   Vector3 dummy;
   coldet.CheckSphereHit(start, end, 1.f, check, dummy, selected);
   
   UpdateEditorGUI();
}


void UpdateEditorGUI()
{
   GUI* objectname = gui[editobject]->GetWidget("ObjectName");
   GUI* objectx = gui[editobject]->GetWidget("ObjectX");
   GUI* objecty = gui[editobject]->GetWidget("ObjectY");
   GUI* objectz = gui[editobject]->GetWidget("ObjectZ");
   GUI* rotx = gui[editobject]->GetWidget("ObjectRotX");
   GUI* roty = gui[editobject]->GetWidget("ObjectRotY");
   GUI* rotz = gui[editobject]->GetWidget("ObjectRotZ");
   GUI* scale = gui[editobject]->GetWidget("ObjectScale");
   GUI* file = gui[editobject]->GetWidget("ObjectFile");
   
   if (selected)
   {
      objectname->text = selected->name;
      objectx->text = ToString(selected->GetPosition().x);
      objecty->text = ToString(selected->GetPosition().y);
      objectz->text = ToString(selected->GetPosition().z);
      rotx->text = ToString(selected->GetRotation().x);
      roty->text = ToString(selected->GetRotation().y);
      rotz->text = ToString(selected->GetRotation().z);
      scale->text = ToString(selected->GetScale());
      file->text = selected->GetFile();
   }
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
            logout << "Trees not supported at this time" << endl;
         }
      }
   }
   newmap.close();
}


void SaveObject()
{
   GUI* objectname = gui[editobject]->GetWidget("ObjectName");
   GUI* objectx = gui[editobject]->GetWidget("ObjectX");
   GUI* objecty = gui[editobject]->GetWidget("ObjectY");
   GUI* objectz = gui[editobject]->GetWidget("ObjectZ");
   GUI* rotx = gui[editobject]->GetWidget("ObjectRotX");
   GUI* roty = gui[editobject]->GetWidget("ObjectRotY");
   GUI* rotz = gui[editobject]->GetWidget("ObjectRotZ");
   GUI* scale = gui[editobject]->GetWidget("ObjectScale");
   GUI* file = gui[editobject]->GetWidget("ObjectFile");
   
   if (selected && !selected->terrain)
   {
      MeshPtr newmesh = meshcache->GetNewMesh(file->text);
      Vector3 pos(atof(objectx->text.c_str()), atof(objecty->text.c_str()), atof(objectz->text.c_str()));
      Vector3 rot(atof(rotx->text.c_str()), atof(roty->text.c_str()), atof(rotz->text.c_str()));
      
      newmesh->Move(pos);
      newmesh->Rotate(rot);
      if (newmesh->GetFile() == selected->GetFile()) // If we changed models then just use the new model's scale
         newmesh->Scale(atof(scale->text.c_str()) / newmesh->GetScale());
      newmesh->name = objectname->text;
      newmesh->dynamic = true;
      newmesh->GenVbo();
      
      meshes.push_back(*newmesh);
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
