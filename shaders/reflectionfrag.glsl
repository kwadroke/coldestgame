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
uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec4 ambient, diffuse;
varying vec3 texweight, texweight1;
varying vec3 worldcoords;

void main()
{
   if (worldcoords.y < 0) discard;
   if (length(texweight) < .01 && length(texweight1) < .01) texweight.r = 1;
   /* Texturing */
   vec4 base = gl_Color;
   base.a = 1.;
   vec4 color = vec4(0, 0, 0, 0);
   color += texweight.r * texture2D(tex, gl_TexCoord[0].st);
   color += texweight.g * texture2D(tex1, gl_TexCoord[0].st);
   color += texweight.b * texture2D(tex2, gl_TexCoord[0].st);
   color += texweight1.r * texture2D(tex3, gl_TexCoord[0].st);
   /*color += texweight1.g * texture2D(tex4, gl_TexCoord[0].st);
   color += texweight1.b * texture2D(tex5, gl_TexCoord[0].st);*/
   color *= base;/* * .6;*/
   vec4 color1 = color;
   float alpha = color.a;
   float detailmapsize = 200.;
   
   /* Shadows */
   if (dist < detailmapsize)
   {
      color *= ambient + (shadow2DProj(shadowtex, shadowmappos) * diffuse);
      color.a = alpha;
   }
   else color *= ambient + diffuse;
   
   color1 *= ambient + (shadow2DProj(worldshadowtex, worldshadowmappos) * diffuse);
   color1.a = alpha;
   
   color = mix(color, color1, smoothstep(0.8, 1.0, dist / detailmapsize));
   
   /* Fogging */
   if (dist > gl_Fog.start)
   {
      float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
      color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   }
   
   /* Reflection */
   if (worldcoords.y < 0)
   {
      color *= vec4(1, 1, 1, reflectval);
   }
   
   gl_FragColor = color;
}