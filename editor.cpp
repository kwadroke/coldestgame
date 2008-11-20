#include "editor.h"
#include "globals.h"
#include "renderdefs.h"

using std::vector;

map<Mesh*, ProceduralTree> treemap;

Mesh* selected = NULL;
bool clicked = false;

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
         EditorEventHandler(event);
      }
      
      EditorMove();
      
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
         else if (event.key.keysym.sym == SDLK_LSHIFT)
         {
            player[0].run = true;
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
               float modifier = 1.f;
               if (player[0].run)
                  modifier = 5.f;
               selected->Move(selected->GetPosition() + Vector3(event.motion.xrel * modifier, 0, event.motion.yrel * modifier));
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
      if (getdata.find("Objects") != string::npos)
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
   
   ofstream newmap(saveto.c_str(), ios::trunc);
   newmap << olddata;
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      if (!i->terrain)
      {
         newmap << "   Node\n";
         if (treemap.find(&(*i)) == treemap.end()) // Not a proctree
         {
            newmap << "      Type External\n";
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
