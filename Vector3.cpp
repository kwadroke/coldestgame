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
// Copyright 2008-2012 Ben Nemec
// @End License@


#include "Vector3.h"

Vector3::Vector3() : x(0), y(0), z(0)
{
}


Vector3::Vector3(const float& xin, const float& yin, const float& zin) : x(xin), y(yin), z(zin)
{
}


#ifndef INLINE_VECTOR3
float Vector3::dot(const Vector3& v) const
{
   return x * v.x + y * v.y + z * v.z;
}

Vector3 Vector3::cross(const Vector3& v) const
{
   return Vector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x);
}

void Vector3::normalize()
{
   float mag = sqrt(x * x + y * y + z * z);
   if (mag > .000001f)
   {
      x /= mag;
      y /= mag;
      z /= mag;
   }
}

float Vector3::magnitude() const
{
   return sqrt(x * x + y * y + z * z);
}


Vector3 Vector3::operator* (const float& i) const
{
   return Vector3(x * i, y * i, z * i);
}
 
 
void Vector3::operator*= (const float& i)
{
   x *= i;
   y *= i;
   z *= i;
}


Vector3 operator*(const float i, const Vector3& v)
{
   return (v * i);
}


Vector3 Vector3::operator+ (const Vector3& v) const
{
   return Vector3(x + v.x, y + v.y, z + v.z);
}


void Vector3::operator+= (const Vector3& v)
{
   x += v.x;
   y += v.y;
   z += v.z;
}


Vector3 Vector3::operator- (const Vector3& v) const
{
   return Vector3(x - v.x, y - v.y, z - v.z);
}


void Vector3::operator-= (const Vector3& v)
{
   x -= v.x;
   y -= v.y;
   z -= v.z;
}


Vector3 operator-(const Vector3& v)
{
   return -1 * v;
}


Vector3 Vector3::operator/ (const float& i) const
{
   return Vector3(x / i, y / i, z / i);
}


void Vector3::operator/= (const float& i)
{
   x /= i;
   y /= i;
   z /= i;
}


float Vector3::distance(const Vector3& v) const
{
   return sqrt((x - v.x) * (x - v.x) + 
         (y - v.y) * (y - v.y) + 
         (z - v.z) * (z - v.z));
}


// Return the distance ^ 2 because it's faster and may be sufficient
float Vector3::distance2(const Vector3& v) const
{
   return (x - v.x) * (x - v.x) + 
         (y - v.y) * (y - v.y) + 
         (z - v.z) * (z - v.z);
}


float* Vector3::array(float *output)
{
   output[0] = x;
   output[1] = y;
   output[2] = z;
   return output;
}


void Vector3::transform(const GLfloat matrix[16])
{
   float oldx = x;
   float oldy = y;
   float oldz = z;
   x = matrix[0] * oldx + matrix[4] * oldy + matrix[8] * oldz + matrix[12];
   y = matrix[1] * oldx + matrix[5] * oldy + matrix[9] * oldz + matrix[13];
   z = matrix[2] * oldx + matrix[6] * oldy + matrix[10] * oldz + matrix[14];
}


// Intended for use in situations like normal transformation where translation doesn't matter
void Vector3::transform3(const GLfloat matrix[16])
{
   float oldx = x;
   float oldy = y;
   float oldz = z;
   x = matrix[0] * oldx + matrix[4] * oldy + matrix[8] * oldz;
   y = matrix[1] * oldx + matrix[5] * oldy + matrix[9] * oldz;
   z = matrix[2] * oldx + matrix[6] * oldy + matrix[10] * oldz;
}


void Vector3::print() const
{
   logout << x << "  " << y << "  " << z << endl;
}


void Vector3::rotate(float pitch, float rotation, float roll)
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


void Vector3::translate(float xt, float yt, float zt)
{
   x += xt;
   y += yt;
   z += zt;
}
#endif



