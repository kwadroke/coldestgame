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
#ifndef __GRAPHIC_MATRIX
#define __GRAPHIC_MATRIX

#include "glinc.h"
#include <math.h>
#include <iostream>
#include "Vector3.h"

using std::endl;

class GraphicMatrix
{
   private:
      float pi;
      
   public: 
      GLfloat members[16];
      
      GraphicMatrix();
      void translate(float, float, float);
      void translate(Vector3);
      void rotatex(float);
      void rotatey(float);
      void rotatez(float);
      void operator*= (GraphicMatrix);
      void rotateq(Vector3, float);
      GLfloat* array(GLfloat*);
      void identity();
      GLfloat* row(int, GLfloat*);
      
      operator float* () const {return (float*) members;}
      operator const float* () const {return (const float*) members;}
      
};
#endif
