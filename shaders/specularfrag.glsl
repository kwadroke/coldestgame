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

uniform sampler2D spectex;

vec4 specular(vec3 norm, vec3 lightdir, in vec3 viewv, inout vec4 color)
{
   vec4 speccolor = texture2D(spectex, gl_TexCoord[0].st);
   
   vec3 halfvec = normalize(viewv + lightdir);
   
   float ndothv = max(dot(norm, halfvec), 0.);
   vec4 specval = speccolor * pow(ndothv, gl_FrontMaterial.shininess) * 2.;
   color.rgb += specval.rgb;
   return specval;
}
