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
uniform float shadowres;
uniform float detailmapsize;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 diff, vec4 spec, float d, inout vec4 col)
{
   float alpha = col.a;
   vec4 color1 = col;
   // Supposedly randomized sample locations give better results, maybe it's just my
   // sample choices, but it doesn't seem to work that way for me.
   /*float[9] jitterx = float[9](-1. / shadowres, -.6 / shadowres, 1.9 / shadowres,
                    -2.1 / shadowres, .25 / shadowres, 1.7 / shadowres,
                    -1.3 / shadowres, .4 / shadowres, 1.1 / shadowres);
   float[9] jittery = float[9](-1.1 / shadowres, -1.6 / shadowres, -2.1 / shadowres,
                                -.65 / shadowres, .35 / shadowres, .4 / shadowres,
                                1.9 / shadowres, .9 / shadowres, 1.4 / shadowres);
   
   float total = 0.;
   for (int i = 0; i < 9; ++i)
   {
      //total += shadow2DProj(shadowtex, shadowmappos + vec4(jitterx[i] / 1.5, jittery[i] / 1.5, 0., 0.)).r;
   }*/
   
   float total = 0.;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(-1. / shadowres, -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(0., -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(1. / shadowres, -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(-1. / shadowres, 0., 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(1. / shadowres, 0., 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(-1. / shadowres, 1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(0., 1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(shadowtex, shadowmappos + vec4(1. / shadowres, 1. / shadowres, 0., 0.)).r;
   
   float shadowval = 1. - smoothstep(0., .95, total / 9.);
   // If we don't keep a little diffuse lighting our bumpmapped objects look completely flat in shadow
   col.rgb -= diff.rgb * min(shadowval, .9);
   col.rgb -= spec.rgb * shadowval;
   col.a = alpha;
   
   total = 0.;
   total += shadow2DProj(worldshadowtex, worldshadowmappos + vec4(-1. / shadowres, -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(worldshadowtex, worldshadowmappos + vec4(0., -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(worldshadowtex, worldshadowmappos + vec4(1. / shadowres, -1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(worldshadowtex, worldshadowmappos + vec4(-1. / shadowres, 0., 0., 0.)).r;
   total += shadow2DProj(worldshadowtex, worldshadowmappos).r;
   total += shadow2DProj(worldshadowtex, worldshadowmappos + vec4(1. / shadowres, 0., 0., 0.)).r;
   total += shadow2DProj(worldshadowtex, worldshadowmappos + vec4(-1. / shadowres, 1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(worldshadowtex, worldshadowmappos + vec4(0., 1. / shadowres, 0., 0.)).r;
   total += shadow2DProj(worldshadowtex, worldshadowmappos + vec4(1. / shadowres, 1. / shadowres, 0., 0.)).r;
   
   shadowval = 1. - smoothstep(0., .95, total / 9.);
   color1.rgb -= diff.rgb * min(shadowval, .9);
   color1.rgb -= spec.rgb * shadowval;
   color1.a = alpha;
   
   col = mix(col, color1, smoothstep(0.8, 1.0, d / detailmapsize));
}
