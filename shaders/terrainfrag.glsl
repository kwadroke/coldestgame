void basiclighting(in vec3, in vec3, out vec4, out vec4, out vec4, in float);
void shadow(vec4, vec4, float, inout vec4);
void fog(float dist, inout vec4 color);
void texterrain(inout vec4, in vec3, in vec3, in float, in float);

uniform float reflectval;

varying vec3 texweight, texweight1;
varying vec4 worldcoords;
varying vec3 normal;

void main()
{
   /* Reflection */
   if (worldcoords.y < 0. && reflectval > .5) discard;
   
   float dist = worldcoords.w;
   // Texturing
   vec4 base;
   vec4 ambient, diffuse;
   basiclighting(normal, normalize(vec3(gl_LightSource[0].position)), base, ambient, diffuse, 0.);
   base.a = 1.;
   
   shadow(diffuse, vec4(0.), dist, base);
   
   vec4 color = vec4(0, 0, 0, 0);
   
   float normweight = smoothstep(-300., 600., dist) * .7;
   float detailweight = 1. - normweight;
   
   texterrain(color, texweight, texweight1, normweight, detailweight);
   
   color *= base;
   
   fog(dist, color);
   
   gl_FragColor = color;
}
