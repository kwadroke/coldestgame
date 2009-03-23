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
#ifndef __LIGHT_H
#define __LIGHT_H

#include <vector>
#include "Vector3.h"
#include "GraphicMatrix.h"
#include "glinc.h"

using namespace std;

typedef vector<GLfloat> glfvec;

class Light
{
   public:
      Light();
      void SetPos(int, Vector3);
      void SetDir(int, Vector3);
      Vector3 GetPos(int);
      Vector3 GetDir(int);
      Vector3 GetRots(int);
      int Add();
      void SetDiffuse(int, GLfloat[]);
      void SetAmbient(int, GLfloat[]);
      void SetSpecular(int, GLfloat[]);
      void Place();
      int NumLights();
      GraphicMatrix GetView(int, Vector3);
      GraphicMatrix GetProj(int, float);
      static long int infinity;
      
   private:
      bool isvalid(int);
      
      vector<Vector3> posdir;
      vector<glfvec> diffuse;
      vector<glfvec> ambient;
      vector<glfvec> specular;
      vector<bool> type;
      vector<GraphicMatrix> view;
      vector<GraphicMatrix> proj;
      
};

#endif
