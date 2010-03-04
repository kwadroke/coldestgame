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


/* 
 * Author: Stefan Gustavson ITN-LiTH (stegu@itn.liu.se) 2004-12-05
 * Simplex indexing functions by Bill Licea-Kane, ATI (bill@ati.com)
 *
 * You may use, modify and redistribute this code free of charge,
 * provided that the author's names and this notice appear intact.
 */
uniform sampler2D permTexture;
uniform float time;
uniform float speed;

/*
 * Efficient simplex indexing functions by Bill Licea-Kane, ATI. Thanks!
 * (This was originally implemented as a texture lookup. Nice to avoid that.)
 */
void simplex( const in vec3 P, out vec3 offset1, out vec3 offset2 )
{
   vec3 offset0;
   
   vec2 isX = step( P.yz, P.xx );
   offset0.x  = dot( isX, vec2( 1.0 ) );
   offset0.yz = 1.0 - isX;
   
   float isY = step( P.z, P.y );
   offset0.y += isY;
   offset0.z += 1.0 - isY;
   
   offset2 = clamp(   offset0, 0.0, 1.0 );
   offset1 = clamp( --offset0, 0.0, 1.0 );
}


/*
 * 3D simplex noise. Comparable in speed to classic noise, better looking.
 */
float snoise(vec3 P)
{

// The skewing and unskewing factors are much simpler for the 3D case
#define F3 0.333333333333
#define G3 0.166666666667
   float ONE = 1. / 128.;
   float ONEHALF = 1. / 128.;

  // Skew the (x,y,z) space to determine which cell of 6 simplices we're in
   float s = (P.x + P.y + P.z) * F3; // Factor for 3D skewing
   vec3 Pi = floor(P + s);
   float t = (Pi.x + Pi.y + Pi.z) * G3;
   vec3 P0 = Pi - t; // Unskew the cell origin back to (x,y,z) space
   Pi = Pi * ONE + ONEHALF; // Integer part, scaled and offset for texture lookup

   vec3 Pf0 = P - P0;  // The x,y distances from the cell origin

  // For the 3D case, the simplex shape is a slightly irregular tetrahedron.
  // To find out which of the six possible tetrahedra we're in, we need to
  // determine the magnitude ordering of x, y and z components of Pf0.
   vec3 o1;
   vec3 o2;
   simplex(Pf0, o1, o2);

  // Noise contribution from simplex origin
   float perm0 = texture2D(permTexture, Pi.xy).a;
   vec3  grad0 = texture2D(permTexture, vec2(perm0, Pi.z)).rgb * 4.0 - 1.0;
   float t0 = 0.6 - dot(Pf0, Pf0);
   float n0;
   if (t0 < 0.0) n0 = 0.0;
   else {
      t0 *= t0;
      n0 = t0 * t0 * dot(grad0, Pf0);
   }

  // Noise contribution from second corner
   vec3 Pf1 = Pf0 - o1 + G3;
   float perm1 = texture2D(permTexture, Pi.xy + o1.xy*ONE).a;
   vec3  grad1 = texture2D(permTexture, vec2(perm1, Pi.z + o1.z*ONE)).rgb * 4.0 - 1.0;
   float t1 = 0.6 - dot(Pf1, Pf1);
   float n1;
   if (t1 < 0.0) n1 = 0.0;
   else {
      t1 *= t1;
      n1 = t1 * t1 * dot(grad1, Pf1);
   }
  
  // Noise contribution from third corner
   vec3 Pf2 = Pf0 - o2 + 2.0 * G3;
   float perm2 = texture2D(permTexture, Pi.xy + o2.xy*ONE).a;
   vec3  grad2 = texture2D(permTexture, vec2(perm2, Pi.z + o2.z*ONE)).rgb * 4.0 - 1.0;
   float t2 = 0.6 - dot(Pf2, Pf2);
   float n2;
   if (t2 < 0.0) n2 = 0.0;
   else {
      t2 *= t2;
      n2 = t2 * t2 * dot(grad2, Pf2);
   }
  
  // Noise contribution from last corner
   vec3 Pf3 = Pf0 - vec3(1.0-3.0*G3);
   float perm3 = texture2D(permTexture, Pi.xy + vec2(ONE, ONE)).a;
   vec3  grad3 = texture2D(permTexture, vec2(perm3, Pi.z + ONE)).rgb * 4.0 - 1.0;
   float t3 = 0.6 - dot(Pf3, Pf3);
   float n3;
   if(t3 < 0.0) n3 = 0.0;
   else {
      t3 *= t3;
      n3 = t3 * t3 * dot(grad3, Pf3);
   }

  // Sum up and scale the result to cover the range [-1,1]
   return 32.0 * (n0 + n1 + n2 + n3);
}


void main()
{
   float nval = 0.;
   
   vec3 ncoord;
   ncoord.x = gl_FragCoord.x;
   ncoord.y = gl_FragCoord.y;
   ncoord.z = time / speed;
   nval = snoise(ncoord);
   
   /* Duh, it's scaled from -1 to 1, we need 0 to 1*/
   nval *= .5;
   nval += .5;
   
   gl_FragColor = vec4(nval, nval, nval, 1);
   
}