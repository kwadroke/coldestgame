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


#include "MeshNode.h"
#include "globals.h" // Causes problems if included in header
#include "Mesh.h"

MeshNode::MeshNode() : id(0), parentid(0), facing(false), gl(false), parent(NULL)
{
}


void MeshNode::Transform(const MeshNodePtr& interpnode, const float interpval, VertexPtrvec& verts, 
                         const GraphicMatrix& parentm, const Vector3& campos)
{
   if (interpnode.get() == this)
   {
      TransformNoInt(verts, parentm, campos);
      return;
   }
   Vector3 interprot1 = lerp(interpnode->rot1, rot1, interpval);
   Vector3 interprot2 = lerp(interpnode->rot2, rot2, interpval);
   Vector3 interptrans = lerp(interpnode->trans, trans, interpval);
   
   m.identity();
   
   if (!facing)
   {
      m.rotatez(interprot2.z);
      m.rotatey(interprot2.y);
      m.rotatex(interprot2.x);
      
      m.translate(interptrans);
      
      m.rotatez(interprot1.z);
      m.rotatey(interprot1.y);
      m.rotatex(interprot1.x);
   }
   else
   {
      Vector3 dir;
      Vector3 start(0, 0, 1);
      Vector3 facerot, currpos;
      start.transform3(m);
      
      // Find the current position - note that this duplicates code, but with facing containers
      // it is necessary to do this twice so there's not a good way around that
      GraphicMatrix facem;
      facem.translate(interptrans);
      if (parent) facem *= parent->m;
      facem *= parentm;
      currpos.transform(facem);
      dir = campos - currpos;
      
      facerot = RotateBetweenVectors(start, dir);
      
      m.rotatex(facerot.x);
      m.rotatey(facerot.y);
      m.translate(interptrans);
   }

   if (parent)
   {
      m *= parent->m;
   }
   m *= parentm;
   
   TransformLoop(interpnode, interpval, verts, parentm, campos);
   
   // Recursively call this on our children
   size_t csize = children.size();
   for (size_t i = 0; i < csize; ++i)
   {
      children[i]->Transform(interpnode->children[i], interpval, verts, m, campos);
   }
}


// Split this off to aid profiling - inline when not profiling
inline
void MeshNode::TransformLoop(const MeshNodePtr& interpnode, const float interpval, VertexPtrvec& verts, 
                             const GraphicMatrix& parentm, const Vector3& campos)
{
   size_t vsize = vertices.size();
   if (1)//gl)
   {
      for (size_t i = 0; i < vsize; ++i)
      {
         Vertex& verti = vertices[i];
         Vertex& interpvi = interpnode->vertices[i];
         Vertex& currvert = *verts[verti.id];
         
         currvert.norm = lerp(interpvi.norm, verti.norm, interpval);
         currvert.tangent = lerp(interpvi.tangent, verti.tangent, interpval);
         currvert.pos = lerp(interpvi.pos, verti.pos, interpval);
         currvert.pos.transform(m);
         currvert.norm.transform3(m);
         currvert.tangent.transform3(m);
         
         for (size_t j = 0; j < 4; ++j)
         {
            currvert.color[j] = 
                  static_cast<unsigned char>(lerp(float(interpvi.color[j]), float(verti.color[j]), interpval));
         }
      }
   }
   else
   {
      for (size_t i = 0; i < vsize; ++i)
      {
         Vertex& verti = vertices[i];
         Vertex& currvert = *verts[verti.id];
         
         currvert.pos = lerp(interpnode->vertices[i].pos, verti.pos, interpval);
         currvert.pos.transform(m);
      }
   }
}


void MeshNode::TransformNoInt(VertexPtrvec& verts, const GraphicMatrix& parentm, const Vector3& campos)
{
   m.identity();
   
   if (!facing)
   {
      m.rotatez(rot2.z);
      m.rotatey(rot2.y);
      m.rotatex(rot2.x);
      
      m.translate(trans);
      
      m.rotatez(rot1.z);
      m.rotatey(rot1.y);
      m.rotatex(rot1.x);
   }
   else
   {
      Vector3 dir;
      Vector3 start(0, 0, 1);
      Vector3 facerot, currpos;
      start.transform3(m);
      
      // Find the current position - note that this duplicates code, but with facing containers
      // it is necessary to do this twice so there's not a good way around that
      GraphicMatrix facem;
      facem.translate(trans);
      if (parent) facem *= parent->m;
      facem *= parentm;
      currpos.transform(facem);
      dir = campos - currpos;
      
      facerot = RotateBetweenVectors(start, dir);
      
      m.rotatex(facerot.x);
      m.rotatey(facerot.y);
      m.translate(trans);
   }

   if (parent)
   {
      m *= parent->m;
   }
   m *= parentm;
   
   TransformNoIntLoop(verts, parentm, campos);
   
   // Recursively call this on our children
   size_t csize = children.size();
   for (size_t i = 0; i < csize; ++i)
   {
      children[i]->TransformNoInt(verts, m, campos);
   }
}


// Split this off to aid profiling - inline when not profiling
inline
void MeshNode::TransformNoIntLoop(VertexPtrvec& verts, const GraphicMatrix& parentm, const Vector3& campos)
{
   size_t vsize = vertices.size();
   if (gl) // Means we need normal and color data, otherwise we don't care
   {
      for (size_t i = 0; i < vsize; ++i)
      {
         Vertex& verti = vertices[i];
         Vertex& currvert = *verts[verti.id];
         
         currvert.norm = verti.norm;
         currvert.pos = verti.pos;
         currvert.tangent = verti.tangent;
         currvert.pos.transform(m);
         currvert.norm.transform3(m);
         currvert.tangent.transform3(m);
         
         currvert.color = verti.color;
      }
   }
   else
   {
      for (size_t i = 0; i < vsize; ++i)
      {
         Vertex& verti = vertices[i];
         Vertex& currvert = *verts[verti.id];
         
         currvert.pos = verti.pos;
         currvert.pos.transform(m);
      }
   }
}


// Currently this function keeps parent the same, even though that may not always be
// what is wanted.  It causes problems if we don't do this, however, because this gets
// called when inserting a mesh into an STL container, which is a fairly common
// operation and expected to insert an exact copy, not a copy with this pointer null'd
MeshNodePtr MeshNode::Clone()
{
   MeshNodePtr newmn(new MeshNode(*this));
   newmn->children.clear();
   newmn->parent = parent;
   newmn->gl = gl;
   newmn->vertices = vertices;
   
   for (size_t i = 0; i < children.size(); ++i)
   {
      newmn->children.push_back(children[i]->Clone());
   }
   return newmn;
}


void MeshNode::GetContainers(map<string, MeshNodePtr>& cont, MeshNodePtr& thisptr)
{
   cont[name] = thisptr;
   for (size_t i = 0; i < children.size(); ++i)
      children[i]->GetContainers(cont, children[i]);
}


void MeshNode::Scale(const float& sval)
{
   for (size_t i = 0; i < vertices.size(); ++i)
   {
      vertices[i].pos *= sval;
   }
   trans *= sval;
   for (size_t i = 0; i < children.size(); ++i)
   {
      children[i]->Scale(sval);
   }
}


void MeshNode::ScaleZ(const float& sval)
{
   for (size_t i = 0; i < vertices.size(); ++i)
   {
      vertices[i].pos.z *= sval;
   }
   trans.z *= sval;
   for (size_t i = 0; i < children.size(); ++i)
   {
      children[i]->ScaleZ(sval);
   }
}


void MeshNode::SetGL(const bool dogl)
{
   gl = dogl;
   
   for (size_t i = 0; i < children.size(); ++i)
   {
      children[i]->SetGL(dogl);
   }
}


void MeshNode::SetTangent(const size_t id, const Vector3& tan)
{
   for (size_t i = 0; i < vertices.size(); ++i)
   {
      if (vertices[i].id == id)
      {
         vertices[i].tangent = tan;
         return;
      }
   }
   for (size_t i = 0; i < children.size(); ++i)
      children[i]->SetTangent(id, tan);
}



