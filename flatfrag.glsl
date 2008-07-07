void fog(float dist, inout vec4 color);

uniform sampler2D tex;
uniform float reflectval;

varying float dist;
varying vec3 worldcoords;

void main()
{
   /* Reflection */
   //if (worldcoords.y < 0. && reflectval > .5) discard;
   
   /* Texturing */
   
   vec4 color = texture2D(tex, gl_TexCoord[0].st) * gl_Color;
   
   fog(dist, color);
   
   gl_FragColor = color;
}