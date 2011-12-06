#ifndef PATHNODE_H
#define PATHNODE_H

#include "Vector3.h"
#include "types.h"
#include <boost/shared_ptr.hpp>

class PathNode
{
   public:
      PathNode(const Vector3&);
      Vector3vec GetAdjacent(const float);
      bool Validate(Vector3, Vector3, const float);
      
      Vector3 position;
      vector<boost::shared_ptr<PathNode> > nodes;
      vector<bool> passable;
      vector<ssize_t> num; // To save us time while serializing
      float step;
};

typedef boost::shared_ptr<PathNode> PathNodePtr;

#endif
