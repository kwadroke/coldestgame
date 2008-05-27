#ifndef __CONSOLE_H
#define __CONSOLE_H

#include <map>
#include <iostream>
#include <string>
#include <deque>
#include "gui/TextArea.h"
#include "renderdefs.h"
#include "netdefs.h"
#include "Packet.h"

using std::map;
using std::string;
using std::endl;
using std::cout;
using std::deque;

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
      
      
   private:
      int NumTokens(const string&);
      string Token(const string&, int);
      string SimplifyWhitespace(const string&);
      void Action(const string&);
      
      map<string, string> values;
      deque<string> consolebuffer;
      TextArea* consoleout;
};

void SetupSDL();
void SetupOpenGL();

#endif
