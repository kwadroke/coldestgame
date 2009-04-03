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


void basiclighting(in vec3 norm, in vec3 lightdir, out vec4 col, out vec4 amb, out vec4 diff, in float twoside)
{
   // Diffuse calculations
   float ndotl = max(dot(norm, lightdir), -twoside * dot(norm, lightdir));
   diff = ndotl * gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;
   
   // Ambient calculations
   amb = gl_FrontMaterial.ambient * gl_LightSource[0].ambient;
   
   // Combine our lighting calculations to get a color
   col = gl_Color * (diff + amb);
}
