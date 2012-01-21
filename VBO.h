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
#ifndef VBO_H
#define VBO_H

#include "glinc.h"
#include "types.h"
#include "Vertex.h"
#include <vector>

// This always gets created with a mesh, regardless of whether the mesh was created by the server or not.
// That means we can't always make GL calls, so we only do them when requested (which won't happen on the server).
class VBO
{
   public:
      VBO();
      ~VBO();
      VBO(const VBO&);
      VBO& operator=(const VBO&);
      void CreateBuffers();
      void UploadVBO(const bool);
      void Bind();

      vector<VBOData> vbodata;
      ushortvec indexdata;

   private:
      GLuint vbo, ibo;
      bool dummy;
};

#endif // VBO_H
