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
// Copyright 2008, 2011 Ben Nemec
// @End License@


// Main loop and basic game logic - a rather large file that could probably afford to be
// split up somewhat, but it hasn't really been a problem thus far.

// Necessary include(s)
#include "defines.h"
#include "globals.h"
#include "renderdefs.h"
#include "ClientMap.h"
#include "serverdefs.h"
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

using std::ios_base;

// Notes: Currently seems to be detrimental to performance, will need updates to
// work if it is needed in the future because these worker threads have been
// repurposed to thread VBO updates in the render code.
//#define THREADANIM

/* Do anything function that can be handy for debugging various things
   in a more limited context than the entire engine.*/
void Debug()
{
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
   // Ahh, something is wrong here.  I assume this if was to prevent starting the music when editing, but if so it's still
   // not right because it should be coming after the Windows-specific stuff.
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
   netcode = ClientNetCodePtr(new ClientNetCode());
   
   ShowGUI(updateprogress);
   Updater upd;
   upd.DoUpdate();
#else
   server = true;
   serverthread = SDL_CreateThread(Server, NULL);
#endif
   
   ShowGUI(mainmenu);
   
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
   // Hmm, this cast might be a bad idea...
   userpath = (char*)szPath;
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
   CreateDirectory((TCHAR*)userpath.c_str(), NULL);
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
   console.Parse("set botsmove 1", false);
   console.Parse("set overheat 1", false);
   console.Parse("set syncmax 10", false);
   console.Parse("set name Nooblet", false);
   console.Parse("set syncgrace 15", false);
   console.Parse("set maxanimdelay 25", false);
   console.Parse("set timeout 10", false);
   console.Parse("set numthreads 2", false);
   console.Parse("set checkupdates 1", false);
   console.Parse("set caminterp 50", false);
   console.Parse("set recordfps 30", false);

   // Default keybindings
   console.Parse("set keyforward " + ToString(SDLK_w), false);
   console.Parse("set keyback " + ToString(SDLK_s), false);
   console.Parse("set keyleft " + ToString(SDLK_a), false);
   console.Parse("set keyright " + ToString(SDLK_d), false);
   console.Parse("set keyloadout " + ToString(SDLK_l), false);
   console.Parse("set keyuseitem " + ToString(SDLK_u), false);
   console.Parse("set mousefire " + ToString(SDL_BUTTON_LEFT), false);
   console.Parse("set mousezoom " + ToString(SDL_BUTTON_RIGHT), false);
   console.Parse("set mouseuse " + ToString(SDL_BUTTON_MIDDLE), false);
   console.Parse("set mousenextweap " + ToString(SDL_BUTTON_WHEELDOWN), false);
   console.Parse("set mouseprevweap " + ToString(SDL_BUTTON_WHEELUP), false);

   recorder = RecorderPtr(new Recorder());
   console.Parse("set record 0", false); // This requires the recorder pointer to have been set
   replayer = ReplayerPtr(new Replayer());
   console.Parse("set replay @none@", false);
   
   // Variables that cannot be set from the console
#ifndef DEDICATED
   lasttick = SDL_GetTicks();
   frames = 0;
   noiseres = 128;
   staticdrawdist = false;
#endif
   running = true;
   spawnschanged = true;
   winningteam = 0;
   weaponslots.push_back(Torso);
   weaponslots.push_back(LArm);
   weaponslots.push_back(RArm);
   meshcache = MeshCachePtr(new MeshCache(resman));
   
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

   ReadConfig();

   // Cvars where we want to change the default value
   if (console.GetInt("syncmax") == 50)
      console.Parse("setsave syncmax 10");
   if (console.GetInt("caminterp") == 1)
      console.Parse("setsave caminterp 50");

   // Can't create players until after SDL has been init'd in ReadConfig
   PlayerData dummy = PlayerData(meshes); // Local player is always index 0
   dummy.unit = Nemesis;
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
   gui[updateprogress] = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman, "gui/updateprogress.xml")); 
   
   
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
      NTreeReader read("units/" + units[i].file);
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
   else
   {
      logout << "SDL Initialized" << endl;
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
   else
   {
      logout << "Initialized SDL_net" << endl;
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
      logout << "Failed to init glew: " << glewGetErrorString(err) << endl;
      exit(-2);
   }
   logout << "Glew init successful, using version: " << glewGetString(GLEW_VERSION) << endl;
   if (!GLEW_EXT_framebuffer_object)
   {
      logout << "We don't have EXT_framebuffer_object.  This is fatal." << endl;
      exit(-3);
   }
   if (!GLEW_ARB_vertex_buffer_object)
   {
      logout << "We don't have ARB_vertex_buffer_object.  This is fatal." << endl;
      exit(-4);
   }
   if (!GLEW_ARB_depth_texture)
   {
      logout << "We don't have ARB_depth_texture.  This is fatal." << endl;
      exit(-5);
   }
   if (!GLEW_ARB_shadow)
   {
      logout << "We don't have ARB_shadow.  This is fatal." << endl;
      exit(-6);
   }
   if (!GLEW_ARB_fragment_shader)
   {
      logout << "We don't have ARB_fragment_shader.  This is fatal." << endl;
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

      // Check if a replay was requested
      string replayname;
      replayname = console.GetString("replay");
      if (replayname != "@none@")
      {
         replayer->SetActive(replayname, true);
      }
      else
      {
         replayer->SetActive("", false);
      }

      // Maps have to be loaded in this thread, so the server signals us to do it
      if (serverloadmap)
      {
         servermap = MapPtr(new Map(servermapname));
         servermap->Load();
         serverloadmap = 0;
      }
      
#ifndef DEDICATED
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
         InitGUI();
      }
      
      // Check for end of game
      if (winningteam)
      {
         GUI* gotext = gui[endgame]->GetWidget("GameOverText");
         gotext->text = "Team " + ToString(winningteam) + " wins!";
         ShowGUI(endgame);
      }

      replayer->Update();

      netcode->Update();

      if (!PrimaryGUIVisible())
         UpdatePlayer();

      GUIUpdate();

      // Update any animated objects
      Animate();

      // update the screen
      Repaint();

      // Write replay file if active
      recorder->WriteFrame();

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
   
   if (gui[loadoutmenu]->visible)
   {
      if (spawnschanged)
      {
         ComboBox *spawnpointsbox = (ComboBox*)gui[loadoutmenu]->GetWidget("SpawnPoints");
         GUI* maplabel = gui[loadoutmenu]->GetWidget("Map");
         spawnpointsbox->Clear();
         maplabel->ClearChildren();
         spawnbuttons.clear();
         availablespawns = teamspawns;
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
   if (SDL_GetTicks() - netcode->lasthit < console.GetInt("hitindtime"))
   {
      hitind->visible = true;
   }
   else
      hitind->visible = false;
   
   GUI* servfps = gui[statsdisp]->GetWidget("serverfps");
   servfps->text = "Server FPS: " + ToString(netcode->serverfps);
   GUI* bpslabel = gui[statsdisp]->GetWidget("serverbps");
   bpslabel->text = "Server BPS: " + ToString(netcode->serverbps);
   
   if (gui[mainmenu]->visible)
   {
      GUI* resumebutton = gui[mainmenu]->GetWidget("resumebutton");
      if (netcode->Connected())
         resumebutton->visible = true;
      else
         resumebutton->visible = false;
   }
   
   // For some reason killtable->Clear() is extremely slow (2-5 ms), so we can't do this every
   // time through.  Hence the messageschanged flag.
   // This may no longer be true, but there's no reason to change it now
   if (!PrimaryGUIVisible() && netcode->messageschanged)
   {
      while (netcode->servermessages.size() > 6)
         netcode->servermessages.pop_front();
      
      Table* messagetable = dynamic_cast<Table*>(gui[hud]->GetWidget("servermessages"));
      messagetable->Clear();
      for (size_t i = 0; i < netcode->servermessages.size(); ++i)
         messagetable->Add(netcode->servermessages[i]);
      netcode->messageschanged = 0;
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
      offset.transform(m);

      // Always create the sight particle so we can use it for collision detection, but only add it to the particle list if necessary
      Vector3 sightoffset = units[player[0].unit].weaponoffset[weaponslots[player[0].currweapon]];
      Weapon tempweap(Weapon::Sight);
      Vector3 playerrot(player[0].pitch, player[0].facing + player[0].rotation, 0.f);
      Particle part = CreateShot(tempweap, playerrot, player[0].pos, sightoffset, units[player[0].unit].viewoffset);
      part.origin = part.pos;
      part.playernum = 0;
      part.collide = true;
      part.ttl = 100;
      part.lasttick = SDL_GetTicks() - 1; // Ensure that we do a real update, otherwise the update can happen after 0 ticks and the sight is invisible
      
      part.lasttracer = part.pos;
      part.tracer = "models/sight/base";
      part.clientonly = true;

      if (!guncam)
      {
         particles.push_back(part);
      }

      Vector3 dir = part.dir;
      dir.normalize();
      Vector3 checkstart = part.pos;
      Vector3 checkend = checkstart + dir * 5000.f;
      vector<Mesh*> check = GetMeshesWithoutPlayer(&player[servplayernum], meshes, kdtree, checkstart, checkend, .01f);
      Vector3 dummy;
      Mesh* hitmesh;
      coldet.CheckSphereHit(checkstart, checkend, .01f, check, currmap, dummy, hitmesh);
      PlayerData* p = PlayerFromMesh(hitmesh, player, meshes.end());

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

      GUI* reticle = gui[hud]->GetWidget("reticle");
      if (!reticle)
      {
         logout << "Error getting reticle widget" << endl;
      }
      else
      {
         if (!guncam && !editor)
         {
            reticle->visible = false;
         }
         else
         {
            reticle->visible = true;
         }
      }
   }
#endif
}


bool GUIEventHandler(SDL_Event &event)
{
#ifndef DEDICATED
   // Mini keyboard handler to deal with the console and chat
   bool eatevent = false;
   GUI* chatin = gui[chat]->GetWidget("chatinput");
   if (!chatin)
   {
      logout << "Error getting chat input widget" << endl;
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
                     teamlabel->visible = true;
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
                  GUI* teamlabel = gui[chat]->GetWidget("chatteam");
                  netcode->SendChat(chatin->text, teamlabel->visible);
                  AppendToChat(0, chatin->text, teamlabel->visible);
                  chatin->text = "";
                  chatin->visible = false;
                  teamlabel->visible = false;
               }
               eatevent = true;
               break;
            case SDLK_F12:
               TakeScreenshot();
               break;
            default:
               break;
         }
      
   };
   
   if (eatevent) return eatevent;
   
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
   else if (gui[updateprogress]->visible)
   {
      SDL_ShowCursor(1);
      gui[credits]->ProcessEvent(&event);
      eatevent = true;
   }
   
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
               vector<SpawnPointData> allspawns = currmap->SpawnPoints();
               vector<SpawnPointData> itemspawns = GetSpawns(items);
               allspawns.insert(allspawns.end(), itemspawns.begin(), itemspawns.end());
               if (!player[0].spawned || NearSpawn(player[0], allspawns))
               {
                  gui[loadoutmenu]->visible = true;
                  gui[hud]->visible = false;
                  netcode->SendLoadout();
               }
            }
            else if (event.key.keysym.sym == keys.keyuseitem)
            {
               netcode->UseItem();
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
               netcode->SendPowerdown();
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
               if (player[0].pitch <= -89.99) player[0].pitch = -89.99;
               if (player[0].pitch >= 89.99) player[0].pitch = 89.99;
               
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
               netcode->UseItem();
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
#endif
}


void Quit()
{
   Cleanup();
   exit(0);
}


void Cleanup()
{
   running = false;
   logout << "Waiting for server to end" << endl;
   SDL_WaitThread(serverthread, NULL);
   console.SaveToFile(userpath + "autoexec.cfg");
}


void Move(PlayerData& mplayer, Meshlist& ml, ObjectKDTree& kt, MapPtr movemap)
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
      
      Vector3 checkpos = mplayer.pos;

      // Vicious hack to deal with problem where short moves would sometimes fail to properly determine whether they
      // were moving up or down hill.  This is mostly a problem for unrate-controlled servers.
      if (movedist < .5f)
      {
         Vector3 checkdiff = mplayer.pos - old;
         checkdiff.normalize();
         checkdiff *= .5f;
         checkpos = old + checkdiff;
         hillthreshold = .05f;
      }
      
      vector<Mesh*> check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, mplayer.pos, mplayer.size * 2.f * (threshold + hillthreshold + 1.f));

      bool downcheck = coldet.CheckSphereHit(checkpos, checkpos, mplayer.size * 2.f + hillthreshold, check, movemap);

      if (!downcheck)
      {
         downslope = true;
      }
      if (!downslope)
      {
         bool upcheck = coldet.CheckSphereHit(checkpos, checkpos, mplayer.size * 2.f - hillthreshold, check, movemap);
         if (!upcheck)
         {
            flat = true;
         }
      }
      
      Vector3 slopecheckpos = old;
      slopecheckpos.y -= mplayer.size * 2.f + mplayer.size * 2.f * threshold;
      
      bool slopecheck = coldet.CheckSphereHit(old, slopecheckpos, .01f, check, movemap);
      bool groundcheck = coldet.CheckSphereHit(old, old, mplayer.size * 2.05f, check, movemap);
      
      if ((slopecheck && groundcheck) || mplayer.weight < .99f) // They were on the ground
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
         if (groundcheck && mplayer.fallvelocity > 5)
            mplayer.fallvelocity = 5.f;
         mplayer.pos.y -= mplayer.fallvelocity * step;
      }
   }
   
   if (mplayer.weight < 0.f)
   {
      mplayer.weight += step * .01f;
   }
   else mplayer.weight = 1.f;
   
   ValidateMove(mplayer, old, ml, kt, movemap);
}


bool ValidateMove(PlayerData& mplayer, Vector3 old, Meshlist& ml, ObjectKDTree& kt, MapPtr movemap)
{
   bool nohit = true;
   // Did we hit something?  If so, deal with it
   if (!console.GetBool("ghost") && mplayer.weight > 0)
   {
      Vector3 newpos = mplayer.pos;
      float checksize = mplayer.size * 2.f;
      Vector3vec adjust;
      int count = 0;
      float slop = .01f;

      bool done = false;
      while (!done)
      {
         vector<Mesh*> check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, newpos, checksize);

         bool hit = coldet.CheckSphereHit(old, newpos, checksize, check, movemap, &adjust);

         if (!hit) // Move is okay
         {
            break;
         }
         // Need to adjust move
         newpos += adjust[0] * (1.f + count * slop);
         nohit = false;

         bool innerdone = (adjust.size() < 2);
         while (!innerdone) // Hit a curved surface, apply composite adjustment
         {
            check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, newpos, checksize);

            Vector3 saveadj1 = adjust[1];

            hit = coldet.CheckSphereHit(old, newpos, checksize, check, movemap, &adjust);

            if (!hit)
            {
               old = newpos; // Half of the move is validated
               newpos += saveadj1;// * (1.f + count * slop); // This one has to be exact

               check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, newpos, checksize);

               hit = coldet.CheckSphereHit(old, newpos, checksize, check, movemap, &adjust);

               if (!hit) // Our position is now collision-free
               {
                  innerdone = true;
                  done = true;
               }
               else // Check whether to stay in curved surface loop, or return to normal collision detection
               {
                  newpos += adjust[0];// * (1.f + count * slop);
                  if (adjust.size() < 2) // We didn't hit a curved surface, go back to normal collision detection
                  {
                     innerdone = true;
                  }
                  // Otherwise we go back to the beginning of this loop and resolve the new curved surface collision
               }
            }
            else // We hit something, if it wasn't curved then break the inner loop
            {
               newpos += adjust[0];// * (1.f + count * slop);
               if (adjust.size() < 2)
                  innerdone = true;
            }

            ++count;
            if (count > 2)
               slop *= 2.f;
            if ((count > 10) && hit)
               innerdone = true;
         }
         
         ++count;
         if (count > 2)
            slop *= 2.f;
         if ((count > 10) && hit) // Damage control in case something goes wrong
         {
            logout << "Collision Detection Error " << adjust[0].distance() << endl;
            adjust[0].print();
            // Simply don't allow the movement at all
            newpos = old;
            break;
         }
      }
      mplayer.pos = newpos;
   }
   return nohit;
}


vector<Mesh*> GetMeshesWithoutPlayer(const PlayerData* mplayer, Meshlist& ml, ObjectKDTree& kt,
                                     const Vector3& oldpos, const Vector3& newpos, const float size)
{
   vector<Mesh*> check = kt.getmeshes(oldpos, newpos, size);
   AppendDynamicMeshes(check, ml);
   if (mplayer)
   {
      for (int part = 0; part < numbodyparts; ++part)
      {
         if (mplayer->mesh[part] != ml.end())
         {
            check.erase(std::remove(check.begin(), check.end(), &(*mplayer->mesh[part])), check.end());
         }
      }
   }
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
   float maxdiff = 30.f;
   if (difference < maxdiff || wayoffcount < console.GetInt("syncgrace"))
   {
      if (difference > syncmax)
      {
         posadj.normalize();
         posadj *= syncmax * 10 * (difference / maxdiff);
      }
      if (difference < maxdiff)
         wayoffcount = 0;
      else
         ++wayoffcount;
   }
   else
   {
      posadj *= .1f;
   }

   if (!floatzero(player[0].speed))
   {
      Vector3 old = player[0].pos;
      player[0].pos += posadj;
      ValidateMove(player[0], old, meshes, kdtree, currmap);

      for (deque<OldPosition>::iterator i = oldpos.begin(); i != oldpos.end(); ++i)
      {
         i->pos += posadj;
      }
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
   // Also need to update player models because they can be changed by the net thread
   // Note that they are inserted into meshes so they should be automatically animated
   for (size_t k = 1; k < player.size(); ++k)
   {
      if (k != (size_t)servplayernum)
         UpdatePlayerModel(player[k], meshes);
   }
   
   // Meshes
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      i->updatedelay = (int)(player[0].pos.distance(i->GetPosition()) / 30.f);
      size_t maxdelay = console.GetInt("maxanimdelay");
      if (i->updatedelay > maxdelay)
         i->updatedelay = maxdelay;
      i->Update(player[0].pos);
   }
   
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
   for (i = netcode->servers.begin(); i != netcode->servers.end(); ++i)
   {
      if (!i->inlist && i->haveinfo)
      {
         values = i->name + "|" + i->map + "|" + ToString(i->players) + "|" + ToString(i->maxplayers) + "|" + ToString(i->ping);
         serverlist->Add(values);
         i->inlist = true;
      }
   }
#endif
}


void UpdatePlayerModel(PlayerData& p, Meshlist& ml, bool gl)
{
   if (!p.spawned || p.unit == numunits)
      return;

   if (p.mesh[Legs] == ml.end())
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/legs");
      newmesh->dynamic = true;
      ml.push_front(*newmesh);
      p.mesh[Legs] = ml.begin();
      p.mesh[Legs]->Scale(units[p.unit].scale);
   }
   if (p.mesh[Torso] == ml.end())
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/torso");
      newmesh->dynamic = true;
      ml.push_front(*newmesh);
      p.mesh[Torso] = ml.begin();
      p.mesh[Torso]->Scale(units[p.unit].scale);
   }
   if (p.mesh[Hips] == ml.end())
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/hips");
      newmesh->dynamic = true;
      ml.push_front(*newmesh);
      p.mesh[Hips] = ml.begin();
      p.mesh[Hips]->Scale(units[p.unit].scale);
   }

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
      ml.push_front(*newmesh);
      p.mesh[LArm] = ml.begin();
      p.mesh[LArm]->Scale(units[p.unit].scale);
   }
   if (p.mesh[RArm] == ml.end() && p.hp[RArm] > 0)
   {
      MeshPtr newmesh = meshcache->GetNewMesh("models/" + units[p.unit].file + "/rarm");
      newmesh->dynamic = true;
      ml.push_front(*newmesh);
      p.mesh[RArm] = ml.begin();
      p.mesh[RArm]->Scale(units[p.unit].scale);
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
            p.mesh[i]->reverseanim = false;
            p.mesh[i]->SetAnimSpeed(p.speed);
            p.mesh[i]->SetAnimation(1);
         }
         else
         {
            p.mesh[i]->reverseanim = true;
            p.mesh[i]->SetAnimSpeed(-p.speed);
            p.mesh[i]->SetAnimation(1);
         }
      }
   }
   
   // Add a particle to enemies to indicate their affiliation
   if (gl) // No reason to do this on the server
   {
      if ((!player[0].spectate && p.team != player[servplayernum].team) ||
         (player[0].spectate && p.team != player[spectateplayer].team))
      {
         if (!p.indicator)
         {
            MeshPtr indicatormesh = meshcache->GetNewMesh("models/enemyindicator");
            Particle part(*indicatormesh);
            part.ttl = -1;
            particles.push_back(part);
            p.indicator = &particles.back();
         }
         // This has caused memory corruption multiple times - find a better way to do it?
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
   MapPtr localmap;
   if (HitHandler)
      localmap = servermap;
   else
      localmap = currmap;
   
   int updint = console.GetInt("partupdateinterval");
#ifndef DEDICATED
   if (!HitHandler && partupd >= updint)
   {
      if (!particlemesh)
      {
         particlemesh = meshcache->GetNewMesh("models/empty");
      }
      particlemesh->Clear();
   }
#endif
   Vector3 oldpos, hitpos;
   bool partcheck;
   vector<Mesh*> hitmeshes;
   Mesh* hitmesh;
   if (partupd >= updint)
   {
      // Update particles
      list<Particle>::iterator j = parts.begin();
      while (j != parts.end())
      {
         // Erase particles that hit something the next time through this function so that they still get rendered
         // This is particularly important for things like the laser sight that have a very short ttl
         if (j->expired)
         {
            j = parts.erase(j);
            continue;
         }
         
         partcheck = false;
         oldpos = j->Update();
         if (j->collide)
         {
            if (Rewind)
               Rewind(j->rewind, oldpos, j->pos, j->radius);
            vector<Mesh*> check = GetMeshesWithoutPlayer(&playervec[j->playernum], ml, kt, oldpos, j->pos, j->radius);
            partcheck = coldet.CheckSphereHit(oldpos, j->pos, j->radius, check, localmap, hitpos, hitmesh, NULL, &hitmeshes);
         }
         
         if (!partcheck) // Didn't hit anything
         {
            if (!HitHandler && j->tracer != "" && j->lasttracer.distance2(j->pos) > 10000.f)
            {
               AddTracer(*j);
               j->lasttracer = j->pos;
            }
         }
         else
         {
            if (HitHandler)
               HitHandler(*j, hitmesh, hitpos);
            else
            {
               if (j->tracer != "")
               {
                  j->pos = hitpos;
                  AddTracer(*j);
               }
               if (j->clientonly)
               {
                  AddHit(hitpos, j->weapid);
                  emitters.back().Update(particles);
               }
            }
            j->expired = true;
         }

#ifndef DEDICATED
         if (!HitHandler)
         {
            j->Render(particlemesh.get(), maincam.GetActual());
         }
#endif
         ++j;
      }
      partupd = 0;
   }
   else
   {
      ++partupd;
   }
   if (Rewind)
      Rewind(0, Vector3(), Vector3(), 1e38f); // Rewind all to 0
}


void AddTracer(const Particle& p)
{
   MeshPtr newmesh = meshcache->GetNewMesh(p.tracer);
   Vector3 move = p.lasttracer - p.pos;
   float msize = move.magnitude();
   newmesh->ScaleZ(msize);
   Vector3 rots = RotateBetweenVectors(Vector3(0, 0, 1), move);
   newmesh->Rotate(rots);
   Particle tracepart(*newmesh);
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
#endif
}


// Must grab clientmutex before calling this function
void AppendToChat(int playernum, string line, bool chatteam)
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
   for (size_t i = 0; i < gui.size(); ++i)
      gui[i]->visible = false;
   gui[toshow]->visible = true;
   if (console.GetBool("showfps"))
      gui[statsdisp]->visible = true;
#endif
}


void ResetKeys()
{
   player[0].leftclick = player[0].rightclick = false;
   player[0].moveforward = player[0].moveback = player[0].moveleft = player[0].moveright = false;
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
   part.playernum = pnum;
   part.weapid = weapon.Id();
   part.damage = weapon.Damage();
   part.dmgrad = weapon.Splash();
   part.collide = true;
      
   Vector3 rawoffset = offset;
   offset.transform(m);
   part.pos += offset;
   part.lasttracer = part.pos;
   part.tracertime = weapon.TracerTime();
   part.origin = part.pos;

   // TODO: weaponfocus should be handled some other way
   part.dir = GetShotVector(console.GetFloat("weaponfocus"), rawoffset, viewoffset, rots);
   return part;
}


Vector3 GetShotVector(const float focus, const Vector3& rawoffset, const Vector3& viewoffset, const Vector3& rots)
{
   Vector3 actualaim = Vector3(0, 0, -focus);
   Vector3 difference = actualaim + rawoffset - viewoffset;
   Vector3 rot = RotateBetweenVectors(Vector3(0, 0, -1), difference);
   GraphicMatrix m;
   m.rotatex(-rots.x + rot.x);
   m.rotatey(rots.y - rot.y);
   Vector3 retval(0.f, 0.f, -1.f);
   retval.transform(m);
   return retval;
}


// Should have the client mutex before calling this
void ClientCreateShot(const PlayerData& localplayer, const Weapon& currplayerweapon)
{
   #ifndef DEDICATED
   int weaponslot = weaponslots[localplayer.currweapon];
   Vector3 startpos = localplayer.pos;
   Vector3 rot(localplayer.pitch, localplayer.facing + localplayer.rotation, 0.f);
   Vector3 offset = units[localplayer.unit].weaponoffset[weaponslot];
   Particle part = CreateShot(currplayerweapon, rot, startpos, offset, units[localplayer.unit].viewoffset);
   // Add tracer if necessary
   if (currplayerweapon.Tracer() != "")
   {
      part.tracer = "models/" + currplayerweapon.Tracer() + "/base";
      part.tracertime = currplayerweapon.TracerTime();
   }
   particles.push_back(part);
   
   if (currplayerweapon.Id() != Weapon::NoWeapon)
      resman.soundman.PlaySound(currplayerweapon.FireSound(), localplayer.pos);
   #endif
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
   if (player[0].spectate && player[0].spawned)
   {
      UpdateSpectatePosition();
   }
   else
   {
      Move(player[0], meshes, kdtree, currmap);
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
   else
   {
      return; // We can't do the serverfps bit below while spectating because serverfps will be 0
   }
      
   int weaponslot = weaponslots[localplayer.currweapon];
   Weapon& currplayerweapon = localplayer.weapons[weaponslot];
   /* We need to add 1000 / netcode->serverfps / 2 to our reload time because it will, on average, take half a server frame for it to get to
      our fire request, so we'll always be that much ahead with our fire requests and that causes us to see things well before
      they actually happen on the server.
      */
   int reloadadjust = 1000 / netcode->serverfps / 2;
   if (localplayer.leftclick && 
       (SDL_GetTicks() - localplayer.lastfiretick[weaponslot] >= currplayerweapon.ReloadTime() + reloadadjust) &&
       (currplayerweapon.ammo != 0) && localplayer.hp[weaponslot] > 0 && localplayer.spawned)
   {
#ifndef DEDICATED
      netcode->SendFire();
#endif
      player[0].lastfiretick[weaponslot] = SDL_GetTicks();
      if (player[0].weapons[weaponslot].ammo > 0) // Negative ammo value indicates infinite ammo
         player[0].weapons[weaponslot].ammo--;
         
      ClientCreateShot(localplayer, currplayerweapon);
      recorder->AddShot(0, currplayerweapon.Id());
   }
}


void AddHit(const Vector3& pos, const int type)
{
   Weapon dummy(type);
   ParticleEmitter newemitter(dummy.ExpFile(), resman);
   newemitter.position = pos;
   emitters.push_back(newemitter);
}


PlayerData* PlayerFromMesh(Mesh* m, vector<PlayerData>& p, Meshlist::iterator invalid)
{
   size_t psize = p.size();
   for (size_t i = 1; i < psize; ++i)
   {
      for (size_t j = 0; j < numbodyparts; ++j)
      {
         if ((p[i].mesh[j] != invalid) && (&(*p[i].mesh[j]) == m))
         {
            return &p[i];
         }
      }
   }
   return NULL;
}


bool PrimaryGUIVisible()
{
#ifndef DEDICATED
   // A bit counterintuitive...
   return !(!gui[mainmenu]->visible && !gui[loadprogress]->visible && !gui[loadoutmenu]->visible &&
         !gui[settings]->visible && !gui[endgame]->visible && !gui[serverbrowser]->visible && !gui[credits]->visible &&
         !gui[updateprogress]->visible);
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
      i->Update();
   }
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


void TakeScreenshot()
{
#ifndef DEDICATED
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
   CreateDirectory((TCHAR*)screenpath.c_str(), NULL);
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
#endif
}


void LoadMap(const string& map)
{
// This no longer needs to be used on the dedicated server
#ifndef DEDICATED
   if (!initialized)
      return;

   Repaint();

   currmap = MapPtr(new ClientMap(map));
   currmap->Load();

   winningteam = 0;
   netcode->SendSync();

   if (!replaying)
      ShowGUI(loadoutmenu);
   else
      gui[loadprogress]->visible = false;
   if (!replayer->Active())
      recorder->SetActive(console.GetBool("record"));
#endif
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


