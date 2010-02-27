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
// Copyright 2008, 2009 Ben Nemec
// @End License@


#ifndef __Vector3__
#define __Vector3__

#include "glinc.h"
#include <iostream>
#include <math.h>
#include "logout.h"

using std::endl;
using std::ostream;

// Doesn't make a huge difference in performance, but can be useful for profiling
// because it causes the time taken by Vector3 calls to be lumped into the calling
// function's profile time
#define INLINE_VECTOR3 1

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
      void transform3(const GLfloat[16]);
      float distance(const Vector3& v = Vector3()) const;
      float distance2(const Vector3& v = Vector3()) const;
      float magnitude() const;
      float *array(float*);
      
      float x, y, z;
};

Vector3 operator*(const float, const Vector3&);
Vector3 operator-(const Vector3&);

inline ostream& operator<<(ostream& stream, const Vector3& v)
{
   stream << "x: " << v.x << " y: " << v.y << " z: " << v.z;
   return stream;
}

#ifdef INLINE_VECTOR3
inline float Vector3::dot(const Vector3& v) const
{
   return x * v.x + y * v.y + z * v.z;
}

inline Vector3 Vector3::cross(const Vector3& v) const
{
   return Vector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x);
}

inline void Vector3::normalize()
{
   float mag = sqrt(x * x + y * y + z * z);
   if (mag > .000001f)
   {
      x /= mag;
      y /= mag;
      z /= mag;
   }
}

inline float Vector3::magnitude() const
{
   return sqrt(x * x + y * y + z * z);
}


inline Vector3 Vector3::operator* (const float& i) const
{
   return Vector3(x * i, y * i, z * i);
}
 
 
inline void Vector3::operator*= (const float& i)
{
   x *= i;
   y *= i;
   z *= i;
}


inline Vector3 operator*(const float i, const Vector3& v)
{
   return (v * i);
}


inline Vector3 Vector3::operator+ (const Vector3& v) const
{
   return Vector3(x + v.x, y + v.y, z + v.z);
}


inline void Vector3::operator+= (const Vector3& v)
{
   x += v.x;
   y += v.y;
   z += v.z;
}


inline Vector3 Vector3::operator- (const Vector3& v) const
{
   return Vector3(x - v.x, y - v.y, z - v.z);
}


inline void Vector3::operator-= (const Vector3& v)
{
   x -= v.x;
   y -= v.y;
   z -= v.z;
}


inline Vector3 operator-(const Vector3& v)
{
   return -1 * v;
}


inline Vector3 Vector3::operator/ (const float& i) const
{
   return Vector3(x / i, y / i, z / i);
}


inline void Vector3::operator/= (const float& i)
{
   x /= i;
   y /= i;
   z /= i;
}


inline float Vector3::distance(const Vector3& v) const
{
   return sqrt((x - v.x) * (x - v.x) + 
         (y - v.y) * (y - v.y) + 
         (z - v.z) * (z - v.z));
}


// Return the distance ^ 2 because it's faster and may be sufficient
inline float Vector3::distance2(const Vector3& v) const
{
   return (x - v.x) * (x - v.x) + 
         (y - v.y) * (y - v.y) + 
         (z - v.z) * (z - v.z);
}


inline float* Vector3::array(float *output)
{
   output[0] = x;
   output[1] = y;
   output[2] = z;
   return output;
}


inline void Vector3::print() const
{
   logout << x << "  " << y << "  " << z << endl;
}


inline void Vector3::transform(const GLfloat matrix[16])
{
   float oldx = x;
   float oldy = y;
   float oldz = z;
   x = matrix[0] * oldx + matrix[4] * oldy + matrix[8] * oldz + matrix[12];
   y = matrix[1] * oldx + matrix[5] * oldy + matrix[9] * oldz + matrix[13];
   z = matrix[2] * oldx + matrix[6] * oldy + matrix[10] * oldz + matrix[14];
}


// Intended for use in situations like normal transformation where translation doesn't matter
inline void Vector3::transform3(const GLfloat matrix[16])
{
   float oldx = x;
   float oldy = y;
   float oldz = z;
   x = matrix[0] * oldx + matrix[4] * oldy + matrix[8] * oldz;
   y = matrix[1] * oldx + matrix[5] * oldy + matrix[9] * oldz;
   z = matrix[2] * oldx + matrix[6] * oldy + matrix[10] * oldz;
}


inline void Vector3::rotate(float pitch, float rotation, float roll)
{
   float pi = 3.14159265;
   float radrotation = rotation * pi / 180.;
   float radpitch = pitch * pi / 180.;
   float radroll = roll * pi / 180.;
   
   float dx, dy, dz;
   float tempx = x;
   float tempy = y;
   float tempz = z;
      
   dx = tempx * cos(radroll) - tempy * sin(radroll);
   dy = tempx * sin(radroll) + tempy * cos(radroll);
   tempx = dx;
   tempy = dy;
   dy = tempy * cos(radpitch) - tempz * sin(radpitch);
   dz = tempy * sin(radpitch) + tempz * cos(radpitch);
   tempy = dy;
   tempz = dz;
   dz = tempz * cos(radrotation) - tempx * sin(radrotation);
   dx = tempz * sin(radrotation) + tempx * cos(radrotation);
   x = dx;
   y = dy;
   z = dz;
}


inline void Vector3::translate(float xt, float yt, float zt)
{
   x += xt;
   y += yt;
   z += zt;
}
#endif





#endif
