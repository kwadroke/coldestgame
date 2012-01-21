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


#include "GraphicMatrix.h"

GraphicMatrix::GraphicMatrix()
{
   pi = 3.14159265;
   for (int i = 0; i < 16; ++i)
   {
      if (i % 5 == 0)
         members[i] = 1;
      else members[i] = 0;
   }
}


void GraphicMatrix::translate(float x, float y, float z)
{
   members[12] += x;
   members[13] += y;
   members[14] += z;
}


void GraphicMatrix::translate(Vector3 in)
{
   members[12] += in.x;
   members[13] += in.y;
   members[14] += in.z;
}


void GraphicMatrix::rotatex(float inangle)
{
   if (inangle == 0)
      return;
   
   float angle = inangle * pi / 180;
   
   GraphicMatrix temp;
   for (int i = 0; i < 16; ++i)
      temp.members[i] = 0;
   temp.members[0] = temp.members[15] = 1;
   temp.members[5] = cos(angle);
   temp.members[6] = sin(angle);
   temp.members[9] = -sin(angle);
   temp.members[10] = cos(angle);
   *this *= temp;
}


void GraphicMatrix::rotatey(float inangle)
{
   if (inangle == 0)
      return;
   
   float angle = inangle * pi / 180;
   
   GraphicMatrix temp;
   for (int i = 0; i < 16; ++i)
      temp.members[i] = 0;
   temp.members[5] = temp.members[15] = 1;
   temp.members[0] = cos(angle);
   temp.members[2] = sin(angle);
   temp.members[8] = -sin(angle);
   temp.members[10] = cos(angle);
   *this *= temp;
}


void GraphicMatrix::rotatez(float inangle)
{
   if (inangle == 0)
      return;
   
   float angle = inangle * pi / 180;
   
   GraphicMatrix temp;
   for (int i = 0; i < 16; ++i)
      temp.members[i] = 0;
   temp.members[10] = temp.members[15] = 1;
   temp.members[0] = cos(angle);
   temp.members[1] = sin(angle);
   temp.members[4] = -sin(angle);
   temp.members[5] = cos(angle);
   *this *= temp;
}


// Note: Actually does this = m * this
void GraphicMatrix::operator*= (GraphicMatrix m)
{
   GLfloat mtemp[16];
   
   int mod, div;
   
   for (int i = 0; i < 16; ++i)
   {
      mod = i % 4;
      div = int(i / 4) * 4;
      mtemp[i] = members[div] * m.members[mod] + 
                   members[div + 1] * m.members[mod + 4] + 
                   members[div + 2] * m.members[mod + 8] + 
                   members[div + 3] * m.members[mod + 12];
   }
   
   for (int i = 0; i < 16; ++i)
   {
      members[i] = mtemp[i];
   }
}


/* Largely ripped from http://vamos.sourceforge.net/matrixfaq.htm#Q45
   No idea whether this function actually works, most likely not
   Significant testing is necessary if it is ever used.
   */
void GraphicMatrix::rotateq(Vector3 v, float w)
{
   GraphicMatrix temp;
   float savesin = sin(w / 2);
   
   float qx = v.x / savesin;
   float qy = v.y / savesin;
   float qz = v.z / savesin;
   float qw = cos(w / 2);
   
   float xx, xy, xz, xw, yy, yz, yw, zz, zw;
   xx = qx * qx;
   xy = qx * qy;
   xz = qx * qz;
   xw = qx * qw;
   
   yy = qy * qy;
   yz = qy * qz;
   yw = qy * qw;
   
   zz = qz * qz;
   zw = qz * qw;
   
   temp.members[0] = 1 - 2 * (yy + zz);
   temp.members[1] = 2 * (xy + zw);
   temp.members[2] = 2 * (xz - yw);
   temp.members[4] = 2 * (xy - zw);
   temp.members[5] = 1 - 2 * (xx + zz);
   temp.members[6] = 2 * (yz + xw);
   temp.members[8] = 2 * (xz + yw);
   temp.members[9] = 2 * (yz - xw);
   temp.members[10] = 1 - 2 * (xx - yy);
   temp.members[3] = temp.members[7] = temp.members[11] = temp.members[12] =
         temp.members[13] = temp.members[14] = 0;
   temp.members[15] = 1;
   
   *this *= temp;
}


GLfloat * GraphicMatrix::array(GLfloat *temp)
{
   temp = members;
   return temp;
}


GLfloat * GraphicMatrix::row(int num, GLfloat *temp)
{
   for (int i = 0; i < 4; ++i)
      temp[i] = members[i * 4 + num];
   return temp;
}


void GraphicMatrix::identity()
{
   for (int i = 0; i < 16; ++i)
   {
      if (i % 5 == 0)
         members[i] = 1;
      else members[i] = 0;
   }
}


