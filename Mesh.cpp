#include "Mesh.h"
#include "ProceduralTree.h" // Circular dependency
#include "globals.h"        // Ditto

Mesh::Mesh(IniReader& reader, ResourceManager &rm, bool gl) : vbosteps(), impdist(0.f), render(true), animtime(0),
            lastanimtick(SDL_GetTicks()), position(Vector3()), rots(Vector3()),
            size(100.f), width(0.f), height(0.f), resman(rm), tris(Trianglevec()), trantris(Trianglevec()),
            impostortex(0), vbodata(vector<VBOData>()), vbo(0), next(0), hasvbo(false), currkeyframe(0),
            frametime(), glops(gl), havemats(false), dynamic(false), dist(0.f), 
            impmat(MaterialPtr(new Material("materials/impostor", rm.texman, rm.shaderman)))
{
   Load(reader);
}


Mesh::~Mesh()
{
   // TODO: Need to properly free vbo here, also free impostor Mesh (maybe, smart pointers ftw)
   //cout << "Warning: Called unimplemented destructor" << endl;
}


// TODO: Need to properly copy vbo and impostor Mesh here
Mesh::Mesh(const Mesh& m) : resman(m.resman), vbosteps(m.vbosteps), impdist(m.impdist), render(m.render),
         animtime(m.animtime), lastanimtick(m.lastanimtick), position(m.position), rots(m.rots),
         size(m.size), width(m.width), height(m.height), tris(m.tris), trantris(m.trantris),
         impostortex(m.impostortex), vbodata(m.vbodata), vbo(m.vbo), next(m.next), hasvbo(m.hasvbo),
         currkeyframe(m.currkeyframe), frametime(m.frametime), glops(m.glops), havemats(m.havemats),
         dynamic(m.dynamic), dist(m.dist), impostor(m.impostor), 
         impmat(MaterialPtr(new Material("materials/impostor", m.resman.texman, m.resman.shaderman)))
{
   impmat->SetTexture(0, m.impmat->GetTexture(0));
   // Copy frameroot and framecontainer - these contain smart ptrs so the actual objects are shared
   // otherwise, which is a bad thing here
   for (int i = 0; i < m.frameroot.size(); ++i)
   {
      frameroot.push_back(m.frameroot[i]->Clone());
      framecontainer.push_back(map<string, MeshNodePtr>());
      frameroot[i]->GetContainers(framecontainer[i], frameroot[i]);
   }
}


Mesh& Mesh::operator=(const Mesh& m)
{
   cout <<  "Warning: Called undefined operator=" << endl;
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
   reader.Read(rots.y, "Rotations", 0); // Note: Might be better to change this order
   reader.Read(rots.x, "Rotations", 1);
   reader.Read(rots.z, "Rotations", 2);
   reader.Read(size, "Size");
   reader.Read(impdist, "ImpostorDistance");
   reader.Read(scale, "Scale");
   
   if (type == "External")
   {
      string basepath;
      string currfile;
      int numkeyframes = 0;
      
      reader.Read(basepath, "Files");
      reader.Read(numkeyframes, "NumFrames");
      
      cout << "Loading " << basepath << endl;
      
      for (int i = 0; i < numkeyframes; ++i)
      {
         currfile = "models/" + basepath + "/frame" + PadNum(i, 4);
         IniReader currframe(currfile);
         
         string currver("");
         currframe.Read(currver, "Version");
         if (currver != objectfilever)
         {
            cout << "Object file version mismatch for file: " << currfile << endl << flush;
            return;
         }
         
         int currft = 0;
         currframe.Read(currft, "TimeToNextFrame");
         frametime.push_back(currft);
         
         framecontainer.push_back(map<string, MeshNodePtr>());
         
         MeshNodeMap nodes;
         for (int j = 0; j < currframe.NumChildren(); ++j)
         {
            IniReader currprim = currframe.GetItem(j);
            MeshNodePtr newnode(new MeshNode());
            
            string type;
            currprim.Read(type, "Type");
            if (type == "Quad") // Need to add one more vert and related properties
            {
               newnode->vert.push_back(Vector3());
               for (int k = 0; k < 8; ++k)
                  newnode->texcoords[k].push_back(floatvec(2, 0.f));
            }
            if (type == "Container")
               newnode->render = false;
            currprim.Read(newnode->id, "ID");
            currprim.Read(newnode->parentid, "ParentID");
            currprim.Read(newnode->matname, "Material");
            if (newnode->matname != "" && glops)
               newnode->material = &resman.LoadMaterial(newnode->matname);
            
            currprim.Read(newnode->rot1.x, "Rot1", 0);
            currprim.Read(newnode->rot1.y, "Rot1", 1);
            currprim.Read(newnode->rot1.z, "Rot1", 2);
            currprim.Read(newnode->rot2.x, "Rot2", 0);
            currprim.Read(newnode->rot2.y, "Rot2", 1);
            currprim.Read(newnode->rot2.z, "Rot2", 2);
            currprim.Read(newnode->trans.x, "Trans", 0);
            currprim.Read(newnode->trans.y, "Trans", 1);
            currprim.Read(newnode->trans.z, "Trans", 2);
            newnode->trans *= scale;
            string pname;
            string tcname;
            for (int k = 0; k < newnode->vert.size(); ++k)
            {
               pname = "p" + ToString(k);
               tcname = "tc" + ToString(k);
               currprim.Read(newnode->vert[k].x, pname, 0);
               currprim.Read(newnode->vert[k].y, pname, 1);
               currprim.Read(newnode->vert[k].z, pname, 2);
               // Apply scaling
               newnode->vert[k] *= scale;
               for (int m = 0; m < 8; ++m)
               {
                  currprim.Read(newnode->texcoords[m][k][0], tcname + "x", m);
                  currprim.Read(newnode->texcoords[m][k][1], tcname + "y", m);
               }
            }
            currprim.Read(newnode->collide, "Collide");
            currprim.Read(newnode->facing, "Facing");
            currprim.Read(newnode->name, "Name");
            nodes[newnode->id] = newnode;
            if (type == "Container")
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
         tris.push_back(newquad.First());
         tris.push_back(newquad.Second());
      }
   }
   else if (type == "proctree")
   {
      ProceduralTree t;
      string barkmat, leafmat;
      
      t.ReadParams(reader);
      reader.Read(barkmat, "Materials", 0);
      reader.Read(leafmat, "Materials", 1);
      
      int save = t.GenTree(this, &resman.LoadMaterial(barkmat), &resman.LoadMaterial(leafmat));
      cout << "Tree primitives: " << save << endl;
   }
   else if (type == "Terrain" || type == "Empty"){} // No-op to avoid bogus warnings
   else
   {
      cout << "Warning: Attempted to load unknown object type " << type << endl;
   }
   CalcBounds();
}


void Mesh::Move(const Vector3& v)
{
   position = v;
}


const Vector3& Mesh::GetPosition() const
{
   return position;
}


void Mesh::Rotate(const Vector3& v)
{
   rots = v;
}


void Mesh::GenVbo()
{
   if (tris.size())
   {
      vbosteps.clear();
      vbodata.clear();
      /*if (hasvbo)
         glDeleteBuffersARB(1, &vbo);
      glGenBuffersARB(1, &vbo);*/
      if (!hasvbo)
      {
         glGenBuffersARB(1, &vbo);
      }
      glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo);
      
      sort(tris.begin(), tris.end());
      int counter = 0;
      Trianglevec::iterator last = tris.begin();
      for (Trianglevec::iterator i = tris.begin(); i != tris.end(); ++i)
      {
         if (*last < *i)
         {
            vbosteps.push_back(counter);
            counter = 0;
         }
         for (int j = 0; j < 3; ++j)
         {
            vbodata.push_back(i->GetVboData(j));
         }
         last = i;
         ++counter;
      }
      vbosteps.push_back(counter);
      if (frameroot.size() <= 1)
      {
         glBufferDataARB(GL_ARRAY_BUFFER_ARB, 
                     vbodata.size() * sizeof(VBOData), 
                     0, GL_STATIC_DRAW_ARB);
      }
      else
      {
         glBufferDataARB(GL_ARRAY_BUFFER_ARB, 
                        vbodata.size() * sizeof(VBOData), 
                        0, GL_DYNAMIC_DRAW_ARB);
      }
      glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, 0, vbodata.size() * sizeof(VBOData), &vbodata[0]);
      glBindBufferARB(GL_ARRAY_BUFFER_ARB, 0);
      
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
   if (!tris.size()) return;
   BindVbo();
   int currindex = 0;
   if (overridemat)
      overridemat->Use();
   for (int i = 0; i < vbosteps.size(); ++i)
   {
      if (tris[currindex].material)
      {
         if (!overridemat)
            tris[currindex].material->Use();
         else tris[currindex].material->UseTextureOnly();
      }
      BindAttribs();
      glDrawArrays(GL_TRIANGLES, currindex * 3, vbosteps[i] * 3);
      UnbindAttribs();
      currindex += vbosteps[i];
   }
}


void Mesh::BindAttribs()
{
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
}


void Mesh::UnbindAttribs()
{
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
}


void Mesh::RenderImpostor(Mesh& rendermesh, FBO& impfbo, const Vector3& campos)
{
   if (!impostor)
   {
      IniReader impread("models/impostor/base");
      impostor = MeshPtr(new Mesh(impread, resman, false));
      impostor->frameroot[0]->material = impmat.get();
      impostor->frameroot[0]->texcoords[0][0][1] = 1.f;
      impostor->frameroot[0]->texcoords[0][1][1] = 0.f;
      impostor->frameroot[0]->texcoords[0][2][1] = 0.f;
      impostor->frameroot[0]->texcoords[0][3][1] = 1.f;
   }
   
   impmat->SetTexture(0, impfbo.GetTexture());
   float width2 = width / 2.f;
   float height2 = height / 2.f;
   impostor->frameroot[0]->vert[0] = Vector3(-width2, height2, 0);
   impostor->frameroot[0]->vert[1] = Vector3(-width2, -height2, 0);
   impostor->frameroot[0]->vert[2] = Vector3(width2, -height2, 0);
   impostor->frameroot[0]->vert[3] = Vector3(width2, height2, 0);
   
   Vector3 moveto = position;
   moveto.y += height2;
   impostor->Move(moveto);
   impostor->AdvanceAnimation(campos);
   rendermesh.Add(*impostor);
}


void Mesh::AdvanceAnimation(const Vector3& campos)
{
   if (frameroot.size() < 1) return;
   
   Uint32 currtick = SDL_GetTicks();
   animtime += currtick - lastanimtick;
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
   float interpval = (float)animtime / (float)frametime[currkeyframe];
   
   if (index < 0 || index >= frameroot.size()) return;
   
   tris.clear();
   trantris.clear();
   
   GraphicMatrix m;
   
   m.rotatex(rots.x);
   m.rotatey(rots.y);
   m.rotatez(rots.z);
   m.translate(position);
   
   if (frameroot.size() == 1) // Implies index has to be 0
   {
      //if (tris.size() <= 0)
         frameroot[0]->GenTris(frameroot[0], interpval, m, tris, campos);
   }
   else if (index == frameroot.size() - 1) // Could happen if we land exactly on the last keyframe
   {
      frameroot[index]->GenTris(frameroot[index], interpval, m, tris, campos);
   }
   else
   {
      frameroot[index]->GenTris(frameroot[index + 1], interpval, m, tris, campos);
   }
   
   CalcBounds();
   
   if (glops)
      GenVbo();
}


void Mesh::CalcBounds()
{
   float size2 = 0.f;
   float dist2 = 0.f;
   Vector3 min;
   Vector3 max;
   float temp;
   for (int i = 0; i < tris.size(); ++i)
   {
      for (int j = 0; j < 3; ++j)
      {
         dist2 = tris[i].vert[j].distance2(position);
         if (dist2 > size2) size2 = dist2;
         temp = tris[i].vert[j].x - position.x;
         if (temp > max.x) max.x = temp;
         if (temp < min.x) min.x = temp;
         temp = tris[i].vert[j].y - position.y;
         if (temp > max.y) max.y = temp;
         if (temp < min.y) min.y = temp;
         temp = tris[i].vert[j].z - position.z;
         if (temp > max.z) max.z = temp;
         if (temp < min.z) min.z = temp;
      }
   }
   size = sqrt(size2) * 2.f;
   height = max.y - min.y;
   width = (max.x - min.x) > (max.z - min.z) ? (max.x - min.x) : (max.z - min.z);
}


void Mesh::LoadMaterials()
{
   if (havemats) return;
   for (int i = 0; i < frameroot.size(); ++i)
      frameroot[i]->LoadMaterials(resman);
   havemats = true;
}


// The insertion happens conceptually, but m remains a separate Mesh
void Mesh::InsertIntoContainer(const string& name, Mesh& m)
{
   if (frameroot.size() != m.frameroot.size())
   {
      cout << "Warning: Not inserting mesh.  Keyframe mismatch." << endl;
   }
   
   for (int i = 0; i < frameroot.size(); ++i)
   {
      m.frameroot[i]->parent = &(*framecontainer[i][name]);
   }
}


void Mesh::Add(Triangle& tri)
{
   tris.push_back(tri);
}


void Mesh::Add(Quad& quad)
{
   tris.push_back(quad.First());
   tris.push_back(quad.Second());
}


void Mesh::Add(Mesh &mesh)
{
   for (int i = 0; i < mesh.tris.size(); ++i)
      tris.push_back(mesh.tris[i]);
}


void Mesh::Begin()
{
   next = 0;
}


bool Mesh::HasNext() const
{
   return next < tris.size();
}


const Triangle& Mesh::Next()
{
   ++next;
   return tris[next - 1];
}


int Mesh::Size() const
{
   return tris.size();
}






