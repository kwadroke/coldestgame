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


void fog(float dist, inout vec4 color);

uniform sampler2D tex;
uniform float reflectval;

varying float dist;
varying vec3 worldcoords;

void main()
{
   /* Reflection */
   //if (worldcoords.y < 0. && reflectval > .5) discard;
   
   /* Texturing */
   
   vec4 color = texture2D(tex, gl_TexCoord[0].st) * gl_Color;
   
   fog(dist, color);
   
   gl_FragColor = color;
}