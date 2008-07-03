#ifndef __GLOBALS
#define __GLOBALS

#include <string>
#include <sstream>

#define PI 3.14159265

using std::string;
using std::stringstream;

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
