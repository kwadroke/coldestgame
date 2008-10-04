#ifndef __LOG_H
#define __LOG_H

#include <vector>
#include <fstream>
#include <string>
#include <iostream>

using std::vector;
using std::ofstream;
using std::ostream;
using std::string;
using std::cout;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Log
{
   public:
      Log();
      void SetFile(const string&);
      
      // Handle endl since the template can't
      Log& operator<<(ostream& (*f)(ostream&));
      template <typename T>
      Log& operator<<(const T& s);
      template <typename T>
      Log& operator<<(T& s);
      
   private:
      Log(const Log&); // No copying allowed
      Log& operator=(const Log&);
      
      ofstream fileout;
};


template <typename T>
Log& Log::operator<<(const T& s)
{
   cout << s;
   if (fileout)
      fileout << s;
   return *this;
}

template <typename T>
Log& Log::operator<<(T& s)
{
   cout << s;
   if (fileout)
      fileout << s;
   return *this;
}

#endif
