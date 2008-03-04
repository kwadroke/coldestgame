#ifndef __MESHNODE_H
#define __MESHNODE_H

#include "Triangle.h"
#include "Vector3.h"
#include "types.h"
#include "Material.h"
#include "GraphicMatrix.h"
#include <boost/shared_ptr.hpp>

/**
	@author Ben Nemec <ben@nemebean.com>
*/

using boost::shared_ptr;

class MeshNode
{
   public:
      MeshNode();
      void GenTris(const shared_ptr<MeshNode>&, const float, const GraphicMatrix&, Trianglevec&);
      shared_ptr<MeshNode> Clone();
      void GetContainers(map<string, shared_ptr<MeshNode> >& cont, shared_ptr<MeshNode>&);
      
      int id, parentid;
      bool facing, collide, render;
      Material* material;
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
