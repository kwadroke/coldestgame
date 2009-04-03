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
// Copyright 2008, 2009 Ben Nemec
// @End License@


varying float dist;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
   gl_FrontColor = gl_Color;
   
   gl_Position = ftransform();
   
   /* For fogging - this method is not ideal, but the other per-vertex method
      doesn't work in some cases. */
   dist = gl_Position.z;
}
