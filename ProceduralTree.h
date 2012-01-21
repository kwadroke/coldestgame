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


#ifndef __PROCEDURALTREE_H
#define __PROCEDURALTREE_H

#include <cstdlib>
#include <ctime>
#include <math.h>
#include <list>
#include <vector>
#include <string>
#include <fstream>
#include "GraphicMatrix.h"
#include "NTreeReader.h"
#include "Mesh.h"
#include "Quad.h"
#include "StableRandom.h"

class ProceduralTree
{
   public:
      ProceduralTree();
      size_t GenTree(Mesh*, Material*, Material*);
      void ReadParams(const NTreeReader&);
      
      int numlevels;
      int firstleaflevel;
      int numslices;
      int numbranches[10];
      int totalprims;
      int numsegs;
      int numleaves;
      int randseed;
      int trunknumslices;
      int trunknumsegs;
      int branchafter;
      int sidebranches;
      int leafsegs;
      int seed;
      float maxangle;
      float minangle;
      float maxbranchangle;
      float maxtrunkangle;
      float initrad;
      float radreductionperc;
      float initheight;
      float heightreductionperc;
      float leafsize;
      float trunkrad;
      float trunktaper;
      float minsidebranchangle;
      float maxsidebranchangle;
      float sidesizeperc;
      float minheightvar;
      float maxheightvar;
      float sidetaper;
      float curvecoeff;
      float leafcurve;
      bool continuebranch;
      bool multitrunk;
      bool split;
      bool branchwithleaves;
      Mesh* mesh;
      string barkfile, leavesfile;
      
   private:
      void GenBranch(GraphicMatrix, int, int, vector<Vector3>, int);
      float Random(float, float);
      Material *bark, *leaves;
      StableRandom random;
      
      
};

#endif
