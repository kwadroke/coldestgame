#ifndef __UTIL_H
#define __UTIL_H

#include <string>
#include <sstream>

using std::string;
using std::stringstream;
using std::ostringstream;

string PadNum(int, int);
bool floatzero(float, float error = .00001);
float Random(float min, float max);
int gettid();

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

#endif
