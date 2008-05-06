// This is the file that contains the main() function for this app.

// Necessary include(s)
#include "defines.h"
#include "globals.h"
#include "renderdefs.h"
#include "netdefs.h"

#ifdef WINDOWS
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#endif

/* Do anything function that can be handy for debugging various things
   in a more limited context than the entire engine.*/
void Debug()
{
   exit(0);
}


#ifndef WINDOWS
int main(int argc, char* argv[])
#else
int APIENTRY WinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPSTR     lpCmdLine,
                     int       nCmdShow)

#endif
{
#ifdef LINUX
   //system("ulimit -c unlimited");
#endif
   //Debug();
   initialized = false;
   InitGlobals();
   initialized = true;
   // Note, these are called by the restartgl console command, which is required in the autoexec.cfg file
   //SetupSDL();
   //SetupOpenGL();
   LoadMaterials();
   InitShaders();
   InitNoise();
   
   // Start network threads
   netin = SDL_CreateThread(NetListen, NULL);
   
   MainLoop();

   return 0;
}


void InitGlobals()
{
   PlayerData dummy = PlayerData(meshes); // Local player is always index 0
   // Variables that can be set by the console
   console.Parse("set screenwidth 640");
   console.Parse("set screenheight 480");
   console.Parse("set showfps 1");
   console.Parse("set quiet 1");
   console.Parse("set fly 0");
   console.Parse("set thirdperson 0");
   console.Parse("set camdist 100");
   console.Parse("set consoletrans 128");
   console.Parse("set movestep 200");
   console.Parse("set ghost 0");
   console.Parse("set fov 60");
   console.Parse("set viewdist 1000");
   console.Parse("set showkdtree 0");
   console.Parse("set tickrate 30");
   console.Parse("set serveraddr localhost");
   console.Parse("set shadows 1");
   console.Parse("set reflection 1");
   console.Parse("set partupdateinterval 0");
   console.Parse("set serversync 1");
   console.Parse("set aa 0");
   console.Parse("set af 1");
   console.Parse("set impdistmulti 1");
   
   // Variables that cannot be set from the console
   dummy.unit = UnitTest;
   player.push_back(dummy);
   
   lasttick = SDL_GetTicks();
   frames = 0;
   running = true;
   sendpacketnum.next();  // 0 has special meaning
   recpacketnum = 0;
   ackpack = 0;
   doconnect = false;
   connected = false;
   noiseres = 128;
   nextmap = mapname = "";
   clientmutex = SDL_CreateMutex();
   spawnschanged = true;
   
   standardshader = "shaders/standard";
   noiseshader = "shaders/noise";
   terrainshader = "shaders/terrain";
   cloudshader = "shaders/cloud";
   shadowshader = "shaders/shadowmap";
   watershader = "shaders/water";
   cloudgenshader = "shaders/cloudgen";
   bumpshader = "shaders/bump";
   
   ReadConfig();
   
   // These have to be done here because GL has to be initialized first
   if (console.GetInt("reflectionres") < 1)
      console.Parse("set reflectionres 512");
   if (console.GetInt("cloudres") < 1)
      console.Parse("set cloudres 1024");
   if (console.GetInt("shadowmapsize") < 1)
      console.Parse("set shadowmapsize 1024");
   
   InitGUI();
   InitUnits();
   InitWeapons();
}


void InitGUI()
{
   // SDL_ttf must be initialized before GUI's are built
   if (TTF_Init() == -1)
   {
      cout << "Failed to initialize font system: " << TTF_GetError() << endl;
      exit(1);
   }
   int screenwidth = console.GetInt("screenwidth");
   int screenheight = console.GetInt("screenheight");
   mainmenu.SetTextureManager(&resman.texman);
   mainmenu.SetActualSize(screenwidth, screenheight);
   mainmenu.InitFromFile("mainmenu.xml");
   hud.SetTextureManager(&resman.texman);
   hud.SetActualSize(screenwidth, screenheight);
   hud.InitFromFile("hud.xml");
   loadprogress.SetTextureManager(&resman.texman);
   loadprogress.SetActualSize(screenwidth, screenheight);
   loadprogress.InitFromFile("loadprogress.xml");
   loadoutmenu.SetTextureManager(&resman.texman);
   loadoutmenu.SetActualSize(screenwidth, screenheight);
   loadoutmenu.InitFromFile("loadout.xml");
   statsdisp.SetTextureManager(&resman.texman);
   statsdisp.SetActualSize(screenwidth, screenheight);
   statsdisp.InitFromFile("stats.xml");
   consolegui.SetTextureManager(&resman.texman);
   consolegui.SetActualSize(screenwidth, screenheight);
   consolegui.InitFromFile("console.xml");
   // There's no particular reason not to new these, and it allows better RAII semantics
   ingamestatus = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman));
   ingamestatus->InitFromFile("ingamestatus.xml");
   chat = GUIPtr(new GUI(screenwidth, screenheight, &resman.texman));
   chat->InitFromFile("chat.xml");
   TextArea* consoleout = dynamic_cast<TextArea*>(consolegui.GetWidget("consoleoutput"));
   console.InitWidget(*consoleout);
}


void InitUnits()
{
   UnitData dummy;
   dummy.file = "unittest";
   dummy.turnspeed = 1.f;
   dummy.maxspeed = 1.f;
   dummy.size = 10.f;
   dummy.weight = 100;
   dummy.baseweight = 50;
   for (short i = 0; i < numunits; ++i)
      units.push_back(dummy);
   
   units[UnitTest].file = "unittest";
   units[Ultra].file = "ultra";
   units[Omega].file = "omega";
}


void InitWeapons()
{
   WeaponData dummy;
   dummy.file = "projectile";
   dummy.name = "None";
   dummy.acceleration = 1.f;
   dummy.velocity = .3f;
   dummy.weight = .5f;
   dummy.radius = 5.f;
   dummy.splashradius = 0.f;
   dummy.explode = true;
   dummy.damage = 10;
   dummy.reloadtime = 50;
   dummy.heat = 0.f;
   for (short i = 0; i < numweapons; ++i)
      weapons.push_back(dummy);
   
   weapons[MachineGun].reloadtime = 20;
   weapons[MachineGun].velocity = 20.f;
   weapons[MachineGun].radius = 5.f;
   weapons[MachineGun].weight = .1f;
   weapons[MachineGun].name = "Machine Gun";
   weapons[GaussRifle].reloadtime = 1000;
   weapons[GaussRifle].velocity = 10.f;
   weapons[GaussRifle].weight = .25f;
   weapons[GaussRifle].radius = 2.f;
   weapons[GaussRifle].damage = 50;
   weapons[GaussRifle].name = "Gauss Rifle";
   weapons[GaussRifle].heat = 10.f;
   weapons[Laser].reloadtime = 300;
   weapons[Laser].velocity = 20.f;
   weapons[Laser].weight = 0.f;
   weapons[Laser].name = "Laser";
   weapons[Laser].heat = 25.f;
   weapons[Mortar].reloadtime = 1000;
   weapons[Mortar].velocity = .5f;
   weapons[Mortar].weight = 1.f;
   weapons[Mortar].name = "Mortar";
}


void ReadConfig()
{
   string conffile = "autoexec.cfg";
   string buffer;
   
   ifstream getconf(conffile.c_str(), ios_base::in);
   getline(getconf, buffer);
   while (!getconf.eof())
   {
      console.Parse(buffer);
      getline(getconf, buffer);
   }
}


void SetupSDL() 
{
   const SDL_VideoInfo* video;
   
   if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0) 
   {
      cout << "Couldn't initialize SDL: " << SDL_GetError() << endl;
      exit(1);
   }
   
   atexit(SDL_Quit);
   
   video = SDL_GetVideoInfo();
   
   if (!video) 
   {
      cout << "Couldn't get video information: " << SDL_GetError() << endl;
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
      cout << "Couldn't set video mode: " << SDL_GetError() << endl;
      exit(1);
   }
   
   SDL_WM_SetCaption("Coldest", "");
   
   SDL_ShowCursor(0);
   //SDL_WM_GrabInput(SDL_GRAB_ON);
   
   if (SDLNet_Init() == -1)
   {
      cout << "SDLNet_Init: " << SDLNet_GetError() << endl;
      exit(1);
   }
   
   atexit(SDLNet_Quit);
}


void SetupOpenGL()
{
   static bool first = true;
   
   int screenwidth = console.GetInt("screenwidth");
   int screenheight = console.GetInt("screenheight");
   aspect = (float)screenwidth / (float)screenheight;

   // Make the viewport cover the whole window
   glViewport(0, 0, screenwidth, screenheight);

   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   
   gluPerspective(console.GetFloat("fov"), aspect, nearclip, farclip);
   //glFrustum(-1, 1, -1 / aspect, 1 / aspect, 1, 10000.);
   
   glMatrixMode(GL_MODELVIEW);
   
   if (!first) return;
   first = false;

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
   GLfloat f[4] = {.3, .3, .7, 0};
   glFogfv(GL_FOG_COLOR, f);

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
      cout << "Failed to init glew: " << glewGetErrorString(err) << endl << flush;
      exit(-2);
   }
   cout << "Glew init successful, using version: " << glewGetString(GLEW_VERSION) << endl << flush;
   if (!GLEW_EXT_framebuffer_object)
   {
      cout << "We don't have EXT_framebuffer_object.  This is fatal.\n" << flush;
      exit(-3);
   }
   if (!GLEW_ARB_vertex_buffer_object)
   {
      cout << "We don't have ARB_vertex_buffer_object.  This is fatal.\n" << flush;
      exit(-4);
   }
   if (!GLEW_ARB_depth_texture)
   {
      cout << "We don't have ARB_depth_texture.  This is fatal.\n" << flush;
      exit(-5);
   }
   if (!GLEW_ARB_shadow)
   {
      cout << "We don't have ARB_shadow.  This is fatal.\n" << flush;
      exit(-6);
   }
   if (!GLEW_ARB_fragment_shader)
   {
      cout << "We don't have ARB_fragment_shader.  This is fatal.\n" << flush;
      exit(-7);
   }
   if (!GLEW_ARB_multitexture)
   {
      cout << "We don't have ARB_multitexture.  This is fatal." << endl;
      exit(-8);
   }
   
   noisefbo = FBO(noiseres, noiseres, false, &resman.texhand);
   resman.texhand.BindTexture(noisefbo.GetTexture());
   // Need different tex params for this texture
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
}


void LoadMaterials()
{
   resman.LoadMaterial("materials/water");
   shadowmat = &resman.LoadMaterial("materials/shadowgen");
}


void InitShaders()
{
   if (!initialized) return;
   resman.shaderman.SetShadow(console.GetBool("shadows"));
   resman.shaderman.ReloadAll();
   resman.shaderman.LoadShader(standardshader);
   
   resman.shaderman.LoadShader(noiseshader);
   resman.shaderman.SetUniform1f(noiseshader, "time", SDL_GetTicks());
   
   resman.shaderman.LoadShader(terrainshader);
   
   resman.shaderman.LoadShader(cloudshader);
   
   resman.shaderman.LoadShader(cloudgenshader);
   resman.shaderman.SetUniform1f(cloudgenshader, "noiseres", noiseres);
   
   resman.shaderman.LoadShader(shadowshader);
   
   resman.shaderman.LoadShader(watershader);
   
   resman.shaderman.LoadShader(bumpshader);
   
   resman.shaderman.UseShader("none");
}


// Sets up textures for noise shader
// Credit to: TODO: Need to look this up again, same source as the noise shader
void InitNoise()
{
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
}


static void MainLoop() 
{
   SDL_Event event;
   while(1) 
   {
      if (nextmap != mapname)
      {
         GUI* progress = loadprogress.GetWidget("loadingprogress");
         //mainmenu.visible = false;
         loadprogress.visible = true;
         Repaint();
         GetMap(nextmap);
         loadprogress.visible = false;
         loadoutmenu.visible = true;
      }
      
      GUIUpdate();
      
      // process pending events
      while(SDL_PollEvent(&event)) 
      {
         if (!GUIEventHandler(event))
         {
            GameEventHandler(event);
         }
      }
      // update the screen
      Repaint();
   } // End of while(1)
}  // End of MainLoop function


void GUIUpdate()
{
   static Uint32 servupdatecounter = SDL_GetTicks();
   static Uint32 statupdatecounter = SDL_GetTicks();
   static GUI* teamdisplay = loadoutmenu.GetWidget("TeamDisplay");
   Uint32 currtick;
   if (mainmenu.visible)
   {
      currtick = SDL_GetTicks();
      if (currtick - servupdatecounter > 100)
      {
         UpdateServerList();
         servupdatecounter = currtick;
      }
   }
   if (ingamestatus->visible)
   {
      currtick = SDL_GetTicks();
      if (currtick - statupdatecounter > 100)
      {
         UpdatePlayerList();
         statupdatecounter = currtick;
      }
   }
   SDL_mutexP(clientmutex);
   for (int i = 0; i < newchatlines.size(); ++i)
      AppendToChat(newchatplayers[i], newchatlines[i]);
   newchatlines.clear();
   
   if (loadoutmenu.visible)
   {
      if (player[0].team == 1)
         teamdisplay->text = "Spectator";
      else
         teamdisplay->text = "Team " + ToString(player[0].team - 1);
      
      if (spawnschanged)
      {
         ComboBox *spawnpointsbox = (ComboBox*)loadoutmenu.GetWidget("SpawnPoints");
         spawnpointsbox->Clear();
         for (int i = 0; i < availablespawns.size(); ++i)
         {
            string name = ToString(i) + ": ";
            name += availablespawns[i].name;
            /*name += ToString(availablespawns[i].position.x) + ", ";
            name += ToString(availablespawns[i].position.y) + ", ";
            name += ToString(availablespawns[i].position.z);*/
            spawnpointsbox->Add(name);
         }
         spawnschanged = false;
      }
   }
   SDL_mutexV(clientmutex);
}


bool GUIEventHandler(SDL_Event &event)
{
   // Mini keyboard handler to deal with the console
   bool eatevent = false;
   switch (event.type)
   {
      case SDL_KEYDOWN:
         switch(event.key.keysym.sym)
         {
            case SDLK_BACKQUOTE:
               consolegui.visible = !consolegui.visible;
               if (consolegui.visible)
               {
                  GUI* consolein = consolegui.GetWidget("consoleinput");
                  consolein->SetActive();
               }
               eatevent = true;
               break;
            case SDLK_ESCAPE:
               if (consolegui.visible)
               {
                  consolegui.visible = false;
                  eatevent = true;
               }
               if (chat->visible)
               {
                  chat->visible = false;
                  eatevent = true;
               }
               break;
            case SDLK_RETURN:
               if (consolegui.visible)
               {
                  GUI* consolein = consolegui.GetWidget("consoleinput");
                  console.Parse(consolein->text);
                  consolein->text = "";
               }
               else if (!chat->visible)
               {
                  chat->visible = true;
                  GUI* chatin = chat->GetWidget("chatinput");
                  if (!chatin)
                  {
                     cout << "Error getting chat input widget" << endl;
                     break;
                  }
                  chatin->SetActive();
               }
               else
               {
                  GUI *chatin = chat->GetWidget("chatinput");
                  if (!chatin)
                  {
                     cout << "Error getting chat input widget" << endl;
                     break;
                  }
                  SDL_mutexP(clientmutex);
                  chatstring = chatin->text;
                  AppendToChat(0, chatin->text);
                  SDL_mutexV(clientmutex);
                  chatin->text = "";
               }
               eatevent = true;
               
            /*case SDLK_PAGEUP:
               if (consolebottomline < consolebuffer.size())
               consolebottomline++;
               break;
            case SDLK_PAGEDOWN:
               if (consolebottomline > 0)
               consolebottomline--;
               break;*/
         }
      
   };
   
   // If a menu is visible it eats all events
   if (mainmenu.visible) 
   {
      SDL_ShowCursor(1);
      mainmenu.ProcessEvent(&event);
      eatevent = true;
   }
   else if (loadoutmenu.visible)
   {
      SDL_ShowCursor(1);
      loadoutmenu.ProcessEvent(&event);
      eatevent = true;
   }
   
   if (!eatevent)
   {
      if (consolegui.visible)
      {
         SDL_ShowCursor(1);
         consolegui.ProcessEvent(&event);
      }
      if (chat->visible)
      {
         chat->ProcessEvent(&event);
      }
   }
   
   return eatevent;
}


void GameEventHandler(SDL_Event &event)
{
   SDL_ShowCursor(0);
   int screenwidth = console.GetInt("screenwidth");
   int screenheight = console.GetInt("screenheight");
   SDL_mutexP(clientmutex);
   switch(event.type) 
   {
      case SDL_KEYDOWN:
         if (!consolegui.visible)
         {
            switch (event.key.keysym.sym) 
            {
               case SDLK_ESCAPE:
                  mainmenu.visible = !mainmenu.visible;
                  hud.visible = !hud.visible;
                  break;
               case SDLK_a:
                  player[0].moveleft = true;
                  break;
               case SDLK_d:
                  player[0].moveright = true;
                  break;
               case SDLK_w:
                  player[0].moveforward = true;
                  break;
               case SDLK_s:
                  player[0].moveback = true;
                  break;
               /* Doesn't currently work, most likely due to using Euler angles for player
                  rotation, but this probably doesn't make sense in this type of game
                  anyway so Euler angles it is!:-)
               case SDLK_e:
                  player[0].roll = 45;
                  break;
               case SDLK_q:
                  player[0].roll = -45;
                  break;*/
               case SDLK_LSHIFT:
               case SDLK_RSHIFT:
                  player[0].run = true;
                  break;
               case SDLK_SPACE:
                  player[0].pos.x = 200;
                  player[0].pos.y = 200;
                  player[0].pos.z = 200;
                  break;
               case SDLK_TAB:
                  ingamestatus->visible = true;
                  break;
            }
         }
         break;
         
      case SDL_KEYUP:
         switch (event.key.keysym.sym)
         {
            case SDLK_a:
               player[0].moveleft = false;
               break;
            case SDLK_d:
               player[0].moveright = false;
               break;
            case SDLK_w:
               player[0].moveforward = false;
               break;
            case SDLK_s:
               player[0].moveback = false;
               break;
            case SDLK_e:
               player[0].roll = 0;
               break;
            case SDLK_q:
               player[0].roll = 0;
               break;
            case SDLK_LSHIFT:
            case SDLK_RSHIFT:
               player[0].run = false;
               break;
            case SDLK_TAB:
               ingamestatus->visible = false;
               break;
         }
         break;
         
      case SDL_MOUSEMOTION:
         if ((event.motion.x != screenwidth / 2 || 
              event.motion.y != screenheight / 2) && !consolegui.visible)
         {
            player[0].pitch += event.motion.yrel / 4.;
            if (player[0].pitch < -90) player[0].pitch = -90;
            if (player[0].pitch > 90) player[0].pitch = 90;
            player[0].rotation += event.motion.xrel / 4.;
            /*if (player[0].rotation < 0) player[0].rotation += 360;
            if (player[0].rotation > 359) player[0].rotation -= 360;*/
            if (player[0].rotation < -90) player[0].rotation = -90;
            if (player[0].rotation > 90) player[0].rotation = 90;
            if (!console.GetBool("quiet"))
               cout << "Pitch: " << player[0].pitch << "  Rotation: " << player[0].rotation << "\n";
            SDL_WarpMouse(screenwidth / 2, screenheight / 2);
         }
         break;
         
      case SDL_MOUSEBUTTONDOWN:
         if (event.button.button == SDL_BUTTON_LEFT)
         {
            player[0].leftclick = true;
         }
         else if (event.button.button == SDL_BUTTON_WHEELDOWN)
         {
            player[0].currweapon = (player[0].currweapon + 1) % numbodyparts;
         }
         else if (event.button.button == SDL_BUTTON_WHEELUP)
         {
            player[0].currweapon = player[0].currweapon == 0 ? numbodyparts - 1 : player[0].currweapon - 1;
         }
         break;
      case SDL_MOUSEBUTTONUP:
         if (event.button.button == SDL_BUTTON_LEFT)
            player[0].leftclick = false;
         break;

      case SDL_QUIT:
         Quit();
   }
   SDL_mutexV(clientmutex);
}


void Quit()
{
   Cleanup();
   exit(0);
}


void Cleanup()
{
   running = false;
   cout << "Waiting for netout thread to end" << endl;
   SDL_WaitThread(netout, NULL);
   cout << "Waiting for netin thread to end" << endl;
   SDL_WaitThread(netin, NULL);
   cout << "Waiting for server to end" << endl;
   SDL_WaitThread(serverthread, NULL);
   SDL_DestroyMutex(clientmutex);
#ifdef LINUX
   //system("ulimit -c 0");
#endif
}


void Move(PlayerData& mplayer, Meshlist& ml, ObjectKDTree& kt)
{
   // In case we hit something
   Vector3 old = mplayer.pos;
   
   // Calculate how far to move based on time since last frame
   int numticks = SDL_GetTicks() - mplayer.lastmovetick;
   mplayer.lastmovetick = SDL_GetTicks();
   if (numticks > 60) numticks = 60; // Yes this is a hack, it should be removed eventually
   float step = (float)numticks * (console.GetFloat("movestep") / 1000.);
   if (mplayer.run) step *= 2.f;
   
   bool onground = false;
   bool moving = false;
   
   Vector3 temp;
   if (mplayer.moveforward)
   {
      temp.z += 1;
      
   }
   if (mplayer.moveback)
   {
      temp.z -= 1;
   }
   
   if (mplayer.moveleft)
   {
      //temp.x -= 1;
      mplayer.facing -= step * 2;
      if (mplayer.facing < 0) mplayer.facing += 360;
   }
   if (mplayer.moveright)
   {
      //temp.x += 1;
      mplayer.facing += step * 2;
      if (mplayer.facing > 360) mplayer.facing -= 360;
   }
   //temp.normalize();
   if (mplayer.moveforward || mplayer.moveback)// || mplayer.moveleft || mplayer.moveright)
      moving = true;
   
   Vector3 d = temp;
   GraphicMatrix rot;
   if (mplayer.pitch > 89.99)
      rot.rotatex(89.99);
   else if (mplayer.pitch < -89.99)
      rot.rotatex(-89.99);
   else rot.rotatex(mplayer.pitch);
   rot.rotatey(-mplayer.facing);
   d.transform(rot);
   if (!console.GetBool("fly"))
      d.y = 0.f;
   d.normalize();
   
   mplayer.pos.x += d.x * step;
   mplayer.pos.z -= d.z * step;
   
   static const float threshold = .35f;
   static float gravity = .1f;
   
   if (console.GetBool("fly"))
      mplayer.pos.y += d.y * step;
   else
   {
      Vector3 groundcheck = old;
      groundcheck.y -= mplayer.size + mplayer.size * threshold;
      
      vector<Mesh*> check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, groundcheck, .01f);
      groundcheck = coldet.CheckSphereHit(old, groundcheck, .01, check, NULL);
      
      if (groundcheck.magnitude() > .00001f) // They were on the ground
      {
         if (mplayer.fallvelocity > .00001f)
         {
            // Eventually this might do damage if they fall too far
            //cout << "Hit ground " << mplayer.fallvelocity << endl;
         }
         mplayer.fallvelocity = 0.f;
         groundcheck = mplayer.pos;
         /* It turns out that our collision detection isn't accurate enough to just use our previous
            height, so calculate the exact height so we know whether we're on a downslope.*/
         groundcheck.y = GetTerrainHeight(old.x, old.z);
         groundcheck.y += .01f;
         check = GetMeshesWithoutPlayer(&mplayer, ml, kt, old, groundcheck, .01f);
         groundcheck = coldet.CheckSphereHit(old, groundcheck, .01, check, NULL);
         /* If this vector comes back zero then it means they're on a downslope and might need a little help
            staying on the ground.  Otherwise we get a nasty stairstepping effect that looks quite bad.*/
         if (moving && groundcheck.magnitude() < .00001f)
         {
            mplayer.pos.y -= step;
         }
      }
      else
      {
         mplayer.fallvelocity += step * gravity;
         mplayer.pos.y -= mplayer.fallvelocity * step;
      }
   }
   
   // Did we hit something?  If so, deal with it
   if (!console.GetBool("ghost"))
   {
      Vector3 offsetold = old;
      offsetold += (old - mplayer.pos) * mplayer.size; // Not sure mplayer.size is the appropriate value here
      
      vector<Mesh*> check = GetMeshesWithoutPlayer(&mplayer, ml, kt, offsetold, mplayer.pos, mplayer.size);
      Vector3 adjust = coldet.CheckSphereHit(offsetold, mplayer.pos, mplayer.size, check, NULL);
      int count = 0;
      
      while (adjust.distance() > 1e-4f) // Not zero vector
      {
         mplayer.pos += adjust;
         adjust = coldet.CheckSphereHit(offsetold, mplayer.pos, mplayer.size, check, NULL);
         ++count;
         if (count > 25) // Damage control in case something goes wrong
         {
            cout << "Collision Detection Error " << adjust.distance() << endl;
            // Simply don't allow the movement at all
            mplayer.pos = old;
            break;
         }
      }
      if (0)//mplayer.pos.y < GetTerrainHeight(mplayer.pos.x, mplayer.pos.z) + 10)
      {
         cout << "Impossible.........................................................................";
         cout << GetTerrainHeight(mplayer.pos.x, mplayer.pos.z) << endl;
         mplayer.pos.print();
         adjust.print();
      }
   }
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
            check.erase(remove(check.begin(), check.end(), &(*mplayer->mesh[part])), check.end());
      }
   }
   return check;
}


void AppendDynamicMeshes(vector<Mesh*>& appto, Meshlist& ml)
{
   for (Meshlist::iterator i = ml.begin(); i != ml.end(); ++i)
   {
      if (i->dynamic)
      {
         appto.push_back(&(*i));
      }
   }
}


// No mutex needed, only called from mutex'd code

// TODO: Currently this code leaks memory because it never removes anything from oldpos
void SynchronizePosition()
{
#ifdef NOCLIENTPREDICTION
   player[0].pos = player[servplayernum].pos;
   return;
#endif
   static deque<OldPosition> oldpos;
   static int smoothfactor = 3;
   OldPosition temp;
   Uint32 currtick = SDL_GetTicks();
   Vector3 smoothserverpos;
   Vector3 smootholdpos;
   
   if (player.size() <= servplayernum || servplayernum <= 0)
      return;
   
   if (oldpos.size() < 1) // If oldpos is empty, populate it with a single object
   {
      temp.tick = currtick;
      temp.pos = player[0].pos;
   
      oldpos.push_back(temp);
   }
   
   // Smooth out our ping so we don't get jumpy movement
   static deque<Uint32> pings;
   if (player[servplayernum].ping >= 0 && player[servplayernum].ping < 2000)
      pings.push_back(player[servplayernum].ping);
   while (pings.size() > 200)
      pings.pop_front();
   
   int ping = 0;
   for (deque<Uint32>::iterator i = pings.begin(); i != pings.end(); ++i)
      ping += *i;
   if (pings.size() != 0)
      ping /= pings.size();
   else ping = 0;
   
   // Also smooth out positions over a few frames to further reduce jumpiness
   static deque<int> recentoldpos;
   static deque<PlayerData> recentservinfo;
   
   recentservinfo.push_back(player[servplayernum]);
   while (recentservinfo.size() > smoothfactor)
      recentservinfo.pop_front();
   for (deque<PlayerData>::iterator i = recentservinfo.begin(); i != recentservinfo.end(); ++i)
      smoothserverpos += i->pos;
   smoothserverpos /= recentservinfo.size();
   
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
   
   recentoldpos.push_back(currindex);
   while (recentoldpos.size() > smoothfactor)
      recentoldpos.pop_front();
   for (deque<int>::iterator i = recentoldpos.begin(); i != recentoldpos.end(); ++i)
      smootholdpos += oldpos[*i].pos;
   smootholdpos /= recentoldpos.size();
   
   float difference = smoothserverpos.distance(smootholdpos);
   int tickdiff = abs(int(currtick - ping - oldpos[currindex].tick));
   float pingslop = .1f;
   float diffslop = difference - (float)tickdiff * pingslop;
   difference = diffslop > 0 ? diffslop : 0.f;
   
   // vecdiff is not necessary, everything can probably be put directly into posadj now
   Vector3 vecdiff = smoothserverpos - smootholdpos;
   vecdiff.normalize();
   vecdiff *= difference;
   Vector3 posadj = vecdiff;
   
   /* If we're way off, snap quite a bit because things are hopelessly out of sync and need
      to be fixed quickly.  If we're not moving then don't slide at all, as this looks
      quite bad.  Otherwise, just adjust a little bit to keep us in sync.*/
   if (difference > 10.f)
      posadj *= .7f;
   else if (!player[0].moveforward && !player[0].moveback)
      posadj *= 0.f;
   else if (difference > .3f)
      posadj *= .5f;
   // Note: If difference < .3f then we snap to the server location, but it's not noticeable
   // because the error is so small
   
   player[0].pos += posadj;
   for (deque<OldPosition>::iterator i = oldpos.begin(); i != oldpos.end(); ++i)
   {
      i->pos += posadj;
   }
   
   temp.tick = currtick;
   temp.pos = player[0].pos;
   
   oldpos.push_back(temp);
}


void Animate()
{
   SDL_mutexP(clientmutex);
   // Meshes
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      i->AdvanceAnimation(player[0].pos);
   }
   
   // Particles
   static int partupd = 100;
   UpdateParticles(particles, partupd, kdtree, meshes, player[0].pos);
   
   // Also need to update player models because they can be changed by the net thread
   // Note that they are inserted into meshes so they should be automatically animated
   for (int k = 1; k < player.size(); ++k)
   {
      if (k != servplayernum)
         UpdatePlayerModel(player[k], meshes);
   }
   SDL_mutexV(clientmutex);
}


void UpdateServerList()
{
   Table* serverlist = (Table*)mainmenu.GetWidget("serverlist");
   string values;
   vector<ServerInfo>::iterator i;
   if (!serverlist)
   {
      cout << "Failed to get pointer to serverlist" << endl;
      exit(-10);
   }
   SDL_mutexP(clientmutex);
   //serverlist->clear();
   for (i = servers.begin(); i != servers.end(); ++i)
   {
      if (!i->inlist && i->haveinfo)
      {
         values = i->name + "|" + i->map + "|" + ToString(i->ping);
         serverlist->Add(values);
         i->inlist = true;
      }
   }
   SDL_mutexV(clientmutex);
}


void UpdatePlayerModel(PlayerData& p, Meshlist& ml, bool gl)
{
   if (!p.spawned) return;
   
   if (p.mesh[Legs] == ml.end())
   {
      cout << "GL: " << gl << endl;
      IniReader load("models/" + units[p.unit].file + "/legs/base");
      Mesh newmesh(load, resman, gl);
      newmesh.dynamic = true;
      ml.push_front(newmesh);
      p.mesh[Legs] = ml.begin();
   }
   if (p.mesh[Torso] == ml.end())
   {
      IniReader load("models/" + units[p.unit].file + "/torso/base");
      Mesh newmesh(load, resman, gl);
      newmesh.dynamic = true;
      ml.push_front(newmesh);
      p.mesh[Torso] = ml.begin();
   }
   
   p.mesh[Legs]->Rotate(Vector3(0.f, p.facing, 0.f));
   p.mesh[Legs]->Move(p.pos);
   
   p.mesh[Torso]->Rotate(Vector3(-p.pitch, p.facing + p.rotation, p.roll));
   p.mesh[Torso]->Move(p.pos);
   
   if (p.mesh[LArm] == ml.end())
   {
      IniReader load("models/" + units[p.unit].file + "/larm/base");
      Mesh newmesh(load, resman, gl);
      newmesh.dynamic = true;
      p.mesh[Torso]->InsertIntoContainer("LeftArmConnector", newmesh);
      ml.push_front(newmesh);
      p.mesh[LArm] = ml.begin();
   }
   if (p.mesh[RArm] == ml.end())
   {
      IniReader load("models/" + units[p.unit].file + "/rarm/base");
      Mesh newmesh(load, resman, gl);
      newmesh.dynamic = true;
      p.mesh[Torso]->InsertIntoContainer("RightArmConnector", newmesh);
      ml.push_front(newmesh);
      p.mesh[RArm] = ml.begin();
   }
   p.size = units[p.unit].size;
}


// Note: Only the server passes in HitHandler, the client should always pass in NULL
// This is important because this function decides whether to do GL stuff based on that
// and if the server thread tries to do GL it will crash
// The server is also the only one to pass in Rewind
void UpdateParticles(list<Particle>& parts, int& partupd, ObjectKDTree& kt, Meshlist& ml, const Vector3& campos,
                     void (*HitHandler)(Particle&, vector<Mesh*>&), void (*Rewind)(int))
{
   IniReader empty("models/empty/base");
   if (!HitHandler)
   {
      particlemesh = MeshPtr(new Mesh(empty, resman));
      particlemesh->dynamic = true;
   }
   Vector3 oldpos, partcheck;
   vector<Mesh*> hitmeshes;
   if (partupd >= console.GetInt("partupdateinterval"))
   {
      // Update particles
      list<Particle>::iterator j = parts.begin();
      while (j != parts.end())
      {
         partcheck = Vector3();
         oldpos = j->Update();
         if (j->collide)
         {
            vector<Mesh*> check = kt.getmeshes(oldpos, j->pos, j->radius);
            AppendDynamicMeshes(check, ml);
            if (Rewind)
               Rewind(j->rewind);
            partcheck = coldet.CheckSphereHit(oldpos, j->pos, j->radius, check, &hitmeshes);
            if (Rewind)
               Rewind(0);
         }
         
         if (partcheck.distance2() < 1e-5) // Didn't hit anything
         {
            if (j->expired)
            {
               j = parts.erase(j);
            }
            else
            {
               if (!HitHandler)
               {
                  j->mesh.LoadMaterials();
                  j->Render(particlemesh.get(), player[0].pos);
               }
               ++j;
            }
         }
         else
         {
            if (HitHandler)
               HitHandler(*j, hitmeshes);
            j = parts.erase(j);
         }
      }
      partupd = 0;
      if (!HitHandler)
         particlemesh->GenVbo();
   }
   else ++partupd;
}


float GetTerrainHeight(const float x, const float y)
{
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
   SDL_mutexP(clientmutex);
   
   Table* playerlist = (Table*)ingamestatus->GetWidget("playerlist");
   
   playerlist->Clear();
   playerlist->Add("Name|Kills|Deaths|Ping");
   
   string add;
   for (int i = 1; i < player.size(); ++i)
   {
      add = player[i].name + "|";
      add += ToString(player[i].kills) + "|";
      add += ToString(player[i].deaths) + "|";
      add += ToString(player[i].ping);
      playerlist->Add(add);
   }
   
   SDL_mutexV(clientmutex);
}


// Must grab clientmutex before calling this function
void AppendToChat(int playernum, string line)
{
   TextArea *chatout = (TextArea*)chat->GetWidget("chatoutput");
   if (!chatout)
   {
      cout << "Error getting chat output widget" << endl;
      return;
   }
   chatout->Append(player[playernum].name + ": " + line + "\n");
   chatout->ScrollToBottom();
}


/****************************************************************
The following are all utility functions
****************************************************************/
// Quick utility function for texture creation
int PowerOf2(int input)
{
   int value = 1;

   while ( value < input ) 
   {
      value <<= 1;
   }
   return value;
}


void SDL_GL_Enter2dMode()
{
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
}


void SDL_GL_Exit2dMode()
{
   glMatrixMode(GL_PROJECTION);
   glPopMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   glPopMatrix();
   
   glPopAttrib();
}


string PadNum(int n, int digits)
{
   stringstream temp;
   temp.width(digits);
   temp.fill('0');
   temp << n;
   return temp.str();
}


// TODO: This is almost certainly not portable as written
string AddressToDD(Uint32 ahost)
{
   int parts[4];
   parts[0] = ahost & 0x000000ff;
   parts[1] = (ahost & 0x0000ff00) >> 8;
   parts[2] = (ahost & 0x00ff0000) >> 16;
   parts[3] = (ahost & 0xff000000) >> 24;
   ostringstream dotteddec;
   dotteddec << parts[0] << '.' << parts[1] << '.' << parts[2] << '.' << parts[3];
   return dotteddec.str();
}


bool floatzero(float num, float error)
{
   return (num < 0 + error && num > 0 - error);
}


float Random(float min, float max)
{
   if (max < min) return 0;
   float size = max - min;
   return (size * ((float)rand() / (float)RAND_MAX) + min);
}


int gettid()
{
#ifdef LINUX
#ifndef IS64
   return syscall(224);
#else
   return syscall(186);
#endif
#else
return 0;
#endif
}


void GLError()
{
   GLenum error = glGetError();
   if (error == GL_NO_ERROR)
   {
      cout << "No errors" << endl;
   }
   else if (error == GL_INVALID_ENUM)
   {
      cout << "GL_INVALID_ENUM" << endl;
   }
   else if (error == GL_INVALID_VALUE)
   {
      cout << "GL_INVALID_VALUE" << endl;
   }
   else if (error == GL_INVALID_OPERATION)
   {
      cout << "GL_INVALID_OPERATION" << endl;
   }
   else if (error == GL_STACK_OVERFLOW)
   {
      cout << "GL_STACK_OVERFLOW" << endl;
   }
   else if (error == GL_STACK_UNDERFLOW)
   {
      cout << "GL_STACK_UNDERFLOW" << endl;
   }
   else if (error == GL_OUT_OF_MEMORY)
   {
      cout << "GL_OUT_OF_MEMORY" << endl;
   }
   else if (error == GL_TABLE_TOO_LARGE)
   {
      cout << "GL_TABLE_TOO_LARGE" << endl;
   }
}


