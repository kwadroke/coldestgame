// This is the file that contains the main() function for this app.

// Necessary include(s)
#include "defines.h"
#include "globals.h"
#include "renderdefs.h"
#include "netdefs.h"

/* Do anything function that can be handy for debugging various things
   in a more limited context than the entire engine.*/
void Debug()
{
   /*IniReader ir("maps/newtest.map");
   //IniReader test = ir(0);
   int t = 100;
   float tf = 200.f;
   string ts = "100";
   
   ir.ReadInt(t, "Stretch");
   ir.ReadFloat(tf, "zzz");
   ir.ReadString(ts, "zzz");
   cout << t << tf << ts << endl;
   
   ir.ReadInt(t, "Lines");
   ir.ReadFloat(tf, "Lines");
   ir.ReadString(ts, "Line");
   cout << t << tf << ts << endl;
   
   cout << "L:" << ir.ReadInt(t, "Line") << endl;
   cout << ir.ReadInt(t, "Lines") << endl;
   //cout << test.ReadInt(t, "Lines") << endl;*/
   
   exit(0);
}


int main(int argc, char* argv[])
{
#ifdef LINUX
   //system("ulimit -c unlimited");
#endif
   //Debug();
   initialized = false;
   InitGlobals();
   // Note, these are called by the restartgl console command, which is required in the autoexec.cfg file
   //SetupSDL();
   //SetupOpenGL();
   LoadMaterials();
   InitShaders();
   InitNoise();
   
   // Start network threads
   netin = SDL_CreateThread(NetListen, NULL);
   
   if (server)
      serverthread = SDL_CreateThread(Server, NULL);
   
   initialized = true;
   MainLoop();

   return 0;
}


void InitGlobals()
{
   PlayerData dummy = PlayerData(meshes); // Local player is always index 0
   // Variables that can be set by the console
   screenwidth = 640;
   screenheight = 480;
   showfps = true;
   quiet = true;
   fly = true;
   thirdperson = true;
   camdist = 100;
   consoletrans = 128;
   movestep = 200;
   //movestep = 100;
   ghost = false;
   fov = 60;
   viewdist = 1000;
//   coldet.intmethod = 0;
   showkdtree = 0;
   tickrate = 30;
   serveraddr = "localhost";
   doconnect = false;
   server = false;
   shadows = true;
   reflection = true;
   reflectionres = 512;
   cloudres = 1024;
   shadowmapsize = 1024;
   partupdateinterval = 0;
   serversync = true;
   aalevel = 2;
   
   // Variables that cannot be set from the console
   dummy.unit = UnitTest;
   player.push_back(dummy);
   
   lasttick = SDL_GetTicks();
   frames = 0;
   //terrainlistvalid = false;
   running = true;
   sendpacketnum = 1;  // 0 has special meaning
   recpacketnum = 0;
   ackpack = 0;
   connected = false;
   //coldet.dynobj = &dynobjects;
   noiseres = 128;
   nextmap = mapname = "";
   clientmutex = SDL_CreateMutex();
   
   standardshader = "shaders/standard";
   noiseshader = "shaders/noise";
   terrainshader = "shaders/terrain";
   cloudshader = "shaders/cloud";
   shadowshader = "shaders/shadowmap";
   watershader = "shaders/water";
   cloudgenshader = "shaders/cloudgen";
   bumpshader = "shaders/bump";
   
   ReadConfig();
   
   /*consoletop = consoleleft = 10;
   consolebottom = screenheight - 300;
   consoleright = screenwidth - 10;*/
   
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
   console.SetTextureManager(&resman.texman);
   console.SetActualSize(screenwidth, screenheight);
   console.InitFromFile("console.xml");
   // There's no particular reason not to new these, and it allows better RAII semantics
   ingamestatus = new GUI(screenwidth, screenheight, &resman.texman);
   ingamestatus->InitFromFile("ingamestatus.xml");
   ConsoleBufferToGUI();
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
   dummy.velocity = 0.f;//.3f;
   dummy.weight = .5f;
   dummy.radius = 5.f;
   dummy.splashradius = 0.f;
   dummy.explode = true;
   dummy.damage = 10;
   dummy.reloadtime = 500;
   dummy.heat = 0.f;
   for (short i = 0; i < numweapons; ++i)
      weapons.push_back(dummy);
   
   weapons[MachineGun].reloadtime = 20;
   weapons[MachineGun].velocity = 20.f;
   weapons[MachineGun].radius = 5.f;
   weapons[MachineGun].weight = .1f;
   weapons[MachineGun].name = "Machine Gun";
   weapons[GaussRifle].reloadtime = 1000;
   weapons[GaussRifle].name = "Gauss Rifle";
   weapons[Laser].reloadtime = 300;
   weapons[Laser].weight = 0.f;
   weapons[Laser].name = "Laser";
   weapons[Laser].heat = 25.f;
}


void ReadConfig()
{
   string conffile = "autoexec.cfg";
   string buffer;
   
   ifstream getconf(conffile.c_str(), ios_base::in);
   while (!getconf.eof())
   {
      getline(getconf, buffer);
      ConsoleHandler(buffer);
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
   if (fullscreen)
      flags |= SDL_FULLSCREEN;
   if( SDL_SetVideoMode(screenwidth, screenheight, video->vfmt->BitsPerPixel, flags) == 0 ) 
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
   
   aspect = (float)screenwidth / (float)screenheight;

   // Make the viewport cover the whole window
   glViewport(0, 0, screenwidth, screenheight);

   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   
   gluPerspective(fov, aspect, nearclip, farclip);
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
   
   if (aalevel)
      glEnable(GL_MULTISAMPLE);
   
   glPixelStorei(GL_UNPACK_ALIGNMENT, 8);
   
   GLenum err = glewInit();
   if (err != GLEW_OK)
   {
      cout << "Failed to init glew: " << glewGetErrorString(err) << endl << flush;
      exit(-1);
   }
   cout << "Glew init successful, using version: " << glewGetString(GLEW_VERSION) << endl << flush;
   if (!GLEW_EXT_framebuffer_object)
   {
      cout << "We don't have EXT_framebuffer_object.  This is fatal.\n" << flush;
      exit(-1);
   }
   if (!GLEW_ARB_vertex_buffer_object)
   {
      cout << "We don't have ARB_vertex_buffer_object.  This is fatal.\n" << flush;
      exit(-1);
   }
   if (!GLEW_ARB_depth_texture)
   {
      cout << "We don't have ARB_depth_texture.  This is fatal.\n" << flush;
      exit(-1);
   }
   if (!GLEW_ARB_shadow)
   {
      cout << "We don't have ARB_shadow.  This is fatal.\n" << flush;
      exit(-1);
   }
   if (!GLEW_ARB_fragment_shader)
   {
      cout << "We don't have ARB_fragment_shader.  This is fatal.\n" << flush;
      exit(-1);
   }
   if (!GLEW_ARB_multitexture)
   {
      cout << "We don't have ARB_multitexture.  This is fatal." << endl;
      exit(-1);
   }
   
   if (!cloudfbo.IsValid())
      cloudfbo = FBO(cloudres, cloudres, false, &resman.texhand);
   if (!reflectionfbo.IsValid())
      reflectionfbo = FBO(reflectionres, reflectionres, false, &resman.texhand);
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


// Ordinarily I would consider this atrocious indentation, but because
// this function by necessity has so many nested statements it actually
// makes it easier to read
// Note: Eventually a lot of this will just be moved to separate functions
// and then it won't be a problem
static void MainLoop() 
{
SDL_Event event;
Uint32 servupdatecounter = SDL_GetTicks();
Uint32 statupdatecounter = SDL_GetTicks();
Uint32 currtick;
while(1) 
{
   if (nextmap != mapname)
   {
      GUI* progress = loadprogress.GetWidget("loadingprogress");
      mainmenu.visible = false;
      loadprogress.visible = true;
      Repaint();
      GetMap(nextmap);
      loadprogress.visible = false;
      mainmenu.visible = true;
   }
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
// process pending events
while( SDL_PollEvent( &event ) ) 
{
   // Mini keyboard handler to deal with the console
   switch (event.type)
   {
      case SDL_KEYDOWN:
         switch(event.key.keysym.sym)
         {
            case SDLK_BACKQUOTE:
               console.visible = !console.visible;
               continue;
            case SDLK_ESCAPE:
               console.visible = false;
               break;
            case SDLK_RETURN:
               if (console.visible)
               {
                  GUI* consolein = console.GetWidget("consoleinput");
                  ConsoleHandler(consolein->text);
                  consolein->text = "";
                  //continue;
               }
               continue;
               
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
      continue;
   }
   else if (loadoutmenu.visible)
   {
      SDL_ShowCursor(1);
      loadoutmenu.ProcessEvent(&event);
      continue;
   }
   
   if (console.visible)
   {
      SDL_ShowCursor(1);
      console.ProcessEvent(&event);
      continue;
   }
   
   SDL_ShowCursor(0);
   SDL_mutexP(clientmutex);
   switch(event.type) 
   {
      case SDL_KEYDOWN:
         if (!console.visible)
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
             event.motion.y != screenheight / 2) && !console.visible)
         {
            player[0].pitch += event.motion.yrel / 4.;
            if (player[0].pitch < -90) player[0].pitch = -90;
            if (player[0].pitch > 90) player[0].pitch = 90;
            player[0].rotation += event.motion.xrel / 4.;
            /*if (player[0].rotation < 0) player[0].rotation += 360;
            if (player[0].rotation > 359) player[0].rotation -= 360;*/
            if (player[0].rotation < -90) player[0].rotation = -90;
            if (player[0].rotation > 90) player[0].rotation = 90;
            if (!quiet)
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
// update the screen
Repaint();
} // End of while(1)
}  // End of MainLoop function


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


void Move(PlayerData& mplayer, Meshlist& ml, CollisionDetection& cd)
{
   // In case we hit something
   Vector3 old = mplayer.pos;
   
   // Calculate how far to move based on time since last frame
   int numticks = SDL_GetTicks() - mplayer.lastmovetick;
   mplayer.lastmovetick = SDL_GetTicks();
   if (numticks > 30) numticks = 30; // Yes this is a hack, it should be removed eventually
   float step = (float)numticks * (movestep / 1000.);
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
   if (!fly)
      d.y = 0.f;
   d.normalize();
   
   mplayer.pos.x += d.x * step;
   mplayer.pos.z -= d.z * step;
   
   // Build list of objects to ignore for collision detection (a player can't hit themself)
   vector<Meshlist::iterator> ignoreobjs;
   if (mplayer.legs != ml.end())
      ignoreobjs.push_back(mplayer.legs);
   if (mplayer.torso != ml.end())
      ignoreobjs.push_back(mplayer.torso);
   if (mplayer.larm != ml.end())
      ignoreobjs.push_back(mplayer.larm);
   if (mplayer.rarm != ml.end())
      ignoreobjs.push_back(mplayer.rarm);
   Meshlist dummy;
   
   static const float threshold = .35f;
   static float gravity = .1f;
   
   if (fly)
      mplayer.pos.y += d.y * step;
   else
   {
      Vector3 groundcheck = old;
      groundcheck.y -= mplayer.size + mplayer.size * threshold;
      cd.listvalid = false;
      groundcheck = cd.CheckSphereHit(old, groundcheck, .01, &dummy, ignoreobjs, NULL);
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
         cd.listvalid = false;
         Vector3 debug = groundcheck;
         groundcheck = cd.CheckSphereHit(old, groundcheck, .01, &dummy, ignoreobjs, NULL);
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
   if (!ghost)
   {
      cd.listvalid = false;
      Vector3 adjust = cd.CheckSphereHit(old, mplayer.pos, mplayer.size, &dummy, ignoreobjs, NULL);
      int count = 0;
      
      while (adjust.distance() > 1e-4f) // Not zero vector
      {
         mplayer.pos += adjust;
         adjust = cd.CheckSphereHit(old, mplayer.pos, mplayer.size, &dummy, ignoreobjs, NULL);
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


// No mutex needed, only called from mutex'd code

/* This is a mess and needs to be cleaned up, but I've been staring at it so long trying to get
   it to work in a semi-acceptable fashion that I just don't want to deal with it right now.*/
void SynchronizePosition()
{
   static deque<OldPosition> oldpos;
   static int smoothfactor = 1;
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
   
   /*if (oldpos[currindex].tick < currtick - ping)
   {
      float perc = (float)(currtick - ping - oldpos[currindex].tick) / (float)(oldpos[currindex + 1].tick - oldpos[currindex].tick);
      smootholdpos = oldpos[currindex].pos * (1.f - perc) + oldpos[currindex + 1].pos * perc;
   }
   else
   {
      smootholdpos = oldpos[currindex].pos;
   }*/
   
   recentoldpos.push_back(currindex);
   while (recentoldpos.size() > smoothfactor)
      recentoldpos.pop_front();
   for (deque<int>::iterator i = recentoldpos.begin(); i != recentoldpos.end(); ++i)
      smootholdpos += oldpos[*i].pos;
   smootholdpos /= recentoldpos.size();
   
   float difference = smoothserverpos.distance(smootholdpos);
   int tickdiff = abs(int(currtick - ping - oldpos[currindex].tick));
   float pingslop = .01f;
   float posthresh = 1.f;
   float diffslop = difference - (float)tickdiff * pingslop;
   difference = diffslop > 0 ? diffslop : 0.f;
   
   Vector3 vecdiff = smoothserverpos - smootholdpos;
   vecdiff.normalize();
   vecdiff *= difference;
   Vector3 posadj = vecdiff;//difference / posthresh > 1 ? vecdiff : vecdiff * difference / posthresh;
   
#if 0
   vecdiff.print();
   posadj.print();
   //player[servplayernum].pos.print();
   //oldpos[currindex].pos.print();
   smoothserverpos.print();
   smootholdpos.print();
   cout << "currindex: " << currindex << endl;
   cout << "old tick: " << oldpos[currindex].tick << endl;
   cout << "currtick - ping: " << (currtick - ping) << endl;
   cout << "difference: " << difference << endl;
   cout << "moving: " << player[0].moveforward << endl;
   cout << "tickdiff: " << tickdiff << endl << endl;
   if (currindex - 1 > 0 && oldpos[currindex].pos.distance(oldpos[currindex - 1].pos) > 3)
   {
      cout << "Hitch detected\n";
      oldpos[currindex].pos.print();
      oldpos[currindex - 1].pos.print();
      cout << (oldpos[currindex].pos.distance(oldpos[currindex - 1].pos)) << endl;
      cout << tickdiff << endl;
      cout << endl;
   }
#endif
   
   /* If we're way off, snap quite a bit because things are hopelessly out of sync and need
      to be fixed quickly.  If we're not moving then don't slide at all, as this looks
      quite bad.  Otherwise, just adjust a little bit to keep us in sync.*/
   if (difference > 10.f)
      posadj *= .5f;
   else if (!player[0].moveforward && !player[0].moveback)
      posadj *= 0.f;
   else if (difference > .3f)
      posadj *= .2f;
   
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
   // Meshes
   for (Meshlist::iterator i = meshes.begin(); i != meshes.end(); ++i)
   {
      i->AdvanceAnimation();
   }
   
   // Particles
   static int partupd = 100;
   IniReader dummy("models/empty/base");
   particlemesh = MeshPtr(new Mesh(dummy, resman));
   SDL_mutexP(clientmutex);
   if (partupd >= partupdateinterval)
   {
      // Update particles
      //cout << particles.size() << endl;
      list<Particle>::iterator j = particles.begin();
      while (j != particles.end())
      {
         if (j->Update(*particlemesh))
         {
            j = particles.erase(j);
         }
         else
         {
            ++j;
         }
      }
      partupd = 0;
      particlemesh->GenVbo();
   }
   else ++partupd;
   
   // Also need to update player models because they need to change each animation frame
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
      exit(-1);
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
   /*if (p.legs == ml.end())
   {
      IniReader load(units[p.unit].file + "/legs/base");
      Mesh newmesh(load, resman);
      ml.push_front(newmesh);
      p.legs = ml.begin();
   }*/
   if (p.torso == ml.end())
   {
      IniReader load("models/" + units[p.unit].file + "/torso/base");
      Mesh newmesh(load, resman, gl);
      ml.push_front(newmesh);
      p.torso = ml.begin();
   }
   
   /*p.legs->Rotate(Vector3(0.f, p.facing, 0.f));
   p.legs->Move(p.pos);*/
   
   p.torso->Rotate(Vector3(p.pitch, p.facing + p.rotation, p.roll));
   p.torso->Move(p.pos);
   
   /*if (p.larm == ml.end())
   {
      IniReader load(units[p.unit].file + "/larm/base");
      Mesh newmesh(load, resman);
      p.torso->InsertIntoContainer("LeftArmConnector", newmesh);
      ml.push_front(newmesh);
      p.larm = ml.begin();
   }
   if (p.rarm == ml.end())
   {
      IniReader load(units[p.unit].file + "/rarm/base");
      Mesh newmesh(load, resman);
      p.torso->InsertIntoContainer("RightArmConnector", newmesh);
      ml.push_front(newmesh);
      p.rarm = ml.begin();
   }*/
   p.size = units[p.unit].size;
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
   
   playerlist->clear();
   playerlist->Add("Name|Kills|Deaths|Ping");
   
   string add;
   for (int i = 1; i < player.size(); ++i)
   {
      add = "Player " + ToString(i) + "|";
      add += ToString(player[i].kills) + "|";
      add += ToString(player[i].deaths) + "|";
      add += ToString(player[i].ping);
      playerlist->Add(add);
   }
   
   SDL_mutexV(clientmutex);
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


// This is likely not portable as written
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


