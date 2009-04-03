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


uniform sampler2D tex, tex1, tex2, tex3, tex4, tex5;

void texterrain(inout vec4 color, in vec3 texweight, in vec3 texweight1, in float normweight, in float detailweight)
{
   color += texweight.r * texture2D(tex, gl_TexCoord[0].st) * detailweight;
   color += texweight.r * texture2D(tex, gl_TexCoord[0].pq) * normweight;
   
   color += texweight.g * texture2D(tex1, gl_TexCoord[0].st) * detailweight;
   color += texweight.g * texture2D(tex1, gl_TexCoord[0].pq) * normweight;
   
   color += texweight.b * texture2D(tex2, gl_TexCoord[0].st) * detailweight;
   color += texweight.b * texture2D(tex2, gl_TexCoord[0].pq) * normweight;
   
   color += texweight1.r * texture2D(tex3, gl_TexCoord[0].st) * detailweight;
   color += texweight1.r * texture2D(tex3, gl_TexCoord[0].pq) * normweight;
}