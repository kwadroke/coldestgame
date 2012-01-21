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
#include "MeshData.h"
#include "Mesh.h"

MeshData::MeshData(ResourceManager& rm) : resman(rm)
{}

MeshData::MeshData(const MeshData& md) : resman(md.resman)
{
   DeepCopy(md);
}

MeshData& MeshData::operator=(const MeshData& md)
{
   if (&md == this)
      return *this;

   // Can't assign resman, but that's okay because it has to have already been set.
   DeepCopy(md);
   return *this;
}


void MeshData::DeepCopy(const MeshData& md)
{
#ifndef DEDICATED
   if (md.impmat)
   {
      impmat = MaterialPtr(new Material("materials/impostor", resman.texman, resman.shaderman));
   }
   if (md.impostor)
   {
      impostor = MeshPtr(new Mesh(NTreeReader("models/impostor/base"), resman));
   }
#endif

   tris = md.tris;

   // The following containers hold smart pointers, which means that when we copy them
   // the objects are still shared.  That's a bad thing, so we manually copy every
   // object to the new container
   vertices.clear();
   frameroot.clear();
   triptrs.clear();
   for (size_t i = 0; i < md.triptrs.size(); ++i)
   {
      triptrs.push_back(TrianglePtr(new Triangle(*md.triptrs[i])));
   }
   VertexPtrvec localvert = md.vertices;
   for (VertexPtrvec::iterator i = localvert.begin(); i != localvert.end(); ++i)
   {
      VertexPtr p(new Vertex(**i));
      vertices.push_back(p);
   }
   // Only one of the following two for loops should actually happen
   for (size_t i = 0; i < md.tris.size(); ++i)
   {
      for (size_t j = 0; j < 3; ++j)
      {
         tris[i].v[j] = vertices[tris[i].v[j]->id];
      }
   }
   for (size_t i = 0; i < md.triptrs.size(); ++i)
   {
      for (size_t j = 0; j < 3; ++j)
      {
         triptrs[i]->v[j] = vertices[triptrs[i]->v[j]->id];
      }
   }
   for (size_t i = 0; i < md.frameroot.size(); ++i)
   {
      frameroot.push_back(md.frameroot[i]->Clone());
   }
}


void MeshData::EnsureMaterials()
{
   size_t tsize = NumTris();
   for (size_t i = 0; i < tsize; ++i)
   {
      if (!Tri(i).material && Tri(i).matname != "")
         Tri(i).material = &resman.LoadMaterial(Tri(i).matname);
   }
}


void MeshData::SortTris()
{
   if (tris.size())
      std::sort(tris.begin(), tris.end());
   else
      std::sort(triptrs.begin(), triptrs.end(), Triangle::TriPtrComp);
}
