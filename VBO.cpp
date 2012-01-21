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
#include "VBO.h"

VBO::VBO() : dummy(true)
{
}


VBO::~VBO()
{
   if (!dummy)
   {
      glDeleteBuffers(1, &vbo);
      glDeleteBuffers(1, &ibo);
   }
}


// Force regen of buffer ids
VBO::VBO(const VBO& v) : vbodata(v.vbodata), indexdata(v.indexdata)
{
   dummy = true;
}


VBO& VBO::operator=(const VBO& v)
{
   if (&v != this)
   {
      dummy = true;
      vbodata = v.vbodata;
      indexdata = v.indexdata;
   }
   return *this;
}


void VBO::CreateBuffers()
{
#ifndef DEDICATED
   glGenBuffersARB(1, &vbo);
   glGenBuffersARB(1, &ibo);
   dummy = false;
#endif
}


void VBO::UploadVBO(const bool dynamic)
{
   if (dummy)
      CreateBuffers();
   
#ifndef DEDICATED
   glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER, ibo);
   glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo);

   if (!dynamic)
   {
      glBufferDataARB(GL_ELEMENT_ARRAY_BUFFER, indexdata.size() * sizeof(unsigned short),
                      NULL, GL_STATIC_DRAW_ARB);
                      glBufferDataARB(GL_ARRAY_BUFFER_ARB,
                      vbodata.size() * sizeof(VBOData),
                      NULL, GL_STATIC_DRAW_ARB);
   }
   else
   {
      // Apparently it's faster to discard the old buffer and create a new one than to update the old one.
      // I haven't noticed, but it seems my bottleneck is elsewhere so once that's fixed maybe it will matter.
      glBufferDataARB(GL_ELEMENT_ARRAY_BUFFER, indexdata.size() * sizeof(unsigned short),
                      NULL, GL_DYNAMIC_DRAW_ARB);
                      glBufferDataARB(GL_ARRAY_BUFFER_ARB,
                      vbodata.size() * sizeof(VBOData),
                      NULL, GL_DYNAMIC_DRAW_ARB);
   }

   glBufferSubDataARB(GL_ELEMENT_ARRAY_BUFFER, 0, indexdata.size() * sizeof(unsigned short), &indexdata[0]);
   glBufferSubDataARB(GL_ARRAY_BUFFER_ARB, 0, vbodata.size() * sizeof(VBOData), &vbodata[0]);

   if (!dynamic)
   {
      vbodata.clear();
      indexdata.clear();
   }
#endif
}


void VBO::Bind()
{
   if (dummy)
   {
      logout << "Can't bind VBO, it was never uploaded." << endl;
      return;
   }
   VBOData offsets;
   
   glBindBufferARB(GL_ELEMENT_ARRAY_BUFFER_ARB, ibo);
   glBindBufferARB(GL_ARRAY_BUFFER_ARB, vbo);
   
   glEnableClientState(GL_VERTEX_ARRAY);
   glEnableClientState(GL_NORMAL_ARRAY);
   glEnableClientState(GL_COLOR_ARRAY);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   
   glNormalPointer(GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(offsets.nx) - (ptrdiff_t)&offsets));
   glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(VBOData), (void*)((ptrdiff_t)&(offsets.r) - (ptrdiff_t)&offsets));
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(offsets.tc[0]) - (ptrdiff_t)&offsets));
   glClientActiveTextureARB(GL_TEXTURE1_ARB);
   glEnableClientState(GL_TEXTURE_COORD_ARRAY);
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(offsets.tc[1]) - (ptrdiff_t)&offsets));
   /*glClientActiveTextureARB(GL_TEXTURE2_ARB);
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
   glTexCoordPointer(2, GL_FLOAT, sizeof(VBOData), (void*)((ptrdiff_t)&(dummy.tc[5]) - (ptrdiff_t)&dummy));*/
   
   glVertexPointer(3, GL_FLOAT, sizeof(VBOData), 0); // Apparently putting this last helps performance somewhat
   
   glClientActiveTextureARB(GL_TEXTURE0_ARB);
}
