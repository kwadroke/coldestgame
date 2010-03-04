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


void fog(float dist, inout vec4 color)
{
   float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
   color.rgb = mix(color.rgb, gl_Fog.color.rgb, clamp(fogval, 0.0, 1.0));
   float alphaval = (dist - (gl_Fog.end - 500.)) * .002;
   color.a *= 1. - clamp(alphaval, 0., 1.);  // Smoothly blend into skybox instead of having a hard edge
}