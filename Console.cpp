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


#include "Console.h"
#include "globals.h"
#include "serverdefs.h"

// Ditto the comment in the Log class.  At this time Console is created once and destroyed only at exit,
// so we're not properly handling copy/destruction for the mutex.
Console::Console() : consoleout(NULL)
{
   mutex = SDL_CreateMutex();
}


int Console::GetInt(const string& key)
{
   int retval = 0;
   Lock();
   if (values.find(key) != values.end())
   {
      istringstream get(values[key]);
      get >> retval;
   }
   else
      logout << "Console Warning: Key not found " << key << endl;
   Unlock();
   return retval;
}


float Console::GetFloat(const string& key)
{
   float retval = 0.f;
   Lock();
   if (values.find(key) != values.end())
   {
      istringstream get(values[key]);
      get >> retval;
   }
   else
      logout << "Console Warning: Key not found " << key << endl;
   Unlock();
   return retval;
}


string Console::GetString(const string& key)
{
   string retval = "";
   Lock();
   if (values.find(key) != values.end())
   {
      retval = values[key];
   }
   else
      logout << "Console Warning: Key not found " << key << endl;
   Unlock();
   return values[key];
}


bool Console::GetBool(const string& key)
{
   Lock();
   if (values.find(key) != values.end())
   {
      string temp;
      istringstream get(values[key]);
      get >> temp;
      if (temp == "0" || temp == "false")
      {
         Unlock();
         return false;
      }
      Unlock();
      return true;
   }
   logout << "Console Warning: Key not found " << key << endl;
   Unlock();
   return false;
}


// Some very stupid things were done implementing this function - particularly reimplementing parts of stringstream
// I've removed some of it, but I'm leaving parts too because they work well enough for the time being
void Console::Parse(const string& line, bool echo)
{
   string simple = SimplifyWhitespace(line);
   
   if (echo)
      WriteToConsole(simple);
   
   int ntokens = NumTokens(simple);
   if (ntokens == 0 ||
       Token(simple, 0).substr(0, 1) == "#")
      return;
   
   if (Token(simple, 0) == "set" && NumTokens(simple) >= 3)
   {
      Lock();
      values[Token(simple, 1)] = Token(simple, 2, true);
      Unlock();
      Action(Token(simple, 1) + " action");
   }
   if (Token(simple, 0) == "setsave" && NumTokens(simple) >= 3)
   {
      Lock();
      saveval.insert(Token(simple, 1));
      values[Token(simple, 1)] = Token(simple, 2, true);
      Unlock();
      Action(Token(simple, 1) + " action");
   }
#ifndef DEDICATED
   if (Token(simple, 0) == "send")
   {
      string remote;
      for (size_t i = 1; i < NumTokens(simple); ++i)
      {
         remote += Token(simple, i);
         if (i != NumTokens(simple) - 1)
            remote += " ";
      }
      netcode->SendCommand(remote);
   }
   if (Token(simple, 0) == "auth")
   {
      netcode->SendPassword(Token(simple, 1));
   }
   if (Token(simple, 0) == "include")
   {
      // This is now a no-op because it doesn't work well with the current console
   }
#endif
   else Action(Token(simple, 0));
}


// Just counts spaces, make sure to run through simplifywhitespace first
// This should have been done with a stringstream
size_t Console::NumTokens(const string& str)
{
   int count = 0;
   for (size_t i = 0; i < str.size(); i++)
   {
      if (str.substr(i, 1) == " ")
         count++;
   }
   return count + 1;
}


// To get the token and the rest of the line, set line to true.
string Console::Token(const string& str, int tokennum, bool line)
{
   istringstream gettoken(str);
   string currtoken = "";
   ssize_t stop = tokennum;
   if (line)
      --stop;

   for (ssize_t i = 0; i <= stop; ++i)
   {
      gettoken >> currtoken;
   }
   if (line)
   {
      if (tokennum != 0)
         gettoken.ignore(); // There should be a leftover whitespace character
      getline(gettoken, currtoken);
   }

   return currtoken;
}


// Note: Does not strip all trailing spaces.
// This shouldn't be necessary, but due to the improper way NumTokens was written it is
string Console::SimplifyWhitespace(const string& str)
{
   string newstr = "";
   bool inwhitespace = true;
   for (size_t i = 0; i < str.size(); i++)
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


#ifndef DEDICATED
void Console::InitWidget(TextArea& co)
{
   Lock();
   consoleout = &co;
   deque<string>::iterator i = consolebuffer.begin();
   while (i != consolebuffer.end())
   {
      consoleout->Append(*i);
      i = consolebuffer.erase(i);
   }
   Unlock();
}
#endif


/* The console needs to be written to in the process of loading autoexec.cfg, which means
   we can't have instantiated the console GUI yet, so if that is the case then we write to a
   temporary buffer that can later be loaded into the GUI portion.
*/
void Console::WriteToConsole(const string& line)
{
   Lock();
   logout << line << endl;
#ifndef DEDICATED
   if (consoleout)
   {
      consoleout->Append(line + "\n");
      Unlock();
      return;
   }
#endif
   consolebuffer.push_back(line + "\n");
   Unlock();
}


void Console::SaveToFile(const string& filename, const bool forcesave)
{
   Lock();
   ifstream read(filename.c_str());
   string buffer;
   deque<string> lines;
   set<string> saved;
   while(getline(read, buffer))
   {
      string simple = SimplifyWhitespace(buffer);
      
      if (Token(simple, 0) == "set" || Token(simple, 0) == "setsave")
      {
         if (saveval.find(Token(simple, 1)) != saveval.end())
         {
            string newcommand = Token(simple, 0);
            newcommand += " " + Token(simple, 1) + " " + values[Token(simple, 1)] + '\n';
            lines.push_back(newcommand);
            saved.insert(Token(simple, 1));
         }
         else lines.push_back(simple + '\n');
      }
      else
         lines.push_back(simple + '\n');
   }
   read.close();
   
   if (forcesave)
   {
      for (map<string, string>::iterator i = values.begin(); i != values.end(); ++i)
      {
         saveval.insert(i->first);
      }
   }
   
   ofstream save(filename.c_str());
   while (lines.size())
   {
      save << lines.front();
      lines.pop_front();
   }
   set<string> remaining;
   set_difference(saveval.begin(), saveval.end(), saved.begin(), saved.end(), inserter(remaining, remaining.end()));
   for (set<string>::iterator i = remaining.begin(); i != remaining.end(); ++i)
   {
      save << "set " << *i << " " << values[*i] << endl;
   }
   if (forcesave) // Then we're writing a new config file
   {
      save << "# restartgl must be included to initialize OpenGL\n";
      save << "restartgl\n";
   }
   save.close();
   Unlock();
}


void Console::Action(const string& action)
{
   if (action == "help")
   {
      WriteToConsole(string("set <variable name> <value>"));
      WriteToConsole(string("help"));
   }
   else if (action == "map")
   {
#ifndef DEDICATED
      LoadMap(GetString("map"));
#endif
      if (server)
         ServerLoadMap(GetString("map"));
      
   }
   else if (action == "connect")
   {
      netcode->Connect();
   }
   else if (action == "restartgl")
   {
      SetupSDL();
      SetupOpenGL();
   }
   else if (action == "reloadres")
   {
      clientmutex->lock();
      LoadMap(GetString("map"));
      clientmutex->unlock();
   }
   else if (action == "laghax action")
   {
      Packet::laghax = GetInt("laghax");
   }
   else if (action == "shadowres action")
   {
      int value = GetInt("shadowres");
      if (value >= 8  && value <= 8192)
      {
         int shadowres = value;
#ifndef DEDICATED
#ifndef DEBUGSMT
         shadowmapfbo = FBO(shadowres, shadowres, true, &resman.texhand);
#else
         shadowmapfbo = FBO(shadowres, shadowres, false, &resman.texhand);
#endif
#endif
      }
      else WriteToConsole(string("Invalid value"));
   }
   else if (action == "reflectionres action")
   {
      int value = GetInt("reflectionres");
      if (value >= 8  && value <= 8192)
      {
         int reflectionres = value;
#ifndef DEDICATED
         reflectionfbo = FBO(reflectionres, reflectionres, false, &resman.texhand);
#endif
      }
      else WriteToConsole(string("Invalid value"));
   }
   else if (action == "cloudres action")
   {
      int value = GetInt("cloudres");
      if (value >= 8  && value <= 8192)
      {
         int cloudres = value;
#ifndef DEDICATED
         cloudfbo = FBO(cloudres, cloudres, false, &resman.texhand);
#endif
      }
      else WriteToConsole(string("Invalid value"));
   }
   else if (action == "name action")
   {
      // If SDL wasn't initialized yet, we won't have created any of these objects yet so we can't use them, but that's okay
      // because they'll be properly initialized later.
      if (SDL_WasInit(0))
      {
         clientmutex->lock();
         if (player.size())
            player[0].name = GetString("name");
         clientmutex->unlock();
      }
   }
   else if (action == "af action")
   {
#ifndef DEDICATED
      resman.texhand.af = GetFloat("af");
#endif
   }
   else if (action == "shadows action" || action == "softshadows action" || action == "reloadshaders")
   {
      InitShaders();
   }
   else if (action == "record action")
   {
      if (netcode && netcode->Connected())
         recorder->SetActive(GetBool("record"));
   }
   else if (action == "kill")
   {
      netcode->SendKill();
   }
   else if (action == "exit" || action == "quit")
   {
      running = false;
   }
}
