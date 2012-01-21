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


#version 110

void basiclighting(inout vec3, in vec3, out vec4, out vec4, out vec4, in float);
vec4 specular(vec3, vec3, in vec3, inout vec4);
void shadow(vec4, vec4, float, inout vec4);
void fog(float, inout vec4);

uniform sampler2D tex, bumptex;
uniform float reflectval;

//varying vec4 shadowmappos, worldshadowmappos; // Just a reminder
varying float dist;
varying vec3 worldcoords;
varying vec3 view, lightdir;

void main()
{
   // Reflection
   if (worldcoords.y < 0. && reflectval > .5) discard;
   
   // Texturing
   vec4 color = gl_Color;
   
   vec3 bump = texture2D(bumptex, gl_TexCoord[0].st).xyz * 2. - 1.;
   
   vec4 ambient, diffuse;
   basiclighting(bump, lightdir, color, ambient, diffuse, 0.);
   vec4 texcol = texture2D(tex, gl_TexCoord[0].st);
   color *= texcol;
   diffuse *= texcol;
   vec4 specval = specular(bump, lightdir, view, color);
   shadow(diffuse, specval, dist, color);
   
   fog(dist, color);
   
   gl_FragColor = color;
   //gl_FragColor.rg = gl_TexCoord[0].st;
   //gl_FragColor.rgb = lightdir * 2. - 1.;
}