#include "Log.h"

Log::Log()
{
}


void Log::SetFile(const string& filename)
{
   if (fileout)
      fileout.close();
   fileout.open(filename.c_str());
}


Log& Log::operator<<(ostream& (*s)(ostream&))
{
   cout << s;
   if (fileout)
      fileout << s;
}



