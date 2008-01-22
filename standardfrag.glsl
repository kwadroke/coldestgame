void shadow(vec4 amb, vec4 diff, float d, inout vec4 color);
void fog(float dist, inout vec4 color);

uniform sampler2D tex;
uniform float reflectval;

varying float dist;
varying vec4 ambient, diffuse;
varying vec3 worldcoords;

void main()
{
   /* Reflection */
   if (worldcoords.y < 0 && reflectval > .5) discard;
   
   /* Texturing */
   vec4 color = gl_Color * texture2D(tex, gl_TexCoord[0].st);
   
   shadow(ambient, diffuse, dist, color);
   
   fog(dist, color);
   
   gl_FragColor = color;
}