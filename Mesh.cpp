#include "Mesh.h"
#include "ProceduralTree.h" // Circular dependency

Mesh::Mesh(const string& filename, ResourceManager &rm, IniReader read, bool gl) : vbosteps(), impdist(0.f), render(true), animtime(0),
            lastanimtick(SDL_GetTicks()), position(Vector3()), rots(Vector3()),
            size(100.f), drawdistmult(-1.f), debug(false), width(0.f), height(0.f), resman(rm),
            impostortex(0), vbodata(vector<VBOData>()), vbo(0), ibo(0), next(0), hasvbo(false), vbosize(0), ibosize(0),
            currkeyframe(0), frametime(), glops(gl), havemats(false), dynamic(false), collide(true), dist(0.f), 
            animspeed(1.f)
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
   // TODO: Need to properly free vbo here, also free impostor Mesh (maybe, smart pointers ftw)
   //cout << "Warning: Called unimplemented destructor" << endl;
}


// TODO: Need to properly copy vbo and impostor Mesh here
Mesh::Mesh(const Mesh& m) : resman(m.resman), vbosteps(m.vbosteps), impdist(m.impdist), render(m.render),
         animtime(m.animtime), lastanimtick(m.lastanimtick), position(m.position), rots(m.rots),
         size(m.size), drawdistmult(m.drawdistmult), debug(m.debug), width(m.width), height(m.height),
         impostortex(m.impostortex), vbodata(m.vbodata), vbo(m.vbo), ibo(m.ibo), next(m.next), hasvbo(m.hasvbo),
         childmeshes(m.childmeshes), currkeyframe(m.currkeyframe), frametime(m.frametime), glops(m.glops), havemats(m.havemats),
         dynamic(m.dynamic), collide(m.collide), dist(m.dist), impostor(m.impostor), 
         animspeed(m.animspeed)
{
#ifndef DEDICATED
   if (m.impmat)
   {
      impmat = MaterialPtr(new Material("materials/impostor", resman.texman, resman.shaderman));
      impmat->SetTexture(0, m.impmat->GetTexture(0));
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
   cout <<  "Warning: Called undefined operator=" << endl;
   return *this;
}


void Mesh::Load(const IniReader& reader)
{
   string material;
   float scale = .01f;
   
   string type("");
   reader.Read(type, "Type");
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
      string basepath;
      string currfile;
      int numkeyframes = 0;
      
      string basefile;
      reader.Read(basefile, "BaseFile");
      if (basefile != "")
      {
         basepath = basefile;
         IniReader base(basefile);
         base.Read(numkeyframes, "NumFrames");
      }
      else
      {
         basepath = reader.GetPath();
         reader.Read(numkeyframes, "NumFrames");
      }
      basepath = basepath.substr(0, basepath.length() - 5);
      
      //cout << "Loading " << basepath << endl;
      
      map<size_t, size_t> vertmap;
      for (int i = 0; i < numkeyframes; ++i)
      {
         currfile = basepath + "/frame" + PadNum(i, 4);
         IniReader currframe(currfile);
         
         string currver("");
         currframe.Read(currver, "Version");
         if (currver != objectfilever)
         {
            cout << "Object file version mismatch for file: " << currfile << endl << flush;
            cout << currver << endl;
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
            for (int k = 0; k < currcon.NumChildren(); ++k)
            {
               const IniReader& currvert = currcon(k);
               VertexPtr newv(new Vertex());
               currvert.Read(newv->id, "ID");
               currvert.Read(newv->pos.x, "Pos", 0);
               currvert.Read(newv->pos.y, "Pos", 1);
               currvert.Read(newv->pos.z, "Pos", 2);
               currvert.Read(newv->norm.x, "Norm", 0);
               currvert.Read(newv->norm.y, "Norm", 1);
               currvert.Read(newv->norm.z, "Norm", 2);
               newv->pos *= scale;
               for (int m = 0; m < 8; ++m)
               {
                  currvert.Read(newv->texcoords[m][0], "TC", m * 2);
                  currvert.Read(newv->texcoords[m][1], "TC", m * 2 + 1);
               }
               currvert.Read(newv->color[0], "Color", 0);
               currvert.Read(newv->color[1], "Color", 1);
               currvert.Read(newv->color[2], "Color", 2);
               currvert.Read(newv->color[3], "Color", 3);
               newnode->vertices.push_back(newv);
               if (!i)
               {
                  vertices.push_back(VertexPtr(new Vertex(*newv)));
                  vertmap[newv->id] = vertices.size() - 1;
                  vertices.back()->id = vertices.size() - 1;
               }
               newv->id = vertmap[newv->id];
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
                  cout << "Error building tree for:  " << currfile << endl;
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
               if (glops && newtri->matname != "")
                  newtri->material = &resman.LoadMaterial(newtri->matname);
               curr.Read(newtri->collide, "Collide");
               tris.push_back(newtri);
            }
         }
      }
      UpdateTris(0, Vector3());
   }
   else if (type == "bush")
   {
      int numleaves = 0;  // Don't need to store this value
      reader.Read(numleaves, "NumLeaves");
      
      // Generate leaves
      float height = size;
      for (int j = 0; j < numleaves; j++)
      {
         Quad newquad;
         reader.Read(material, "Materials");
         newquad.SetMaterial(&resman.LoadMaterial(material));
         newquad.SetCollide(false);
         float leafratio = .5;
         Vector3vec corners(4, Vector3());
         corners[0] = Vector3(height / leafratio, 0, height / leafratio);
         corners[1] = Vector3(height / leafratio, 0, -height / leafratio);
         corners[2] = Vector3(-height / leafratio, 0, -height / leafratio);
         corners[3] = Vector3(-height / leafratio, 0, height / leafratio);
         
         float amount = j * 360 / numleaves;
         GraphicMatrix transform;
         transform.rotatex(amount * 2.5);
         transform.rotatey(amount * 3.3);
         transform.rotatez(amount);
         transform.translate(0, height / 2.f, 0);
         transform.rotatex(rots.x);
         transform.rotatey(rots.y);
         transform.rotatez(rots.z);
         transform.translate(position);
         
         for (int v = 0; v < 4; v++)
         {
            corners[v].transform(transform);
         }
         newquad.SetVertex(0, corners[0]);
         newquad.SetVertex(1, corners[1]);
         newquad.SetVertex(2, corners[2]);
         newquad.SetVertex(3, corners[3]);
         /* Right now we shut off lighting for tree leaves because
            it doesn't really look very good, so this step is not necessary
         for (int n = 0; n < 4; n++)
         {
            Vector3 temp1 = prims[nextprim].v[1] - prims[nextprim].v[0];
            Vector3 temp2 = prims[nextprim].v[2] - prims[nextprim].v[0];
            prims[nextprim].n[n] = temp1.cross(temp2);
            prims[nextprim].n[n].normalize();
         }*/
         Add(newquad);
      }
   }
   else if (type == "proctree")
   {
      ProceduralTree t;
      string barkmat, leafmat;
      
      t.ReadParams(reader);
      reader.Read(barkmat, "Materials", 0);
      reader.Read(leafmat, "Materials", 1);
      size_t save = t.GenTree(this, &resman.LoadMaterial(barkmat), &resman.LoadMaterial(leafmat));
      cout << "Tree primitives: " << save << endl;
   }
   else if (type == "Terrain" || type == "Empty"){} // No-op to avoid bogus warnings
   else
   {
      cout << "Warning: Attempted to load unknown object type " << type;
	  cout << " from file " << reader.GetPath() << endl;
   }
   CalcBounds();
}


void Mesh::Move(const Vector3& v)
{
   position = v;
   ResetTriMaxDims();
}


const Vector3& Mesh::GetPosition() const
{
   return position;
}


void Mesh::Rotate(const Vector3& v)
{
   rots = v;
   ResetTriMaxDims();
}


void Mesh::GenVbo()
{
   if (tris.size() || childmeshes.size())
   {
      vbosteps.clear();
      vbodata.clear();
      indexdata.clear();
      if (childmeshes.size())
         tris.clear();
      int currindex = 0;
      if (!hasvbo)
      {
         glGenBuffersARB(1, &vbo);
         glGenBuffersARB(1, &ibo);
      }
      for (size_t m = 0; m < childmeshes.size() + 1; ++m)
      {
         Mesh* currmesh;
         if (m < 1)
            currmesh = this;
         else
            currmesh = childmeshes[m - 1];
         VertexPtrvec& currvertices = currmesh->vertices;
         for (VertexPtrvec::iterator i = currvertices.begin(); i != currvertices.end(); ++i)
         {
            (*i)->tangent = Vector3();
         }
         TrianglePtrvec& currtris = currmesh->tris;
         for (size_t i = 0; i < currtris.size(); ++i)
         {
            // Generate tangents for triangles
            Vector3 one = currtris[i]->v[1]->pos - currtris[i]->v[0]->pos;
            Vector3 two = currtris[i]->v[2]->pos - currtris[i]->v[0]->pos;
            float tcone = currtris[i]->v[1]->texcoords[0][1] - currtris[i]->v[0]->texcoords[0][1];
            float tctwo = currtris[i]->v[2]->texcoords[0][1] - currtris[i]->v[0]->texcoords[0][1];
            Vector3 tangent = one * -tctwo + two * tcone;
            for (size_t j = 0; j < 3; ++j)
               currtris[i]->v[j]->tangent += tangent;
            
            if (m > 0)
               tris.push_back(currtris[i]);
         }
         
         // Build VBO
         for (VertexPtrvec::iterator i = currvertices.begin(); i != currvertices.end(); ++i)
         {
            (*i)->tangent.normalize();
            (*i)->index = currindex;
            ++currindex;
            vbodata.push_back((*i)->GetVboData());
         }
      }
      
      // Build IBO
      sort(tris.begin(), tris.end(), Triangle::TriPtrComp);
      int counter = 0;
      TrianglePtrvec::iterator last = tris.begin();
      for (TrianglePtrvec::iterator i = tris.begin(); i != tris.end(); ++i)
      {
         if (**last < **i)
         {
            vbosteps.push_back(counter);
            counter = 0;
         }
         ushortvec ind = (*i)->GetIndices();
         indexdata.insert(indexdata.end(), ind.begin(), ind.end());
         last = i;
         ++counter;
      }
      vbosteps.push_back(counter);
      
      glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER, ibo);
      glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo);
      if (!hasvbo || (vbodata.size() * sizeof(VBOData) > vbosize) || (indexdata.size() * sizeof(unsigned short) > ibosize))
      {
         if (frameroot.size() <= 1 && !dynamic)
         {
            glBufferDataARB(GL_ELEMENT_ARRAY_BUFFER, indexdata.size() * sizeof(unsigned short),
                           0, GL_STATIC_DRAW_ARB);
            glBufferDataARB(GL_ARRAY_BUFFER_ARB, 
                        vbodata.size() * sizeof(VBOData), 
                        0, GL_STATIC_DRAW_ARB);
         }
         else
         {
            glBufferDataARB(GL_ELEMENT_ARRAY_BUFFER, indexdata.size() * sizeof(unsigned short),
                           0, GL_STREAM_DRAW_ARB);
            glBufferDataARB(GL_ARRAY_BUFFER_ARB, 
                           vbodata.size() * sizeof(VBOData), 
                           0, GL_STREAM_DRAW_ARB);
         }
      }
      vbosize = vbodata.size() * sizeof(VBOData);
      ibosize = indexdata.size() * sizeof(unsigned short);
      glBufferSubDataARB(GL_ELEMENT_ARRAY_BUFFER, 0, indexdata.size() * sizeof(unsigned short), &indexdata[0]);
      glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, 0, vbodata.size() * sizeof(VBOData), &vbodata[0]);
      
      if (!glops)
      {
         LoadMaterials();
      }
      hasvbo = true;
   }
   glops = true;
}


void Mesh::BindVbo()
{
   if (!hasvbo)
   {
      cout << "Hey dummy, you have to call GenVbo first" << endl;
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
}


// Passing in overridemat causes this function to use every attribute of that material
// except the texture in unit 0.  This is primarily useful for shadowmap renders where
// we don't care about anything but the right shape so we use a very basic material
void Mesh::Render(Material* overridemat)
{
#ifndef DEDICATED
   if (!tris.size() || !render || !hasvbo)
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
      glDrawElements(GL_TRIANGLES, vbosteps[i] * 3, GL_UNSIGNED_SHORT, offset);
      UnbindAttribs();
      currindex += vbosteps[i];
   }
#endif
}


void Mesh::BindAttribs()
{
#ifndef DEDICATED
   if (resman.shaderman.CurrentShader() == "none") return;
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
   if (resman.shaderman.CurrentShader() == "none") return;
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
   impostor->frameroot[0]->vertices[0]->pos = Vector3(-width2, height2, 0);
   impostor->frameroot[0]->vertices[1]->pos = Vector3(-width2, -height2, 0);
   impostor->frameroot[0]->vertices[2]->pos = Vector3(width2, height2, 0);
   impostor->frameroot[0]->vertices[3]->pos = Vector3(width2, -height2, 0);
   
   Vector3 moveto = position;
   moveto.y += height2;
   impostor->Move(moveto);
   impostor->AdvanceAnimation(campos);
   rendermesh.Add(*impostor);
#endif
}


void Mesh::AdvanceAnimation(const Vector3& campos)
{
   if (frameroot.size() < 1) return;
   
   Uint32 currtick = SDL_GetTicks();
   animtime += static_cast<int>(animspeed * static_cast<float>(currtick - lastanimtick));
   lastanimtick = currtick;
   while (animtime > frametime[currkeyframe])
   {
      animtime -= frametime[currkeyframe];
      ++currkeyframe;
      if (currkeyframe >= frameroot.size() - 1)
         currkeyframe = 0;
   }
   UpdateTris(currkeyframe, campos);
}


// Parameter is index into frameroot, if invalid (i.e. negative or > frameroot.size())
// then this does nothing.  If frameroot.size() == 1 then it simply returns the tris
// described by that nodetree.  Otherwise, interpolate between frameroot[index] and
// frameroot[index + 1] based on animtime

// TODO: Doesn't currently update transparent tris (but then neither does anything else ATM)
void Mesh::UpdateTris(int index, const Vector3& campos)
{
   float interpval;
   if (frametime.size() > 0)
      interpval = (float)animtime / (float)frametime[currkeyframe];
   else 
      interpval = 0.f;
   
   if (glops && !hasvbo) // Means we set glops with SetGL
      LoadMaterials(); // Need to do this before Transform
   else if (index < 0 || index >= frameroot.size()) return;
   
   GraphicMatrix m;
   
   m.rotatex(rots.x);
   m.rotatey(rots.y);
   m.rotatez(rots.z);
   GraphicMatrix nm = m;
   m.translate(position);
   
   if (frameroot.size() == 1) // Implies index has to be 0
   {
      frameroot[0]->Transform(frameroot[0], interpval, vertices, m, nm, campos);
   }
   else if (index == frameroot.size() - 1) // Could happen if we land exactly on the last keyframe
   {
      frameroot[index]->Transform(frameroot[index], interpval, vertices, m, nm, campos);
   }
   else
   {
      frameroot[index]->Transform(frameroot[index + 1], interpval, vertices, m, nm, campos);
   }
   
   CalcBounds();
   
   if (glops)
      GenVbo();
}


void Mesh::CalcBounds()
{
   size = 0.f;
   float dist = 0.f;
   Vector3 min;
   Vector3 max;
   float temp;
   for (int i = 0; i < tris.size(); ++i)
   {
      for (int j = 0; j < 3; ++j)
      {
         dist = tris[i]->v[j]->pos.distance(position) + tris[i]->radmod;
         if (dist > size) size = dist;
         temp = tris[i]->v[j]->pos.x - position.x;
         if (temp + tris[i]->radmod > max.x) max.x = temp + tris[i]->radmod;
         if (temp - tris[i]->radmod < min.x) min.x = temp - tris[i]->radmod;
         temp = tris[i]->v[j]->pos.y - position.y;
         if (temp + tris[i]->radmod > max.y) max.y = temp + tris[i]->radmod;
         if (temp - tris[i]->radmod < min.y) min.y = temp - tris[i]->radmod;
         temp = tris[i]->v[j]->pos.z - position.z;
         if (temp + tris[i]->radmod > max.z) max.z = temp + tris[i]->radmod;
         if (temp - tris[i]->radmod < min.z) min.z = temp - tris[i]->radmod;
      }
   }
   height = max.y - min.y;
   width = (max.x - min.x) > (max.z - min.z) ? (max.x - min.x) : (max.z - min.z);
}


// I am not at all certain that animspeed needs to be part of the state, we'll see
void Mesh::SetState(const Vector3& pos, const Vector3& rot, const int keyframe, const int atime, const float aspeed)
{
   if (frameroot.size() < 1) return;
   
   position = pos;
   rots = rot;
   currkeyframe = keyframe;
   animtime = atime;
   SetAnimSpeed(aspeed);
   
   // campos is not important because this is only called by the server (at this time)
   UpdateTris(currkeyframe, Vector3());
}


void Mesh::ReadState(Vector3& pos, Vector3& rot, int& keyframe, int& atime, float& aspeed)
{
   pos = position;
   rot = rots;
   keyframe = currkeyframe;
   atime = animtime;
   aspeed = animspeed;
}


void Mesh::LoadMaterials()
{
#ifndef DEDICATED
   if (havemats) return;
   for (size_t i = 0; i < tris.size(); ++i)
   {
      for (size_t j = 0; j < tris.size(); ++j)
      {
         if (!tris[i]->material && tris[i]->matname != "")
            tris[i]->material = &resman.LoadMaterial(tris[i]->matname);
      }
   }
   impmat = MaterialPtr(new Material("materials/impostor", resman.texman, resman.shaderman));
   havemats = true;
#endif
}


void Mesh::Scale(const float& sval)
{
   for (int i = 0; i < frameroot.size(); ++i)
      frameroot[i]->Scale(sval);
   ResetTriMaxDims();
}


void Mesh::ScaleZ(const float& sval)
{
   for (size_t i = 0; i < frameroot.size(); ++i)
      frameroot[i]->ScaleZ(sval);
   ResetTriMaxDims();
}


// The insertion happens conceptually, but m remains a separate Mesh
void Mesh::InsertIntoContainer(const string& name, Mesh& m)
{
   if (frameroot.size() != m.frameroot.size())
   {
      cout << "Warning: Not inserting mesh.  Keyframe mismatch." << endl;
      return;
   }
   
   for (int i = 0; i < frameroot.size(); ++i)
   {
      m.frameroot[i]->parent = &(*framecontainer[i][name]);
   }
}


void Mesh::SetAnimSpeed(const float newas)
{
   animspeed = newas;
   /*float ratio = newas / animspeed;
   animspeed = newas;
   animtime = static_cast<int>(static_cast<float>(animtime) * ratio);*/
}


void Mesh::ResetAnimation()
{
   animspeed = 0.f;
   currkeyframe = 0;
   animtime = 0;
}


void Mesh::ResetTriMaxDims()
{
   for (size_t i = 0; i < tris.size(); ++i)
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
   for (size_t i = 0; i < mesh.tris.size(); ++i)
   {
      Add(mesh.tris[i]);
   }
}


void Mesh::Add(Mesh* mesh)
{
   childmeshes.push_back(mesh);
}


void Mesh::Begin()
{
   next = 0;
}


bool Mesh::HasNext() const
{
   return next < tris.size();
}


Triangle& Mesh::Next()
{
   ++next;
   return *tris[next - 1];
}


int Mesh::Size() const
{
   return tris.size();
}


void Mesh::Clear()
{
   tris.clear();
   vertices.clear();
   childmeshes.clear();
}






