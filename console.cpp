// Console related functions

#include "glinc.h"
#include <string>
#include <deque>
#include <set>
#include "CollisionDetection.h"
#include "Hit.h"
#include "PlayerData.h"
#include "Packet.h"
#include "gui/TextArea.h"
#include "SDL_net.h"
#include "renderdefs.h"
#include "netdefs.h"
#include "globals.h"

using namespace std;

void SetupSDL();
void SetupOpenGL();
void GetMap(string);
void WriteToConsole(string);
void ConsoleBufferToGUI();

deque<string> consolebuffer;

// Just counts spaces, make sure to run through simplifywhitespace first
int NumTokens(string str)
{
   int count = 0;
   for (int i = 0; i < str.size(); i++)
   {
      if (str.substr(i, 1) == " ")
         count++;
   }
   return count + 1;
}


string Token(string str, int tokennum)
{
   bool found = false;
   int count = 0;
   string newstr = str;
   while(!found)
   {
      for (int i = 0; i < newstr.size(); i++)
      {
         if (newstr.substr(i, 1) == " " || i == newstr.size() - 1)
         {
            if (count == tokennum)
            {
               if (i == newstr.size() - 1)
                  return newstr;
               newstr.erase(i);
               return newstr;
            }
            else
            {
               newstr.erase(0, i + 1);
               count++;
               break;
            }
         }
      }
   }
   return "";
}


string SimplifyWhitespace(string str)
{
   string newstr = "";
   bool inwhitespace = true;
   for (int i = 0; i < str.size(); i++)
   {
      if (str.substr(i, 1) == " ")
      {
         if (!inwhitespace)
            newstr += str[i];
         inwhitespace = true;
      }
      else
      {
         inwhitespace = false;
         newstr += str[i];
      }
   }
   return newstr;
}


void ConsoleHandler(string command)
{
   string newcommand = SimplifyWhitespace(command);
   
   if (newcommand == "")
   {
      WriteToConsole("");
      return;
   }
   
   WriteToConsole(newcommand);
   
   int ntokens = NumTokens(newcommand);
   if (ntokens == 0)  // Nothing to do
      return;
   if (Token(newcommand, 0).substr(0, 1) == "#")
      return;
   
   // Handle set command
   if (Token(newcommand, 0) == "set")
   {
      if (ntokens == 2 && Token(newcommand, 1) == "help")
      {
         WriteToConsole("Variables available");
         WriteToConsole("quiet showfps consoletop consolebottom consoleleft consoleright consoletrans movestep ghost freelook fov screenwidth screenheight viewdist playersize intmethod showkdtree tickrate");
         return;
      }
      
      if (ntokens < 3)
      {
         WriteToConsole("Invalid Command");
         return;
      }
      if (Token(newcommand, 1) == "quiet")
      {
         if (Token(newcommand, 2) == "1")
            quiet = true;
         else quiet = false;
         return;
      }
      else if (Token(newcommand, 1) == "showfps")
      {
         if (Token(newcommand, 2) == "1")
            showfps = true;
         else showfps = false;
         return;
      }
      else if (Token(newcommand, 1) == "ghost")
      {
         if (Token(newcommand, 2) == "1")
            ghost = true;
         else ghost = false;
         return;
      }
      else if (Token(newcommand, 1) == "fly")
      {
         if (Token(newcommand, 2) == "1")
            fly = true;
         else fly = false;
         return;
      }
      else if (Token(newcommand, 1) == "thirdperson")
      {
         if (Token(newcommand, 2) == "1")
            thirdperson = true;
         else thirdperson = false;
         return;
      }
      else if (Token(newcommand, 1) == "server")
      {
         if (Token(newcommand, 2) == "1")
            server = true;
         else server = false;
         return;
      }
      else if (Token(newcommand, 1) == "camdist")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < 10000)
            camdist = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "consoletop")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < screenheight && value < consolebottom)
            consoletop = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "consolebottom")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < screenheight && value > consoletop)
            consolebottom = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "consoleleft")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < screenwidth && value < consoleright)
            consoleleft = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "consoleright")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < screenwidth && value > consoleleft)
            consoleright = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "consoletrans")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < 256)
            consoletrans = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "movestep")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0)
            movestep = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "fov")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < 180)
            fov = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "screenwidth")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < 10000)
            screenwidth = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "screenheight")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < 10000)
            screenheight = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "viewdist")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < 100000)
            viewdist = value;
         else WriteToConsole(string("Invalid value"));
         glFogf(GL_FOG_START, viewdist * .8);
         glFogf(GL_FOG_END, viewdist);
         farclip = viewdist;
         
         glMatrixMode(GL_PROJECTION);
         glLoadIdentity();
         gluPerspective(fov, aspect, nearclip, farclip);
         glMatrixMode(GL_MODELVIEW);
         return;
      }
      else if (Token(newcommand, 1) == "playersize")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value < 1000)
            player[0].size = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "intmethod")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value >= 0 && value < 2)
            coldet.intmethod = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "showkdtree")
      {
         if (Token(newcommand, 2) == "1")
            showkdtree = true;
         else showkdtree = false;
         return;
      }
      else if (Token(newcommand, 1) == "shadows")
      {
         if (Token(newcommand, 2) != "0")
         {
            standardshader = "shaders/standard";
            terrainshader = "shaders/terrain";
            shadows = true;
         }
         else
         {
            standardshader = "shaders/standardnoshadow";
            terrainshader = "shaders/terrainnoshadow";
            shadows = false;
         }
         if (initialized)
            InitShaders();
         return;
      }
      else if (Token(newcommand, 1) == "reflection")
      {
         if (Token(newcommand, 2) == "1")
            reflection = true;
         else reflection = false;
         return;
      }
      else if (Token(newcommand, 1) == "tickrate")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value > 0 && value <= 120)
            tickrate = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "serveraddr")
      {
         serveraddr = Token(newcommand, 2);
         return;
      }
      else if (Token(newcommand, 1) == "aa")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value >= 0 && value <= 16)
            aalevel = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "af")
      {
         float value = atof(Token(newcommand, 2).c_str());
         if (value >= .999f && value <= 16.001f)
            resman.texhand.af = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "map")
      {
         //currentmap = Token(newcommand, 2);
         WriteToConsole(string("Note: This command is non-functional at the moment"));
         return;
      }
      else if (Token(newcommand, 1) == "fullscreen")
      {
         if (Token(newcommand, 2) == "1")
            fullscreen = true;
         else fullscreen = false;
         return;
      }
      else if (Token(newcommand, 1) == "partupdateinterval")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value >= 0 && value <= 10)
            partupdateinterval = value;
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "laghax")
      {
         Packet::laghax = atoi(Token(newcommand, 2).c_str());
         return;
      }
      else if (Token(newcommand, 1) == "serversync")
      {
         if (Token(newcommand, 2) == "1")
            serversync = true;
         else serversync = false;
         return;
      }
      else if (Token(newcommand, 1) == "shadowmapsize")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value >= 8  && value <= 8192)
         {
            shadowmapsize = value;
#ifndef DEBUGSMT
            shadowmapfbo = FBO(shadowmapsize, shadowmapsize, true, &resman.texhand);
#else
            shadowmapfbo = FBO(shadowmapsize, shadowmapsize, false, &resman.texhand);
#endif
         }
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "reflectionres")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value >= 8  && value <= 8192)
         {
            reflectionres = value;
            reflectionfbo = FBO(reflectionres, reflectionres, false, &resman.texhand);
            if (initialized)
            {
               for (vector<WorldPrimitives>::iterator i = waterobj->prims.begin(); i != waterobj->prims.end(); ++i)
                  i->texnums[0] = reflectionfbo.GetTexture();
            }
         }
         else WriteToConsole(string("Invalid value"));
         return;
      }
      else if (Token(newcommand, 1) == "cloudres")
      {
         int value = atoi(Token(newcommand, 2).c_str());
         if (value >= 8  && value <= 8192)
         {
            cloudres = value;
            cloudfbo = FBO(cloudres, cloudres, false, &resman.texhand);
         }
         else WriteToConsole(string("Invalid value"));
         return;
      }
      
      // If we get to here then we matched nothing
      WriteToConsole(string("Unrecognized variable name"));
   }
   
   else if (Token(newcommand, 0) == "help")
   {
      WriteToConsole(string("set <variable name> <value>"));
      WriteToConsole(string("help"));
      return;
   }
   
   else if (Token(newcommand, 0) == "connect")
   {
      doconnect = true;
      return;
   }
   else if (Token(newcommand, 0) == "loadmap")
   {
      WriteToConsole(string("This doesn't work right now, use set map"));
      //GetMap("maps/" + Token(newcommand, 1));
      return;
   }
   else if (Token(newcommand, 0) == "restartgl")
   {
      SetupSDL();
      SetupOpenGL();
      return;
   }
   else if (Token(newcommand, 0) == "reloadshaders")
   {
      InitShaders();
      return;
   }
   else if (Token(newcommand, 0) == "reloadres")
   {
      mapname = "";
      return;
   }
   WriteToConsole(string("Unrecognized command"));
}


/* The console needs to be written to in the process of loading autoexec.cfg, which means
   we can't have instantiated the console GUI yet, so if that is the case then we write to a
   temporary buffer that can later be loaded into the GUI portion.
*/
void WriteToConsole(string line)
{
   cout << line << endl;
   TextArea* consoleout = (TextArea*)console.GetWidget("consoleoutput");
   if (consoleout)
   {
      consoleout->Append(line + "\n");
      return;
   }
   consolebuffer.push_back(line + "\n");
}


void ConsoleBufferToGUI()
{
   TextArea* consoleout = (TextArea*)console.GetWidget("consoleoutput");
   if (!consoleout)
   {
      cout << "Warning, ConsoleBufferToGUI aborting" << endl;
      return;
   }
   
   deque<string>::iterator i = consolebuffer.begin();
   while (i != consolebuffer.end())
   {
      consoleout->Append(*i);
      i = consolebuffer.erase(i);
   }
}
