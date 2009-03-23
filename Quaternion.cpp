// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
#include "Quaternion.h"

Quaternion::Quaternion()
{
   v.x = 0;
   v.y = 0;
   v.z = 0;
   w = 0;
   pi = 3.14159265;
}


Quaternion::Quaternion(Vector3 vin, float win)
{
   v.x = vin.x;
   v.y = vin.y;
   v.z = vin.z;
   w = win;
   pi = 3.14159265;
}


Quaternion Quaternion::operator* (Quaternion rhs)
{
   Quaternion temp;
   temp.v.x = w * rhs.v.x + v.x * rhs.w + v.y * rhs.v.z - v.z * rhs.v.y;
   temp.v.y = w * rhs.v.y - v.x * rhs.v.z + v.y * rhs.w + v.z * rhs.v.x;
   temp.v.z = w * rhs.v.z + v.x * rhs.v.y - v.y * rhs.v.x + v.z * rhs.w;
   temp.w = w * rhs.w - v.x * rhs.v.x - v.y * rhs.v.y - v.z * rhs.v.z;
   return temp;
}


void Quaternion::operator*= (Quaternion rhs)
{
   *this = *this * rhs;
}


Quaternion Quaternion::operator+ (Quaternion rhs)
{
   Quaternion temp;
   temp.v = v + rhs.v;
   temp.w = w + rhs.w;
   return temp;
}


void Quaternion::operator+= (Quaternion rhs)
{
   v += rhs.v;
   w += rhs.w;
}


void Quaternion::rotate(Vector3 axis, float angle)
{
   axis.normalize();
   Quaternion temp;
   float radangle = angle * pi / 180;
   radangle *= .5;
   temp.v.x = axis.x * sin(radangle);
   temp.v.y = axis.y * sin(radangle);
   temp.v.z = axis.z * sin(radangle);
   temp.w = cos(radangle);
   Quaternion tempconj(temp.v * -1, temp.w);
   *this = (temp * *this) * tempconj;
}


// This can be optimized
GraphicMatrix Quaternion::matrix()
{
   GraphicMatrix temp;
   temp.members[0] = 1 - 2 * (v.y * v.y + v.z * v.z);
   temp.members[1] = 2 * (v.x * v.y - v.z * w);
   temp.members[2] = 2 * (v.x * v.z + v.y * w);
   temp.members[4] = 2 * (v.x * v.y + v.z * w);
   temp.members[5] = 1 - 2 * (v.x * v.x + v.z * v.z);
   temp.members[6] = 2 * (v.y * v.z - v.x * w);
   temp.members[8] = 2 * (v.x * v.z - v.y * w);
   temp.members[9] = 2 * (v.y * v.z + v.x * w);
   temp.members[10] = 1 - 2 * (v.x * v.x + v.y * v.y);
   return temp;
}

