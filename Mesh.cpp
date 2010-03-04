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
// Copyright 2008, 2010 Ben Nemec
// @End License@


#include "Mesh.h"
#include "ProceduralTree.h" // Circular dependency

Mesh::Mesh(const string& filename, ResourceManager &rm, IniReader read, bool gl) : render(true), dynamic(false),
           collide(true), terrain(false), drawdistmult(-1.f), impdist(0.f), dist(0.f), impostortex(0), debug(false),
           updatedelay(0), vbo(0), ibo(0), hasvbo(false), vbosize(0), ibosize(0), animtime(0), currkeyframe(0),
           lastanimtick(SDL_GetTicks()), animspeed(1.f), curranimation(0), nextanimation(0), newchildren(false),
           boundschanged(true), position(Vector3()), rots(Vector3()), size(100.f), height(0.f), width(0.f),
           resman(rm), next(0), glops(gl), havemats(false), updatevbo(true), updateibo(false), scale(.01f), trisdirty(true),
           parent(NULL), lasttick(0)
{
#ifndef DEDICATED
   if (gl)
      impmat = MaterialPtr(new Material("materials/impostor", rm.texman, rm.shaderman));
#endif
   if (filename != "")
   {
      IniReader reader(filename);
      Load(reader);
   }
   else Load(read);
}


Mesh::~Mesh()
{
   if (hasvbo)
   {
#ifndef DEDICATED
      glDeleteBuffers(1, &vbo);
      glDeleteBuffers(1, &ibo);
#endif
   }
}


Mesh::Mesh(const Mesh& m) : render(m.render), dynamic(m.dynamic), collide(m.collide), terrain(m.terrain),
           drawdistmult(m.drawdistmult), name(m.name), impdist(m.impdist), dist(m.dist), impostortex(m.impostortex),
           debug(m.debug), updatedelay(m.updatedelay), vbosteps(m.vbosteps), minindex(m.minindex), maxindex(m.maxindex), 
           vbo(0), ibo(0), frametime(m.frametime),
           hasvbo(false), childmeshes(m.childmeshes), animtime(m.animtime), currkeyframe(m.currkeyframe),
           lastanimtick(m.lastanimtick), animspeed(m.animspeed), curranimation(m.curranimation),
           nextanimation(m.nextanimation), numframes(m.numframes), startframe(m.startframe),
           newchildren(m.newchildren), boundschanged(m.boundschanged), position(m.position), rots(m.rots),
           size(m.size), height(m.height), width(m.width), resman(m.resman), next(m.next), glops(m.glops),
           havemats(m.havemats), updatevbo(m.updatevbo), updateibo(m.updateibo), basefile(m.basefile), scale(m.scale),
           campos(m.campos), trisdirty(m.trisdirty), parent(m.parent), lasttick(m.lasttick)
{
#ifndef DEDICATED
   if (m.impmat)
   {
      impmat = MaterialPtr(new Material("materials/impostor", resman.texman, resman.shaderman));
      impmat->SetTexture(0, m.impmat->GetTexture(0));
   }
   if (m.impostor)
   {
      impostor = MeshPtr(new Mesh(*m.impostor));
   }
#endif
   // The following containers hold smart pointers, which means that when we copy them
   // the objects are still shared.  That's a bad thing, so we manually copy every
   // object to the new container
   VertexPtrvec localvert = m.vertices;
   for (VertexPtrvec::iterator i = localvert.begin(); i != localvert.end(); ++i)
   {
      VertexPtr p(new Vertex(**i));
      vertices.push_back(p);
   }
   for (size_t i = 0; i < m.tris.size(); ++i)
   {
      TrianglePtr p(new Triangle(*m.tris[i]));
      for (size_t j = 0; j < 3; ++j)
      {
         p->v[j] = vertices[p->v[j]->id];
      }
      tris.push_back(p);
   }
   for (size_t i = 0; i < m.frameroot.size(); ++i)
   {
      frameroot.push_back(m.frameroot[i]->Clone());
      framecontainer.push_back(map<string, MeshNodePtr>());
      frameroot[i]->GetContainers(framecontainer[i], frameroot[i]);
   }
}


Mesh& Mesh::operator=(const Mesh& m)
{
   if (this == &m)
      return *this;
   
   //resman = m.resman; Reference, can't be reseated.  Should be okay to leave it since it has to be set though.
   vbosteps = m.vbosteps;
   minindex = m.minindex;
   maxindex = m.maxindex;
   impdist = m.impdist;
   render = m.render;
   animtime = m.animtime;
   lastanimtick = m.lastanimtick;
   position = m.position;
   rots = m.rots;
   size = m.size;
   drawdistmult = m.drawdistmult;
   name = m.name;
   debug = m.debug;
   width = m.width;
   height = m.height;
   impostortex = m.impostortex;
   vbo = 0;
   ibo = 0;
   hasvbo = false;
   next = m.next;
   childmeshes = m.childmeshes;
   boundschanged = m.boundschanged;
   currkeyframe = m.currkeyframe;
   frametime = m.frametime;
   glops = m.glops;
   havemats = m.havemats;
   basefile = m.basefile;
   dynamic = m.dynamic;
   collide = m.collide;
   terrain = m.terrain;
   dist = m.dist;
   animspeed = m.animspeed;
   curranimation = m.curranimation;
   nextanimation = m.nextanimation;
   newchildren = m.newchildren;
   numframes = m.numframes;
   startframe = m.startframe;
   scale = m.scale;
   updatevbo = m.updatevbo;
   updateibo = m.updateibo;
   campos = m.campos;
   trisdirty = m.trisdirty;
   parent = m.parent;
   updatedelay = m.updatedelay;
   lasttick = m.lasttick;
   
#ifndef DEDICATED
   if (m.impmat)
   {
      impmat = MaterialPtr(new Material("materials/impostor", resman.texman, resman.shaderman));
      impmat->SetTexture(0, m.impmat->GetTexture(0));
   }
   if (m.impostor)
   {
      impostor = MeshPtr(new Mesh(*m.impostor));
   }
#endif
   // The following containers hold smart pointers, which means that when we copy them
   // the objects are still shared.  That's a bad thing, so we manually copy every
   // object to the new container
   vertices.clear();
   VertexPtrvec localvert = m.vertices;
   for (VertexPtrvec::iterator i = localvert.begin(); i != localvert.end(); ++i)
   {
      VertexPtr p(new Vertex(**i));
      vertices.push_back(p);
   }
   tris.clear();
   for (size_t i = 0; i < m.tris.size(); ++i)
   {
      TrianglePtr p(new Triangle(*m.tris[i]));
      for (size_t j = 0; j < 3; ++j)
      {
         p->v[j] = vertices[p->v[j]->id];
      }
      tris.push_back(p);
   }
   frameroot.clear();
   for (size_t i = 0; i < m.frameroot.size(); ++i)
   {
      frameroot.push_back(m.frameroot[i]->Clone());
      framecontainer.push_back(map<string, MeshNodePtr>());
      frameroot[i]->GetContainers(framecontainer[i], frameroot[i]);
   }
   return *this;
}


void Mesh::Load(const IniReader& reader)
{
   string material;
   
   string type("");
   reader.Read(type, "Type");
   reader.Read(name, "Name");
   reader.Read(position.x, "Position", 0);
   reader.Read(position.y, "Position", 1);
   reader.Read(position.z, "Position", 2);
   reader.Read(rots.x, "Rotations", 0);
   reader.Read(rots.y, "Rotations", 1);
   reader.Read(rots.z, "Rotations", 2);
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
         IniReader base(basefile);
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
         IniReader currframe(currfile);
         
         string currver("");
         currframe.Read(currver, "Version");
         if (currver != objectfilever)
         {
            logout << "Object file version mismatch for file: " << currfile << endl << flush;
            logout << currver << endl;
            return;
         }
         
         int currft = 0;
         currframe.Read(currft, "TimeToNextFrame");
         frametime.push_back(currft);
         
         framecontainer.push_back(map<string, MeshNodePtr>());
         
         MeshNodeMap nodes;
         for (int j = 0; j < currframe.GetItemIndex("Triangles"); ++j)
         {
            IniReader currcon = currframe.GetItem(j);
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
               const IniReader& currvert = currcon(k);
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
                  vertices.push_back(VertexPtr(new Vertex(newv)));
                  vertmap[newv.id] = vertices.size() - 1;
                  vertices.back()->id = vertices.size() - 1;
               }
               newnode->vertices.back().id = vertmap[newv.id];
            }
            currcon.Read(newnode->facing, "Facing");
            currcon.Read(newnode->name, "Name");
            nodes[newnode->id] = newnode;
            framecontainer[i][newnode->name] = newnode;
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
               frameroot.push_back(it->second);
            }
         }
         
         // Load triangles
         if (!i)
         {
            string matname;
            size_t vid;
            const IniReader& readtris = currframe.GetItemByName("Triangles");
            for (size_t j = 0; j < readtris.NumChildren(); ++j)
            {
               const IniReader& curr = readtris(j);
               TrianglePtr newtri(new Triangle());
               for (int k = 0; k < 3; ++k)
               {
                  curr.Read(vid, "Verts", k);
                  newtri->v[k] = vertices[vertmap[vid]];
                  string tempid;
                  curr.Read(tempid, "ID");
               }
               curr.Read(newtri->matname, "Material");
               if (glops)
                  newtri->material = &resman.LoadMaterial(newtri->matname);
               curr.Read(newtri->collide, "Collide");
               curr.Read(newtri->id, "ID");
               
               tris.push_back(newtri);
            }
         }
         
         // Generate tangents for triangles
         size_t currf = frameroot.size() - 1;
         GraphicMatrix m;
         frameroot[currf]->Transform(frameroot[currf], 0.f, vertices, m, Vector3());
         
         for (size_t k = 0; k < tris.size(); ++k)
         {
            TrianglePtr newtri = tris[k];
            Vector3 one = newtri->v[1]->pos - newtri->v[0]->pos;
            Vector3 two = newtri->v[2]->pos - newtri->v[0]->pos;
            float tcone = newtri->v[1]->texcoords[0][1] - newtri->v[0]->texcoords[0][1];
            float tctwo = newtri->v[2]->texcoords[0][1] - newtri->v[0]->texcoords[0][1];
            Vector3 tangent = one * -tctwo + two * tcone;
            for (size_t j = 0; j < 3; ++j)
               newtri->v[j]->tangent += tangent;
            // Apply tangents to nodes' vertices
            for (size_t j = 0; j < 3; ++j)
            {
               newtri->v[j]->tangent.normalize();
               frameroot[currf]->SetTangent(newtri->v[j]->id, newtri->v[j]->tangent);
            }
         }
      }
      UpdateTris();
   }
   else if (type == "proctree")
   {
      ProceduralTree t;
      string barkmat, leafmat;
      
      t.ReadParams(reader);
      reader.Read(barkmat, "Materials", 0);
      reader.Read(leafmat, "Materials", 1);
      size_t save = t.GenTree(this, &resman.LoadMaterial(barkmat), &resman.LoadMaterial(leafmat));
      collide = true;
      logout << "Tree primitives: " << save << endl;
   }
   else if (type == "Terrain" || type == "Empty"){} // No-op to avoid bogus warnings
   else
   {
      logout << "Warning: Attempted to load unknown object type " << type;
	   logout << " from file " << reader.GetPath() << endl;
   }
   CalcBounds();
   for (size_t i = 0; i < frameroot.size(); ++i)
      frameroot[i]->SetGL(glops);
}


// Note, if this mesh has child meshes they need to have Move(GetPosition()) called on them
// to force an update on their geometry
void Mesh::Move(const Vector3& v, bool movetris)
{
   if (movetris)
   {
      Vector3 move = v - position;
      
      for (VertexPtrvec::iterator i = vertices.begin(); i != vertices.end(); ++i)
      {
         (*i)->pos += move;
      }
      CalcBounds();
   }
   
   position = v;
   trisdirty = true;
   updatevbo = true;
}


const Vector3 Mesh::GetPosition() const
{
   if (frameroot.size() && frameroot[currkeyframe]->parent)
   {
      GraphicMatrix m = frameroot[currkeyframe]->parent->m;
      Vector3 p = position;
      p.transform(m);
      return p; 
   }
   return position;
}


void Mesh::Rotate(const Vector3& v, bool movetris)
{
   if (rots.distance2(v) > 1.f)
      boundschanged = true;
   if (movetris)
   {
      Vector3 pos = GetPosition();
      GraphicMatrix m;
      
      m.translate(-pos);
      m.rotatez(-rots.z);
      m.rotatey(-rots.y);
      m.rotatex(-rots.x);
      m.rotatex(v.x);
      m.rotatey(v.y);
      m.rotatez(v.z);
      m.translate(pos);
      
      for (VertexPtrvec::iterator i = vertices.begin(); i != vertices.end(); ++i)
      {
         (*i)->pos.transform(m);
      }
      CalcBounds();
   }
   
   rots = v;
   trisdirty = true;
   updatevbo = true;
}


void Mesh::GenVbo(const int type)
{
#ifndef DEDICATED
   if ((tris.size() || childmeshes.size()) && render)
   {
      if (type != OnlyUpload)
      {
         GenVboData();
         GenIboData();
      }
      if (type != OnlyData)
      {
         UploadVbo();
      }
   }
#endif
}


void Mesh::GenVboData()
{
   size_t currindex = 0;
   
   size_t numverts = vertices.size();
   for (size_t m = 0; m < childmeshes.size(); ++m)
   {
      numverts += childmeshes[m]->vertices.size();
   }
   
   if (vbodata.size() != numverts)
   {
      updateibo = true;
      vbodata.resize(numverts);
   }
   
   for (size_t m = 0; m < childmeshes.size() + 1; ++m)
   {
      Mesh* currmesh;
      if (m < 1)
         currmesh = this;
      else
         currmesh = childmeshes[m - 1];
      VertexPtrvec& currvertices = currmesh->vertices;
      VertexPtrvec::iterator cvend = currvertices.end();
      TrianglePtrvec& currtris = currmesh->tris;
      size_t ctsize = currtris.size();
      if (newchildren && m > 0)
      {
         for (size_t i = 0; i < ctsize; ++i)
         {
            tris.push_back(currtris[i]);
         }
      }
      
      // Build VBO
      for (VertexPtrvec::iterator i = currvertices.begin(); i != cvend; ++i)
      {
         Vertex& currv = **i;
         currv.index = currindex;
         currv.GetVboData(vbodata[currindex], dynamic);
         ++currindex;
      }
   }
   newchildren = false;
}

void Mesh::GenIboData()
{
   // Build IBO
   if (updateibo)
   {
      sort(tris.begin(), tris.end(), Triangle::TriPtrComp);
      // Shouldn't clear these for efficiency reasons, but for the moment I'm not worrying about it
      indexdata.clear();
      vbosteps.clear();
      minindex.clear();
      maxindex.clear();
      int counter = 0;
      unsigned short currmin = 0, currmax = 0;
      TrianglePtrvec::iterator last = tris.begin();
      TrianglePtrvec::iterator tend = tris.end();
      for (TrianglePtrvec::iterator i = tris.begin(); i != tend; ++i)
      {
         if ((*last)->material != (*i)->material)
         {
            vbosteps.push_back(counter);
            minindex.push_back(currmin);
            maxindex.push_back(currmax);
            counter = 0;
            currmin = 0;
            currmax = 0;
         }
         ushortvec ind = (*i)->GetIndices();
         indexdata.insert(indexdata.end(), ind.begin(), ind.end());
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
      updateibo = false;
   }
}

void Mesh::UploadVbo()
{
#ifndef DEDICATED
   if (!hasvbo)
   {
      glGenBuffersARB(1, &vbo);
      glGenBuffersARB(1, &ibo);
      hasvbo = true;
   }
   
   glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER, ibo);
   glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo);
   
   if (frameroot.size() <= 1 && !dynamic)
   {
      glBufferDataARB(GL_ELEMENT_ARRAY_BUFFER, indexdata.size() * sizeof(unsigned short),
                        NULL, GL_STATIC_DRAW_ARB);
      glBufferDataARB(GL_ARRAY_BUFFER_ARB, 
                        vbodata.size() * sizeof(VBOData), 
                        NULL, GL_STATIC_DRAW_ARB);
   }
   else
   {
      // Apparently it's faster to discard the old buffer and create a new one than to update the old one.
      // I haven't noticed, but it seems my bottleneck is elsewhere so once that's fixed maybe it will matter.
      glBufferDataARB(GL_ELEMENT_ARRAY_BUFFER, indexdata.size() * sizeof(unsigned short),
                        NULL, GL_DYNAMIC_DRAW_ARB);
      glBufferDataARB(GL_ARRAY_BUFFER_ARB, 
                        vbodata.size() * sizeof(VBOData), 
                        NULL, GL_DYNAMIC_DRAW_ARB);
   }
   
   glBufferSubDataARB(GL_ELEMENT_ARRAY_BUFFER, 0, indexdata.size() * sizeof(unsigned short), &indexdata[0]);
   glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, 0, vbodata.size() * sizeof(VBOData), &vbodata[0]);
   
   if (frameroot.size() <= 1 && !dynamic)
   {
      vbodata.clear();
      indexdata.clear();
   }
   
   vbosize = vbodata.size() * sizeof(VBOData);
   ibosize = indexdata.size() * sizeof(unsigned short);
   updatevbo = false;
   if (!glops)
      SetGL();
#endif
}


void Mesh::BindVbo()
{
#ifndef DEDICATED
   if (!hasvbo)
   {
      logout << "Hey dummy, you have to call GenVbo first" << endl;
      return;
   }
   VBOData dummy;
   
   glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER_ARB, ibo);
   glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo);
   
   glEnableClientState(GL_VERTEX_ARRAY);
   glEnableClientState(GL_NORMAL_ARRAY);
   glEnableClientState(GL_COLOR_ARRAY);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   
   glNormalPointer(GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.nx) - (ptrdiff_t)&dummy));
   glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.r) - (ptrdiff_t)&dummy));
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.tc[0]) - (ptrdiff_t)&dummy));
   glClientActiveTextureARB(GL_TEXTURE1_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.tc[1]) - (ptrdiff_t)&dummy));
   glClientActiveTextureARB(GL_TEXTURE2_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.tc[2]) - (ptrdiff_t)&dummy));
   glClientActiveTextureARB(GL_TEXTURE3_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.tc[3]) - (ptrdiff_t)&dummy));
   glClientActiveTextureARB(GL_TEXTURE4_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.tc[4]) - (ptrdiff_t)&dummy));
   glClientActiveTextureARB(GL_TEXTURE5_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.tc[5]) - (ptrdiff_t)&dummy));
   
   glVertexPointer(3, GL_FLOAT, sizeof(VBOData), 0); // Apparently putting this last helps performance somewhat
   
   glClientActiveTextureARB(GL_TEXTURE0_ARB);
#endif
}


// Passing in overridemat causes this function to use every attribute of that material
// except the texture in unit 0.  This is primarily useful for shadowmap renders where
// we don't care about anything but the right shape so we use a very basic material
void Mesh::Render(Material* overridemat)
{
#ifndef DEDICATED
   if (!render)
      return;
   if (updatevbo)// && !hasvbo) // For checking VBO generation performance
      GenVbo();
   if (!havemats)
      LoadMaterials();
   if (!tris.size() || !hasvbo)
   {
      return;
   }
   BindVbo();
   size_t currindex = 0;
   if (overridemat)
      overridemat->Use();
   for (size_t i = 0; i < vbosteps.size(); ++i)
   {
      if (tris[currindex]->material)
      {
         if (!overridemat)
            tris[currindex]->material->Use();
         else tris[currindex]->material->UseTextureOnly();
      }
      BindAttribs();
      void* offset = (void*)(ptrdiff_t(&indexdata[currindex * 3]) - ptrdiff_t(&indexdata[0]));
      glDrawRangeElements(GL_TRIANGLES, minindex[i], maxindex[i], vbosteps[i] * 3, GL_UNSIGNED_SHORT, offset);
      UnbindAttribs();
      currindex += vbosteps[i];
   }
#endif
}


void Mesh::BindAttribs()
{
#ifndef DEDICATED
   if (resman.shaderman.CurrentShader() == 0) return;
   VBOData dummy;
   int location;
   location = resman.shaderman.GetAttribLocation(resman.shaderman.CurrentShader(), "terrainwt");
   if (location >= 0)
   {
      glEnableVertexAttribArrayARB(location);
      glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.terrainwt[0]) - (ptrdiff_t)&dummy));
   }
   location = resman.shaderman.GetAttribLocation(resman.shaderman.CurrentShader(), "terrainwt1");
   if (location >= 0)
   {
      glEnableVertexAttribArrayARB(location);
      glVertexAttribPointerARB(location, 3, GL_FLOAT, GL_FALSE, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.terrainwt1[0]) - (ptrdiff_t)&dummy));
   }
   location = resman.shaderman.GetAttribLocation(resman.shaderman.CurrentShader(), "tangent");
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
   if (resman.shaderman.CurrentShader() == 0) return;
   int location = resman.shaderman.GetAttribLocation(resman.shaderman.CurrentShader(), "terrainwt");
   if (location >= 0)
   {
      glDisableVertexAttribArrayARB(location);
   }
   location = resman.shaderman.GetAttribLocation(resman.shaderman.CurrentShader(), "terrainwt1");
   if (location >= 0)
   {
      glDisableVertexAttribArrayARB(location);
   }
   location = resman.shaderman.GetAttribLocation(resman.shaderman.CurrentShader(), "tangent");
   if (location >= 0)
   {
      glDisableVertexAttribArrayARB(location);
   }
#endif
}


void Mesh::RenderImpostor(Mesh& rendermesh, FBO& impfbo, const Vector3& campos)
{
#ifndef DEDICATED
   if (!impostor)
   {
      impostor = MeshPtr(new Mesh("models/impostor/base", resman));
      TrianglePtr first = impostor->tris[0];
      TrianglePtr second = impostor->tris[1];
      first->material = impmat.get();
      second->material = impmat.get();
   }
   
   TrianglePtr first = impostor->tris[0];
   TrianglePtr second = impostor->tris[1];
   
   impmat->SetTexture(0, impfbo.GetTexture());
   float width2 = width / 2.f;
   float height2 = height / 2.f;
   impostor->frameroot[0]->vertices[0].pos = Vector3(-width2, height2, 0);
   impostor->frameroot[0]->vertices[1].pos = Vector3(-width2, -height2, 0);
   impostor->frameroot[0]->vertices[2].pos = Vector3(width2, height2, 0);
   impostor->frameroot[0]->vertices[3].pos = Vector3(width2, -height2, 0);
   
   Vector3 moveto = position;
   impostor->Move(moveto);
   impostor->AdvanceAnimation(campos);
   rendermesh.Add(*impostor);
#endif
}


void Mesh::AdvanceAnimation(const Vector3& cpos)
{
   // Ideally this would be < 2, but it causes some problems ATM
   if (frameroot.size() < 1) // || frameroot.size() < 2 && !dynamic
      return;
   
   Uint32 currtick = SDL_GetTicks();
   animtime += static_cast<int>(fabs(animspeed) * static_cast<float>(currtick - lastanimtick));
   lastanimtick = currtick;
   while (animtime > frametime[currkeyframe])
   {
      animtime -= frametime[currkeyframe];
      // Move to next frame
      if (curranimation != nextanimation)
      {
         curranimation = nextanimation;
         currkeyframe = startframe[curranimation];
      }
      else
         ++currkeyframe;
      
      // Loop
      if (currkeyframe >= startframe[curranimation] + numframes[curranimation] - 1)
         currkeyframe = startframe[curranimation];
   }
   trisdirty = true;
   campos = cpos;
   UpdateTris();
}


// TODO: Doesn't currently update transparent tris (but then neither does anything else ATM)
void Mesh::UpdateTris()
{
   Uint32 currtick = SDL_GetTicks();
   if (!trisdirty || !frameroot.size() ||
      (currkeyframe < startframe[curranimation] || currkeyframe >= startframe[curranimation] + numframes[curranimation]) ||
      (currtick - lasttick < updatedelay))
      return;
   lasttick = currtick;
   float interpval;
   if (frametime.size() > 0)
      interpval = (float)animtime / (float)frametime[currkeyframe];
   else 
      interpval = 0.f;
   
   if (glops && !hasvbo) // Means we set glops with SetGL
      LoadMaterials(); // Need to do this before Transform
   
   GraphicMatrix m;
   
   m.rotatex(rots.x);
   m.rotatey(rots.y);
   m.rotatez(rots.z);
   
   m.translate(position);
   
   if (curranimation != nextanimation)
   {
      frameroot[currkeyframe]->Transform(frameroot[startframe[nextanimation]], interpval, vertices, m, campos);
      boundschanged = true;
   }
   else
   {
      if (currkeyframe == startframe[curranimation] + numframes[curranimation] - 1)
      {
         frameroot[currkeyframe]->Transform(frameroot[currkeyframe], interpval, vertices, m, campos);
      }
      else
      {
         frameroot[currkeyframe]->Transform(frameroot[currkeyframe + 1], interpval, vertices, m, campos);
         boundschanged = true;
      }
   }
   
   CalcBounds();
   ResetTriMaxDims();
   if (!childmeshes.size())
      trisdirty = false; // We don't know this if we have child meshes
   updatevbo = true;
}


void Mesh::CalcBounds()
{
   // If we just translated the mesh then we don't need to do this.
   if (boundschanged && !childmeshes.size())
   {
      size = 0.f;
      float dist = 0.f;
      float temp;
      Vector3 localpos = GetPosition();
      Vector3 localwpos, localhpos;
      size_t tsize = tris.size();
      height = 0;
      width = 0;
      for (size_t i = 0; i < tsize; ++i)
      {
         for (int j = 0; j < 3; ++j)
         {
            Triangle& currtri = *tris[i];
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
   }
   boundschanged = false;
   if (childmeshes.size())
   {
      for (size_t i = 0; i < childmeshes.size(); ++i)
         childmeshes[i]->CalcBounds();
      size = 0;
      height = 0;
      width = 0;
      for (size_t i = 0; i < childmeshes.size(); ++i)
      {
         size = std::max(size, childmeshes[i]->size);
         height = std::max(height, childmeshes[i]->height);
         width = std::max(width, childmeshes[i]->width);
      }
   }
}


// I am not at all certain that animspeed needs to be part of the state, we'll see
void Mesh::SetState(const Vector3& pos, const Vector3& rot, const int keyframe, const int atime, const float aspeed)
{
   if (frameroot.size() < 1) return;
   
   rots = rot;
   currkeyframe = keyframe;
   animtime = atime;
   SetAnimSpeed(aspeed);
   
   if (!frameroot[currkeyframe]->parent) // If we're a child mesh our position should be set by the parent
   {
      position = pos;
   }
   
   trisdirty = true;
   UpdateTris();
}


void Mesh::ReadState(Vector3& pos, Vector3& rot, int& keyframe, int& atime, float& aspeed, float& getsize)
{
   pos = GetPosition();
   rot = rots;
   keyframe = currkeyframe;
   atime = animtime;
   aspeed = animspeed;
   getsize = size;
}


void Mesh::LoadMaterials()
{
#ifndef DEDICATED
   if (havemats) return;
   for (size_t i = 0; i < tris.size(); ++i)
   {
      if (!tris[i]->material && tris[i]->matname != "")
         tris[i]->material = &resman.LoadMaterial(tris[i]->matname);
   }
   impmat = MaterialPtr(new Material("materials/impostor", resman.texman, resman.shaderman));
   havemats = true;
#endif
}


// Only for meshes that are built out of raw triangles - meshes loaded from a file should already have this done
void Mesh::GenTangents()
{
   for (size_t k = 0; k < tris.size(); ++k)
   {
      TrianglePtr newtri = tris[k];
      Vector3 one = newtri->v[1]->pos - newtri->v[0]->pos;
      Vector3 two = newtri->v[2]->pos - newtri->v[0]->pos;
      float tcone = newtri->v[1]->texcoords[0][1] - newtri->v[0]->texcoords[0][1];
      float tctwo = newtri->v[2]->texcoords[0][1] - newtri->v[0]->texcoords[0][1];
      Vector3 tangent = one * -tctwo + two * tcone;
      for (size_t j = 0; j < 3; ++j)
         newtri->v[j]->tangent += tangent;
   }
   for (size_t i = 0; i < vertices.size(); ++i)
   {
      vertices[i]->tangent.normalize();
   }
}


void Mesh::Scale(const float& sval)
{
   for (size_t i = 0; i < frameroot.size(); ++i)
      frameroot[i]->Scale(sval);
   ResetTriMaxDims();
   scale *= sval;
}


void Mesh::ScaleZ(const float& sval)
{
   for (size_t i = 0; i < frameroot.size(); ++i)
      frameroot[i]->ScaleZ(sval);
   ResetTriMaxDims();
}


// The insertion happens conceptually, but m remains a separate Mesh
// Note: Any time you move a parent you must call Move(mesh.GetPosition()) on the
// child mesh so that the geometry knows it needs to reset (mostly for collision detection).
// Eventually this should probably be done automatically
void Mesh::InsertIntoContainer(const string& name, Mesh& m)
{
   if (frameroot.size() != m.frameroot.size())
   {
      logout << "Warning: Not inserting mesh.  Keyframe mismatch." << endl;
      return;
   }
   
   for (size_t i = 0; i < frameroot.size(); ++i)
   {
      m.frameroot[i]->parent = &(*framecontainer[i][name]);
   }
   m.parent = this;
}


void Mesh::SetAnimSpeed(const float newas)
{
   animspeed = newas;
}


void Mesh::ResetAnimation()
{
   animspeed = 0.f;
   currkeyframe = 0;
   animtime = 0;
}


void Mesh::ResetTriMaxDims()
{
   size_t s = tris.size();
   for (size_t i = 0; i < s; ++i)
      tris[i]->maxdim = -1.f;
}


void Mesh::Add(TrianglePtr& tri)
{
   tris.push_back(tri);
   for (size_t i = 0; i < 3; ++i)
   {
      if (find(vertices.begin(), vertices.end(), tri->v[i]) == vertices.end())
      {
         vertices.push_back(tri->v[i]);
         tri->v[i]->id = vertices.size() - 1;
      }
   }
   boundschanged = true;
}


void Mesh::Add(Quad& quad)
{
   TrianglePtr temp = quad.First();
   Add(temp);
   temp = quad.Second();
   Add(temp);
}


void Mesh::Add(Mesh &mesh)
{
   mesh.UpdateTris();
   if (glops)
      mesh.SetGL();
   for (size_t i = 0; i < mesh.tris.size(); ++i)
   {
      Add(mesh.tris[i]);
   }
}


void Mesh::Add(Mesh* mesh)
{
   mesh->UpdateTris();
   if (glops)
      mesh->SetGL();
   childmeshes.push_back(mesh);
   newchildren = true;
   if (tris.size() && !childmeshes.size())
      logout << "Warning: Adding mesh pointers to non-empty mesh.  This erases all of its existing triangles.\n";
   tris.clear();
   updateibo = true;
   boundschanged = true;
}


void Mesh::Remove(Mesh* mesh)
{
   childmeshes.erase(remove(childmeshes.begin(), childmeshes.end(), mesh), childmeshes.end());
   tris.clear();
   newchildren = true;
   boundschanged = true;
}


int Mesh::NumTris() const
{
   return tris.size();
}


void Mesh::Clear()
{
   tris.clear();
   vertices.clear();
   childmeshes.clear();
   vbosize = 0;
}


void Mesh::SetAnimation(const int newanim)
{
   if (newanim < 10 && numframes[newanim] != 0)
      nextanimation = newanim;
}


void Mesh::SetGL()
{
   glops = true;
   LoadMaterials();
   for (size_t i = 0; i < frameroot.size(); ++i)
      frameroot[i]->SetGL(true);
}






