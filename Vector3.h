#ifndef __Vector3__
#define __Vector3__

#define NO_SDL_GLEXT
#include <iostream>
#include <math.h>
#include "SDL_opengl.h"

class Vector3
{
   public:
      Vector3();
      Vector3(float, float, float);
      Vector3 operator* (float);
      void operator*= (float);
      Vector3 operator+ (Vector3);
      void operator+= (Vector3);
      Vector3 operator- (Vector3);
      void operator-= (Vector3);
      Vector3 operator/ (float);
      void operator /= (float);
      Vector3 cross(Vector3);
      void normalize();
      void print();
      float dot(Vector3);
      void rotate(float, float, float);
      void translate(float, float, float);
      void transform(GLfloat[16]);
      void transform4(GLfloat[16]);
      float distance(Vector3);
      float distance2(Vector3 v = Vector3());
      float magnitude();
      float x, y, z;
      float *array(float*);
};


inline float Vector3::dot(Vector3 v)
{
   return x * v.x + y * v.y + z * v.z;
}

inline Vector3 Vector3::cross(Vector3 v)
{
/*   Vector3 newv(0, 0, 0);
   newv.x = y * v.z - z * v.y;
   newv.y = z * v.x - x * v.z;
   newv.z = x * v.y - y * v.x;
   return newv;*/
   return Vector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x);
}

inline void Vector3::normalize()
{
   float mag = sqrt(x * x + y * y + z * z);
   if (mag != 0)
   {
      x /= mag;
      y /= mag;
      z /= mag;
   }
}

#endif
