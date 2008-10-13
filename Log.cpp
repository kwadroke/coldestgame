#include "Log.h"

Log::Log()
{
}


void Log::SetFile(const string& filename)
{
   fileout.open(filename.c_str());
}


Log& Log::operator<<(ostream& (*s)(ostream&))
{
   cout << s;
   if (fileout)
      fileout << s;
	return *this;
}



