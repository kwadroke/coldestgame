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
#include "ProceduralTree.h"

/*
Ideas:
-Define curves of branches
*/

ProceduralTree::ProceduralTree()
{
   numlevels = 2;
   numslices = 3;
   numbranches[0] = 5;
   numbranches[1] = 2;
   numbranches[2] = 3;
   maxangle = 70;
   minangle = 20;
   maxbranchangle = 5;
   maxtrunkangle = 5.f;
   initrad = 5;
   radreductionperc = .2;
   initheight = 40;
   heightreductionperc = .7;
   firstleaflevel = 2;
   leafsize = 20;
   numsegs = 3;
   numleaves = 1;
   trunkrad = 5;
   trunknumslices = 10;
   trunktaper = .9;
   trunknumsegs = 8;
   branchafter = 1;
   sidebranches = 0;
   minsidebranchangle = -10;
   maxsidebranchangle = 10;
   sidesizeperc = .75f;
   minheightvar = .75;
   maxheightvar = 1.25;
   sidetaper = .7;
   curvecoeff = 0.f;
   split = true;
   continuebranch = false;
   multitrunk = false;
   branchwithleaves = false;
   leafsegs = 2;
   leafcurve = 3.f;
   seed = 0;
}


// Returns the number of primitives generated
long ProceduralTree::GenTree(Mesh* currmesh, Material* barkmat, Material* leavesmat)
{
   mesh = currmesh;
   bark = barkmat;
   leaves = leavesmat;
   totalprims = 0;
   random.Seed(seed);
   
   GraphicMatrix m;
   Vector3 temp;
   vector<Vector3> pts;
   Vector3 mrot = mesh->GetRotation();
   
   float sliceangle = 360. / trunknumslices;
   for (int j = 0; j < trunknumslices; ++j)
   {
      m = GraphicMatrix();
      temp = Vector3();
      m.translate(trunkrad, 0, 0);
      m.rotatey(-sliceangle * j);
      
      m.rotatex(mrot.x);
      m.rotatey(mrot.y);
      m.translate(mesh->GetPosition());
      temp.transform(m);
      pts.push_back(temp);
   }
   m = GraphicMatrix();
   m.rotatex(mrot.x);
   m.rotatey(mrot.y);
   m.translate(mesh->GetPosition());
   int i = 0;
   if (!multitrunk)
      i = numbranches[0] - 1;
   for (; i < numbranches[0]; ++i)
      GenBranch(m, 0, 0, pts, true, 0);
   // Center the mesh location
   currmesh->CalcBounds();
   currmesh->Move(currmesh->GetPosition() + Vector3(0, currmesh->GetHeight() / 2.f, 0));
   // Force reset of dimensions
   currmesh->Move(currmesh->GetPosition(), true);
   return totalprims;
}


void ProceduralTree::GenBranch(GraphicMatrix trans, int lev, int seg, vector<Vector3> oldpts, bool trunk, int side)
{
   if (lev > numlevels) return;
   vector<Vector3> newpts;
   vector<Vector3> normals;
   vector<Vector3> oldnorms;
   
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
      if (!side)
      {
         startrad = initrad * pow(radreductionperc, lev);
         endrad = initrad * pow(radreductionperc, lev + 1);
      }
      else if (lev == 1) // Won't work for branches not off the trunk
      {
         startrad = trunkrad * pow(trunktaper, seg + 1);
         endrad = trunkrad * pow(trunktaper, seg + 2);
      }
   }
   float radius = ((locnumsegs - seg) * startrad + seg * endrad) / locnumsegs;
   
   float height;
   height = initheight * pow(heightreductionperc, lev);
   height = random.Random(height * minheightvar, height * maxheightvar);
   height /= locnumsegs;
   
   if (side)
   {
      startrad = radius * sidesizeperc;
      endrad = startrad * radreductionperc;
      radius = ((locnumsegs - side) * startrad + side * endrad) / locnumsegs;
      height *= pow(sidetaper, seg);
   }
   
   float sliceangle = 360. / numslices;
   int locnumbranches;
   locnumbranches = numbranches[lev];
   Vector3 temp;
   GraphicMatrix m;
   
   anglex = angley = anglez = 0;
   if (seg == 0 && lev != 0 && !side) // Angle of new normal branch
   {
      anglex = random.Random(minangle, maxangle);
      if (random.Random(0, 1) > .5) anglex *= -1;
      angley = 0;
      anglez = random.Random(minangle, maxangle);
      if (random.Random(0, 1) > .5) anglez *= -1;
   }
   else if (side == 1) // Angle of new side branch
   {
      anglex = 90 + random.Random(minsidebranchangle, maxsidebranchangle);
      angley = random.Random(0, 360);
      anglez = 0;
   }
   else if (lev != 0) // Continued angle of current branch
   {
      anglex = random.Random(-maxbranchangle, maxbranchangle);
      angley = 0;
      anglez = random.Random(-maxbranchangle, maxbranchangle);
   }
   else // Trunk angle
   {
      anglex = random.Random(-maxtrunkangle, maxtrunkangle);
      angley = 0;
      anglez = random.Random(-maxtrunkangle, maxtrunkangle);
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
         if (lev != 0)
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
         if (lev != 0)
            m.translate(0, curvecoeff * (float)(square * square) * height, 0);
         norm.transform(m);
         Vector3 tempn = temp - norm;
         tempn.normalize();
         normals.push_back(tempn);
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
      
      for (int j = 0; j < oldpts.size(); ++j)
      {
         temp = Vector3();
         temp.transform(trans);
         Vector3 norm = oldpts[j] - temp;
         norm.normalize();
         oldnorms.push_back(norm);
      }
      
      // Generate primitives from our points
      
      if (lev == 0)
      {
         Vector3 colstart, colend;
         for (int j = 0; j < oldpts.size(); ++j)
         {
            colstart += oldpts[j];
         }
         colstart /= oldpts.size();
         for (int j = 0; j < newpts.size(); ++j)
         {
            colend += newpts[j];
         }
         colend /= newpts.size();
         TrianglePtr coltri = TrianglePtr(new Triangle(mesh->vertheap));
         coltri->v[0]->pos = colstart;
         coltri->v[1]->pos = colstart;
         coltri->v[2]->pos = colend;
         coltri->radmod = radius;
         coltri->collide = true;
         coltri->material = bark;
         mesh->Add(coltri);
      }
      int newind, newind1;
      for (int j = 0; j < oldpts.size(); ++j)
      {
         Quad tempq(mesh->vertheap);
#ifndef DEDICATED
         tempq.SetMaterial(bark);
#endif
         newind = (int)(j * ((float)numslices / (float)oldpts.size()));
         newind1 = (int)((j + 1) * ((float)numslices / (float)oldpts.size()));
         tempq.SetVertex(0, newpts[newind]);
         tempq.SetVertex(1, oldpts[j]);
         tempq.SetVertex(2, oldpts[(j + 1) % oldpts.size()]);
         tempq.SetVertex(3, newpts[newind1 % numslices]);
         
         tempq.SetNormal(0, normals[newind]);
         tempq.SetNormal(1, oldnorms[j]);
         tempq.SetNormal(2, oldnorms[(j + 1) % oldpts.size()]);
         tempq.SetNormal(3, normals[newind1 % numslices]);
         
         floatvec tc(2, 0.f);
         int currseg = side ? side - 1 : seg;
         tc[0] = float(j) / float(oldpts.size());
         tc[1] = 1.f - float(currseg + 1) / float(locnumsegs);
         tempq.SetTexCoords(0, 0, tc);
         tc[1] = 1.f - float(currseg) / float(locnumsegs);
         tempq.SetTexCoords(1, 0, tc);
         tc[0] = float(j + 1) / float(oldpts.size());
         tempq.SetTexCoords(2, 0, tc);
         tc[1] = 1.f - float(currseg + 1) / float(locnumsegs);
         tempq.SetTexCoords(3, 0, tc);
         
         //if (lev == 0)
         //   tempq.SetCollide(true);
         
         mesh->Add(tempq);
         ++totalprims;
      }
   }
   /* If this was a trunk piece we're done with numslices so set it back
      for the branches*/
   numslices = savenumslices;
   
   // Generate leaves if necessary
   if (lev >= firstleaflevel && (!seg || side == 1))
   {
      vector<VertexVHPvec> verts(leafsegs + 1, VertexVHPvec(leafsegs + 1));
      float leafangle = 0.f;//180. / numleaves + random.Random(-45.f, 45.f);
      float leafscale = 1.5;
      float leafheight = height * (locnumsegs - seg) * leafscale;
      float overlap = 5;
      for (int i = 0; i < numleaves; ++i)
      {
         for (int x = -leafsegs / 2; x < leafsegs / 2; ++x)
         {
            for (int y = -leafsegs / 2; y < leafsegs / 2; ++y)
            {
               float x1 = float(x + 1);
               float y1 = float(y + 1);
               float curveoffset = leafcurve * (float(x * x) + float(y * y));
               float curveoffset1 = leafcurve * (float(x1 * x1) + float(y * y));
               float curveoffset2 = leafcurve * (float(x * x) + float(y1 * y1));
               float curveoffset3 = leafcurve * (float(x1 * x1) + float(y1 * y1));
               
               Quad tempq(mesh->vertheap);
               tempq.SetMaterial(leaves);
               tempq.SetCollide(false);
               VertexVHPvec vertptrs(4);
               
               for (int j = 0; j < 4; ++j)
               {
                  temp = Vector3();
                  Vertex newvert;
                  m.identity();
                  switch(j)
                  {
                     case 0:
                        m.translate(-leafsize + (leafsize * 2.f * float(x + leafsegs / 2) / float(leafsegs)), 
                                     -leafsize + (leafsize * 2.f * float(y + 1 + leafsegs / 2) / float(leafsegs)), 
                                    radius + curveoffset2);
                        newvert.texcoords[0][0] = 1.f - float(x + leafsegs / 2) / float(leafsegs);
                        newvert.texcoords[0][1] = 1.f - float(y + 1 + leafsegs / 2) / float(leafsegs);
                        break;
                     case 1:
                        m.translate(-leafsize + (leafsize * 2.f * float(x + leafsegs / 2) / float(leafsegs)), 
                                     -leafsize + (leafsize * 2.f * float(y + leafsegs / 2) / float(leafsegs)), 
                                     radius + curveoffset);
                        newvert.texcoords[0][0] = 1.f - float(x + leafsegs / 2) / float(leafsegs);
                        newvert.texcoords[0][1] = 1.f - float(y + leafsegs / 2) / float(leafsegs);
                        break;
                     case 2:
                        m.translate(-leafsize + (leafsize * 2.f * float(x + 1 + leafsegs / 2) / float(leafsegs)), 
                                     -leafsize + (leafsize * 2.f * float(y + leafsegs / 2) / float(leafsegs)), 
                                     radius + curveoffset1);
                        newvert.texcoords[0][0] = 1.f - float(x + 1 + leafsegs / 2) / float(leafsegs);
                        newvert.texcoords[0][1] = 1.f - float(y + leafsegs / 2) / float(leafsegs);
                        break;
                     case 3:
                        m.translate(-leafsize + (leafsize * 2.f * float(x + 1 + leafsegs / 2) / float(leafsegs)), 
                                     -leafsize + (leafsize * 2.f * float(y + 1 + leafsegs / 2) / float(leafsegs)), 
                                     radius + curveoffset3);
                        newvert.texcoords[0][0] = 1.f - float(x + 1 + leafsegs / 2) / float(leafsegs);
                        newvert.texcoords[0][1] = 1.f - float(y + 1 + leafsegs / 2) / float(leafsegs);
                        break;
                  };
                     
                  m.rotatey(leafangle * i);
                  m.rotatex(anglex);
                  m.rotatey(angley);
                  m.rotatez(anglez);
                  m *= trans;
                  temp.transform(m);
                  newvert.pos = temp;
                  
                  switch (j)
                  {
                     case 0:
                        if (!verts[x + leafsegs / 2][y + 1 + leafsegs / 2])
                           verts[x + leafsegs / 2][y + 1 + leafsegs / 2] = mesh->vertheap.insert(newvert);
                        vertptrs[j] = verts[x + leafsegs / 2][y + 1 + leafsegs / 2];
                        break;
                     case 1:
                        if (!verts[x + leafsegs / 2][y + leafsegs / 2])
                           verts[x + leafsegs / 2][y + leafsegs / 2] = mesh->vertheap.insert(newvert);
                        vertptrs[j] = verts[x + leafsegs / 2][y + leafsegs / 2];
                        break;
                     case 2:
                        if (!verts[x + 1 + leafsegs / 2][y + leafsegs / 2])
                           verts[x + 1 + leafsegs / 2][y + leafsegs / 2] = mesh->vertheap.insert(newvert);
                        vertptrs[j] = verts[x + 1 + leafsegs / 2][y + leafsegs / 2];
                        break;
                     case 3:
                        if (!verts[x + 1 + leafsegs / 2][y + 1 + leafsegs / 2])
                           verts[x + 1 + leafsegs / 2][y + 1 + leafsegs / 2] = mesh->vertheap.insert(newvert);
                        vertptrs[j] = verts[x + 1 + leafsegs / 2][y + 1 + leafsegs / 2];
                        break;
                  };
               }
               
               for (int j = 0; j < 4; ++j)
               {
                  if (!(x % 2) && !(y % 2))
                     tempq.SetVertexVHP(j, vertptrs[j]);
                  else tempq.SetVertexVHP(j, vertptrs[(j + 1) % 4]);
               }
               // Generate normals - note that this is not completely accurate because
               // it forces all of the quads to share a single quads normal rather than
               // averaging them, but it's close enough IMHO
               Vector3 temp1 = vertptrs[1]->pos - vertptrs[0]->pos;
               Vector3 temp2 = vertptrs[2]->pos - vertptrs[0]->pos;
               Vector3 tempn = temp1.cross(temp2);
               tempn.normalize();
               for (int n = 0; n < 4; n++)
               {
                  tempq.SetNormal(n, tempn);
               }
               mesh->Add(tempq);
               ++totalprims;
            }
         }
      }
   }
   
   if (!side && seg && (seg >= branchafter))  // Side branches
   {
      for (int i = 0; i < sidebranches; ++i)
      {
         // Generate branches anywhere along the segment, not just the joint
         m.identity();
         m.translate(0, random.Random(0.f, height), 0);
         m.rotatex(anglex);
         m.rotatey(angley);
         m.rotatez(anglez);
         m *= trans;
         GenBranch(m, lev + 1, seg, newpts, false, 1);
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
   if (lev != 0)
      m.translate(0, curvecoeff * (float)(square * square) * height, 0);
   
   if (!side)
   {
      if (seg >= locnumsegs - 1 && split)  // Split ends:-)
      {
         for (int i = 0; i < locnumbranches; ++i)
            GenBranch(m, lev + 1, 0, newpts, false, 0);
      }
      else if (seg < locnumsegs)  // This branch, next segment
         GenBranch(m, lev, seg + 1, newpts, false, 0);
   }
   else
   {
      if (side < locnumsegs)  // Side branch next segment (?)
         GenBranch(m, lev, seg, newpts, false, side + 1);
      else if (split)
      {
         for (int i = 0; i < locnumbranches; ++i)
            GenBranch(m, lev + 1, 0, newpts, false, 0);
      }
   }
   if (continuebranch && seg >= locnumsegs)  // Continue, probably pretty useless
      GenBranch(m, lev + 1, 0, newpts, true, 0);
}


// Reads tree parameters from the designated IniReader
void ProceduralTree::ReadParams(const IniReader &get)
{
   get.Read(barkfile, "Materials", 0);
   get.Read(leavesfile, "Materials", 1);
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
   get.Read(maxtrunkangle, "maxtrunkangle");
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
   get.Read(maxtrunkangle, "maxtrunkangle");
   get.Read(branchafter, "branchafter");
   get.Read(sidebranches, "sidebranches");
   get.Read(minsidebranchangle, "minsidebranchangle");
   get.Read(maxsidebranchangle, "maxsidebranchangle");
   get.Read(sidesizeperc, "sidesizeperc");
   get.Read(split, "split");
   get.Read(continuebranch, "continuebranch");
   get.Read(multitrunk, "multitrunk");
   get.Read(branchwithleaves, "branchwithleaves");
   get.Read(sidetaper, "sidetaper");
   get.Read(minheightvar, "minheightvar");
   get.Read(maxheightvar, "maxheightvar");
   get.Read(curvecoeff, "curvecoeff");
   get.Read(leafsegs, "leafsegs");
   get.Read(leafcurve, "leafcurve");
   get.Read(seed, "seed");
}


