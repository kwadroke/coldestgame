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
// Copyright 2008, 2011 Ben Nemec
// @End License@


#version 110

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec3 worldcoords;
varying vec3 view, lightdir;

attribute vec3 tangent;

void main()
{
   gl_TexCoord[0].st = gl_MultiTexCoord0.st;
   gl_FrontColor = gl_Color;
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
   using the texture matrix. */
   shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   /* For fogging */
   dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   
   /* Used in reflection */
   worldcoords.xyz = gl_Vertex.xyz;
   
   vec3 t, b, n;
   n = normalize(gl_Normal);
   t = normalize(tangent);
   b = normalize(cross(t, n));
   
   vec3 location = gl_ModelViewMatrixInverse[3].xyz;
   lightdir = normalize(gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz;
   
   vec3 tmp = lightdir;
   lightdir.x = dot(tmp, t);
   lightdir.y = dot(tmp, b);
   lightdir.z = dot(tmp, n);
   
   view = normalize(location - worldcoords);
   tmp = view;
   view.x = dot(tmp, t);
   view.y = dot(tmp, b);
   view.z = dot(tmp, n);
   
   gl_Position = ftransform();
}

