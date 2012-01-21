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
#ifndef PATHNODE_H
#define PATHNODE_H

#include "Vector3.h"
#include "types.h"
#include <boost/shared_ptr.hpp>
#include <set>

using std::set;

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
      
   private:
      bool Validate(Vector3, Vector3, const float, set<PathNode*>&);
};

typedef boost::shared_ptr<PathNode> PathNodePtr;

#endif
