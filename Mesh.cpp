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
// Copyright 2008, 2011 Ben Nemec
// @End License@
#include "Mesh.h"
#include "util.h"
#include "ProceduralTree.h"

Mesh::Mesh(NTreeReader reader, ResourceManager& rm) : render(true), dynamic(true), collide(true), terrain(false), reverseanim(false), dist(0.f), impdist(0.f),
   impostorfbo(0), updatedelay(0), drawdistmult(1.f), meshdata(rm),
   next(0), size(0.f), height(0.f), width(0.f), scale(1.f), trismoved(false),
   trischanged(true), boundschanged(true), updatevbo(true), animtime(0), currkeyframe(0), animspeed(1.f), curranimation(0), nextanimation(0)
{
   ImpTimer.start();
   animtimer.start();
   Load(reader);
}


void Mesh::Load(const NTreeReader& reader)
{
   string material;
   
   string type("");
   reader.Read(type, "Type");
   reader.Read(name, "Name");
   reader.Read(position.x, "Position", 0);
   reader.Read(position.y, "Position", 1);
   reader.Read(position.z, "Position", 2);
   reader.Read(rotation.x, "Rotations", 0);
   reader.Read(rotation.y, "Rotations", 1);
   reader.Read(rotation.z, "Rotations", 2);
   reader.Read(size, "Size");
   reader.Read(impdist, "ImpostorDistance");
   reader.Read(scale, "Scale");
   reader.Read(animspeed, "AnimSpeed");
   
   if (type == "External")
   {
      string currfile, basepath;
      numframes = intvec(10, 0);
      startframe = intvec(10, 0);
      
      reader.Read(basefile, "BaseFile");
      int numkeyframes = 0;
      if (basefile != "")
      {
         basepath = basefile;
         NTreeReader base(basefile);
         for (size_t i = 0; i < 10; ++i)
         {
            base.Read(numframes[i], "NumFrames", i);
            startframe[i] = numkeyframes;
            numkeyframes += numframes[i];
            if (numframes[i] == 0)
               break;
         }
      }
      else
      {
         basepath = reader.GetPath();
         basefile = basepath;
         for (size_t i = 0; i < 10; ++i)
         {
            reader.Read(numframes[i], "NumFrames", i);
            startframe[i] = numkeyframes;
            numkeyframes += numframes[i];
            if (numframes[i] == 0)
               break;
         }
      }
      basepath = basepath.substr(0, basepath.length() - 5);
      
      //logout << "Loading " << basepath << endl;
      
      map<size_t, size_t> vertmap;
      for (int i = 0; i < numkeyframes; ++i)
      {
         currfile = basepath + "/frame" + PadNum(i, 4);
         NTreeReader currframe(currfile);
         
         string currver("");
         currframe.Read(currver, "Version");
         if (currver != objectfilever)
         {
            logout << "Object file version mismatch for file: " << currfile << endl;
            logout << currver << endl;
            return;
         }
         
         int currft = 0;
         currframe.Read(currft, "TimeToNextFrame");
         frametime.push_back(currft);
         string currsound;
         currframe.Read(currsound, "Sound");
         framesound.push_back(currsound);
         
         MeshNodeMap nodes;
         for (int j = 0; j < currframe.GetItemIndex("Triangles"); ++j)
         {
            NTreeReader currcon = currframe.GetItem(j);
            MeshNodePtr newnode(new MeshNode());
            
            currcon.Read(newnode->id, "ID");
            currcon.Read(newnode->parentid, "ParentID");
            
            currcon.Read(newnode->rot1.x, "Rot1", 0);
            currcon.Read(newnode->rot1.y, "Rot1", 1);
            currcon.Read(newnode->rot1.z, "Rot1", 2);
            currcon.Read(newnode->rot2.x, "Rot2", 0);
            currcon.Read(newnode->rot2.y, "Rot2", 1);
            currcon.Read(newnode->rot2.z, "Rot2", 2);
            currcon.Read(newnode->trans.x, "Trans", 0);
            currcon.Read(newnode->trans.y, "Trans", 1);
            currcon.Read(newnode->trans.z, "Trans", 2);
            newnode->trans *= scale;
            
            // Read vertices
            for (size_t k = 0; k < currcon.NumChildren(); ++k)
            {
               const NTreeReader& currvert = currcon(k);
               Vertex newv;
               currvert.Read(newv.id, "ID");
               currvert.Read(newv.pos.x, "Pos", 0);
               currvert.Read(newv.pos.y, "Pos", 1);
               currvert.Read(newv.pos.z, "Pos", 2);
               currvert.Read(newv.norm.x, "Norm", 0);
               currvert.Read(newv.norm.y, "Norm", 1);
               currvert.Read(newv.norm.z, "Norm", 2);
               newv.pos *= scale;
               for (int m = 0; m < 8; ++m)
               {
                  currvert.Read(newv.texcoords[m][0], "TC", m * 2);
                  currvert.Read(newv.texcoords[m][1], "TC", m * 2 + 1);
               }
               int intermediate; // These are uchars, so they will only read a single digit if read directly
               for (size_t m = 0; m < 4; ++m)
               {
                  intermediate = newv.color[m];
                  currvert.Read(intermediate, "Color", m);
                  newv.color[m] = intermediate;
               }
               newnode->vertices.push_back(newv);
               if (!i)
               {
                  meshdata.vertices.push_back(VertexPtr(new Vertex(newv)));
                  vertmap[newv.id] = meshdata.vertices.size() - 1;
                  meshdata.vertices.back()->id = meshdata.vertices.size() - 1;
               }
               newnode->vertices.back().id = vertmap[newv.id];
            }
            currcon.Read(newnode->facing, "Facing");
            currcon.Read(newnode->name, "Name");
            nodes[newnode->id] = newnode;
         }
         
         // Now that the nodes are loaded, rebuild the tree to get their proper positions
         MeshNodeMap::iterator it;
         for (it = nodes.begin(); it != nodes.end(); ++it)
         {
            if (it->second->parentid != -1)
            {
               if (nodes.find(it->second->parentid) != nodes.end())
               {
                  nodes[it->second->parentid]->children.push_back(it->second);
               }
               else
               {
                  logout << "Error building tree for:  " << currfile << endl;
               }
            }
            else
            {
               meshdata.frameroot.push_back(it->second);
            }
         }
         
         // Load triangles
         if (!i)
         {
            string matname;
            size_t vid;
            const NTreeReader& readtris = currframe.GetItemByName("Triangles");
            for (size_t j = 0; j < readtris.NumChildren(); ++j)
            {
               const NTreeReader& curr = readtris(j);
               TrianglePtr newtri(new Triangle());
               for (int k = 0; k < 3; ++k)
               {
                  curr.Read(vid, "Verts", k);
                  newtri->v[k] = meshdata.vertices[vertmap[vid]];
                  string tempid;
                  curr.Read(tempid, "ID");
               }
               curr.Read(newtri->matname, "Material");
               curr.Read(newtri->collide, "Collide");
               curr.Read(newtri->id, "ID");
               
               meshdata.tris.push_back(*newtri);
            }
         }
         
         // Generate tangents for triangles
         size_t currf = meshdata.frameroot.size() - 1;
         GraphicMatrix m;
         meshdata.frameroot[currf]->Transform(meshdata.frameroot[currf], 0.f, meshdata.vertices, m, Vector3());
         
         for (size_t k = 0; k < meshdata.tris.size(); ++k)
         {
            Triangle& newtri = meshdata.tris[k];
            Vector3 one = newtri.v[1]->pos - newtri.v[0]->pos;
            Vector3 two = newtri.v[2]->pos - newtri.v[0]->pos;
            float tcone = newtri.v[1]->texcoords[0][1] - newtri.v[0]->texcoords[0][1];
            float tctwo = newtri.v[2]->texcoords[0][1] - newtri.v[0]->texcoords[0][1];
            Vector3 tangent = one * -tctwo + two * tcone;
            for (size_t j = 0; j < 3; ++j)
               newtri.v[j]->tangent += tangent;
            // Apply tangents to nodes' vertices
            for (size_t j = 0; j < 3; ++j)
            {
               newtri.v[j]->tangent.normalize();
               meshdata.frameroot[currf]->SetTangent(newtri.v[j]->id, newtri.v[j]->tangent);
            }
         }
      }
   }
   else if (type == "proctree")
   {
      ProceduralTree t;
      string barkmat, leafmat;
      
      t.ReadParams(reader);
      reader.Read(barkmat, "Materials", 0);
      reader.Read(leafmat, "Materials", 1);
      size_t save = t.GenTree(this, &meshdata.resman.LoadMaterial(barkmat), &meshdata.resman.LoadMaterial(leafmat));
      collide = true;
      logout << "Tree primitives: " << save << endl;
   }
   else if (type == "Terrain" || type == "Empty"){} // No-op to avoid bogus warnings
   else
   {
      logout << "Warning: Attempted to load unknown object type " << type;
      logout << " from file " << reader.GetPath() << endl;
   }
   Update();
}


void Mesh::Move(const Vector3& v, const bool movetris)
{
   if (movetris)
   {
      Vector3 move = v - position;
      
      for (VertexPtrvec::iterator i = meshdata.vertices.begin(); i != meshdata.vertices.end(); ++i)
      {
         (*i)->pos += move;
      }
      updatevbo = true;
      ResetTriMaxDims();
   }
   ResetTriMaxDims();
   position = v;
   trismoved = true;
}


void Mesh::Rotate(const Vector3& v, const bool movetris)
{
   if (movetris)
   {
      Vector3 pos = GetPosition();
      GraphicMatrix m;
      
      m.translate(-pos);
      m.rotatez(-rotation.z);
      m.rotatey(-rotation.y);
      m.rotatex(-rotation.x);
      m.rotatex(v.x);
      m.rotatey(v.y);
      m.rotatez(v.z);
      m.translate(pos);
      
      for (VertexPtrvec::iterator i = meshdata.vertices.begin(); i != meshdata.vertices.end(); ++i)
      {
         (*i)->pos.transform(m);
      }
      updatevbo = true;
   }
   ResetTriMaxDims();
   rotation = v;
   trismoved = true;
   boundschanged = true;
}


void Mesh::Scale(const float& sval)
{
   for (size_t i = 0; i < meshdata.frameroot.size(); ++i)
      meshdata.frameroot[i]->Scale(sval);
   ResetTriMaxDims();
   scale *= sval;
   trismoved = true;
   boundschanged = true;
}


void Mesh::ScaleZ(const float& sval)
{
   for (size_t i = 0; i < meshdata.frameroot.size(); ++i)
      meshdata.frameroot[i]->ScaleZ(sval);
   ResetTriMaxDims();
   trismoved = true;
   boundschanged = true;
}


// Most of what goes on in Update should maybe be moved to MeshData, but for the moment I'm leaving it alone.
// Something to think about in the future though.
void Mesh::Update(const Vector3& campos, bool noanimation)
{
   if (!noanimation)
      AdvanceAnimation();
   if (trismoved || trischanged)
      UpdateTris(campos);
   if (boundschanged)
      CalcBounds();
}


void Mesh::AdvanceAnimation()
{
   if (meshdata.frameroot.size() < 2)
      return;

   animtime += static_cast<int>(fabs(animspeed) * static_cast<float>(animtimer.elapsed()));
   animtimer.start();

   while (animtime > frametime[currkeyframe])
   {
      animtime -= frametime[currkeyframe];

      currkeyframe = NextKeyFrame();
      
      currentsound = framesound[currkeyframe];
   }

   trismoved = true;
   boundschanged = true;
}


int Mesh::NextKeyFrame()
{
   int retval = currkeyframe;
   if (curranimation != nextanimation)
   {
      curranimation = nextanimation;
      return startframe[curranimation];
   }
   else
   {
      if (reverseanim)
         --retval;
      else
         ++retval;
   }
   
   if (reverseanim)
   {
      if (retval < startframe[curranimation])
         retval = startframe[curranimation] + numframes[curranimation] - 1;
   }
   else
   {
      if (retval > startframe[curranimation] + numframes[curranimation] - 1)
         retval = startframe[curranimation];
   }
   return retval;
}


void Mesh::UpdateTris(const Vector3& campos)
{
   if (!meshdata.frameroot.size() || (currkeyframe < startframe[curranimation] || currkeyframe >= startframe[curranimation] + numframes[curranimation]))
      return;

   float interpval;
   if (frametime.size() > 0)
      interpval = float(animtime) / float(frametime[currkeyframe]);
   else
      interpval = 0.f;

   GraphicMatrix m;
   m.rotatex(rotation.x);
   m.rotatey(rotation.y);
   m.rotatez(rotation.z);
   m.translate(position);

   if (curranimation != nextanimation)
   {
      meshdata.frameroot[currkeyframe]->Transform(meshdata.frameroot[startframe[nextanimation]], interpval, meshdata.vertices, m, campos);
   }
   else
   {
      if (numframes[curranimation] == 1) // Unanimated meshes
      {
         meshdata.frameroot[currkeyframe]->Transform(meshdata.frameroot[currkeyframe], interpval, meshdata.vertices, m, campos);
      }
      else if (reverseanim)
      {
         meshdata.frameroot[currkeyframe]->Transform(meshdata.frameroot[NextKeyFrame()], interpval, meshdata.vertices, m, campos);
      }
      else
      {
         meshdata.frameroot[currkeyframe]->Transform(meshdata.frameroot[NextKeyFrame()], interpval, meshdata.vertices, m, campos);
      }
   }
   trismoved = false;
   updatevbo = true; // Let the render code know that what it has is out of date
}


// Note that UpdateTris needs to be called before this so we're not working with old tris
void Mesh::CalcBounds()
{
   // If we just translated the mesh then we don't need to do this.
   size = 0.f;
   float dist = 0.f;
   float temp;
   Vector3 localpos = GetPosition();
   Vector3 localwpos, localhpos;
   size_t tsize = meshdata.tris.size();
   height = 0;
   width = 0;
   for (size_t i = 0; i < tsize; ++i)
   {
      for (int j = 0; j < 3; ++j)
      {
         Triangle& currtri = meshdata.tris[i];
         dist = currtri.v[j]->pos.distance(localpos) + currtri.radmod;
         if (dist > size) size = dist;

         localwpos = currtri.v[j]->pos;
         localwpos.y = localpos.y;
         temp = localwpos.distance(localpos) + currtri.radmod;
         if (temp > width) width = temp;

         localhpos = currtri.v[j]->pos;
         localhpos.x = localpos.x;
         localhpos.z = localpos.z;
         temp = localhpos.distance(localpos) + currtri.radmod;
         if (temp > height) height = temp;
      }
   }
   height *= 2.f;
   width *= 2.f;
   boundschanged = false;
}


// Note: This needs to be done even if tris just moved without changing size because this also triggers
// the collision detection code to regenerate the midpoint of the tri for culling calculations
void Mesh::ResetTriMaxDims()
{
   size_t s = meshdata.tris.size();
   for (size_t i = 0; i < s; ++i)
      meshdata.tris[i].maxdim = -1.f;
}


// Passing in overridemat causes this function to use every attribute of that material
// except the texture in unit 0.  This is primarily useful for shadowmap renders where
// we don't care about anything but the right shape so we use a very basic material
void Mesh::Render(Material* overridemat)
{
#ifndef DEDICATED
   if (!render || !meshdata.tris.size())
      return;
   EnsureMaterials();
   if (updatevbo)
      GenVbo();

   vbo.Bind();

   size_t currindex = 0;
   if (overridemat)
      overridemat->Use();
   for (size_t i = 0; i < vbosteps.size(); ++i)
   {
      if (meshdata.tris[currindex].material)
      {
         if (!overridemat)
            meshdata.tris[currindex].material->Use();
         else meshdata.tris[currindex].material->UseTextureOnly();
      }
      else
      {
         logout << "NULL material?" << endl;
      }
      BindAttribs();
      void* offset = offsets[i];
      glDrawRangeElements(GL_TRIANGLES, minindex[i], maxindex[i], vbosteps[i] * 3, GL_UNSIGNED_SHORT, offset);
      UnbindAttribs();
      currindex += vbosteps[i];
   }
#endif
}


void Mesh::GenVbo()
{
#ifndef DEDICATED
   if (meshdata.tris.size())
   {
      GenVboData();
      if (trischanged)
         GenIboData();
      vbo.UploadVBO(dynamic || meshdata.frameroot.size() > 1);
   }
   updatevbo = false;
#endif
}


void Mesh::GenVboData()
{
#ifndef DEDICATED
   size_t currindex = 0;
   
   size_t numverts = meshdata.vertices.size();
   
   if (vbo.vbodata.size() != numverts)
   {
      vbo.vbodata.resize(numverts);
   }
   
   VertexPtrvec::iterator vend = meshdata.vertices.end();

   // Build VBO
   for (VertexPtrvec::iterator i = meshdata.vertices.begin(); i != vend; ++i)
   {
      Vertex& currv = **i;
      if (currv.index != currindex)
      {
         currv.index = currindex;
         trischanged = true;
      }
      currv.GetVboData(vbo.vbodata[currindex], dynamic);
      ++currindex;
   }
#endif
}


void Mesh::GenIboData()
{
#ifndef DEDICATED
   // Build IBO
   std::sort(meshdata.tris.begin(), meshdata.tris.end());
   vbo.indexdata.clear();
   vbosteps.clear();
   offsets.clear();
   minindex.clear();
   maxindex.clear();
   int counter = 0;
   unsigned short currmin = 0, currmax = 0;
   Trianglevec::iterator last = meshdata.tris.begin();
   Trianglevec::iterator tend = meshdata.tris.end();
   offsets.push_back((void*)0);
   for (Trianglevec::iterator i = meshdata.tris.begin(); i != tend; ++i)
   {
      if (last->material != i->material)
      {
         vbosteps.push_back(counter);

         ptrdiff_t current = ptrdiff_t(&vbo.indexdata[vbo.indexdata.size() - 1]) + ptrdiff_t(sizeof(vbo.indexdata[0]));
         ptrdiff_t start = ptrdiff_t(&vbo.indexdata[0]);
         offsets.push_back( (void*)(current - start) );

         minindex.push_back(currmin);
         maxindex.push_back(currmax);
         counter = 0;
         currmin = 0;
         currmax = 0;
      }
      ushortvec ind = i->GetIndices();
      vbo.indexdata.insert(vbo.indexdata.end(), ind.begin(), ind.end());
      last = i;
      ++counter;
      for (size_t j = 0; j < ind.size(); ++j)
      {
         currmin = std::min(currmin, ind[j]);
         currmax = std::max(currmax, ind[j]);
      }
   }
   vbosteps.push_back(counter);
   minindex.push_back(currmin);
   maxindex.push_back(currmax);

   trischanged = false;
#endif
}


void Mesh::BindAttribs()
{
   #ifndef DEDICATED
   if (meshdata.resman.shaderman.CurrentShader() == 0) return;
   VBOData dummy;
   int location;
   location = meshdata.resman.shaderman.GetAttribLocation(meshdata.resman.shaderman.CurrentShader(), "terrainwt");
   if (location >= 0)
   {
      glEnableVertexAttribArrayARB(location);
      glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.terrainwt[0]) - (ptrdiff_t)&dummy));
   }
   location = meshdata.resman.shaderman.GetAttribLocation(meshdata.resman.shaderman.CurrentShader(), "terrainwt1");
   if (location >= 0)
   {
      glEnableVertexAttribArrayARB(location);
      glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.terrainwt1[0]) - (ptrdiff_t)&dummy));
   }
   location = meshdata.resman.shaderman.GetAttribLocation(meshdata.resman.shaderman.CurrentShader(), "tangent");
   if (location >= 0)
   {
      glEnableVertexAttribArrayARB(location);
      glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.tx) - (ptrdiff_t)&dummy));
   }
   #endif
}


void Mesh::UnbindAttribs()
{
   #ifndef DEDICATED
   if (meshdata.resman.shaderman.CurrentShader() == 0) return;
   int location = meshdata.resman.shaderman.GetAttribLocation(meshdata.resman.shaderman.CurrentShader(), "terrainwt");
   if (location >= 0)
   {
      glDisableVertexAttribArrayARB(location);
   }
   location = meshdata.resman.shaderman.GetAttribLocation(meshdata.resman.shaderman.CurrentShader(), "terrainwt1");
   if (location >= 0)
   {
      glDisableVertexAttribArrayARB(location);
   }
   location = meshdata.resman.shaderman.GetAttribLocation(meshdata.resman.shaderman.CurrentShader(), "tangent");
   if (location >= 0)
   {
      glDisableVertexAttribArrayARB(location);
   }
   #endif
}


void Mesh::RenderImpostor(Mesh& rendermesh, FBO& impfbo, const Vector3& campos)
{
   #ifndef DEDICATED
   if (!meshdata.impmat)
   {
      meshdata.impmat = MaterialPtr(new Material("materials/impostor", meshdata.resman.texman, meshdata.resman.shaderman));
   }
   if (!meshdata.impostor)
   {
      meshdata.impostor = MeshPtr(new Mesh(NTreeReader("models/impostor/base"), meshdata.resman));
      Triangle& first = meshdata.impostor->meshdata.tris[0];
      Triangle& second = meshdata.impostor->meshdata.tris[1];
      first.material = meshdata.impmat.get();
      second.material = meshdata.impmat.get();
   }
   
   meshdata.impmat->SetTexture(0, impfbo.GetTexture());
   float width2 = width / 2.f;
   float height2 = height / 2.f;
   meshdata.impostor->meshdata.frameroot[0]->vertices[0].pos = Vector3(-width2, height2, 0);
   meshdata.impostor->meshdata.frameroot[0]->vertices[1].pos = Vector3(-width2, -height2, 0);
   meshdata.impostor->meshdata.frameroot[0]->vertices[2].pos = Vector3(width2, height2, 0);
   meshdata.impostor->meshdata.frameroot[0]->vertices[3].pos = Vector3(width2, -height2, 0);
   
   Vector3 moveto = position;
   meshdata.impostor->Move(moveto);
   meshdata.impostor->Update(campos);
   rendermesh.Add(*meshdata.impostor);
   #endif
}


void Mesh::Add(Triangle& triangle)
{
   meshdata.tris.push_back(triangle);
   Triangle& tri = meshdata.tris.back();
   for (size_t i = 0; i < 3; ++i)
   {
      if (std::find(meshdata.vertices.begin(), meshdata.vertices.end(), tri.v[i]) == meshdata.vertices.end())
      {
         meshdata.vertices.push_back(tri.v[i]);
         tri.v[i]->id = meshdata.vertices.size() - 1;
      }
   }
   boundschanged = true;
   trischanged = true;
   updatevbo = true;
}


void Mesh::Add(Quad& quad)
{
   TrianglePtr temp = quad.First();
   Add(*temp);
   temp = quad.Second();
   Add(*temp);
}


void Mesh::Add(Mesh &mesh)
{
   for (size_t i = 0; i < mesh.meshdata.tris.size(); ++i)
   {
      Add(mesh.meshdata.tris[i]);
   }
}


void Mesh::Clear()
{
   meshdata.tris.clear();
   meshdata.vertices.clear();
   trischanged = true;
   updatevbo = true;
   boundschanged = true;
}


// Only for meshes that are built out of raw triangles - meshes loaded from a file should already have this done
void Mesh::GenTangents()
{
   for (size_t k = 0; k < meshdata.tris.size(); ++k)
   {
      Triangle& newtri = meshdata.tris[k];
      Vector3 one = newtri.v[1]->pos - newtri.v[0]->pos;
      Vector3 two = newtri.v[2]->pos - newtri.v[0]->pos;
      float tcone = newtri.v[1]->texcoords[0][1] - newtri.v[0]->texcoords[0][1];
      float tctwo = newtri.v[2]->texcoords[0][1] - newtri.v[0]->texcoords[0][1];
      Vector3 tangent = one * -tctwo + two * tcone;
      for (size_t j = 0; j < 3; ++j)
         newtri.v[j]->tangent += tangent;
   }
   for (size_t i = 0; i < meshdata.vertices.size(); ++i)
   {
      meshdata.vertices[i]->tangent.normalize();
   }
}


void Mesh::EnsureMaterials()
{
   if (trischanged)
   {
      meshdata.EnsureMaterials();
      // This also means we need color, normal, etc. to be calculated by the MeshNodes
      for (size_t i = 0; i < meshdata.frameroot.size(); ++i)
         meshdata.frameroot[i]->SetGL(true);
   }
}


// There's a good chance animspeed doesn't actually need to be part of the state, but it doesn't really hurt to have it either.
void Mesh::SetState(const Vector3& pos, const Vector3& rot, const int keyframe, const int atime, const float aspeed)
{
   if (meshdata.frameroot.size() < 1) return;
   
   rotation = rot;
   currkeyframe = keyframe;
   animtime = atime;
   SetAnimSpeed(aspeed);
   position = pos;
   Update(Vector3(), true); // We don't want the animation code to run because it would alter the state
}


void Mesh::ReadState(Vector3& pos, Vector3& rot, int& keyframe, int& atime, float& aspeed, float& getsize)
{
   pos = GetPosition();
   rot = rotation;
   keyframe = currkeyframe;
   atime = animtime;
   aspeed = animspeed;
   getsize = size;
}


void Mesh::SetAnimSpeed(const float newas)
{
   animspeed = newas;
}


void Mesh::SetAnimation(const int newanim)
{
   if (newanim < 10 && numframes[newanim] != 0)
      nextanimation = newanim;
}


void Mesh::debug()
{
   if (basefile == "models/sighthit/base")
   {
      logout << "debug" << endl;
      for (size_t i = 0; i < meshdata.tris.size(); ++i)
      {
         for (size_t j = 0; j < 3; ++j)
         {
            logout << meshdata.tris[i].v[j]->texcoords[0][0] << endl;
            logout << meshdata.tris[i].v[j]->texcoords[0][1] << endl;
         }
      }
   }
}

