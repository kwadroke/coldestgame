// This is the file that contains the main() function for this app.

// Necessary include(s)
#include "defines.h"

/* Do anything function that can be handy for debugging various things
   in a more limited context than the entire engine.*/
void Debug()
{
   /*GraphicMatrix m1, m2;
   Vector3 test;
   
   m1.rotatey(90);
   m1.translate(10, 10, 10);
   //m1.rotatey(90);
   
   test.x = 10;
   Quaternion q(Vector3(), 0);
   q += Quaternion(Vector3(10, 10, 10), 0);
   q.rotate(Vector3(0, 1, 0), 90);
   q.v.print();
   q += Quaternion(Vector3(0, 0, 10), 0);
   q.rotate(Vector3(0, 0, 1), 90);
   q.v.print();*/
   
   TextureHandler th;
   GUI g(1000, 1000, &th);
   g.InitFromFile("mainmenu.xml");
   g.Render();
   
   exit(0);
}


int main(int argc, char* argv[])
{
#ifdef LINUX
   //system("ulimit -c unlimited");
#endif
   //Debug();
   LoadFonts(); // Needs to happen before GUI elements are initialized
   InitGlobals();
   SetupSDL();
   SetupOpenGL();
   LoadShaders();
   LoadDOTextures("models/testex");
   lastdelaytick = SDL_GetTicks(); // Otherwise our first step is huge
   //coldet.octree = ot;
   
   // Start network threads
   netin = SDL_CreateThread(NetListen, NULL);
   
   if (server)
      serverthread = SDL_CreateThread(Server, NULL);
   
   MainLoop();

   return 0;
}


void InitGlobals()
{
   PlayerData dummy = PlayerData(); // Local player is always index 0
   
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
   dummy.size = 25;
   coldet.intmethod = 0;
   showkdtree = 0;
   tickrate = 30;
   serveraddr = "localhost";
   doconnect = false;
   server = false;
   shadows = true;
   reflection = true;
   reflectionres = 512;
   cloudres = 1024;
   partupdateinterval = 0;
   
   // Variables that cannot be set from the console
   tilesize = 0;
   dummy.pos.x = 300;
   dummy.pos.y = 50;
   dummy.pos.z = 300;
   dummy.pitch = dummy.roll = dummy.rotation = dummy.facing = 0.;
   dummy.moveforward = dummy.moveback = dummy.moveleft = dummy.moveright = false;
   dummy.unit = UnitTest;
   dummy.kills = dummy.deaths = dummy.hp = 0;
   dummy.leftclick = dummy.rightclick = false;
   dummy.currweapon = Torso;
   dummy.legs = dummy.torso = dummy.rarm = dummy.larm = dynobjects.end();
   for (int i = 0; i < numbodyparts; ++i)
      dummy.weapons.push_back(Empty);
   player.push_back(dummy);
   
   lasttick = SDL_GetTicks();
   frames = 0;
   consoleinput = "";
   consolebottomline = 0;
   aalevel = 2;
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
   
   ReadConfig();
   
   consoletop = consoleleft = 10;
   consolebottom = screenheight - 300;
   consoleright = screenwidth - 10;
   InitGUI();
   InitUnits();
   InitWeapons();
}


void InitGUI()
{
   mainmenu.SetTextureHandler(&texhand);
   mainmenu.SetActualSize(screenwidth, screenheight);
   mainmenu.InitFromFile("mainmenu.xml");
   hud.SetTextureHandler(&texhand);
   hud.SetActualSize(screenwidth, screenheight);
   hud.InitFromFile("hud.xml");
   loadprogress.SetTextureHandler(&texhand);
   loadprogress.SetActualSize(screenwidth, screenheight);
   loadprogress.InitFromFile("loadprogress.xml");
   loadoutmenu.SetTextureHandler(&texhand);
   loadoutmenu.SetActualSize(screenwidth, screenheight);
   loadoutmenu.InitFromFile("loadout.xml");
}


void InitUnits()
{
   UnitData dummy;
   dummy.file = "";
   dummy.turnspeed = 1.f;
   dummy.maxspeed = 1.f;
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
   dummy.acceleration = 1.f;
   dummy.velocity = .5f;
   dummy.weight = .5f;
   dummy.radius = 5.f;
   dummy.splashradius = 0.f;
   dummy.explode = true;
   dummy.damage = 10;
   dummy.reloadtime = 300;
   for (short i = 0; i < numweapons; ++i)
      weapons.push_back(dummy);
   
   weapons[MachineGun].reloadtime = 2;
   weapons[MachineGun].velocity = 20.f;
   weapons[MachineGun].radius = 5.f;
   weapons[MachineGun].weight = .1f;
}


void ReadConfig()
{
   string conffile = "autoexec.cfg";
   string buffer;
   
   ifstream getconf(conffile.c_str(), ios_base::in);
   while (!getconf.eof())
   {
      getline(getconf, buffer);
      cout << buffer << endl << flush;
      ConsoleHandler(buffer);
   }
}


void SetupSDL() 
{
   const SDL_VideoInfo* video;
   
   if (SDL_Init(SDL_INIT_VIDEO) < 0) 
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
   
   SDL_WM_SetCaption("SDL OpenGL Engine", "");
   
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

   // Do draw back-facing polygons
   glDisable(GL_CULL_FACE);
   //glEnable(GL_CULL_FACE);
   
   // Set the alpha function, then can disable or enable
   glAlphaFunc(GL_GREATER, 0.5);
   glDisable(GL_ALPHA_TEST);
   
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
   
   lights.Add();
   lights.SetDir(0, Vector3(-1, 1, -1));
   
   if (shadows)
   {
      // Generate FBO to render to the shadow map texture
#ifndef DEBUGSMT
      shadowmapfbo = FBO(shadowmapsize, shadowmapsize, true, &texhand);
      worldshadowmapfbo = FBO(shadowmapsize, shadowmapsize, true, &texhand);
#else
      shadowmapfbo = FBO(shadowmapsize, shadowmapsize, false, &texhand);
      worldshadowmapfbo = FBO(shadowmapsize, shadowmapsize, false, &texhand);
#endif
   }
   
   cloudfbo = FBO(cloudres, cloudres, false, &texhand);
   reflectionfbo = FBO(reflectionres, reflectionres, false, &texhand);
   noisefbo = FBO(noiseres, noiseres, false, &texhand);
   texhand.BindTexture(noisefbo.GetTexture());
   // Need different tex params for this texture
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
}


void LoadShaders()
{
   standardshader = "shaders/standard";
   noiseshader = "shaders/noise";
   terrainshader = "shaders/terrain";
   cloudshader = "shaders/test";
   shadowshader = "shaders/shadow";
   watershader = "shaders/water";
   cloudgenshader = "shaders/cloudgen";
   
   shaderhand.LoadShader(standardshader);
   cout << "Loaded standard shader\n";
   shaderhand.LoadShader(noiseshader);
   cout << "Loaded noise shader\n";
   shaderhand.LoadShader(terrainshader);
   cout << "Loaded terrain shader\n";
   
   shaderhand.LoadShader(cloudshader);
   cout << "Loaded cloud shader\n";
   shaderhand.SetUniform1i(cloudshader, "tex", 0);
   
   shaderhand.LoadShader(cloudgenshader);
   cout << "Loaded cloud gen shader\n";
   shaderhand.SetUniform1i(cloudgenshader, "basenoise", 0);
   shaderhand.SetUniform1f(cloudgenshader, "noiseres", noiseres);
   
   /*shaderhand.LoadShader("shaders/reflection");
   cout << "Loaded reflection shader\n";
   shaderhand.SetUniform1i("shaders/reflection", "tex", 0);
   shaderhand.SetUniform1i("shaders/reflection", "tex1", 1);
   shaderhand.SetUniform1i("shaders/reflection", "tex2", 2);
   shaderhand.SetUniform1i("shaders/reflection", "tex3", 3);
   shaderhand.SetUniform1i("shaders/reflection", "tex4", 4);
   shaderhand.SetUniform1i("shaders/reflection", "tex5", 5);
   shaderhand.SetUniform1i("shaders/reflection", "shadowtex", 6);
   shaderhand.SetUniform1i("shaders/reflection", "worldshadowtex", 7);*/
   
   shaderhand.SetUniform1i(standardshader, "tex", 0);
   shaderhand.SetUniform1i(standardshader, "shadowtex", 6);
   shaderhand.SetUniform1i(standardshader, "worldshadowtex", 7);
   shaderhand.SetUniform1f(standardshader, "reflectval", 0.f);
   
   shaderhand.SetUniform1i(terrainshader, "tex", 0);
   shaderhand.SetUniform1i(terrainshader, "tex1", 1);
   shaderhand.SetUniform1i(terrainshader, "tex2", 2);
   shaderhand.SetUniform1i(terrainshader, "tex3", 3);
   shaderhand.SetUniform1i(terrainshader, "tex4", 4);
   shaderhand.SetUniform1i(terrainshader, "tex5", 5);
   shaderhand.SetUniform1i(terrainshader, "shadowtex", 6);
   shaderhand.SetUniform1i(terrainshader, "worldshadowtex", 7);
   shaderhand.SetUniform1f(terrainshader, "reflectval", 0.f);
   
   shaderhand.SetUniform1i(noiseshader, "permTexture", 0);
   shaderhand.SetUniform1i(noiseshader, "time", SDL_GetTicks());
   
   shaderhand.LoadShader(shadowshader);
   cout << "Loaded shadow shader\n";
   shaderhand.SetUniform1i(shadowshader, "tex", 0);
   
   shaderhand.LoadShader(watershader);
   cout << "Loaded water shader\n";
   shaderhand.SetUniform1i(watershader, "tex", 0);
   shaderhand.SetUniform1i(watershader, "noisetex", 1);
   
   InitNoise();
   shaderhand.UseShader("none");
}


// Sets up textures for noise shader
void InitNoise()
{
   int perm[256]= {151,160,137,91,90,15,
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
   texhand.BindTexture(noisetex); // Bind the texture to texture unit 0
   
   GLubyte pixels[256 * 256 * 4];
   for(i = 0; i<256; i++)
      for(j = 0; j<256; j++) {
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


static void LoadFonts()
{
   // Make sure we have a texture to render to
   //textures.reserve(1);
   textures.push_back(0);
   glGenTextures(1, &textures[0]);
   cout << "Loading fonts...\n";
   if (TTF_Init() == -1)
   {
      cout << "Failed to initialize font system: " << TTF_GetError() << endl;
      exit(1);
   }
   lcd = TTF_OpenFont("fonts/chp-fire.ttf", 24);
   if (!lcd)
   {
      cout << "Failed to initialize font: " << TTF_GetError() << endl;
      exit(1);
   }
   consolefont = TTF_OpenFont("fonts/lcd.ttf", 14);
   if (!consolefont)
   {
      cout << "Failed to initialize font: " << TTF_GetError() << endl;
      exit(1);
   }
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
// process pending events
while( SDL_PollEvent( &event ) ) 
{
   // If a menu is visible it eats all events
   if (mainmenu.visible) 
   {
      SDL_ShowCursor(1);
      mainmenu.ProcessEvent(&event);
      break;
   }
   else if (loadoutmenu.visible)
   {
      SDL_ShowCursor(1);
      loadoutmenu.ProcessEvent(&event);
      break;
   }
   SDL_ShowCursor(0);
   switch( event.type ) 
   {
      case SDL_KEYDOWN:
         if (!consolevisible)
         {
            switch (event.key.keysym.sym) 
            {
               case SDLK_ESCAPE:
                  mainmenu.visible = !mainmenu.visible;
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
               /* Doesn't currently work due to the gimbal lock caused by using
                  Euler angles for camera direction.
               case SDLK_e:
                  player[0].roll = 45;
                  break;
               case SDLK_q:
                  player[0].roll = -45;
                  break;*/
               case SDLK_LSHIFT:
               case SDLK_RSHIFT:
                  movestep *= 2;
                  break;
               case SDLK_SPACE:
                  player[0].pos.x = 200;
                  player[0].pos.y = 200;
                  player[0].pos.z = 200;
                  break;
               case SDLK_BACKQUOTE:
                  consolevisible = true;
                  break;
            }
         }
         else
         {
            switch (event.key.keysym.sym) 
            {
               case SDLK_BACKQUOTE:
                  consolevisible = false;
                  break;
               case SDLK_ESCAPE:
                  consolevisible = false;
                  break;
               case SDLK_RETURN:
                  consolebuffer.push_front(consoleinput);
                  ConsoleHandler(consoleinput);
                  consoleinput = "";
                  break;
               case SDLK_PAGEUP:
                  if (consolebottomline < consolebuffer.size())
                     consolebottomline++;
                  break;
               case SDLK_PAGEDOWN:
                  if (consolebottomline > 0)
                     consolebottomline--;
                  break;
               case SDLK_BACKSPACE:
                  if (consoleinput.length() > 0)
                     consoleinput = consoleinput.substr(0, consoleinput.length() - 1);
                  break;
               default:
                  char c = event.key.keysym.sym;
                  consoleinput.append(string(1, c));
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
               movestep /= 2;
               break;
         }
         break;
         
      case SDL_MOUSEMOTION:
         if ((event.motion.x != screenwidth / 2 || 
             event.motion.y != screenheight / 2) && !consolevisible)
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
         break;
      case SDL_MOUSEBUTTONUP:
         if (event.button.button == SDL_BUTTON_RIGHT)
            player[0].leftclick = false;
         break;

      case SDL_QUIT:
         Quit();
   }
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


void Move(PlayerData& mplayer, list<DynamicObject>& dynobj, CollisionDetection& cd)
{
   // In case we hit something
   Vector3 old = mplayer.pos;
   
   // Calculate how far to move based on time since last frame
   int numticks = SDL_GetTicks() - mplayer.lastmovetick;
   mplayer.lastmovetick += numticks;
   float step = (float)numticks * (movestep / 1000.);
   
   /* Had some problems that I think stemmed from step being negative, possibly due to the
      cast of numticks above.  In any case, we never want step to be negative anyway so this
      check isn't hurting anything.*/
   if (step < 0.f) step == 0.f;
   
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
   //rot.rotatez(mplayer.roll);
   d.transform(rot);
   if (!fly)
      d.y = 0.f;
   d.normalize();
   
   // Build list of objects to ignore for collision detection (a player can't hit themself)
   vector<list<DynamicObject>::iterator> ignoreobjs;
   ignoreobjs.push_back(mplayer.legs);
   
   if (fly)
      mplayer.pos.y += d.y * step;
   else
   {
      if (!fly)
      {
         Vector3 groundcheck = mplayer.pos;
         groundcheck.y -= mplayer.size + mplayer.size * .35f;
         groundcheck = cd.CheckSphereHit(mplayer.pos, groundcheck, .01, &dynobj, ignoreobjs, NULL);
         if (groundcheck.magnitude() > .00001f)
            onground = true;
         else
            mplayer.pos.y -= mplayer.fallvelocity * step;
         if (onground && moving)
            mplayer.pos.y -= mplayer.fallvelocity * step;
         
      }
      if (onground)
         mplayer.fallvelocity = .3f;
      else mplayer.fallvelocity += step * .1f;
      if (mplayer.fallvelocity > 10.f)
         mplayer.fallvelocity = 10.f;
   }
   
   /*if (!onground && !fly)
   {
      d.x *= .5f;
      d.z *= .5f;
   }*/
   mplayer.pos.x += d.x * step;
   mplayer.pos.z -= d.z * step;
   
   // Did we hit something?  If so, deal with it
   if (!ghost)
   {
      coldet.listvalid = false;
      Vector3 adjust = cd.CheckSphereHit(old, mplayer.pos, mplayer.size, &dynobj, ignoreobjs, NULL);
      int count = 0;
      Vector3 normadj;
      
      while (adjust.distance2(Vector3()) > .001) // Not zero vector
      {
         mplayer.pos += adjust * 1.1f;
         adjust = cd.CheckSphereHit(old, mplayer.pos, mplayer.size, &dynobj, ignoreobjs, NULL);
         ++count;
         if (count > 25) // Damage control in case something goes wrong
         {
            cout << "Collision Detection Error " << adjust.distance2(Vector3()) << endl;
            // Simply don't allow the movement at all
            mplayer.pos = old;
            break;
         }
      }
   }
   
   // This most likely won't work well now
   //if (!quiet)
   //   cout << mplayer.pos.x << "  "  << mplayer.pos.y << "  " << mplayer.pos.z << endl;
}


void Fire()
{
   /*Vector3 dir(0, 0, -1);
   GraphicMatrix m;
   m.rotatex(-player[0].pitch);
   m.rotatey(player[0].facing + player[0].rotation);
   //m.rotatez(player[0].roll);
   dir.transform(m.members);
   
   list<DynamicObject>::iterator temp = LoadObject("projectile");
   Particle part(player[0].pos, dir, .4, 1, 10, 1, temp, SDL_GetTicks());
   part.pos += part.dir * 40;
   part.cd = &coldet;
   part.playernum = 0;
   part.damage = 10;
   part.dmgrad = 10;
   
   particles.push_back(part);*/
}


void Animate()
{
   static int partupd = 100;
   SDL_mutexP(clientmutex);
   if (partupd >= partupdateinterval)
   {
      // Update particles
      //cout << particles.size() << endl;
      list<Particle>::iterator j = particles.begin();
      while (j != particles.end())
      {
         DynamicObject* dummy = &(*(j->obj));
         if (j->Update(&dynobjects))
         {
            dynobjects.erase(j->obj);
            j = particles.erase(j);
         }
         else
         {
            ++j;
         }
      }
      partupd = 0;
   }
   else ++partupd;
   
   // Update dynamic objects
   list<DynamicObject>::iterator i;
   for (i = dynobjects.begin(); i != dynobjects.end(); i++)
   {
      Uint32 ticks = SDL_GetTicks();
      if (ticks - i->lasttick >= i->animdelay)
      {
         if (i->animframe == i->prims.size() - 1)
         {
            i->animframe = 0;
         }
         else i->animframe++;
         // So if we don't land on exactly the right tick the animation speeds 
         // remain the same
         i->lasttick = ticks - (ticks - i->lasttick - i->animdelay);
      }
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


// Utility function for LoadObject when rebuilding tree
DynamicPrimitive* GetDynPrimById(string id, list<DynamicPrimitive*>* primlist)
{
   list<DynamicPrimitive*>::iterator i;
   for (i = primlist->begin(); i != primlist->end(); i++)
   {
      if ((*i)->id == id)
         return *i;
   }
   // Passed in an id that was not in list
   cout << "Error: Could not find primitive: " << id << endl;
   return NULL;
}


/* Returns an iterator to the object that was loaded, or dynobjects.end() if 
   loading failed.
*/
list<DynamicObject>::iterator LoadObject(string filename, list<DynamicObject>& dynobj)
{
   string currfile = "models/" + filename + "/base";
   ifstream lo(currfile.c_str(), ios_base::in);
   string ver;
   string dummy;
   string buffer;
   int numframes;
   int collide;
   int adelay;
   float scale;
   float size;
   Vector3 initpos;
   
   // Make sure it's a compatible object file
   lo >> ver;
   if (ver != objectfilever)
   {
      cout << "Object file version mismatch for file: " << currfile << endl << flush;
      return dynobj.end();
   }
   //cout << "Loading models/" + filename << endl << flush;
   lo >> dummy;
   lo >> numframes;
   lo >> dummy;
   lo >> collide;
   lo >> dummy;
   lo >> adelay;
   
   lo >> dummy;
   lo >> initpos.x;
   lo >> initpos.y;
   lo >> initpos.z;
   
   lo >> dummy;
   lo >> scale;
   
   lo >> dummy >> size;
   
   DynamicObject tempobj = DynamicObject();
   dynobj.push_front(tempobj);
   list<DynamicObject>::iterator temp = dynobj.begin();
   temp->complete = 1337;
   temp->pitch = temp->rotation = temp->roll = 0;
      
   temp->position.x = initpos.x;
   temp->position.y = initpos.y;
   temp->position.z = initpos.z;
      
   temp->animframe = 0;
   temp->animdelay = adelay;
   temp->lasttick = SDL_GetTicks();
   temp->collide = false;
   temp->size = size * scale;
   temp->billboard = false;
   temp->visible = true;
   
   for (int i = 0; i < numframes; ++i)
   {
      temp->prims.push_back(DPList());
      
      currfile = "models/" + filename + "/frame" + PadNum(i, 4);
      ifstream lf(currfile.c_str(), ios_base::in); // For loading frames
      
      lf >> ver;
      if (ver != objectfilever)
      {
         cout << "Object file version mismatch for file: " << currfile << endl << flush;
         return dynobj.end();
      }
      
      lf >> dummy; // nextid is irrelevant here
      
      
      //int j = 0;
      getline(lf, buffer);
      getline(lf, buffer);
      while (!lf.eof())
      {
         DynamicPrimitive *pbuffer = new DynamicPrimitive();
         
         // Set default texture coordinates
         vector<float> tc(2);
         tc[0] = 0;
         tc[1] = 0;
         vector< vector<float> > tcv;
         for (int c = 0; c < 4; ++c)
            tcv.push_back(tc);
         
         for (int m = 0; m < 6; ++m)
         {
            pbuffer->texcoords.push_back(tcv);
            pbuffer->texcoords[m][1][1] = 1;
            pbuffer->texcoords[m][2][0] = 1;
            pbuffer->texcoords[m][3][0] = 1;
            pbuffer->texcoords[m][3][1] = 1;
         }
         
         while (buffer != "EOP")
         {
            string optname, value;
            string separator = " = ";
            int index = buffer.find(separator);
            optname = buffer.substr(0, index);
            value = buffer.substr(index + separator.length());
            
            if (optname == "Type")
               pbuffer->type = value;
            else if (optname == "ID")
               pbuffer->id = value;
            else if (optname == "Parent ID")
               pbuffer->parentid = value;
            else if (optname == "Texture")
               pbuffer->texnums[0] = atoi(value.c_str());
            else if (optname == "Shader")
               pbuffer->shader = value;
            else if (optname == "X Rot 1")
               pbuffer->rot1.x = atoi(value.c_str());
            else if (optname == "Y Rot 1")
               pbuffer->rot1.y = atoi(value.c_str());
            else if (optname == "Z Rot 1")
               pbuffer->rot1.z = atoi(value.c_str());
            else if (optname == "X Rot 2")
               pbuffer->rot2.x = atoi(value.c_str());
            else if (optname == "Y Rot 2")
               pbuffer->rot2.y = atoi(value.c_str());
            else if (optname == "Z Rot 2")
               pbuffer->rot2.z = atoi(value.c_str());
            else if (optname == "X Trans")
               pbuffer->trans.x = atoi(value.c_str());
            else if (optname == "Y Trans")
               pbuffer->trans.y = atoi(value.c_str());
            else if (optname == "Z Trans")
               pbuffer->trans.z = atoi(value.c_str());
            else if (optname == "p0x")
               pbuffer->v[0].x = atoi(value.c_str());
            else if (optname == "p0y")
               pbuffer->v[0].y = atoi(value.c_str());
            else if (optname == "p0z")
               pbuffer->v[0].z = atoi(value.c_str());
            else if (optname == "p1x")
               pbuffer->v[1].x = atoi(value.c_str());
            else if (optname == "p1y")
               pbuffer->v[1].y = atoi(value.c_str());
            else if (optname == "p1z")
               pbuffer->v[1].z = atoi(value.c_str());
            else if (optname == "p2x")
               pbuffer->v[2].x = atoi(value.c_str());
            else if (optname == "p2y")
               pbuffer->v[2].y = atoi(value.c_str());
            else if (optname == "p2z")
               pbuffer->v[2].z = atoi(value.c_str());
            else if (optname == "p3x")
               pbuffer->v[3].x = atoi(value.c_str());
            else if (optname == "p3y")
               pbuffer->v[3].y = atoi(value.c_str());
            else if (optname == "p3z")
               pbuffer->v[3].z = atoi(value.c_str());
            else if (optname == "tc0x")
               pbuffer->texcoords[0][0][0] = atof(value.c_str());
            else if (optname == "tc0y")
               pbuffer->texcoords[0][0][1] = atof(value.c_str());
            else if (optname == "tc1x")
               pbuffer->texcoords[0][1][0] = atof(value.c_str());
            else if (optname == "tc1y")
               pbuffer->texcoords[0][1][1] = atof(value.c_str());
            else if (optname == "tc2x")
               pbuffer->texcoords[0][2][0] = atof(value.c_str());
            else if (optname == "tc2y")
               pbuffer->texcoords[0][2][1] = atof(value.c_str());
            else if (optname == "tc3x")
               pbuffer->texcoords[0][3][0] = atof(value.c_str());
            else if (optname == "tc3y")
               pbuffer->texcoords[0][3][1] = atof(value.c_str());
            else if (optname == "Radius 1")
               pbuffer->rad = atoi(value.c_str());
            else if (optname == "Radius 2")
               pbuffer->rad1 = atoi(value.c_str());
            else if (optname == "Height")
               pbuffer->height = atoi(value.c_str());
            else if (optname == "Slices")
               pbuffer->slices = atoi(value.c_str());
            else if (optname == "Stacks")
               pbuffer->stacks = atoi(value.c_str());
            else if (optname == "Transparent")
            {
               pbuffer->transparent = true;
               if (value == "0")
                  pbuffer->transparent = false;
            }
            else if (optname == "Translucent")
            {
               pbuffer->translucent = true;
               if (value == "0")
                  pbuffer->translucent = false;
            }
            else if (optname == "Collide")
            {
               pbuffer->collide = true;
               if (value == "0")
                  pbuffer->collide = false;
            }
            else if (optname == "Facing")
            {
               pbuffer->facing = true;
               if (value == "0")
                  pbuffer->facing = false;
            }
            getline(lf, buffer);
         }
         pbuffer->parentobj = temp;
         pbuffer->dynamic = true;
         for (int k = 0; k < 4; ++k)
         {
            pbuffer->v[k] *= scale;
            pbuffer->orig[k] = pbuffer->v[k];
         }
         // Apply scaling
         pbuffer->trans *= scale;
         
         temp->prims[i].push_back(pbuffer);
         //++j;
         getline(lf, buffer);
      }
      
      /* Now that the primitives are loaded into a vector, we need to rebuild
         the tree that is used to render them properly
      */
      list<DynamicPrimitive*>::iterator it;
      for (it = temp->prims[i].begin(); it != temp->prims[i].end(); it++)
      {
         if ((*it)->parentid != "-1")
         {
            DynamicPrimitive *p = GetDynPrimById((*it)->parentid, &(temp->prims[i]));
            //int c = GetDynPrimById(it->id, &(dynobj[nextobj].prims[i]));
            if (p)
            {
               (*it)->parent = p;
               p->child.push_back(*it);
            }
            //   dynobjects[nextobj].prims[i][p].child.push_back(c);
            else
            {
               cout << "Error building object tree: " << currfile << endl << flush;
            }
         }
      }
      lf.close();
      
   }
   lo.close();
   temp->complete = 164264;
   return temp;
}


void LoadDOTextures(string filename)
{
   ifstream lf(filename.c_str(), ios_base::in);
   string ver;
   string buffer;
   int numtex;
   
   // Make sure it's a compatible object file
   lf >> ver;
   if (ver != objectfilever + "Textures")
   {
      cout << "Object file version mismatch for file: " << filename << endl << flush;
      return;
   }
   lf >> numtex;
   GLuint temptex[numtex];
   glGenTextures(numtex, temptex);
   for (int j = 0; j < numtex; ++j)
   {
      lf >> buffer;
      dotextures.push_back(temptex[j]);
      bool alpha;  // Don't really care
      texhand.LoadTexture(buffer, temptex[j], true, &alpha);
   }
   lf.close();
}


void UpdatePlayerModel(PlayerData& p, list<DynamicObject>& dynobj)
{
   if (p.legs == dynobj.end())
   {
      p.legs = LoadObject(units[p.unit].file + "/legs", dynobj);
   }
   p.legs->position.x = p.pos.x;
   p.legs->position.y = p.pos.y;
   p.legs->position.z = p.pos.z;
   p.legs->rotation = p.facing;
   p.legs->pitch = p.pitch;
   p.legs->roll = p.roll;
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


float Max(float one, float two)
{
   if (one > two) return one;
   return two;
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


