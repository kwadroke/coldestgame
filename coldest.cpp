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


// Main loop and basic game logic - a rather large file that could probably afford to be
// split up somewhat, but it hasn't really been a problem thus far.

// Necessary include(s)
#include "defines.h"
#include "globals.h"
#include "renderdefs.h"
#include "netdefs.h"
#ifndef _WIN32
// I hate Windows so much...boost::filesystem is apparently broken with STLPort,
// and the Visual C++ STL performance is terrible compared to STLPort for me
#include <boost/filesystem.hpp>
#endif

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <shlobj.h>
#endif

// Notes: Currently seems to be detrimental to performance, will need updates to
// work if it is needed in the future because these worker threads have been
// repurposed to thread VBO updates in the render code.
//#define THREADANIM

/* Do anything function that can be handy for debugging various things
   in a more limited context than the entire engine.*/
void Debug()
{
   float a = -1.001;
   float b = acos(a);
   cout << b << endl;
   
   exit(0);
}


#if !defined(WIN32) || defined(DEDICATED)
int main(int argc, char* argv[])
#else
int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)

#endif
{
   //Debug();
   
   setsighandler();
   initialized = false;
   
   // This function has to be before OutputDiagnosticData because that sets the log path based on this
   CreateAppDir();
   OutputDiagnosticData();
   logout << "Main " << gettid() << endl;
   InitGlobals();
   initialized = true;
   
#if !defined(_WIN32) || defined(DEDICATED)
   if (argc < 2)
#else
   // This is an overly simplistic command line handler, but for the moment it suffices
   string cmdline(lpCmdLine);
   size_t argc = 0;
   vector<string> argv(2);
   if (cmdline.length() > 0)
   {
      argv[1] = cmdline;
      argc = 2;
   }
#endif
   StartBGMusic();
   // Note, these are called by the restartgl console command, which is required in the autoexec.cfg file
   //SetupSDL();
   //SetupOpenGL();
   LoadMaterials();
   InitShaders();
   InitNoise();
   
#if !defined(DEDICATED)
   if (argc > 1)
   {
      logout << "Editing " << argv[1] << endl;
      EditorLoop(argv[1]);
      return 0;
   }
#endif
   
   // Start network threads
#ifndef DEDICATED
   netin = SDL_CreateThread(NetListen, NULL);
#else
   server = true;
   serverthread = SDL_CreateThread(Server, NULL);
#endif
   MainLoop();

   return 0;
}


void CreateAppDir()
{
#ifndef _WIN32
   userpath = getenv("HOME");
#else
   TCHAR szPath[MAX_PATH];

   if(SUCCEEDED(SHGetFolderPath(NULL, CSIDL_APPDATA|CSIDL_FLAG_CREATE, NULL, 0, szPath))) 
{
   userpath = szPath;
}
   else
{
   exit(-1); // This is very bad because we can't even log a message yet
}
#endif
   if (userpath.substr(userpath.length() - 1) != "/")
      userpath += "/.coldest/";
   else
      userpath += ".coldest/";
   
#ifndef _WIN32
   if (!boost::filesystem::is_directory(userpath))
      boost::filesystem::create_directory(userpath);
#else
   // This will fail most of the time because the directory already exists, but oh well.
   CreateDirectory(userpath.c_str(), NULL);
#endif
}


void OutputDiagnosticData()
{
#ifndef DEDICATED
   logout.SetFile(userpath + "console.log");
#else
   logout.SetFile(userpath + "server.log");
#endif
   logout << "Initializing Coldest\n";
   logout << "Built on: " << __DATE__ << " at " << __TIME__ << endl;
#ifdef __GNUC__
   logout << "GCC version: " << __VERSION__ << endl;
#endif
   SDL_version v = *SDL_Linked_Version();
   logout << "Linked SDL version: " << int(v.major) << "." << int(v.minor) << "." << int(v.patch) << endl;
   SDL_VERSION(&v);
   logout << "Compiled SDL version: " << int(v.major) << "." << int(v.minor) << "." << int(v.patch) << endl;
}


void InitGlobals()
{
   // Default cvars
   console.Parse("set screenwidth 800", false);
   console.Parse("set screenheight 600", false);
   console.Parse("set fullscreen 0", false);
   console.Parse("set showfps 0", false);
   console.Parse("set quiet 1", false);
   console.Parse("set fly 0", false);
   console.Parse("set thirdperson 0", false);
   console.Parse("set camdist 100", false);
   console.Parse("set consoletrans 128", false);
   console.Parse("set movestep 100", false);
   console.Parse("set ghost 0", false);
   console.Parse("set fov 60", false);
   console.Parse("set viewdist 3000", false);
   console.Parse("set showkdtree 0", false);
   console.Parse("set tickrate 30", false);
   console.Parse("set serveraddr localhost", false);
   console.Parse("set shadows 1", false);
   console.Parse("set reflection 1", false);
   console.Parse("set partupdateinterval 0", false);
   console.Parse("set serversync 1", false);
   console.Parse("set aa 0", false);
   console.Parse("set af 1", false);
   console.Parse("set impdistmulti 5", false);
   console.Parse("set detailmapsize 600", false);
   console.Parse("set softshadows 0", false);
   console.Parse("set turnsmooth 20", false);
   console.Parse("set endgametime 10", false);
   console.Parse("set splashlevels 3", false);
   console.Parse("set grassdrawdist 1000", false);
   console.Parse("set grassdensity 1", false);
   console.Parse("set zoomfactor 2", false);
   console.Parse("set weaponfocus 1000", false);
   console.Parse("set serverport 12010", false);
   console.Parse("set hitindtime 1000", false);
   console.Parse("set startsalvage 100", false);
   console.Parse("set viewoffset 0", false);
   console.Parse("set limitserverrate 1", false);
   console.Parse("set maxplayers 32", false);
   console.Parse("set mousespeed 400", false);
   console.Parse("set terrainmulti 3", false);
   console.Parse("set map riverside", false);
   console.Parse("set master www.coldestgame.com", false);
   console.Parse("set respawntime 15000", false);
   console.Parse("set cache 1", false);
   console.Parse("set musicvol 40", false);
   console.Parse("set servername @none@", false);
   console.Parse("set serverpwd password", false);
   console.Parse("set bots 0", false);
   console.Parse("set overheat 1", false);
   console.Parse("set syncmax 50", false);
   console.Parse("set name Nooblet", false);
   console.Parse("set syncgrace 15", false);
   console.Parse("set maxanimdelay 25", false);
   console.Parse("set timeout 10", false);
   console.Parse("set numthreads 2", false);
   
   // Variables that cannot be set from the console
#ifndef DEDICATED
   lasttick = SDL_GetTicks();
   frames = 0;
   noiseres = 128;
   staticdrawdist = false;
#endif
   running = true;
   sendpacketnum.next();  // 0 has special meaning
   recpacketnum = 0;
   ackpack = 0;
   doconnect = false;
   connected = false;
   nextmap = mapname = "";
   clientmutex = SDL_CreateMutex();
   spawnschanged = true;
   winningteam = 0;
   weaponslots.push_back(Torso);
   weaponslots.push_back(LArm);
   weaponslots.push_back(RArm);
   meshcache = MeshCachePtr(new MeshCache(resman));
   lasthit = 0;
   
#ifndef DEDICATED
   standardshader = "shaders/standard";
   noiseshader = "shaders/noise";
   cloudshader = "shaders/cloud";
   shadowshader = "shaders/shadowmap";
   watershader = "shaders/water";
   cloudgenshader = "shaders/cloudgen";
   bumpshader = "shaders/bump";
   flatshader = "shaders/flat";
#endif

   string keyspath = userpath + "keys.cfg";
   ifstream checkkeys(keyspath.c_str(), ios_base::in);
   
   if (checkkeys.fail())
   {
      checkkeys.close();
      ofstream writekeys(keyspath.c_str(), ios_base::out);
      
      writekeys << "# Do not edit this file - it will be overwritten\n";
      writekeys << "set keyforward " << SDLK_w << endl;
      writekeys << "set keyback " << SDLK_s << endl;
      writekeys << "set keyleft " << SDLK_a << endl;
      writekeys << "set keyright " << SDLK_d << endl;
      writekeys << "set keyloadout " << SDLK_l << endl;
      writekeys << "set keyuseitem " << SDLK_u << endl;
      writekeys << "set mousefire " << SDL_BUTTON_LEFT << endl;
      writekeys << "set mousezoom " << SDL_BUTTON_RIGHT << endl;
      writekeys << "set mouseuse " << SDL_BUTTON_MIDDLE << endl;
      writekeys << "set mousenextweap " << SDL_BUTTON_WHEELDOWN << endl;
      writekeys << "set mouseprevweap " << SDL_BUTTON_WHEELUP << endl;
      writekeys.close();
      
      console.Parse("include keys.cfg", true);
   }
   
   ReadConfig();
   
   locks.Register(meshes);
   
   // Can't create players until after SDL has been init'd in ReadConfig
   PlayerData dummy = PlayerData(meshes); // Local player is always index 0
   dummy.unit = Nemesis;
   dummy.spawned = true;
   dummy.name = console.GetString("name");
   player.push_back(dummy);
   
   SetupOpenAL();
   
#ifndef DEDICATED
   // These have to be done here because GL has to be initialized first
   if (console.GetInt("reflectionres") < 1)
      console.Parse("setsave reflectionres 512", false);
   if (console.GetInt("cloudres") < 1)
      console.Parse("setsave cloudres 1024", false);
   if (console.GetInt("shadowres") < 1)
      console.Parse("setsave shadowres 1024", false);
   
   InitGUI();
   
   for (size_t i = 0; i < vboworkers.size(); ++i)
   {
      if (!vboworkers[i])
         vboworkers[i] = VboWorkerPtr(new VboWorker());
   }
#endif
   InitUnits();
}


void InitGUI()
{
#ifndef DEDICATED
   // SDL_ttf must be initialized before GUI's are built
   if (TTF_Init() == -1)
   {
      logout << "Failed to initialize font system: " << TTF_GetError() << endl;
      exit(1);
   }
   int screenwidth = console.GetInt("screenwidth");
   int screenheight = console.GetInt("screenheight");
   gui.clear();
   gui.resize(numguis);
   gui[mainmenu] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/mainmenu.xml"));
   gui[hud] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/hud.xml"));
   gui[loadprogress] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/loadprogress.xml"));
   gui[loadoutmenu] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/loadout.xml"));
   gui[statsdisp] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/stats.xml"));
   gui[consolegui] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/console.xml"));
   gui[ingamestatus] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/ingamestatus.xml"));
   gui[chat] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/chat.xml"));
   gui[settings] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/settings.xml"));
   gui[endgame] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/endgame.xml"));
   gui[loadoutmessage] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/loadoutmessage.xml"));
   gui[editobject] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/editobject.xml"));
   gui[editormain] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/editormain.xml"));
   gui[serverbrowser] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/serverbrowser.xml"));
   gui[credits] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/credits.xml"));
   
   
   TextArea* consoleout = dynamic_cast<TextArea*>(gui[consolegui]->GetWidget("consoleoutput"));
   console.InitWidget(*consoleout);
   reloadgui = false;
#endif
}


void InitUnits()
{
   UnitData dummy;
   dummy.file = "nemesis";
   dummy.turnspeed = 1.f;
   dummy.acceleration = .05f;
   dummy.maxspeed = 3.f;
   dummy.size = 20.f;
   dummy.scale = 1.f;
   dummy.weight = 50;
   dummy.weaponoffset[Legs] = Vector3();
   dummy.weaponoffset[Torso] = Vector3(0, 0, 0);
   dummy.weaponoffset[LArm] = Vector3(-10, 0, 0);
   dummy.weaponoffset[RArm] = Vector3(10, 0, 0);
   dummy.viewoffset = Vector3(0, 10, -10);
   for (size_t i = 0; i < numbodyparts; ++i)
      dummy.maxhp[i] = 200;
   for (short i = 0; i < numunits; ++i)
      units.push_back(dummy);
   
   units[Ultra].file = "ultra";
   units[Omega].file = "omega";
   for (size_t i = 0; i < numunits; ++i)
   {
      IniReader read("units/" + units[i].file);
      read.Read(units[i].turnspeed, "TurnSpeed");
      read.Read(units[i].acceleration, "Acceleration");
      read.Read(units[i].maxspeed, "MaxSpeed");
      read.Read(units[i].size, "Size");
      read.Read(units[i].scale, "Scale");
      read.Read(units[i].weight, "Weight");
      read.Read(units[i].weaponoffset[Torso].x, "TorsoOffset", 0);
      read.Read(units[i].weaponoffset[Torso].y, "TorsoOffset", 1);
      read.Read(units[i].weaponoffset[Torso].z, "TorsoOffset", 2);
      read.Read(units[i].weaponoffset[LArm].x, "LArmOffset", 0);
      read.Read(units[i].weaponoffset[LArm].y, "LArmOffset", 1);
      read.Read(units[i].weaponoffset[LArm].z, "LArmOffset", 2);
      read.Read(units[i].weaponoffset[RArm].x, "RArmOffset", 0);
      read.Read(units[i].weaponoffset[RArm].y, "RArmOffset", 1);
      read.Read(units[i].weaponoffset[RArm].z, "RArmOffset", 2);
      read.Read(units[i].viewoffset.x, "ViewOffset", 0);
      read.Read(units[i].viewoffset.y, "ViewOffset", 1);
      read.Read(units[i].viewoffset.z, "ViewOffset", 2);
      for (size_t j = 0; j < numbodyparts; ++j)
         read.Read(units[i].maxhp[j], "HP", j);
   }
   
   // Just while we don't have unique models for each unit
   units[Ultra].scale = units[Nemesis].scale * units[Ultra].size / units[Nemesis].size;
   units[Omega].scale = units[Nemesis].scale * units[Omega].size / units[Nemesis].size;
   units[Ultra].viewoffset = units[Nemesis].viewoffset * units[Ultra].size / units[Nemesis].size;
   units[Omega].viewoffset = units[Nemesis].viewoffset * units[Omega].size / units[Nemesis].size;
   for (size_t i = 0; i < numbodyparts; ++i)
   {
      units[Ultra].weaponoffset[i] = units[Nemesis].weaponoffset[i] * (units[Ultra].size / units[Nemesis].size);
      units[Omega].weaponoffset[i] = units[Nemesis].weaponoffset[i] * (units[Omega].size / units[Nemesis].size);
   }
}


void ReadConfig()
{
   string conffile = userpath + "autoexec.cfg";
   string buffer;
   
   ifstream checkconf(conffile.c_str(), ios_base::in);
   
   if (checkconf.fail())
   {
      checkconf.close();
      console.SaveToFile(conffile, true);
      console.Parse("restartgl");
   }

   ifstream getconf(conffile.c_str(), ios_base::in);
   
   while (!getconf.eof())
   {
      getline(getconf, buffer);
      console.Parse(buffer);
   }
   
   // Populate keybindings
   keys.keyforward = SDLKey(console.GetInt("keyforward"));
   keys.keyback = SDLKey(console.GetInt("keyback"));
   keys.keyleft = SDLKey(console.GetInt("keyleft"));
   keys.keyright = SDLKey(console.GetInt("keyright"));
   keys.keyloadout = SDLKey(console.GetInt("keyloadout"));
   keys.keyuseitem = SDLKey(console.GetInt("keyuseitem"));
   keys.mousefire = console.GetInt("mousefire");
   keys.mousezoom = console.GetInt("mousezoom");
   keys.mouseuse = console.GetInt("mouseuse");
   keys.mousenextweap = console.GetInt("mousenextweap");
   keys.mouseprevweap = console.GetInt("mouseprevweap");
}


void SetupSDL() 
{
   const SDL_VideoInfo* video;
   
#ifndef DEDICATED
   if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0)
#else
   if (SDL_Init(SDL_INIT_TIMER) < 0)
#endif
   {
      logout << "Couldn't initialize SDL: " << SDL_GetError() << endl;
      exit(1);
   }
   
   SDL_EnableUNICODE(1);
   SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);
   
   atexit(SDL_Quit);
   
#ifndef DEDICATED
   video = SDL_GetVideoInfo();
   
   if (!video) 
   {
      logout << "Couldn't get video information: " << SDL_GetError() << endl;
      exit(1);
   }
   
   // Set the minimum requirements for the OpenGL window
   SDL_GL_SetAttribute( SDL_GL_RED_SIZE, 8 );
   SDL_GL_SetAttribute( SDL_GL_GREEN_SIZE, 8 );
   SDL_GL_SetAttribute( SDL_GL_BLUE_SIZE, 8 );
   SDL_GL_SetAttribute( SDL_GL_ALPHA_SIZE, 8 );
   SDL_GL_SetAttribute( SDL_GL_DEPTH_SIZE, 24 );
   SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );
   
   // Add antialiasing support
   int aalevel = console.GetInt("aa");
   if (aalevel)
   {
      SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 1);
      SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, aalevel);
   }
   
   /* Note the SDL_DOUBLEBUF flag is not required to enable double 
   * buffering when setting an OpenGL video mode. 
   * Double buffering is enabled or disabled using the 
   * SDL_GL_DOUBLEBUFFER attribute.
   */
   Uint32 flags = SDL_OPENGL;
   if (console.GetBool("fullscreen"))
      flags |= SDL_FULLSCREEN;
   if( SDL_SetVideoMode(console.GetInt("screenwidth"), console.GetInt("screenheight"), video->vfmt->BitsPerPixel, flags) == 0 ) 
   {
      logout << "Couldn't set video mode: " << SDL_GetError() << endl;
      exit(1);
   }
   
   SDL_WM_SetCaption("Coldest", "");
   
   SDL_ShowCursor(1);
   //SDL_WM_GrabInput(SDL_GRAB_ON);
#endif
   
   if (SDLNet_Init() == -1)
   {
      logout << "SDLNet_Init: " << SDLNet_GetError() << endl;
      exit(1);
   }
   
   atexit(SDLNet_Quit);
}


void SetupOpenGL()
{
#ifndef DEDICATED
   int screenwidth = console.GetInt("screenwidth");
   int screenheight = console.GetInt("screenheight");
   aspect = (float)screenwidth / (float)screenheight;

   // Make the viewport cover the whole window
   glViewport(0, 0, screenwidth, screenheight);

   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   
   gluPerspective(console.GetFloat("fov"), aspect, nearclip, console.GetFloat("viewdist"));
   //glFrustum(-1, 1, -1 / aspect, 1 / aspect, 1, 10000.);
   
   glMatrixMode(GL_MODELVIEW);

   resman.texman.Clear();

   glClearColor(0.0, 0.0 ,0.0, 0);
   
   // We want z-buffer tests enabled
   glEnable(GL_DEPTH_TEST);
   glEnable(GL_LIGHTING);
   glEnable(GL_LIGHT0);
   glEnable(GL_COLOR_MATERIAL);
   glEnable(GL_TEXTURE_2D);
   glEnable(GL_BLEND);
   //glEnable(GL_POLYGON_SMOOTH);
   //glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   glDepthFunc(GL_LEQUAL);
   
   glDisable(GL_FOG); // Done by shader anyway
   float viewdist = console.GetFloat("viewdist");
   glFogf(GL_FOG_START, viewdist * .8);
   glFogf(GL_FOG_END, viewdist);
   glFogf(GL_FOG_MODE, GL_LINEAR);

   // Do draw back-facing polygons - this can now be done on a per-material basis
   glDisable(GL_CULL_FACE);
   //glEnable(GL_CULL_FACE);
   //glCullFace(GL_BACK);
   
   // Set the alpha function, then can disable or enable
   glAlphaFunc(GL_GREATER, 0.5);
   glDisable(GL_ALPHA_TEST);
   
   if (console.GetInt("aa"))
      glEnable(GL_MULTISAMPLE);
   
   glPixelStorei(GL_UNPACK_ALIGNMENT, 8);
   
   GLenum err = glewInit();
   if (err != GLEW_OK)
   {
      logout << "Failed to init glew: " << glewGetErrorString(err) << endl << flush;
      exit(-2);
   }
   logout << "Glew init successful, using version: " << glewGetString(GLEW_VERSION) << endl << flush;
   if (!GLEW_EXT_framebuffer_object)
   {
      logout << "We don't have EXT_framebuffer_object.  This is fatal.\n" << flush;
      exit(-3);
   }
   if (!GLEW_ARB_vertex_buffer_object)
   {
      logout << "We don't have ARB_vertex_buffer_object.  This is fatal.\n" << flush;
      exit(-4);
   }
   if (!GLEW_ARB_depth_texture)
   {
      logout << "We don't have ARB_depth_texture.  This is fatal.\n" << flush;
      exit(-5);
   }
   if (!GLEW_ARB_shadow)
   {
      logout << "We don't have ARB_shadow.  This is fatal.\n" << flush;
      exit(-6);
   }
   if (!GLEW_ARB_fragment_shader)
   {
      logout << "We don't have ARB_fragment_shader.  This is fatal.\n" << flush;
      exit(-7);
   }
   if (!GLEW_ARB_multitexture)
   {
      logout << "We don't have ARB_multitexture.  This is fatal." << endl;
      exit(-8);
   }
   
   noisefbo = FBO(noiseres, noiseres, false, &resman.texhand);
   fastnoisefbo = FBO(noiseres, noiseres, false, &resman.texhand);
   resman.texhand.BindTexture(noisefbo.GetTexture());
   // Need different tex params for this texture
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
   resman.texhand.BindTexture(fastnoisefbo.GetTexture());
   // Need different tex params for this texture
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
#endif
}


void SetupOpenAL()
{
#ifndef DEDICATED
   if (!alutInit(NULL, NULL))
   {
      logout << "Error initializing OpenAL: " << alGetError() << endl;
      exit(-1);
   }
   resman.soundman.SetMaxSources(16);
#endif
}


void LoadMaterials()
{
#ifndef DEDICATED
   resman.LoadMaterial("materials/water");
   shadowmat = &resman.LoadMaterial("materials/shadowgen");
#endif
}


void InitShaders()
{
#ifndef DEDICATED
   if (!initialized) return;
   resman.shaderman.SetShadow(console.GetBool("shadows"), console.GetBool("softshadows"));
   resman.shaderman.ReloadAll();
   resman.shaderman.LoadShader(standardshader);
   
   resman.shaderman.LoadShader(noiseshader);
   resman.shaderman.SetUniform1f(noiseshader, "time", SDL_GetTicks());
   
   resman.shaderman.LoadShader(cloudshader);
   
   resman.shaderman.LoadShader(cloudgenshader);
   resman.shaderman.SetUniform1f(cloudgenshader, "noiseres", noiseres);
   
   resman.shaderman.LoadShader(shadowshader);
   
   resman.shaderman.LoadShader(watershader);
   
   resman.shaderman.LoadShader(bumpshader);
   
   resman.shaderman.LoadShader(flatshader);
   
   resman.shaderman.UseShader("none");
#endif
}


// Sets up textures for noise shader
/* 
 * Author: Stefan Gustavson ITN-LiTH (stegu@itn.liu.se) 2004-12-05
 * Simplex indexing functions by Bill Licea-Kane, ATI (bill@ati.com)
 *
 * You may use, modify and redistribute this code free of charge,
 * provided that the author's names and this notice appear intact.
 */
void InitNoise()
{
#ifndef DEDICATED
   int perm[256] = {151,160,137,91,90,15,
  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180};

   /* These are Ken Perlin's proposed gradients for 3D noise. I kept them for
      better consistency with the reference implementation, but there is really
      no need to pad this to 16 gradients for this particular implementation.
      If only the "proper" first 12 gradients are used, they can be extracted
      from the grad4[][] array: grad3[i][j] == grad4[i*2][j], 0<=i<=11, j=0,1,2
   */
   int grad3[16][3] = {{0,1,1},{0,1,-1},{0,-1,1},{0,-1,-1},
                     {1,0,1},{1,0,-1},{-1,0,1},{-1,0,-1},
                     {1,1,0},{1,-1,0},{-1,1,0},{-1,-1,0}, // 12 cube edges
                     {1,0,-1},{-1,0,-1},{0,-1,1},{0,1,1}}; // 4 more to make 16
   int i,j;
   
   glGenTextures(1, &noisetex); // Generate a unique texture ID
   resman.texhand.BindTexture(noisetex); // Bind the texture to texture unit 0
   
   GLubyte pixels[256 * 256 * 4];
   for (i = 0; i<256; i++)
      for (j = 0; j<256; j++)
      {
         int offset = (i*256+j)*4;
         char value = perm[(j+perm[i]) & 0xFF];
         pixels[offset] = grad3[value & 0x0F][0] * 64 + 64;   // Gradient x
         pixels[offset+1] = grad3[value & 0x0F][1] * 64 + 64; // Gradient y
         pixels[offset+2] = grad3[value & 0x0F][2] * 64 + 64; // Gradient z
         pixels[offset+3] = value;                     // Permuted index
      }
   
   glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, 256, 256, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels );
   glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
   glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
#endif
}


void MainLoop()
{
   static bool repeat = true;
   SDL_Event event;
   while(1) 
   {
      if (!running)
         Quit();
      SDL_mutexP(clientmutex);
      if (nextmap != mapname)
      {
         SDL_mutexV(clientmutex);
#ifndef DEDICATED
         ShowGUI(loadprogress);
         Repaint();
#endif
         SDL_mutexP(clientmutex);
         GetMap(nextmap);
         SDL_mutexV(clientmutex);
         winningteam = 0;
#ifndef DEDICATED
         ShowGUI(loadoutmenu);
#endif
         SDL_mutexP(clientmutex); // Prevent double unlock, not sure it's necessary
      }
      SDL_mutexV(clientmutex);
      
      
#ifndef DEDICATED
      GUIUpdate();
      
      // process pending events
      while(SDL_PollEvent(&event)) 
      {
         if (!GUIEventHandler(event))
         {
            SDL_EnableKeyRepeat(0, 0);
            repeat = false;
            GameEventHandler(event);
         }
         else if (!repeat)
         {
            SDL_EnableKeyRepeat(SDL_DEFAULT_REPEAT_DELAY, SDL_DEFAULT_REPEAT_INTERVAL);
            repeat = true;
         }
      }

      // Can't do this in the event handler because that is called from within the GUI
      if (reloadgui)
      {
         SDL_mutexP(clientmutex);
         InitGUI();
         SDL_mutexV(clientmutex);
      }
      
      // Check for end of game
      if (winningteam)
      {
         GUI* gotext = gui[endgame]->GetWidget("GameOverText");
         gotext->text = "Team " + ToString(winningteam) + " wins!";
         ShowGUI(endgame);
      }
      
      SDL_mutexP(clientmutex);
      if (!PrimaryGUIVisible())
         UpdatePlayer();
      SDL_mutexV(clientmutex);
      
      // Update any animated objects
      Animate();
      
      // update the screen
      Repaint();

#else
      SDL_Delay(1);
#endif
   } // End of while(1)
}  // End of MainLoop function


void GUIUpdate()
{
#ifndef DEDICATED
   static Uint32 servupdatecounter = SDL_GetTicks();
   static Uint32 statupdatecounter = SDL_GetTicks();
   Uint32 currtick;
   SDL_mutexP(clientmutex);
   if (gui[serverbrowser]->visible)
   {
      currtick = SDL_GetTicks();
      if (currtick - servupdatecounter > 100)
      {
         UpdateServerList();
         servupdatecounter = currtick;
      }
   }
   if (gui[ingamestatus]->visible || gui[loadoutmenu]->visible)
   {
      currtick = SDL_GetTicks();
      if (currtick - statupdatecounter > 100)
      {
         UpdatePlayerList();
         statupdatecounter = currtick;
      }
   }
   
   for (size_t i = 0; i < newchatlines.size(); ++i)
      AppendToChat(newchatplayers[i], newchatlines[i]);
   newchatlines.clear();
   newchatplayers.clear();
   
   if (gui[loadoutmenu]->visible)
   {
      if (spawnschanged)
      {
         ComboBox *spawnpointsbox = (ComboBox*)gui[loadoutmenu]->GetWidget("SpawnPoints");
         GUI* maplabel = gui[loadoutmenu]->GetWidget("Map");
         spawnpointsbox->Clear();
         maplabel->ClearChildren();
         spawnbuttons.clear();
         availablespawns = mapspawns;
         for (size_t i = 0; i < items.size(); ++i)
         {
            if (items[i].Type() == Item::SpawnPoint && items[i].team == player[0].team)
            {
               string name = "Spawn " + ToString(i);
               SpawnPointData sp;
               sp.name = name;
               sp.position = items[i].mesh->GetPosition();
               sp.team = items[i].team;
               availablespawns.push_back(sp);
            }
         }
         for (size_t i = 0; i < availablespawns.size(); ++i)
         {
            GUIPtr newbutton(new Button(maplabel, &resman.texman));
            Button* buttonptr = dynamic_cast<Button*>(newbutton.get()); // Can't set toggle on a GUIPtr
            buttonptr->toggle = true;
            newbutton->width = 50;
            newbutton->height = 50;
            newbutton->x = availablespawns[i].position.x / mapwidth * maplabel->width - newbutton->width / 2.f;
            newbutton->y = availablespawns[i].position.z / mapheight * maplabel->height - newbutton->height / 2.f;
            newbutton->text = ToString(i);
            newbutton->leftclickaction = "selectspawn";
            newbutton->SetTexture(Normal, "textures/buttonnorm.png");
            newbutton->SetTexture(Hover, "textures/buttonhover.png");
            newbutton->SetTexture(Clicked, "textures/buttonpressed.png");
            spawnbuttons.push_back(newbutton);
            maplabel->Add(newbutton);
            string name = ToString(i) + ": ";
            name += availablespawns[i].name;
            spawnpointsbox->Add(name);
         }
         spawnschanged = false;
      }
      gui[loadoutmessage]->visible = false;
      GUI* spawnbutton = gui[loadoutmenu]->GetWidget("Spawn");
      GUI* spawntimer = gui[loadoutmenu]->GetWidget("SpawnTimer");
      if (player[0].spawntimer)
      {
         spawnbutton->visible = false;
         spawntimer->visible = true;
         spawntimer->text = "Spawn in " + ToString(player[0].spawntimer / 1000);
      }
      else
      {
         spawntimer->visible = false;
      }
   }
   else if (!player[0].spawned && !PrimaryGUIVisible())
   {
      gui[loadoutmessage]->visible = true;
   }
   else
      gui[loadoutmessage]->visible = false;
   
   GUI* hitind = gui[hud]->GetWidget("hitind");
   if (SDL_GetTicks() - lasthit < console.GetInt("hitindtime"))
   {
      hitind->visible = true;
   }
   else
      hitind->visible = false;
   
   GUI* servfps = gui[statsdisp]->GetWidget("serverfps");
   servfps->text = "Server FPS: " + ToString(serverfps);
   GUI* bpslabel = gui[statsdisp]->GetWidget("serverbps");
   bpslabel->text = "Server BPS: " + ToString(serverbps);
   
   if (gui[mainmenu]->visible)
   {
      GUI* resumebutton = gui[mainmenu]->GetWidget("resumebutton");
      if (connected)
         resumebutton->visible = true;
      else
         resumebutton->visible = false;
   }
   
   // For some reason killtable->Clear() is extremely slow (2-5 ms), so we can't do this every
   // time through.  Hence the killschanged flag.
   if (!PrimaryGUIVisible() && killschanged)
   {
      while (killmessages.size() > 6)
         killmessages.pop_front();
      
      Table* killtable = dynamic_cast<Table*>(gui[hud]->GetWidget("killmessages"));
      killtable->Clear();
      for (size_t i = 0; i < killmessages.size(); ++i)
         killtable->Add(killmessages[i]);
      killschanged = 0;
   }
   
   // Check to see if anyone is under our crosshair and display their info
   if (!PrimaryGUIVisible())
   {
      GraphicMatrix m;
      m.rotatex(-player[0].pitch);
      m.rotatey(player[0].rotation + player[0].facing);
      Vector3 offset;
      if (!guncam)
         offset = units[player[0].unit].viewoffset;
      else
         offset = units[player[0].unit].weaponoffset[weaponslots[player[0].currweapon]];
      Vector3 rawoffset = offset;
      offset.transform(m);
      
      Vector3 actualaim = Vector3(0, 0, -console.GetFloat("weaponfocus"));
      // When !guncam this reduces to difference = actualaim
      Vector3 difference = actualaim + rawoffset - units[player[0].unit].viewoffset;
      Vector3 rot = RotateBetweenVectors(Vector3(0, 0, -1), difference);
      Vector3 dir(0, 0, -2000.f);
      m.identity();
      m.rotatex(-player[0].pitch + rot.x);
      m.rotatey(player[0].rotation + player[0].facing - rot.y);
      dir.transform(m);
      
      Vector3 checkstart = player[0].pos + offset;
      Vector3 checkend = checkstart + dir;
      locks.Write(meshes);
      vector<Mesh*> check = GetMeshesWithoutPlayer(&player[servplayernum], meshes, kdtree, checkstart, checkend, .01f);
      Vector3 dummy;
      Mesh* hitmesh;
      coldet.CheckSphereHit(checkstart, checkend, .01f, check, dummy, hitmesh);
      PlayerData* p = PlayerFromMesh(hitmesh, player, meshes.end());
      locks.EndWrite(meshes);
      // Populate GUI object
      GUI* targetplayer = gui[hud]->GetWidget("targetplayer");
      if (p)
      {
         targetplayer->text = p->name;
      }
      else
      {
         targetplayer->text = "";
      }
   }
   
   SDL_mutexV(clientmutex);
#endif
}


bool GUIEventHandler(SDL_Event &event)
{
#ifndef DEDICATED
   SDL_mutexP(clientmutex);
   // Mini keyboard handler to deal with the console and chat
   bool eatevent = false;
   GUI* chatin = gui[chat]->GetWidget("chatinput");
   if (!chatin)
   {
      logout << "Error getting chat input widget" << endl;
      SDL_mutexV(clientmutex);
      return false;
   }
   switch (event.type)
   {
      case SDL_KEYDOWN:
         switch(event.key.keysym.sym)
         {
            case SDLK_BACKQUOTE:
               gui[consolegui]->visible = !gui[consolegui]->visible;
               if (gui[consolegui]->visible)
               {
                  GUI* consolein = gui[consolegui]->GetWidget("consoleinput");
                  consolein->SetActive();
               }
               eatevent = true;
               break;
            case SDLK_ESCAPE:
               if (gui[consolegui]->visible)
               {
                  gui[consolegui]->visible = false;
                  eatevent = true;
               }
               if (chatin->visible)
               {
                  chatin->visible = false;
                  GUI* teamlabel = gui[chat]->GetWidget("chatteam");
                  teamlabel->visible = false;
                  eatevent = true;
               }
               break;
            case SDLK_RETURN:
               player[0].run = false; // In case they pressed shift+Enter to team chat
               if (gui[consolegui]->visible)
               {
                  GUI* consolein = gui[consolegui]->GetWidget("consoleinput");
                  console.Parse(consolein->text);
                  consolein->text = "";
               }
               else if (PrimaryGUIVisible())
               {
                  // Do nothing
               }
               else if (!chatin->visible)
               {
                  GUI* teamlabel = gui[chat]->GetWidget("chatteam");
                  if (event.key.keysym.mod & KMOD_SHIFT)
                  {
                     chatteam = true;
                     teamlabel->visible = true;
                  }
                  else
                  {
                     chatteam = false;
                  }
                  chatin->visible = true;
                  chatin->SetActive();
               }
               else
               {
                  GUI *chatin = gui[chat]->GetWidget("chatinput");
                  if (!chatin)
                  {
                     logout << "Error getting chat input widget" << endl;
                     break;
                  }
                  SDL_mutexP(clientmutex);
                  chatstring = chatin->text;
                  AppendToChat(0, chatin->text);
                  SDL_mutexV(clientmutex);
                  chatin->text = "";
                  chatin->visible = false;
                  GUI* teamlabel = gui[chat]->GetWidget("chatteam");
                  teamlabel->visible = false;
               }
               eatevent = true;
               break;
            case SDLK_F12:
               {
                  logout << "Saving screenshot" << endl;
                  glPixelStorei(GL_PACK_ALIGNMENT,1);
                  int screenwidth = console.GetInt("screenwidth");
                  int screenheight = console.GetInt("screenheight");
                  GLubytevec pixels(screenwidth * screenheight * 3);
               
                  glReadPixels(0, 0, screenwidth, screenheight, GL_BGR, GL_UNSIGNED_BYTE, &pixels[0]);
                  vector<unsigned char> header(12, 0);
                  header[2] = 2;
                  header.push_back(screenwidth % 256);
                  header.push_back(screenwidth / 256);
                  header.push_back(screenheight % 256);
                  header.push_back(screenheight / 256);
                  header.push_back(24);
                  header.push_back(0);
               
                  int num = 0;
                  string filename;
                  bool finished = false;
#ifndef _WIN32
                  if (!boost::filesystem::is_directory(userpath + "screenshots/"))
                     boost::filesystem::create_directory(userpath + "screenshots/");
#else
                  string screenpath = userpath + "screenshots/";
                  CreateDirectory(screenpath.c_str(), NULL);
#endif
                  while (!finished)
                  {
                     string padded = PadNum(num, 5);
                     filename = userpath + "screenshots/screenshot" + padded + ".tga";
                     ifstream test(filename.c_str());
                     if (!test)
                        finished = true;
                     test.close();
                     ++num;
                  }
                  ofstream screenshot(filename.c_str());
                  for (size_t i = 0; i < header.size(); ++i)
                     screenshot << header[i];
                  for (size_t i = 0; i < pixels.size(); ++i)
                     screenshot << pixels[i];
                  screenshot.close();
               }
               break;
            default:
               break;
         }
      
   };
   SDL_mutexV(clientmutex);
   
   if (eatevent) return eatevent;
   
   SDL_mutexP(clientmutex);
   if (gui[consolegui]->visible)
   {
      SDL_ShowCursor(1);
      gui[consolegui]->ProcessEvent(&event);
      eatevent = true;
   }
   else if (chatin->visible)
   {
      gui[chat]->ProcessEvent(&event);
      eatevent = true;
   }
   else if (gui[mainmenu]->visible) 
   {
      SDL_ShowCursor(1);
      gui[mainmenu]->ProcessEvent(&event);
      eatevent = true;
   }
   else if (gui[loadoutmenu]->visible)
   {
      SDL_ShowCursor(1);
      gui[loadoutmenu]->ProcessEvent(&event);
      eatevent = true;
   }
   else if (gui[settings]->visible)
   {
      SDL_ShowCursor(1);
      gui[settings]->ProcessEvent(&event);
      eatevent = true;
   }
   else if (gui[serverbrowser]->visible) 
   {
      SDL_ShowCursor(1);
      gui[serverbrowser]->ProcessEvent(&event);
      eatevent = true;
   }
   else if (gui[credits]->visible) 
   {
      SDL_ShowCursor(1);
      gui[credits]->ProcessEvent(&event);
      eatevent = true;
   }
   SDL_mutexV(clientmutex);
   
   
   return eatevent;
#endif
   return false;
}


void GameEventHandler(SDL_Event &event)
{
#ifndef DEDICATED
   SDL_ShowCursor(0);
   int screenwidth = console.GetInt("screenwidth");
   int screenheight = console.GetInt("screenheight");
   SDL_mutexP(clientmutex);
   if (!player[servplayernum].powerdowntime)
   {
      switch(event.type) 
      {
         case SDL_KEYDOWN:
            if (event.key.keysym.sym == SDLK_ESCAPE)
            {
               ShowGUI(mainmenu);
            }
            else if (event.key.keysym.sym == keys.keyleft)
            {
               player[0].moveleft = true;
            }
            else if (event.key.keysym.sym == keys.keyright)
            {
               player[0].moveright = true;
            }
            else if (event.key.keysym.sym == keys.keyforward)
            {
               player[0].moveforward = true;
            }
            else if (event.key.keysym.sym == keys.keyback)
            {
               player[0].moveback = true;
            }
            else if (event.key.keysym.sym == keys.keyloadout)
            {
               vector<SpawnPointData> allspawns = spawnpoints;
               vector<SpawnPointData> itemspawns = GetSpawns(items);
               allspawns.insert(allspawns.end(), itemspawns.begin(), itemspawns.end());
               if (!player[0].spawned || NearSpawn(player[0], allspawns))
               {
                  gui[loadoutmenu]->visible = true;
                  gui[hud]->visible = false;
                  sendloadout = 1;
               }
            }
            else if (event.key.keysym.sym == keys.keyuseitem)
            {
               useitem = true;
            }
            else if (event.key.keysym.sym == SDLK_LSHIFT)
            {
               player[0].run = true;
            }
            else if (event.key.keysym.sym == SDLK_TAB)
            {
               gui[ingamestatus]->visible = true;
            }
            else if (event.key.keysym.sym == SDLK_p)
            {
               SendPowerdown();
            }
            break;
            
         case SDL_KEYUP:
            if (event.key.keysym.sym == keys.keyleft)
            {
               player[0].moveleft = false;
            }
            else if (event.key.keysym.sym == keys.keyright)
            {
               player[0].moveright = false;
            }
            else if (event.key.keysym.sym == keys.keyforward)
            {
               player[0].moveforward = false;
            }
            else if (event.key.keysym.sym == keys.keyback)
            {
               player[0].moveback = false;
            }
            else if (event.key.keysym.sym == SDLK_LSHIFT)
            {
               player[0].run = false;
            }
            else if (event.key.keysym.sym == SDLK_TAB)
            {
               gui[ingamestatus]->visible = false;
            }
            break;
            
         case SDL_MOUSEMOTION:
            if ((event.motion.x != screenwidth / 2 || 
               event.motion.y != screenheight / 2) && !gui[consolegui]->visible &&
               (SDL_GetAppState() & SDL_APPINPUTFOCUS))
            {
               float zoomfactor = console.GetFloat("zoomfactor");
               float mousespeed = console.GetFloat("mousespeed") / 100.f;
               if (!guncam) 
                  zoomfactor = 1.f;
               
               // If you change these values, don't forget to update the HUD indicator with the new ones
               float minrot = -120.f;
               float maxrot = 120.f;
               
               player[0].pitch += event.motion.yrel / mousespeed / zoomfactor;
               if (player[0].pitch < -90) player[0].pitch = -90;
               if (player[0].pitch > 90) player[0].pitch = 90;
               
               player[0].rotation += event.motion.xrel / mousespeed / zoomfactor;
               if (player[0].rotation < minrot) player[0].rotation = minrot;
               if (player[0].rotation > maxrot) player[0].rotation = maxrot;
               SDL_WarpMouse(screenwidth / 2, screenheight / 2);
            }
            break;
            
         case SDL_MOUSEBUTTONDOWN:
            if (event.button.button == keys.mousefire)
            {
               player[0].leftclick = true;
               if (player[0].spectate)
                  SpectateNext();
            }
            else if (event.button.button == keys.mousenextweap)
            {
               player[0].currweapon = (player[0].currweapon + 1) % weaponslots.size();
            }
            else if (event.button.button == keys.mouseprevweap)
            {
               player[0].currweapon = player[0].currweapon == 0 ? weaponslots.size() - 1 : player[0].currweapon - 1;
            }
            else if (event.button.button == keys.mouseuse)
            {
               useitem = true;
            }
            else if (event.button.button == keys.mousezoom)
            {
               if (player[0].spectate)
                  SpectatePrev();
               else
                  guncam = !guncam;
            }
            break;
         case SDL_MOUSEBUTTONUP:
            if (event.button.button == keys.mousefire)
               player[0].leftclick = false;
            break;
            
         case SDL_QUIT:
            Quit();
      }
   }
   SDL_mutexV(clientmutex);
#endif
}


void Quit()
{
   SDL_mutexV(clientmutex); // This was probably grabbed by GUI update code before calling us
   Cleanup();
   exit(0);
}


void Cleanup()
{
   running = false;
#ifndef DEDICATED
   logout << "Waiting for netout thread to end" << endl;
   SDL_WaitThread(netout, NULL);
   logout << "Waiting for netin thread to end" << endl;
   SDL_WaitThread(netin, NULL);
#endif
   logout << "Waiting for server to end" << endl;
   SDL_WaitThread(serverthread, NULL);
   SDL_DestroyMutex(clientmutex);
   console.SaveToFile(userpath + "autoexec.cfg");
}


void Move(PlayerData& mplayer, Meshlist& ml, ObjectKDTree& kt)
{
   // In case we run into problems
   Vector3 old = mplayer.pos;
   
   // Calculate how far to move based on time since last frame
   Uint32 currtick = SDL_GetTicks();
   if (!mplayer.lastmovetick)
      mplayer.lastmovetick = currtick;
   int numticks = currtick - mplayer.lastmovetick;
   if (numticks > 50) numticks = 50;
   mplayer.lastmovetick = currtick;
   float step = (float)numticks * (console.GetFloat("movestep") / 1000.);
   
   bool moving = false;
   
   float direction;
   if (mplayer.moveforward)
   {
      direction = 1;
   }
   if (mplayer.moveback)
   {
      direction = -1;
   }
   
   if (mplayer.moveleft)
   {
      mplayer.turnspeed -= step / console.GetFloat("turnsmooth");
      if (mplayer.turnspeed < -2.f) mplayer.turnspeed = -2.f;
   }
   if (mplayer.moveright)
   {
      mplayer.turnspeed += step / console.GetFloat("turnsmooth");
      if (mplayer.turnspeed > 2.f) mplayer.turnspeed = 2.f;
   }
   if (mplayer.moveforward || mplayer.moveback)
      moving = true;
   if (!mplayer.moveleft && !mplayer.moveright)
      mplayer.turnspeed = 0;
   
   // Turning
   mplayer.facing += mplayer.turnspeed * step;
   if (mplayer.facing < 0.f) mplayer.facing += 360.f;
   if (mplayer.facing > 360.f) mplayer.facing -= 360.f;
   
   Vector3 d = Vector3(0, 0, 1);
   GraphicMatrix rot;
   if (mplayer.pitch > 89.99)
      rot.rotatex(89.99);
   else if (mplayer.pitch < -89.99)
      rot.rotatex(-89.99);
   else rot.rotatex(mplayer.pitch);
   rot.rotatey(-mplayer.facing);
   d.transform(rot);
   if (!console.GetBool("fly") && !mplayer.spectate)
      d.y = 0.f;
   d.normalize();
   
   float oldspeed = mplayer.speed;
   UnitData punit = units[mplayer.unit];
   float maxspeed = punit.maxspeed;
   float acceleration = punit.acceleration;
   float accmodifier = 1.f;
   if (mplayer.run)
   {
      maxspeed *= 1.5f;
      acceleration *= 2.f;
      if (mplayer.moveforward || mplayer.moveback)
         mplayer.temperature += float(numticks) * .03f;
   }
   if (mplayer.pos.y < mplayer.size)
   {
      maxspeed /= 1.5f;
      acceleration /= 1.5f;
   }
   
   if (moving) // Accelerate or decelerate properly
   {
      if (fabs(oldspeed) > maxspeed) accmodifier = -1;
      mplayer.speed += acceleration * accmodifier * step * direction;
      if (fabs(mplayer.speed) > maxspeed) mplayer.speed = maxspeed * direction;
   }
   else if (!floatzero(mplayer.speed)) // Decelerate them back to 0 speed
   {
      if (oldspeed > 0.f)
      {
         mplayer.speed -= acceleration * step;
         if (mplayer.speed < 0.f) mplayer.speed = 0.f;
      }
      if (oldspeed < 0.f)
      {
         mplayer.speed += acceleration * step;
         if (mplayer.speed > 0.f) mplayer.speed = 0.f;
      }
   }
   
   if (mplayer.spawned)
   {
      mplayer.pos.x += d.x * step * mplayer.speed;
      mplayer.pos.z -= d.z * step * mplayer.speed;
   }
   
   static const float threshold = .3f;
   static float gravity = .15f;
   
   if (console.GetBool("fly") || (mplayer.spectate && mplayer.spawned))
      mplayer.pos.y += d.y * step * mplayer.speed;
   else
   {
      bool downslope = false;
      bool flat = false;
      float movedist = mplayer.pos.distance(old);
      float hillthreshold = .1f * movedist;
      
      Vector3 legoffset = mplayer.pos - Vector3(0, mplayer.size, 0);
      Vector3 oldoffset = old - Vector3(0, mplayer.size, 0);
      Vector3 checkpos = legoffset;
      
      // Vicious hack to deal with problem where short moves would sometimes fail to properly determine whether they
      // were moving up or down hill.  This is mostly a problem for unrate-controlled servers.
      if (movedist < .5f)
      {
         Vector3 checkdiff = legoffset - oldoffset;
         checkdiff.normalize();
         checkdiff *= .5f;
         checkpos = oldoffset + checkdiff;
         hillthreshold = .05f;
      }
      
      locks.Write(ml);
      vector<Mesh*> check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, mplayer.pos, mplayer.size * 2.f * (threshold + hillthreshold + 1.f));
      
      Vector3 downcheck = coldet.CheckSphereHit(checkpos, checkpos, mplayer.size + hillthreshold, check);
      
      if (downcheck.magnitude() < 1e-5f)
      {
         downslope = true;
      }
      if (!downslope)
      {
         Vector3 upcheck = coldet.CheckSphereHit(checkpos, checkpos, mplayer.size - hillthreshold, check);
         if (upcheck.magnitude() < 1e-5f)
         {
            flat = true;
         }
      }
      
      
      Vector3 slopecheckpos = old;
      slopecheckpos.y -= mplayer.size * 2.f + mplayer.size * threshold;
      
      Vector3 slopecheck = coldet.CheckSphereHit(old, slopecheckpos, .01f, check);
      Vector3 groundcheck = coldet.CheckSphereHit(old - Vector3(0.f, mplayer.size, 0.f), old - Vector3(0.f, mplayer.size, 0.f), mplayer.size * 1.05f, check);
      locks.EndWrite(ml);
      
      if ((slopecheck.magnitude() > 1e-4f && groundcheck.magnitude() > 1e-4f) || mplayer.weight < .99f) // They were on the ground
      {
         // Fall damage if wanted (disabled for now)
//          if (mplayer.fallvelocity > .00001f)
//          {
//          }
         mplayer.fallvelocity = 0.f;
         if (mplayer.weight < .99f)
         {
            mplayer.pos.y -= step * 30.f * mplayer.weight;
         }
         else if (!floatzero(mplayer.speed) && downslope) // Moving downhill
         {
            // Give them a little push down to keep them on the ground
            mplayer.pos.y -= step * 2.f;
         }
         else if (!floatzero(mplayer.speed) && !flat) // Moving uphill
         {
            mplayer.pos = lerp(mplayer.pos, old, .75f);
         }
         else if (!floatzero(mplayer.speed)) // Mostly flat
         {
            mplayer.pos.y -= step;
         }
      }
      else
      {
         mplayer.fallvelocity += step * gravity;
         if (groundcheck.magnitude() > 1e-4f && mplayer.fallvelocity > 5)
            mplayer.fallvelocity = 5.f;
         mplayer.pos.y -= mplayer.fallvelocity * step;
      }
   }
   
   if (mplayer.weight < 0.f)
   {
      mplayer.weight += step * .01f;
   }
   else mplayer.weight = 1.f;
   
   ValidateMove(mplayer, old, ml, kt);
}


bool ValidateMove(PlayerData& mplayer, const Vector3& old, Meshlist& ml, ObjectKDTree& kt)
{
   bool success = true;
   // Did we hit something?  If so, deal with it
   if (!console.GetBool("ghost") && mplayer.weight > 0)
   {
      Vector3 oldmainoffset = old + Vector3(0, mplayer.size, 0);
      Vector3 legoffset = mplayer.pos - Vector3(0, mplayer.size, 0);
      Vector3 mainoffset = mplayer.pos + Vector3(0, mplayer.size, 0);
      Vector3 oldlegoffset = old - Vector3(0, mplayer.size, 0);
      
      // This should be removed from CollisionDetection at some point because we don't use it anymore
      bool exthit;
      
      locks.Write(ml);
      vector<Mesh*> check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, mplayer.pos, mplayer.size * 2.f);
      float checksize = mplayer.size;
      Vector3 adjust;// = coldet.CheckSphereHit(oldmainoffset, mainoffset, checksize, check, true, &exthit, false);
      Vector3 legadjust = coldet.CheckSphereHit(oldlegoffset, legoffset, checksize, check, true, &exthit, true);
      if (!floatzero(adjust.magnitude()) && !floatzero(legadjust.magnitude()))
         adjust = (adjust + legadjust) / 2.f;
      else adjust = adjust + legadjust;
      int count = 0;
      float slop = .01f;
      
      while (adjust.distance() > 1e-4f) // Not zero vector
      {
         check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, mainoffset - Vector3(0.f, mplayer.size, 0.f), mplayer.size * 2.f);
         mainoffset += adjust * (1 + count * slop);
         legoffset += adjust * (1 + count * slop);
         
         adjust = Vector3();//coldet.CheckSphereHit(oldmainoffset, mainoffset, checksize, check, true, &exthit);
         legadjust = coldet.CheckSphereHit(oldlegoffset, legoffset, checksize, check, true, &exthit);
         if (!floatzero(adjust.magnitude()) && !floatzero(legadjust.magnitude()))
            adjust = (adjust + legadjust) / 2.f;
         else adjust = adjust + legadjust;
         
         ++count;
         if (count > 2)
            slop *= 2.f;
         if (count > 10 && adjust.distance() > 1e-4f) // Damage control in case something goes wrong
         {
            logout << "Collision Detection Error " << adjust.distance() << endl;
            adjust.print();
            // Simply don't allow the movement at all
            //mplayer.pos = old;
            mainoffset = old + Vector3(0, mplayer.size, 0);
            locks.EndWrite(ml);
            success = false;
            break;
         }
      }
      locks.EndWrite(ml);
      mplayer.pos = mainoffset - Vector3(0, mplayer.size, 0);
   }
   return success;
}


vector<Mesh*> GetMeshesWithoutPlayer(const PlayerData* mplayer, Meshlist& ml, ObjectKDTree& kt,
                                     const Vector3& oldpos, const Vector3& newpos, const float size)
{
   locks.Read(ml);
   vector<Mesh*> check = kt.getmeshes(oldpos, newpos, size);
   AppendDynamicMeshes(check, ml);
   if (mplayer)
   {
      for (int part = 0; part < numbodyparts; ++part)
      {
         if (mplayer->mesh[part] != ml.end())
         {
            check.erase(remove(check.begin(), check.end(), &(*mplayer->mesh[part])), check.end());
         }
      }
      if (mplayer->rendermesh != ml.end())
         check.erase(remove(check.begin(), check.end(), &(*mplayer->rendermesh)), check.end());
   }
   locks.EndRead(ml);
   return check;
}


void AppendDynamicMeshes(vector<Mesh*>& appto, Meshlist& ml)
{
   for (Meshlist::iterator i = ml.begin(); i != ml.end(); ++i)
   {
      if (i->dynamic && i->collide)
      {
         appto.push_back(&(*i));
      }
   }
}


// No mutex needed, only called from mutex'd code
void SynchronizePosition()
{
#if 0
   player[0].pos = player[servplayernum].pos;
   return;
#endif
   static deque<OldPosition> oldpos;
   //static int smoothfactor = 1;   unused
   static int wayoffcount = 0;
   OldPosition temp;
   Uint32 currtick = SDL_GetTicks();
   Vector3 smoothserverpos;
   Vector3 smootholdpos;
   
   if (player.size() <= servplayernum || servplayernum <= 0)
      return;
   
   // Smooth out our ping so we don't get jumpy movement
   static deque<Uint32> pings;
   if (player[servplayernum].ping >= 0 && player[servplayernum].ping < 2000)
      pings.push_back(player[servplayernum].ping);
   while (pings.size() > 10)
      pings.pop_front();
   
   int ping = 0;
   for (deque<Uint32>::iterator i = pings.begin(); i != pings.end(); ++i)
      ping += *i;
   if (pings.size() != 0)
      ping /= pings.size();
   else ping = 0;

//#define SMOOTHPOS
#ifdef SMOOTHPOS
   // Also smooth out positions over a few frames to further reduce jumpiness
   static deque<int> recentoldpos;
   static deque<PlayerData> recentservinfo;
   
   recentservinfo.push_back(player[servplayernum]);
   while (recentservinfo.size() > smoothfactor)
      recentservinfo.pop_front();
   for (deque<PlayerData>::iterator i = recentservinfo.begin(); i != recentservinfo.end(); ++i)
      smoothserverpos += i->pos;
   smoothserverpos /= recentservinfo.size();
#endif
   while (oldpos.size() > 500)
      oldpos.pop_front();

   if (oldpos.size() < 1) // If oldpos is empty, populate it with a single object
   {
      temp.tick = currtick;
      temp.pos = player[0].pos;
   
      oldpos.push_back(temp);
   }
   
   int currindex = oldpos.size() / 2;
   int upper = oldpos.size();
   int lower = 0;
   
   while ((oldpos[currindex].tick != currtick - ping) && (upper - lower > 0))
   {
      if (oldpos[currindex].tick < currtick - ping)
      {
         if (lower != currindex)
            lower = currindex;
         else ++lower;
         currindex = (currindex + upper) / 2;
      }
      else
      {
         if (upper != currindex)
            upper = currindex;
         else --upper;
         currindex = (currindex + lower) / 2;
      }
   }
#if SMOOTHPOS
   recentoldpos.push_back(currindex);
   while (recentoldpos.size() > smoothfactor)
      recentoldpos.pop_front();
   for (deque<int>::iterator i = recentoldpos.begin(); i != recentoldpos.end(); ++i)
      smootholdpos += oldpos[*i].pos;
   smootholdpos /= recentoldpos.size();
   
   float difference = smoothserverpos.distance(smootholdpos);
   int tickdiff = abs(int(currtick - ping - oldpos[currindex].tick));
   float pingslop = 0.f;//.3f;
   float diffslop = difference - (float)tickdiff * pingslop;
   difference = diffslop > 0 ? diffslop : 0.f;
#else
   smoothserverpos = player[servplayernum].pos;
   smootholdpos = oldpos[currindex].pos;
   float difference = smoothserverpos.distance(smootholdpos);
   
#ifndef DEDICATED
   deque<float> diffs;
   float dispdiff = 0.f;
   diffs.push_back(difference);
   while (diffs.size() > 10)
      diffs.pop_front();
   for (size_t i = 0; i < diffs.size(); ++i)
      dispdiff += diffs[i];
   GUI* posvariance = gui[statsdisp]->GetWidget("posvariance");
   posvariance->text = "Pos Variance: " + ToString(difference);
#endif
#endif
   
   Vector3 posadj = smoothserverpos - smootholdpos;
   
#if SMOOTHPOS
   posadj.normalize();
   posadj *= difference;
#endif
   
   // Limit the max adjustment to syncmax in general so that we don't get nasty hitching while
   // moving.  The exception is if we're way off in which case some hitching is necessary
   float syncmax = console.GetFloat("syncmax") / 100.f;
   if (difference < 30.f || wayoffcount < console.GetInt("syncgrace"))
   {
      if (difference > syncmax)
      {
         posadj.normalize();
         posadj *= syncmax;
      }
      if (difference < 30.f)
         wayoffcount = 0;
      else
         ++wayoffcount;
   }
   else
   {
      posadj *= .1f;
   }
   
   Vector3 old = player[0].pos;
   player[0].pos += posadj;
   ValidateMove(player[0], old, meshes, kdtree);
   
   for (deque<OldPosition>::iterator i = oldpos.begin(); i != oldpos.end(); ++i)
   {
      i->pos += posadj;
   }
   
   temp.tick = currtick;
   temp.pos = player[0].pos;
   
   oldpos.push_back(temp);
}


void UpdateSpectatePosition()
{
   // Yes, the size_t below is a bogus cast, but the difference should never matter here
   if (player[spectateplayer].spawned && (size_t)spectateplayer != servplayernum)
   {
      player[0].pos = player[spectateplayer].pos;
      player[0].facing = player[spectateplayer].facing;
      player[0].pitch = player[spectateplayer].pitch;
      player[0].rotation = player[spectateplayer].rotation;
   }
}


void SpectateNext()
{
   int lastplayer = spectateplayer;
   if (!lastplayer)
   {
      if (player.size() < 3) // Only one player, will result in an infinite loop
         return;
      lastplayer = player.size() - 1;
   }
   ++spectateplayer;
   while (spectateplayer != lastplayer)
   {
      if ((size_t)spectateplayer > player.size() - 1)
         spectateplayer = 1;
      if (player[spectateplayer].spawned)
         break;
      ++spectateplayer;
   }
}

void SpectatePrev()
{
   int lastplayer = spectateplayer;
   if (!lastplayer)
   {
      if (player.size() < 3)
         return;
      lastplayer = 1;
   }
   --spectateplayer;
   while (spectateplayer != lastplayer)
   {
      if (spectateplayer < 1)
         spectateplayer = player.size() - 1;
      if (player[spectateplayer].spawned)
         break;
      --spectateplayer;
   }
}


void Animate()
{
   SDL_mutexP(clientmutex);
   // Delete meshes as requested by the net thread
   locks.Write(meshes);
   
   for (size_t i = 0; i < deletemeshes.size(); ++i)
   {
      if (deletemeshes[i] != meshes.end())
         meshes.erase(deletemeshes[i]);
   }
   deletemeshes.clear();
   
   for (size_t i = 0; i < additems.size(); ++i)
   {
      Item& newitem = additems[i];
      MeshPtr newmesh = meshcache->GetNewMesh(newitem.ModelFile());
      newmesh->Move(newitem.position);
      newmesh->SetGL();
      newmesh->dynamic = true;
      meshes.push_front(*newmesh);
      items.push_back(newitem);
      Item& curritem = items.back();
      curritem.mesh = meshes.begin();
      SDL_mutexV(clientmutex);
      spawnschanged = true;
   }
   additems.clear();
   
   
   // Meshes
#if defined(THREADANIM) && !defined(DEDICATED)
   size_t workercount = meshes.size() / console.GetInt("numthreads");
   size_t counter = 0, currworker = 0;
   Meshlist::iterator workerstart = meshes.begin();
#endif
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      i->updatedelay = (int)(player[0].pos.distance(i->GetPosition()) / 30.f);
      size_t maxdelay = console.GetInt("maxanimdelay");
      if (i->updatedelay > maxdelay)
         i->updatedelay = maxdelay;
#if defined(THREADANIM) && !defined(DEDICATED)
      if (counter == workercount)
      {
         vboworkers[currworker]->Run(workerstart, i, player[0].pos);
         if (currworker != (size_t)console.GetInt("numthreads") - 1)
            workerstart = i;
         ++currworker;
         counter = 0;
      }
      ++counter;
#else
      i->AdvanceAnimation(player[0].pos);
#endif
   }
#if defined(THREADANIM) && !defined(DEDICATED)
   animworkers.back()->Run(workerstart, meshes.end(), player[0].pos);
   
   // Wait for worker threads to finish
   for (size_t i = 0; i < animworkers.size(); ++i)
   {
      animworkers[i]->wait();
   }
#endif
   locks.EndWrite(meshes);
   
   
   // Particles
   vector<ParticleEmitter>::iterator i = emitters.begin();
   while (i != emitters.end())
   {
      if (i->Update(particles))
      {
         i = emitters.erase(i);
      }
      else ++i;
   }
   static int partupd = 100;
   UpdateParticles(particles, partupd, kdtree, meshes, player, player[0].pos);
   
   // Also need to update player models because they can be changed by the net thread
   // Note that they are inserted into meshes so they should be automatically animated
   for (size_t k = 1; k < player.size(); ++k)
   {
      if (k != (size_t)servplayernum)
         UpdatePlayerModel(player[k], meshes);
   }
   SDL_mutexV(clientmutex);
}


void UpdateServerList()
{
#ifndef DEDICATED
   Table* serverlist = (Table*)gui[serverbrowser]->GetWidget("serverlist");
   string values;
   vector<ServerInfo>::iterator i;
   if (!serverlist)
   {
      logout << "Failed to get pointer to serverlist" << endl;
      exit(-10);
   }
   SDL_mutexP(clientmutex);
   for (i = servers.begin(); i != servers.end(); ++i)
   {
      if (!i->inlist && i->haveinfo)
      {
         values = i->name + "|" + i->map + "|" + ToString(i->players) + "|" + ToString(i->maxplayers) + "|" + ToString(i->ping);
         serverlist->Add(values);
         i->inlist = true;
      }
   }
   SDL_mutexV(clientmutex);
#endif
}


void UpdatePlayerModel(PlayerData& p, Meshlist& ml, bool gl)
{
   if (!p.spawned || p.unit == numunits)
      return;
   
   locks.Write(ml);
   if (p.rendermesh == ml.end())
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/empty");
      newmesh->dynamic = true;
      newmesh->collide = false;
      if (gl)
         newmesh->SetGL();
      ml.push_front(*newmesh);
      p.rendermesh = ml.begin();
   }
   if (p.mesh[Legs] == ml.end())
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/legs");
      newmesh->dynamic = true;
      newmesh->render = false;
      ml.push_front(*newmesh);
      p.mesh[Legs] = ml.begin();
      p.mesh[Legs]->Scale(units[p.unit].scale);
      p.rendermesh->Add(&ml.front());
   }
   if (p.mesh[Torso] == ml.end())
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/torso");
      newmesh->dynamic = true;
      newmesh->render = false;
      ml.push_front(*newmesh);
      p.mesh[Torso] = ml.begin();
      p.mesh[Torso]->Scale(units[p.unit].scale);
      p.rendermesh->Add(&ml.front());
   }
   if (p.mesh[Hips] == ml.end())
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/hips");
      newmesh->dynamic = true;
      newmesh->render = false;
      ml.push_front(*newmesh);
      p.mesh[Hips] = ml.begin();
      p.mesh[Hips]->Scale(units[p.unit].scale);
      p.rendermesh->Add(&ml.front());
   }
   
   p.rendermesh->Move(p.pos); // Or our bounding box will get huge
   
   p.mesh[Legs]->Rotate(Vector3(0.f, p.facing, 0.f));
   p.mesh[Legs]->Move(p.pos);
   
   p.mesh[Torso]->Rotate(Vector3(-p.pitch, p.facing + p.rotation, p.roll));
   p.mesh[Torso]->Move(p.pos);
   
   p.mesh[Hips]->Rotate(Vector3(0/*-p.pitch*/, p.facing, p.roll));
   p.mesh[Hips]->Move(p.pos);
   
   if (p.mesh[LArm] == ml.end() && p.hp[LArm] > 0)
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/larm");
      newmesh->dynamic = true;
      newmesh->render = false;
      ml.push_front(*newmesh);
      p.mesh[LArm] = ml.begin();
      p.mesh[LArm]->Scale(units[p.unit].scale);
      p.rendermesh->Add(&ml.front());
   }
   if (p.mesh[RArm] == ml.end() && p.hp[RArm] > 0)
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/rarm");
      newmesh->dynamic = true;
      newmesh->render = false;
      ml.push_front(*newmesh);
      p.mesh[RArm] = ml.begin();
      p.mesh[RArm]->Scale(units[p.unit].scale);
      p.rendermesh->Add(&ml.front());
   }
   
   if (p.mesh[LArm] != ml.end())
   {
      p.mesh[LArm]->Rotate(Vector3(-p.pitch, p.facing + p.rotation, p.roll));
      p.mesh[LArm]->Move(p.pos);
   }
   
   if (p.mesh[RArm] != ml.end())
   {
      p.mesh[RArm]->Rotate(Vector3(-p.pitch, p.facing + p.rotation, p.roll));
      p.mesh[RArm]->Move(p.pos);
   }
   
   p.size = units[p.unit].size;
   p.rendermesh->CalcBounds();
   
   for (size_t i = 0; i < numbodyparts; ++i)
   {
      if (p.mesh[i] != ml.end())
      {
         if (floatzero(p.speed))
         {
            p.mesh[i]->SetAnimSpeed(1.f);
            p.mesh[i]->SetAnimation(0);
         }
         else if (p.speed > 0.f)
         {
            p.mesh[i]->SetAnimSpeed(p.speed);
            p.mesh[i]->SetAnimation(1);
         }
         else
         {
            p.mesh[i]->SetAnimSpeed(-p.speed);
            p.mesh[i]->SetAnimation(2);
         }
      }
   }
   locks.EndWrite(ml);
   
   // Add a particle to enemies to indicate their affiliation
   if (gl) // No reason to do this on the server
   {
      if (p.team != player[servplayernum].team)
      {
         if (!p.indicator)
         {
            MeshPtr indicatormesh = meshcache->GetNewMesh("models/enemyindicator");
            Particle part(*indicatormesh);
            part.ttl = 0;
            particles.push_back(part);
            p.indicator = &particles.back();
         }
         p.indicator->pos = p.pos;
      }
      else if (p.indicator) // Also remove in case we switched teams
      {
         p.indicator->ttl = 1;
         p.indicator = NULL;
      }
   }
}


// Note: Only the server passes in HitHandler, the client should always pass in NULL
// This is important because this function decides whether to do GL stuff based on that
// and if the server thread tries to do GL it will crash
// The server is also the only one to pass in Rewind
void UpdateParticles(list<Particle>& parts, int& partupd, ObjectKDTree& kt, Meshlist& ml, vector<PlayerData>& playervec, const Vector3& campos,
                     void (*HitHandler)(Particle&, Mesh*, const Vector3&),
                     void (*Rewind)(Uint32, const Vector3&, const Vector3&, const float))
{
   list<Particle> newparts;
   int updint = console.GetInt("partupdateinterval");
#ifndef DEDICATED
   if (!HitHandler && partupd >= updint)
   {
      if (!particlemesh)
      {
         particlemesh = meshcache->GetNewMesh("models/empty");
         particlemesh->dynamic = true;
      }
      particlemesh->Clear();
   }
#endif
   Vector3 oldpos, partcheck, hitpos;
   vector<Mesh*> hitmeshes;
   Mesh* hitmesh;
   if (partupd >= updint)
   {
      // Update particles
      list<Particle>::iterator j = parts.begin();
      locks.Write(ml);
      while (j != parts.end())
      {
         partcheck = Vector3();
         oldpos = j->Update();
         if (j->collide)
         {
            if (Rewind)
               Rewind(j->rewind, oldpos, j->pos, j->radius);
            vector<Mesh*> check = GetMeshesWithoutPlayer(&playervec[j->playernum], ml, kt, oldpos, j->pos, j->radius);
            partcheck = coldet.CheckSphereHit(oldpos, j->pos, j->radius, check, hitpos, hitmesh, &hitmeshes);
         }
         
         if (partcheck.distance2() < 1e-5) // Didn't hit anything
         {
            if (!HitHandler && j->tracer && j->lasttracer.distance2(j->pos) > 10000.f)
            {
               AddTracer(*j);
               j->lasttracer = j->pos;
            }
            if (j->expired)
            {
               j = parts.erase(j);
            }
            else
            {
#ifndef DEDICATED
               if (!HitHandler)
               {
                  j->Render(particlemesh.get(), player[0].pos);
               }
#endif
               ++j;
            }
         }
         else
         {
            if (HitHandler)
               HitHandler(*j, hitmesh, hitpos);
            else
            {
               if (j->tracer)
               {
                  j->pos = hitpos;
                  AddTracer(*j);
               }
            }
            j = parts.erase(j);
         }
      }
      locks.EndWrite(ml);
      partupd = 0;
#ifndef DEDICATED
      if (!HitHandler)
      {
         particles.insert(particles.end(), newparts.begin(), newparts.end());
      }
#endif
   }
   else ++partupd;
   if (Rewind)
      Rewind(0, Vector3(), Vector3(), 1e38f); // Rewind all to 0
}


void AddTracer(const Particle& p)
{
   Mesh newmesh(*p.tracer);
   Vector3 move = p.lasttracer - p.pos;
   float msize = move.magnitude();
   newmesh.ScaleZ(msize);
   Vector3 rots = RotateBetweenVectors(Vector3(0, 0, 1), move);
   newmesh.Rotate(rots);
   Particle tracepart(newmesh);
   tracepart.ttl = p.tracertime;
   tracepart.pos = p.pos;
   particles.push_back(tracepart);
}


float GetTerrainHeight(const float x, const float y)
{
   if ((x < 0 || x > mapwidth) || y < 0 || y > mapheight) return 0.f;
   int xindex = (int)floor(x / (float)tilesize);
   int yindex = (int)floor(y / (float)tilesize);
   
   float xweight = x / (float)tilesize - xindex;
   xweight = 1 - xweight;
   float yweight = y / (float)tilesize - yindex;
   yweight = 1 - yweight;
   
   float h0 = heightmap[xindex][yindex];
   float h1 = heightmap[xindex + 1][yindex];
   float h2 = heightmap[xindex][yindex + 1];
   float h3 = heightmap[xindex + 1][yindex + 1];
   
   float intermediate = lerp(h0, h1, xweight);
   float intermediate1 = lerp(h2, h3, xweight);
   
   return lerp(intermediate, intermediate1, yweight);
}


void UpdatePlayerList()
{
#ifndef DEDICATED
   SDL_mutexP(clientmutex);
   
   Table* playerlist = dynamic_cast<Table*>(gui[ingamestatus]->GetWidget("playerlist"));
   Table* lplayerlist = dynamic_cast<Table*>(gui[loadoutmenu]->GetWidget("playerlist"));
   
   playerlist->Clear();
   playerlist->Add("Name|Kills|Deaths|Ping");
   lplayerlist->Clear();
   lplayerlist->Add("ID|Name|Kills|Deaths|Ping");
   
   string add;
   for (size_t j = 0; j < 3; ++j)
   {
      if (j < 2)
      {
         playerlist->Add("Team " + ToString((j + 1) % 3) + "|||");
         lplayerlist->Add("Team " + ToString((j + 1) % 3) + "||||");
      }
      else
      {
         playerlist->Add(string("Spectators") + "|||");
         lplayerlist->Add(string("Spectators") + "||||");
      }
      for (size_t i = 1; i < player.size(); ++i)
      {
         if (player[i].connected && player[i].team == (int)(j + 1) % 3)
         {
            add = player[i].name + "|";
            add += ToString(player[i].kills) + "|";
            add += ToString(player[i].deaths) + "|";
            add += ToString(player[i].ping);
            playerlist->Add(add);
            lplayerlist->Add(ToString(i) + "|" + add);
         }
      }
   }
   
   SDL_mutexV(clientmutex);
#endif
}


// Must grab clientmutex before calling this function
void AppendToChat(int playernum, string line)
{
#ifndef DEDICATED
   TextArea *chatout = (TextArea*)gui[chat]->GetWidget("chatoutput");
   if (!chatout)
   {
      logout << "Error getting chat output widget" << endl;
      return;
   }
   if (chatteam)
      chatout->Append("[Team]");
   chatout->Append(player[playernum].name + ": " + line + "\n");
   chatout->ScrollToBottom();
#endif
}


void ShowGUI(int toshow)
{
#ifndef DEDICATED
   SDL_mutexP(clientmutex);
   for (size_t i = 0; i < gui.size(); ++i)
      gui[i]->visible = false;
   gui[toshow]->visible = true;
   if (console.GetBool("showfps"))
      gui[statsdisp]->visible = true;
   SDL_mutexV(clientmutex);
#endif
}


void ResetKeys()
{
   SDL_mutexP(clientmutex); // Otherwise we can end up firing after we respawn
   player[0].leftclick = player[0].rightclick = false;
   player[0].moveforward = player[0].moveback = player[0].moveleft = player[0].moveright = false;
   SDL_mutexV(clientmutex);
}


int CalculatePlayerWeight(const PlayerData& p)
{
   int total = 0;
   for (size_t j = 0; j < numbodyparts; ++j)
      total += p.weapons[j].Weight();
   total += p.item.Weight();
   total += units[p.unit].weight;
   return total;
}


Particle CreateShot(const Weapon& weapon, const Vector3& rots, const Vector3& start, Vector3 offset, const Vector3& viewoffset, int pnum)
{
   Vector3 dir(0, 0, -1);
   GraphicMatrix m;
   m.rotatex(-rots.x);
   m.rotatey(rots.y);
   dir.transform(m);
   float vel = weapon.Velocity();
   float acc = weapon.Acceleration();
   float w = weapon.ProjectileWeight();
   float rad = weapon.Radius();
   bool exp = weapon.Explode();
   
   MeshPtr weaponmesh = meshcache->GetNewMesh("models/" + weapon.ModelFile() + "/base");
   Particle part(0, start, dir, vel, acc, w, rad, exp, SDL_GetTicks(), *weaponmesh);
   part.origin = part.pos;
   part.playernum = pnum;
   part.weapid = weapon.Id();
   part.damage = weapon.Damage();
   part.dmgrad = weapon.Splash();
   part.collide = true;
      
   Vector3 rawoffset = offset;
   offset.transform(m);
   part.pos += offset;
   part.lasttracer = part.pos;
      
   // Note: weaponfocus should actually be configurable per-player
   Vector3 actualaim = Vector3(0, 0, -console.GetFloat("weaponfocus"));
   Vector3 difference = actualaim + rawoffset - viewoffset;
   Vector3 rot = RotateBetweenVectors(Vector3(0, 0, -1), difference);
   m.identity();
   m.rotatex(-rots.x + rot.x);
   m.rotatey(rots.y - rot.y);
   part.dir = Vector3(0, 0, -1);
   part.dir.transform(m);
   return part;
}


// Note that any meshes that don't significantly slow things down probably don't need to be cached here
// (although using the cached loading mechanism for them is still a good idea)
void CacheMeshes()
{
   vector<string> tocache;
   
   tocache.push_back("models/nemesis/legs");
   tocache.push_back("models/nemesis/torso");
   tocache.push_back("models/nemesis/larm");
   tocache.push_back("models/nemesis/rarm");
   tocache.push_back("models/nemesis/hips");
   tocache.push_back("models/ultra/legs");
   tocache.push_back("models/ultra/torso");
   tocache.push_back("models/ultra/larm");
   tocache.push_back("models/ultra/rarm");
   tocache.push_back("models/ultra/hips");
   tocache.push_back("models/omega/legs");
   tocache.push_back("models/omega/torso");
   tocache.push_back("models/omega/larm");
   tocache.push_back("models/omega/rarm");
   tocache.push_back("models/omega/hips");
   
   tocache.push_back("models/explosion");
   tocache.push_back("models/spawn");
   tocache.push_back("models/base");
   
   for (size_t i = 0; i < tocache.size(); ++i)
      meshcache->GetNewMesh(tocache[i]);
}


void UpdatePlayer()
{
   // Update player position
   SDL_mutexP(clientmutex);
      
   if (player[0].spectate && (size_t)spectateplayer != servplayernum && player[0].spawned)
      UpdateSpectatePosition();
   else
   {
      Move(player[0], meshes, kdtree);
   }
   PlayerData localplayer = player[0];
      
      // Set position for sound listener
   GraphicMatrix r;
   r.rotatex(-localplayer.pitch);
   r.rotatey(localplayer.facing + localplayer.rotation);
   Vector3 slook(0, 0, -1.f);
   slook.transform(r);
#ifndef DEDICATED
   resman.soundman.SetListenDir(slook);
   resman.soundman.SetListenPos(localplayer.pos);
#endif
      
   if (!player[0].spectate)
   {
      UpdatePlayerModel(player[0], meshes);
   }
      
   SDL_mutexV(clientmutex);
      
   int weaponslot = weaponslots[localplayer.currweapon];
   Weapon& currplayerweapon = localplayer.weapons[weaponslot];
   if (localplayer.leftclick && 
       (SDL_GetTicks() - localplayer.lastfiretick[weaponslot] >= currplayerweapon.ReloadTime()) &&
       (currplayerweapon.ammo != 0) && localplayer.hp[weaponslot] > 0 && localplayer.spawned)
   {
#ifndef DEDICATED
      SendFire();
#endif
      SDL_mutexP(clientmutex);
#ifndef DEDICATED
      if (currplayerweapon.Id() != Weapon::NoWeapon)
         resman.soundman.PlaySound(currplayerweapon.FireSound(), player[0].pos);
#endif
      player[0].lastfiretick[weaponslot] = SDL_GetTicks();
      if (player[0].weapons[weaponslot].ammo > 0) // Negative ammo value indicates infinite ammo
         player[0].weapons[weaponslot].ammo--;
         
      Vector3 startpos = localplayer.pos;
      Vector3 rot(localplayer.pitch, localplayer.facing + localplayer.rotation, 0.f);
      Vector3 offset = units[localplayer.unit].weaponoffset[weaponslot];
      Particle part = CreateShot(currplayerweapon, rot, startpos, offset, units[localplayer.unit].viewoffset);
         // Add tracer if necessary
      if (currplayerweapon.Tracer() != "")
      {
         part.tracer = MeshPtr(new Mesh("models/" + currplayerweapon.Tracer() + "/base", resman));
         part.tracertime = currplayerweapon.TracerTime();
      }
      particles.push_back(part);
      SDL_mutexV(clientmutex);
   }
}


PlayerData* PlayerFromMesh(Mesh* m, vector<PlayerData>& p, Meshlist::iterator invalid)
{
   size_t psize = p.size();
   for (size_t i = 1; i < psize; ++i)
   {
      if ((p[i].rendermesh != invalid) && (&(*p[i].rendermesh) == m))
         return &p[i];
      for (size_t j = 0; j < numbodyparts; ++j)
      {
         if ((p[i].mesh[j] != invalid) && (&(*p[i].mesh[j]) == m))
            return &p[i];
      }
   }
   return NULL;
}


bool PrimaryGUIVisible()
{
#ifndef DEDICATED
   // A bit counterintuitive...
   return !(!gui[mainmenu]->visible && !gui[loadprogress]->visible && !gui[loadoutmenu]->visible &&
         !gui[settings]->visible && !gui[endgame]->visible && !gui[serverbrowser]->visible && !gui[credits]->visible);
#endif
   return false;
}


void StartBGMusic()
{
#ifndef DEDICATED
   //if (!musicsource)
      musicsource = ALSourcePtr(new ALSource());
   musicsource->loop = AL_TRUE;
   musicsource->rolloff = 0.f;
   //musicsource->relative = AL_TRUE;
   musicsource->gain = console.GetFloat("musicvol") / 100.f;
   musicsource->Play(resman.soundman.GetBuffer("sounds/bgmusic.ogg"));
#endif
}


void RegenFBOList()
{
#ifndef DEDICATED
   int fbodim = fbodims[2];
   int counter = 0;
   FBO dummyfbo;
   impmeshes.clear();
   impfbolist.clear();
   locks.Write(meshes);
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      if (!floatzero(i->impdist))
      {
         if (counter >= fbostarts[2])
            fbodim = fbodims[2];
         else if (counter >= fbostarts[1])
            fbodim = fbodims[1];
         else fbodim = fbodims[0];
         dummyfbo = FBO(fbodim, fbodim, false, &resman.texhand);
         impfbolist.push_back(dummyfbo);
         i->impostorfbo = counter;
         impmeshes.push_back(&(*i));
         ++counter;
      }
      i->GenVbo();
   }
   locks.EndWrite(meshes);
#endif
}


bool NearSpawn(PlayerData& p, vector<SpawnPointData>& allspawns)
{
   for (size_t i = 0; i < allspawns.size(); ++i)
   {
      if (p.pos.distance(allspawns[i].position) < 400.f && allspawns[i].team == p.team)
      {
         return true;
      }
   }
   return false;
}


vector<SpawnPointData> GetSpawns(vector<Item>& allitems)
{
   vector<SpawnPointData> retval;
   for (size_t i = 0; i < allitems.size(); ++i)
   {
      if (allitems[i].Type() == Item::SpawnPoint)
      {
         SpawnPointData sp;
         sp.name = "Spawn " + ToString(i);
         sp.position = allitems[i].mesh->GetPosition();
         sp.team = allitems[i].team;
         retval.push_back(sp);
      }
   }
   return retval;
}


/****************************************************************
The following are all utility functions
****************************************************************/


void SDL_GL_Enter2dMode()
{
#ifndef DEDICATED
   int screenwidth = console.GetInt("screenwidth");
   int screenheight = console.GetInt("screenheight");
   // Make the viewport cover the whole window
   glViewport(0, 0, screenwidth, screenheight);

   glMatrixMode(GL_PROJECTION);
   glPushMatrix();
   glLoadIdentity();
   
   glOrtho(0.0, screenwidth, screenheight, 0.0, -1.0, 1.0);
   
   glMatrixMode(GL_MODELVIEW);
   glPushMatrix();
   glLoadIdentity();
   
   glColor4f(1, 1, 1, 1);
   glPushAttrib(GL_ENABLE_BIT);
   glEnable(GL_BLEND);
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   glEnable(GL_TEXTURE_2D);
   glDisable(GL_DEPTH_TEST);
   glDisable(GL_LIGHTING);
   //glDisable(GL_FOG);
   //glDisable(GL_CULL_FACE);
#endif
}


void SDL_GL_Exit2dMode()
{
#ifndef DEDICATED
   glMatrixMode(GL_PROJECTION);
   glPopMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   glPopMatrix();
   
   glPopAttrib();
#endif
}





void GLError()
{
#ifndef DEDICATED
   GLenum error = glGetError();
   if (error == GL_NO_ERROR)
   {
      logout << "No errors" << endl;
   }
   else if (error == GL_INVALID_ENUM)
   {
      logout << "GL_INVALID_ENUM" << endl;
   }
   else if (error == GL_INVALID_VALUE)
   {
      logout << "GL_INVALID_VALUE" << endl;
   }
   else if (error == GL_INVALID_OPERATION)
   {
      logout << "GL_INVALID_OPERATION" << endl;
   }
   else if (error == GL_STACK_OVERFLOW)
   {
      logout << "GL_STACK_OVERFLOW" << endl;
   }
   else if (error == GL_STACK_UNDERFLOW)
   {
      logout << "GL_STACK_UNDERFLOW" << endl;
   }
   else if (error == GL_OUT_OF_MEMORY)
   {
      logout << "GL_OUT_OF_MEMORY" << endl;
   }
   else if (error == GL_TABLE_TOO_LARGE)
   {
      logout << "GL_TABLE_TOO_LARGE" << endl;
   }
#endif
}


