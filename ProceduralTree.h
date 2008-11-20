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
#include "IniReader.h"
#include "Mesh.h"
#include "Quad.h"
#include "StableRandom.h"

using namespace std;

class ProceduralTree
{
   public:
      ProceduralTree();
      long GenTree(Mesh*, Material*, Material*);
      void ReadParams(const IniReader&);
      
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
      int branchevery;
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
      void GenBranch(GraphicMatrix, int, int, vector<Vector3>, bool, int);
      float Random(float, float);
      Material *bark, *leaves;
      StableRandom random;
      
      
};

#endif
