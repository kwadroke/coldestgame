void basiclighting(in vec3 norm, in vec3 lightdir, out vec4 col, out vec4 amb, out vec4 diff);
void shadow(vec4 amb, vec4 diff, float d, inout vec4 color);
void fog(float dist, inout vec4 color);

uniform sampler2D tex, tex1, tex2, tex3;
uniform float reflectval;

varying vec3 texweight, texweight1;
varying vec4 worldcoords;
varying vec3 normal;

void main()
{
   /* Reflection */
   if (worldcoords.y < 0 && reflectval > .5) discard;
   
   float dist = worldcoords.w;
   // Texturing
   vec4 base;
   vec4 ambient, diffuse;
   basiclighting(normal, normalize(vec3(gl_LightSource[0].position)), base, ambient, diffuse);
   base.a = 1.;
   
   shadow(ambient, diffuse, dist, base);
   
   vec4 color = vec4(0, 0, 0, 0);
   
   float normweight = smoothstep(-300., 600., dist) * .7;
   float detailweight = 1. - normweight;
   
   color += texweight.r * texture2D(tex, gl_TexCoord[0].st) * detailweight;
   color += texweight.r * texture2D(tex, gl_TexCoord[0].pq) * normweight;
   
   color += texweight.g * texture2D(tex1, gl_TexCoord[0].st) * detailweight;
   color += texweight.g * texture2D(tex1, gl_TexCoord[0].pq) * normweight;
   
   color += texweight.b * texture2D(tex2, gl_TexCoord[0].st) * detailweight;
   color += texweight.b * texture2D(tex2, gl_TexCoord[0].pq) * normweight;
   
   color += texweight1.r * texture2D(tex3, gl_TexCoord[0].st) * detailweight;
   color += texweight1.r * texture2D(tex3, gl_TexCoord[0].pq) * normweight;
   
   color *= base;
   
   fog(dist, color);
   
   gl_FragColor = color;
}