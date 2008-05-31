void basiclighting(in vec3 norm, in vec3 lightdir, out vec4 col, out vec4 amb, out vec4 diff, in float twoside)
{
   // Diffuse calculations
   float ndotl = max(dot(norm, lightdir), -twoside * dot(norm, lightdir));
   diff = ndotl * gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;
   
   // Ambient calculations
   amb = gl_FrontMaterial.ambient * gl_LightSource[0].ambient;
   
   // Combine our lighting calculations to get a color
   col = gl_Color * (diff + amb);
}
