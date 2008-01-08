#include "ProceduralTree.h"

/*
Ideas:
-Err, I got nothin'
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
   maxsidebranchangle = 10;
   minheightvar = .75;
   maxheightvar = 1.25;
   sidetaper = .7;
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
   srand(time(0));  // Seed random number generator
   
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
      anglex = 90 + Random(-maxsidebranchangle, maxsidebranchangle);
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
            switch(j)
            {
               case 0:
                  m.translate(-leafsize, height * (locnumsegs - seg) * leafscale, radius);
                  break;
               case 1:
                  m.translate(-leafsize, 0, radius);
                  break;
               case 2:
                  m.translate(leafsize, height * (locnumsegs - seg) * leafscale, radius);
                  break;
               case 3:
                  m.translate(leafsize, 0, radius);
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
void ProceduralTree::ReadParams(ifstream &get)
{
   string name;
   get >> name;
   while (name != "endopts")
   {
      if (name == "numlevels")
         get >> numlevels;
      else if (name == "numslices")
         get >> numslices;
      else if (name == "numbranches0")
         get >> numbranches[0];
      else if (name == "numbranches1")
         get >> numbranches[1];
      else if (name == "numbranches2")
         get >> numbranches[2];
      else if (name == "numbranches3")
         get >> numbranches[3];
      else if (name == "numbranches4")
         get >> numbranches[4];
      else if (name == "maxangle")
         get >> maxangle;
      else if (name == "minangle")
         get >> minangle;
      else if (name == "maxbranchangle")
         get >> maxbranchangle;
      else if (name == "initrad")
         get >> initrad;
      else if (name == "radreductionperc")
         get >> radreductionperc;
      else if (name == "initheight")
         get >> initheight;
      else if (name == "heightreductionperc")
         get >> heightreductionperc;
      else if (name == "firstleaflevel")
         get >> firstleaflevel;
      else if (name == "leafsize")
         get >> leafsize;
      else if (name == "numsegs")
         get >> numsegs;
      else if (name == "numleaves")
         get >> numleaves;
      else if (name == "trunkrad")
         get >> trunkrad;
      else if (name == "trunknumslices")
         get >> trunknumslices;
      else if (name == "trunktaper")
         get >> trunktaper;
      else if (name == "trunknumsegs")
         get >> trunknumsegs;
      else if (name == "branchevery")
         get >> branchevery;
      else if (name == "sidebranches")
         get >> sidebranches;
      else if (name == "maxsidebranchangle")
         get >> maxsidebranchangle;
      else if (name == "split")
         get >> split;
      else if (name == "continuebranch")
         get >> continuebranch;
      else if (name == "multitrunk")
         get >> multitrunk;
      else if (name == "branchwithleaves")
         get >> branchwithleaves;
      else if (name == "sidebranchdirection")
         get >> sidebranchdirection;
      else if (name == "sidetaper")
         get >> sidetaper;
      else if (name == "minheightvar")
         get >> minheightvar;
      else if (name == "maxheightvar")
         get >> maxheightvar;
      else cout << "Unknown tree param: " << name << endl << flush;
      
      get >> name;
   }
}


