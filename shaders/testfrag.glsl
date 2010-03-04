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


uniform sampler2D tex;

varying float dist;

void main()
{
   /* Texturing */
   vec4 color = gl_Color * texture2D(tex, gl_TexCoord[0].st);
   
   /* Fogging */
   if (dist > gl_Fog.start)
   {
      float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
      color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   }
   
   gl_FragColor = color;
}