#ifndef __Vector3__
#define __Vector3__

#include "glinc.h"
#include <iostream>
#include <math.h>

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
      void operator/= (const float&);
      Vector3 cross(const Vector3&) const;
      void normalize();
      void print() const;
      float dot(const Vector3&) const;
      void rotate(float, float, float);
      void translate(float, float, float);
      void transform(const GLfloat[16]);
      void transform4(const GLfloat[16]);
      float distance(const Vector3& v = Vector3()) const;
      float distance2(const Vector3& v = Vector3()) const;
      float magnitude() const;
      float *array(float*);
      
      float x, y, z;
};

Vector3 operator*(const float, const Vector3&);
Vector3 operator-(const Vector3&);







#endif
