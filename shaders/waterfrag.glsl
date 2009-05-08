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


void shadow(vec4, vec4, float, inout vec4);

uniform sampler2D tex;
uniform sampler2D noisetex, fastnoisetex;
uniform float time;

varying vec3 location;
varying vec3 worldcoords;
varying vec3 lightdir;

void main()
{
   // Texturing
   vec4 shiftedtc = gl_TexCoord[0];

   vec4 shiftamount;
   vec4 shiftamount1;
   vec2 offsets[4];
   offsets[0] = gl_TexCoord[1].st * vec2(3., 8.);
   offsets[1] = gl_TexCoord[1].st * vec2(25., 65.);
   offsets[2] = gl_TexCoord[1].st * vec2(65., 125.);
   offsets[3] = gl_TexCoord[1].st * vec2(105., 195.);
   for (int i = 0; i < 4; ++i)
      offsets[i] += vec2(0., time / 40000.);
   
   shiftamount.xy = texture2D(noisetex, offsets[0]).rg - .5;
   shiftamount.zw = texture2D(fastnoisetex, offsets[1]).rg - .5;
   shiftamount1.xy = texture2D(fastnoisetex, offsets[2]).rg - .5;
   shiftamount1.zw = texture2D(fastnoisetex, offsets[3]).rg - .5;
   shiftamount.xy *= 8.;
   shiftamount.zw *= 4.;
   shiftamount.xy += shiftamount.zw;
   shiftamount.xy += shiftamount1.xy + shiftamount1.zw;
   
   shiftedtc += vec4(shiftamount.x, shiftamount.y, 0., 0.);
   vec3 normal = vec3(0., 15., 0.);
   normal += vec3(shiftamount.x, 0, shiftamount.y);
   vec4 reflectioncolor = texture2DProj(tex, shiftedtc);
   
   // Specular is still a little flickery, but per-pixel it looks alright
   vec3 view = normalize(location - worldcoords);
   vec3 halfvector = normalize(view + lightdir);
   float ndothv = max(0., dot(normalize(normal), halfvector));
   float specval = pow(ndothv, gl_FrontMaterial.shininess);
   
   vec4 diffuse = gl_FrontMaterial.diffuse;
   float diffmix = .2;
   diffuse = mix(diffuse, reflectioncolor, diffmix);
   vec4 color = diffuse + vec4(specval);
   float dist = distance(location, worldcoords);
   diffuse *= gl_FrontMaterial.ambient; // Not really the right way to do this, but it works
   shadow(diffuse, vec4(specval), dist, color);
   color.a = .8;
      
   // Fogging
   float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
   color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   
   gl_FragColor = color;
}