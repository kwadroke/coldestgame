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
// Copyright 2008, 2010 Ben Nemec
// @End License@


#version 110

varying vec3 location;
varying vec3 worldcoords;
varying vec3 lightdir;
varying vec4 shadowmappos, worldshadowmappos;

void main()
{
   gl_TexCoord[0] = gl_TextureMatrix[0] * gl_Vertex;
   gl_TexCoord[1] = gl_MultiTexCoord1;
   
   // This way looks like crap
   //halfvector = normalize(gl_LightSource[0].halfVector.xyz);
   
   location = gl_ModelViewMatrixInverse[3].xyz;
   worldcoords = gl_Vertex.xyz;
   lightdir = normalize(gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz;
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
   using the texture matrix. */
   shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   gl_Position = ftransform();
}
