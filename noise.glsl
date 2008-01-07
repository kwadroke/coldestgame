/* 
 * Author: Stefan Gustavson ITN-LiTH (stegu@itn.liu.se) 2004-12-05
 * Simplex indexing functions by Bill Licea-Kane, ATI (bill@ati.com)
 *
 * You may use, modify and redistribute this code free of charge,
 * provided that the author's names and this notice appear intact.
 *
 * Additional modifications by Ben Nemec in 2007.
 */
uniform sampler2D permTexture;
uniform float time;

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

/* The skewing and unskewing factors are much simpler for the 3D case*/
/* #defines weren't working because my shader loader was stripping off
   all of the \n's, so the compiler kept reading everything as a single line
#define F3 0.333333333333
#define G3 0.166666666667
#define ONE 0.00390625
#define ONEHALF 0.001953125*/
   
   /* Exceeding register limits, lets group some stuff up
      This is no longer actually necessary as we're no longer register limited,
      but it would be more work than it's worth to go through and change it again.*/
   const vec4 consts = vec4(0.333333333333, 0.166666666667, 0.00390625, 0.001953125);

   /* Skew the (x,y,z) space to determine which cell of 6 simplices we're in*/
   float s = (P.x + P.y + P.z) * consts.x;
   vec3 Pi = floor(P + s);
   float ts = (Pi.x + Pi.y + Pi.z) * consts.y;
   vec3 P0 = Pi - ts;
   Pi = Pi * consts.z + consts.w;
   
   vec3 Pf0 = P - P0; 
   
   /* For the 3D case, the simplex shape is a slightly irregular tetrahedron.
      To find out which of the six possible tetrahedra we're in, we need to
      determine the magnitude ordering of x, y and z components of Pf0.*/
   vec3 o1;
   vec3 o2;
   simplex(Pf0, o1, o2);
   
   vec4 t, n, perm;
   /* Noise contribution from simplex origin*/
   perm.x = texture2D(permTexture, Pi.xy).a;
   vec3  grad0 = texture2D(permTexture, vec2(perm.x, Pi.z)).rgb * 4.0 - 1.0;
   t.x = 0.6 - dot(Pf0, Pf0);
   if (t.x < 0.0) n.x = 0.0;
   else {
      t.x *= t.x;
      n.x = t.x * t.x * dot(grad0, Pf0);
   }
   
   /* Noise contribution from second corner*/
   vec3 Pf1 = Pf0 - o1 + consts.y;
   perm.y = texture2D(permTexture, Pi.xy + o1.xy * consts.z).a;
   vec3  grad1 = texture2D(permTexture, vec2(perm.y, Pi.z + o1.z * consts.z)).rgb * 4.0 - 1.0;
   t.y = 0.6 - dot(Pf1, Pf1);
   if (t.y < 0.0) n.y = 0.0;
   else {
      t.y *= t.y;
      n.y = t.y * t.y * dot(grad1, Pf1);
   }
   
   /* Noise contribution from third corner*/
   vec3 Pf2 = Pf0 - o2 + 2.0 * consts.y;
   perm.z = texture2D(permTexture, Pi.xy + o2.xy * consts.z).a;
   vec3  grad2 = texture2D(permTexture, vec2(perm.z, Pi.z + o2.z * consts.z)).rgb * 4.0 - 1.0;
   t.z = 0.6 - dot(Pf2, Pf2);
   if (t.z < 0.0) n.z = 0.0;
   else {
      t.z *= t.z;
      n.z = t.z * t.z * dot(grad2, Pf2);
   }
   
   /* Noise contribution from last corner*/
   vec3 Pf3 = Pf0 - vec3(1.0 - 3.0 * consts.y);
   perm.w = texture2D(permTexture, Pi.xy + vec2(consts.z, consts.z)).a;
   vec3  grad3 = texture2D(permTexture, vec2(perm.w, Pi.z + consts.z)).rgb * 4.0 - 1.0;
   t.w = 0.6 - dot(Pf3, Pf3);
   if(t.w < 0.0) n.w = 0.0;
   else {
      t.w *= t.w;
      n.w = t.w * t.w * dot(grad3, Pf3);
   }
   
   /* Sum up and scale the result to cover the range [-1,1]*/
   return 32.0 * (n.x + n.y + n.z + n.w);
}


void main()
{
   float nval = 0;
   
   nval = snoise(vec3(gl_FragCoord.xy, time));
   
   /* Duh, it's scaled from -1 to 1, we need 0 to 1*/
   nval *= .5;
   nval += .5;
   
   gl_FragColor = vec4(nval, nval, nval, 1);
   
}