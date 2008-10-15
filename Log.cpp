#include "Log.h"

// Note: violating all kinds of rules here, but since Log should only ever be constructed once, and never destructed
// (except at program exit), I'm not worrying about it.  If any of those conditions should change for some reason
// this will need to be fixed.
Log::Log()
{
   mutex = SDL_CreateMutex();
}


void Log::SetFile(const string& filename)
{
   SDL_mutexP(mutex);
   fileout.open(filename.c_str());
   SDL_mutexV(mutex);
}


Log& Log::operator<<(ostream& (*s)(ostream&))
{
   SDL_mutexP(mutex);
   cout << s;
   if (fileout)
      fileout << s;
   SDL_mutexV(mutex);
	return *this;
}



