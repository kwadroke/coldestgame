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
      void GenTris(const shared_ptr<MeshNode>&, const float, const GraphicMatrix&, Mesh&, const Vector3& campos);
      shared_ptr<MeshNode> Clone();
      void GetContainers(map<string, shared_ptr<MeshNode> >& cont, shared_ptr<MeshNode>&);
      void LoadMaterials(ResourceManager&);
      void Scale(const float&);
      
      int id, parentid;
      bool facing, collide, render;
      Material* material;
      string matname;
      Vector3 rot1, rot2;
      Vector3 trans;
      Vector3vec vert;
      vector< vector<floatvec> > texcoords;
      vector<shared_ptr<MeshNode> > children;
      GraphicMatrix m;
      string name;
      MeshNode* parent;
};

typedef shared_ptr<MeshNode> MeshNodePtr;

#endif
