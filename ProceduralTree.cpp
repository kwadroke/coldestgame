#include "ProceduralTree.h"

/*
Ideas:
-Define curves of branches
*/

ProceduralTree::ProceduralTree()
{
   numlevels = 3;
   numslices = 4;
   numbranches[0] = 5;
   numbranches[1] = 2;
   numbranches[2] = 3;
   maxangle = 70;
   minangle = 20;
   maxbranchangle = 5;
   initrad = 5;
   radreductionperc = .3;
   initheight = 20;
   heightreductionperc = .7;
   firstleaflevel = 2;
   leafsize = 5;
   numsegs = 3;
   numleaves = 2;
   trunkrad = 5;
   trunknumslices = 10;
   trunktaper = .8;
   trunknumsegs = 8;
   branchevery = 8;
   sidebranches = 12;
   minsidebranchangle = -10;
   maxsidebranchangle = 10;
   minheightvar = .75;
   maxheightvar = 1.25;
   sidetaper = .7;
   curvecoeff = 0.f;
   split = false;
   continuebranch = true;
   multitrunk = false;
   branchwithleaves = true;
}


// Returns the number of primitives generated
long ProceduralTree::GenTree(list<WorldObjects>::iterator currobj)
{
   object = currobj;
   totalprims = 0;
   srand(time(0) + rand());  // Seed random number generator - the rand() is to make sure that
                             // when we create two trees in the same ms they're not identical
   
   GraphicMatrix m;
   Vector3 temp;
   vector<Vector3> pts;
   
   float sliceangle = 360. / trunknumslices;
   for (int j = 0; j < trunknumslices; ++j)
   {
      m = GraphicMatrix();
      temp = Vector3();
      m.translate(trunkrad, 0, 0);
      m.rotatey(-sliceangle * j);
      m.translate(object->x, object->y, object->z);
      temp.transform(m.members);
      pts.push_back(temp);
   }
   m = GraphicMatrix();
   m.translate(object->x, object->y, object->z);
   int i = 0;
   if (!multitrunk)
      i = numbranches[0] - 1;
   for (; i < numbranches[0]; ++i)
      GenBranch(m, 0, 0, pts, true, 0);
   return totalprims;
}


void ProceduralTree::GenBranch(GraphicMatrix trans, int lev, int seg, vector<Vector3> oldpts, bool trunk, int side)
{
   if (lev > numlevels) return;
   vector<Vector3> newpts;
   vector<Vector3> normals;
   
   float anglex, angley, anglez;
   float startrad, endrad;
   float locnumsegs;
   int savenumslices = numslices;
   locnumsegs = numsegs;
   
   if (lev == 0) // Trunk radius and slices are handled differently
   {
      startrad = trunkrad * pow(trunktaper, seg + 1);
      endrad = trunkrad * pow(trunktaper, seg + 2);
      numslices = trunknumslices;
      locnumsegs = trunknumsegs;
   }
   else 
   {
      startrad = initrad * pow(radreductionperc, lev);
      endrad = initrad * pow(radreductionperc, lev + 1);
   }
   float radius = ((locnumsegs - seg) * startrad + seg * endrad) / locnumsegs;
   
   float height;
   height = initheight * pow(heightreductionperc, lev);
   height = Random(height * minheightvar, height * maxheightvar);
   height /= locnumsegs;
   
   if (side)
   {
      //locnumsegs = side;
      radius = ((locnumsegs - side) * startrad + side * endrad) / locnumsegs;
      height *= pow(sidetaper, seg);
   }
   
   float sliceangle = 360. / numslices;
   int locnumbranches;
   locnumbranches = numbranches[lev];
   Vector3 temp;
   GraphicMatrix m;
   
   anglex = angley = anglez = 0;
   if (seg == 0 && lev != 0 && !trunk && side != 1)
   {
      anglex = Random(minangle, maxangle);
      if (Random(0, 1) > .5) anglex *= -1;
      angley = 0;
      anglez = Random(minangle, maxangle);
      if (Random(0, 1) > .5) anglez *= -1;
   }
   else if (side == 1)
   {
      anglex = 90 + Random(minsidebranchangle, maxsidebranchangle);
      angley = Random(0, 360);
      anglez = 0;
   }
   else if (lev != 0)
   {
      anglex = Random(-maxbranchangle, maxbranchangle);
      angley = 0;
      anglez = Random(-maxbranchangle, maxbranchangle);
   }
   
   if (branchwithleaves || lev < firstleaflevel)
   {
      for (int j = 0; j < numslices; ++j)
      {
         m.identity();
         temp = Vector3();
         m.translate(radius, height, 0);
         m.rotatey(-sliceangle * j);
         m.rotatex(anglex);
         m.rotatey(angley);
         m.rotatez(anglez);
         m *= trans;
         int square = side ? side : seg;
         m.translate(0, curvecoeff * (float)(square * square) * height, 0);
         temp.transform(m);
         newpts.push_back(temp);
         
         Vector3 norm = Vector3();
         m.identity();
         m.translate(0, height, 0);
         m.rotatey(-sliceangle * j);
         m.rotatex(anglex);
         m.rotatey(angley);
         m.rotatez(anglez);
         m *= trans;
         norm.transform(m);
         normals.push_back(temp - norm);
      }
      
      if (side == 1) // Then we don't care about oldpts
      {
         oldpts.clear();
         for (int j = 0; j < numslices; ++j)
         {
            m.identity();
            temp = Vector3();
            m.translate(radius, 0, 0);
            m.rotatey(-sliceangle * j);
            m.rotatex(anglex);
            m.rotatey(angley);
            m.rotatez(anglez);
            m *= trans;
            temp.transform(m.members);
            oldpts.push_back(temp);
         }
      }
      
      // Generate primitives from our points
      //for (int j = 0; j < numslices; ++j)
      int newind, newind1;
      for (int j = 0; j < oldpts.size(); ++j)
      {
         WorldPrimitives temp;
         temp.object = object;
         temp.type = "tristrip";
         temp.texnums[0] = object->texnum;
         temp.collide = (lev == 0);
         newind = (int)(j * ((float)numslices / (float)oldpts.size()));
         newind1 = (int)((j + 1) * ((float)numslices / (float)oldpts.size()));
         temp.v[0] = newpts[newind];
         temp.v[1] = oldpts[j];
         temp.v[2] = newpts[newind1 % numslices];
         temp.v[3] = oldpts[(j + 1) % oldpts.size()];
         // Generate normals
         temp.n[0] = normals[newind];
         temp.n[1] = normals[newind];
         temp.n[2] = normals[newind1 % numslices];
         temp.n[3] = normals[newind1 % numslices];
         for (int n = 0; n < 4; n++)
         {
            /*
            Vector3 temp1 = temp.v[1] - temp.v[0];
            Vector3 temp2 = temp.v[2] - temp.v[0];
            temp.n[n] = temp1.cross(temp2);
            temp.n[n].normalize();
            */
            temp.n[n].normalize();
         }
         
         object->prims.push_back(temp);
         ++totalprims;
      }
   }
   /* If this was a trunk piece we're done with numslices so set it back
      for the branches*/
   numslices = savenumslices;
   
   // Generate leaves if necessary
   if (lev >= firstleaflevel && (!seg || side == 1))
   {
      vector<Vector3> verts;
      float leafangle = 180. / numleaves + Random(-45.f, 45.f);
      for (int i = 0; i < numleaves; ++i)
      {
         verts.clear();
         for (int j = 0; j < 4; ++j)
         {
            temp = Vector3();
            m.identity();
            float leafscale = 1.5;
            float overlap = 5;
            switch(j)
            {
               case 0:
                  m.translate(-leafsize, height * (locnumsegs - seg) * leafscale, radius);
                  break;
               case 1:
                  m.translate(-leafsize, -overlap, radius);
                  break;
               case 2:
                  m.translate(leafsize, height * (locnumsegs - seg) * leafscale, radius);
                  break;
               case 3:
                  m.translate(leafsize, -overlap, radius);
                  break;
            };
               
            m.rotatey(leafangle * i);
            m.rotatex(anglex);
            m.rotatey(angley);
            m.rotatez(anglez);
            m *= trans;
            temp.transform(m.members);
            verts.push_back(temp);
         }
         
         WorldPrimitives temp;
         temp.object = object;
         temp.type = "tristrip";
         temp.texnums[0] = object->texnum2;
         temp.collide = false;
         
         for (int j = 0; j < 4; ++j)
            temp.v[j] = verts[j];
         // Generate normals
         for (int n = 0; n < 4; n++)
         {
            Vector3 temp1 = temp.v[1] - temp.v[0];
            Vector3 temp2 = temp.v[2] - temp.v[0];
            temp.n[n] = temp1.cross(temp2);
            temp.n[n].normalize();
         }
         object->prims.push_back(temp);
         ++totalprims;
         
      }
   }
   
   // Regenerate matrix to point at center of the open end of the cylinder
   m.identity();
   m.translate(0, height, 0);
   m.rotatex(anglex);
   m.rotatey(angley);
   m.rotatez(anglez);
   m *= trans;
   int square = side ? side : seg;
   m.translate(0, curvecoeff * (float)(square * square) * height, 0);
   
   if (seg && (seg % branchevery == 0))  // Side branches
   {
      for (int i = 0; i < sidebranches; ++i)
      {
         GenBranch(m, lev + 1, seg - 1, newpts, false, 1);
      }
   }
   if (seg >= locnumsegs - 1 && split)  // Split ends:-)
   {
      for (int i = 0; i < locnumbranches; ++i)
         GenBranch(m, lev + 1, 0, newpts, false, 0);
   }
   else if (!side && seg < locnumsegs)  // This branch, next segment
      GenBranch(m, lev, seg + 1, newpts, true, 0);
   else if (side && side < locnumsegs)
      GenBranch(m, lev, seg, newpts, true, side + 1);
   if (continuebranch && seg >= locnumsegs)  // Continue, probably pretty useless
      GenBranch(m, lev + 1, 0, newpts, true, 0);
}


float ProceduralTree::Random(float min, float max)
{
   if (max < min) return 0;
   float size = max - min;
   return (size * ((float)rand() / (float)RAND_MAX) + min);
}




// Reads tree parameters from the designated stringstream
void ProceduralTree::ReadParams(IniReader &get)
{
   get.Read(numlevels, "numlevels");
   get.Read(numslices, "numslices");
   get.Read(numbranches[0], "numbranches0");
   get.Read(numbranches[1], "numbranches1");
   get.Read(numbranches[2], "numbranches2");
   get.Read(numbranches[3], "numbranches3");
   get.Read(numbranches[4], "numbranches4");
   get.Read(maxangle, "maxangle");
   get.Read(minangle, "minangle");
   get.Read(maxbranchangle, "maxbranchangle");
   get.Read(initrad, "initrad");
   get.Read(radreductionperc, "radreductionperc");
   get.Read(initheight, "initheight");
   get.Read(heightreductionperc, "heightreductionperc");
   get.Read(firstleaflevel, "firstleaflevel");
   get.Read(leafsize, "leafsize");
   get.Read(numsegs, "numsegs");
   get.Read(numleaves, "numleaves");
   get.Read(trunkrad, "trunkrad");
   get.Read(trunknumslices, "trunknumslices");
   get.Read(trunktaper, "trunktaper");
   get.Read(trunknumsegs, "trunknumsegs");
   get.Read(branchevery, "branchevery");
   get.Read(sidebranches, "sidebranches");
   get.Read(minsidebranchangle, "minsidebranchangle");
   get.Read(maxsidebranchangle, "maxsidebranchangle");
   get.Read(split, "split");
   get.Read(continuebranch, "continuebranch");
   get.Read(multitrunk, "multitrunk");
   get.Read(branchwithleaves, "branchwithleaves");
   get.Read(sidetaper, "sidetaper");
   get.Read(minheightvar, "minheightvar");
   get.Read(maxheightvar, "maxheightvar");
   get.Read(curvecoeff, "curvecoeff");
}


