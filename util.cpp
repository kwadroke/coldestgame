#include "util.h"
#include "SDL.h"

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


// TODO: This is almost certainly not portable as written
string AddressToDD(Uint32 ahost)
{
   int parts[4];
   parts[0] = ahost & 0x000000ff;
   parts[1] = (ahost & 0x0000ff00) >> 8;
   parts[2] = (ahost & 0x00ff0000) >> 16;
   parts[3] = (ahost & 0xff000000) >> 24;
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
   ret.y = acos(start.dot(dir)) * 180.f / 3.14159265f;
   if (start.cross(dir).y >= 0)
      ret.y *= -1;
   dir = end;
   dir.normalize();
   GraphicMatrix rotm;
   rotm.rotatey(ret.y);
   start.transform(rotm);
   ret.x = acos(start.dot(dir)) * 180.f / 3.14159265f;
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


int bitcount()
{
   return sizeof(void*) * 8;
}
