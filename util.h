#ifndef __UTIL_H
#define __UTIL_H

#include <string>
#include <sstream>
#include <csignal>
#include "SDL.h"
#include "Vector3.h"
#include "GraphicMatrix.h"
#include "tsint.h"

using std::string;
using std::stringstream;
using std::ostringstream;

string PadNum(int, int);
string AddressToDD(Uint32);
bool floatzero(float, float error = .00001);
float Random(float min, float max);
Vector3 RotateBetweenVectors(Vector3, const Vector3&);
int gettid();
int bitcount();
void setsighandler();
extern tsint running;
extern Log logout;

template <typename T>
string ToString(const T &input)
{
   stringstream temp;
   temp << input;
   return temp.str();
}


template <typename T>
T lerp(T x, T y, float a)
{
   return (x * a + y * (1 - a));
}

template <typename T>
T smoothstep(T x, T y, T a)
{
   if (a < x) return 0;
   if (a > y) return 1;
   return ((a - x) / (y - x));
}

#endif
