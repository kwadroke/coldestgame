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
   if (max < min) return 0;
   float size = max - min;
   return (size * ((float)rand() / (float)RAND_MAX) + min);
}


// This maybe shouldn't return an int...
int gettid()
{
#ifdef LINUX
   if (bitcount() == 32)
      return syscall(224);
   else if (bitcount() == 64)
      return syscall(186);
#endif
   return 0;
}


int bitcount()
{
   return sizeof(void*) * 8;
}
