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


#include "util.h"
#include <SDL/SDL.h>

int PowerOf2(int input)
{
   int value = 1;

   while ( value < input ) 
   {
      value <<= 1;
   }
   return value;
}

string PadNum(int n, int digits)
{
   stringstream temp;
   temp.width(digits);
   temp.fill('0');
   temp << n;
   return temp.str();
}


string AddressToDD(Uint32 ahost)
{
   int parts[4];
#if SDL_BYTEORDER == SDL_LIL_ENDIAN
   parts[0] = ahost & 0x000000ff;
   parts[1] = (ahost & 0x0000ff00) >> 8;
   parts[2] = (ahost & 0x00ff0000) >> 16;
   parts[3] = (ahost & 0xff000000) >> 24;
#else
   parts[0] = ahost & 0xff000000;
   parts[1] = (ahost & 0x00ff0000) >> 8;
   parts[2] = (ahost & 0x0000ff00) >> 16;
   parts[3] = (ahost & 0x000000ff) >> 24;
#endif
   ostringstream dotteddec;
   dotteddec << parts[0] << '.' << parts[1] << '.' << parts[2] << '.' << parts[3];
   return dotteddec.str();
}


bool floatzero(float num, float error)
{
   return (num < 0 + error && num > 0 - error);
}


float Random(float min, float max)
{
   if (max <= min) return min;
   float size = max - min;
   return (size * ((float)rand() / (float)RAND_MAX) + min);
}


Vector3 RotateBetweenVectors(Vector3 start, const Vector3& end)
{
   Vector3 ret;
   Vector3 dir = end;
   start.normalize();
   dir.y = 0;
   dir.normalize();
   ret.y = acos(clamp(-1.f, 1.f, start.dot(dir))) * 180.f / 3.14159265f;
   if (start.cross(dir).y >= 0)
      ret.y *= -1;
   dir = end;
   dir.normalize();
   GraphicMatrix rotm;
   rotm.rotatey(ret.y);
   start.transform(rotm);
   ret.x = acos(clamp(-1.f, 1.f, start.dot(dir))) * 180.f / 3.14159265f;
   if (dir.y >= 0)
      ret.x *= -1;
   return ret;
}


// The main thread isn't necessarily the one getting this signal, and Quit() needs to
// be called from there, so signal it that we're done.
void handler(int param)
{
   running = false;
}
void setsighandler()
{
   signal(SIGTERM, handler);
   signal(SIGINT, handler);
}


// This maybe shouldn't return an int...
int gettid()
{
#ifdef linux
#ifndef __amd64__
      return syscall(224);
#else
      return syscall(186);
#endif
#endif
   return 0;
}


// Don't think this is actually used since runtime bit counting is not very useful and we (royal we of course;-)
// recently discovered the compiler defines that indicate bit count.
int bitcount()
{
   return sizeof(void*) * 8;
}


vector<string> split(const string& str, const string& sep)
{
   string remaining = str;
   string currval;
   vector<string> retval;
   while (remaining.length())
   {
      currval = remaining.substr(0, remaining.find(sep));
      if (remaining.find(sep) != string::npos)
         remaining = remaining.substr(remaining.find(sep) + 1);
      else remaining = "";
      retval.push_back(currval);
   }
   return retval;
}

