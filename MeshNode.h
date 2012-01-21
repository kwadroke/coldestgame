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


#ifndef __MESHNODE_H
#define __MESHNODE_H

#include "Triangle.h"
#include "Vector3.h"
#include "types.h"
#include "Material.h"
#include "GraphicMatrix.h"
#include "ResourceManager.h"
#include <boost/shared_ptr.hpp>

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/

using boost::shared_ptr;

class Mesh;

class MeshNode
{
   public:
      MeshNode();
      void Transform(const shared_ptr<MeshNode>&, const float, VertexPtrvec&, const GraphicMatrix&, const Vector3&);
      void TransformLoop(const shared_ptr<MeshNode>&, const float, VertexPtrvec&, const GraphicMatrix&, const Vector3&);
      void TransformNoInt(VertexPtrvec&, const GraphicMatrix&, const Vector3&);
      void TransformNoIntLoop(VertexPtrvec&, const GraphicMatrix&, const Vector3&);
      shared_ptr<MeshNode> Clone();
      void GetContainers(map<string, shared_ptr<MeshNode> >& cont, shared_ptr<MeshNode>&);
      void Scale(const float&);
      void ScaleZ(const float&);
      void SetGL(const bool);
      void SetTangent(size_t, const Vector3&);
      
      int id, parentid;
      bool facing;
      bool gl;
      Vector3 rot1, rot2;
      Vector3 trans;
      vector<shared_ptr<MeshNode> > children;
      Vertexvec vertices;
      GraphicMatrix m;
      string name;
      MeshNode* parent;
};

typedef shared_ptr<MeshNode> MeshNodePtr;

#endif
