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


uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 diff, vec4 spec, float d, inout vec4 col)
{
   float alpha = col.a;
   
   float shadowval = 1. - shadow2DProj(worldshadowtex, worldshadowmappos).r;
   col.rgb -= diff.rgb * shadowval;
   col.rgb -= spec.rgb * shadowval;
   col.a = alpha;
}