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
      Vector3(const float&, const float&, const float&);
      Vector3 operator* (const float&) const;
      void operator*= (const float&);
      Vector3 operator+ (const Vector3&) const;
      void operator+= (const Vector3&);
      Vector3 operator- (const Vector3&) const;
      void operator-= (const Vector3&);
      Vector3 operator/ (const float&) const;
      void operator /= (const float&);
      Vector3 cross(const Vector3&) const;
      void normalize();
      void print();
      float dot(const Vector3&) const;
      void rotate(float, float, float);
      void translate(float, float, float);
      void transform(const GLfloat[16]);
      void transform4(const GLfloat[16]);
      float distance(const Vector3&) const;
      float distance2(const Vector3& v = Vector3()) const;
      float magnitude() const;
      float x, y, z;
      float *array(float*);
};


inline float Vector3::dot(const Vector3& v) const
{
   return x * v.x + y * v.y + z * v.z;
}

inline Vector3 Vector3::cross(const Vector3& v) const
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
