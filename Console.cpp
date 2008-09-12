#include "Console.h"
#include "globals.h"

Console::Console() : consoleout(NULL)
{
}


int Console::GetInt(const string& key)
{
   if (values.find(key) != values.end())
      return atoi(values[key].c_str());
   cout << "Console Warning: Key not found " << key << endl;
   return 0;
}


float Console::GetFloat(const string& key)
{
   if (values.find(key) != values.end())
      return atof(values[key].c_str());
   cout << "Console Warning: Key not found " << key << endl;
   return 0.f;
}


string Console::GetString(const string& key)
{
   if (values.find(key) != values.end())
      return values[key];
   cout << "Console Warning: Key not found " << key << endl;
   return "";
}


bool Console::GetBool(const string& key)
{
   if (values.find(key) != values.end())
   {
      if (values[key] == "0" || values[key] == "false")
         return false;
      return true;
   }
   cout << "Console Warning: Key not found " << key << endl;
   return false;
}


void Console::Parse(const string& line, bool echo)
{
   string simple = SimplifyWhitespace(line);
   
   if (echo)
      WriteToConsole(simple);
   
   int ntokens = NumTokens(simple);
   if (ntokens == 0 ||
       Token(simple, 0).substr(0, 1) == "#")
      return;
   
   if (Token(simple, 0) == "set" && NumTokens(simple) == 3)
   {
      values[Token(simple, 1)] = Token(simple, 2);
      Action(Token(simple, 1) + " action");
   }
   if (Token(simple, 0) == "setsave" && NumTokens(simple) == 3)
   {
      saveval.insert(Token(simple, 1));
      values[Token(simple, 1)] = Token(simple, 2);
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
      SendCommand(remote);
   }
#endif
   else Action(Token(simple, 0));
}


// Just counts spaces, make sure to run through simplifywhitespace first
int Console::NumTokens(const string& str)
{
   int count = 0;
   for (int i = 0; i < str.size(); i++)
   {
      if (str.substr(i, 1) == " ")
         count++;
   }
   return count + 1;
}


string Console::Token(const string& str, int tokennum)
{
   bool found = false;
   int count = 0;
   string newstr = str;
   while(!found && newstr.size())
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


// Note: Does not strip all trailing spaces.
string Console::SimplifyWhitespace(const string& str)
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


#ifndef DEDICATED
void Console::InitWidget(TextArea& co)
{
   consoleout = &co;
   deque<string>::iterator i = consolebuffer.begin();
   while (i != consolebuffer.end())
   {
      consoleout->Append(*i);
      i = consolebuffer.erase(i);
   }
}
#endif


/* The console needs to be written to in the process of loading autoexec.cfg, which means
   we can't have instantiated the console GUI yet, so if that is the case then we write to a
   temporary buffer that can later be loaded into the GUI portion.
*/
void Console::WriteToConsole(const string& line)
{
   cout << line << endl;
#ifndef DEDICATED
   if (consoleout)
   {
      consoleout->Append(line + "\n");
      return;
   }
#endif
   consolebuffer.push_back(line + "\n");
}


void Console::SaveToFile(const string& filename)
{
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
   save.close();
}


void Console::Action(const string& action)
{
   if (action == "help")
   {
      WriteToConsole(string("set <variable name> <value>"));
      WriteToConsole(string("help"));
   }
   else if (action == "connect")
   {
      doconnect = true;
   }
   else if (action == "restartgl")
   {
      SetupSDL();
      SetupOpenGL();
   }
   else if (action == "reloadres")
   {
      mapname = "";
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
      SDL_mutexP(clientmutex);
      player[0].name = GetString("name");
      SDL_mutexV(clientmutex);
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
   else if (action == "kill")
   {
      sendkill = true;
   }
   else if (action == "exit" || action == "quit")
   {
      Quit();
   }
}
