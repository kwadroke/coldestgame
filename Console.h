// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
#ifndef __CONSOLE_H
#define __CONSOLE_H

#include <map>
#include <iostream>
#include <string>
#include <deque>
#include <set>
#include "gui/TextArea.h"
#include "renderdefs.h"
#include "netdefs.h"
#include "Packet.h"

using std::map;
using std::string;
using std::endl;
using std::deque;
using std::set;
using std::inserter;

class Console
{
   public:
      Console();
      int GetInt(const string&);
      float GetFloat(const string&);
      string GetString(const string&);
      bool GetBool(const string&);
      void Parse(const string&, bool echo = true);
      void InitWidget(TextArea&);
      void WriteToConsole(const string&);
      void SaveToFile(const string&, const bool forcesave = false);
      
      
   private:
      int NumTokens(const string&);
      string Token(const string&, int);
      string SimplifyWhitespace(const string&);
      void Action(const string&);
      void Lock() {SDL_mutexP(mutex);}
      void Unlock() {SDL_mutexV(mutex);}
      
      map<string, string> values;
      set<string> saveval;
      deque<string> consolebuffer;
      TextArea* consoleout;
      SDL_mutex* mutex;
};

void SetupSDL();
void SetupOpenGL();
void Quit();

#endif
