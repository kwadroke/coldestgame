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

#version 110

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec3 normal;
varying vec3 worldcoords;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
   normal = normalize(gl_NormalMatrix * gl_Normal);
   gl_FrontColor = vec4(1, 1, 1, 1);
   //gl_BackColor = gl_FrontColor;
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
      using the texture matrix. */
   shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   /* For fogging */
   dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   
   /* Used in reflection */
   worldcoords.xyz = gl_Vertex.xyz;
   
   gl_Position = ftransform();
   
   /* For fogging - method above is better, probably a little slower though*/
   /*dist = gl_Position.z;*/
}
