void basiclighting(out vec4 amb, out vec4 diff)
{
   vec3 normal, lightdir;
   float ndotl;
   
   // Diffuse calculations
   normal = normalize(gl_NormalMatrix * gl_Normal);
   lightdir = normalize(vec3(gl_LightSource[0].position));
   ndotl = max(dot(normal, lightdir), 0.0);
   //diff = gl_FrontMaterial.diffuse * gl_LightSource[0].diffuse;
   diff = vec4(1, 1, 1, 1) * gl_LightSource[0].diffuse;
   
   // Ambient calculations
   //amb = gl_FrontMaterial.ambient * gl_LightSource[0].ambient;
   //amb += gl_FrontMaterial.ambient * gl_LightModel.ambient;
   amb = gl_LightSource[0].ambient;
   //amb += gl_LightModel.ambient;
   
   // Combine our lighting calculations to get a color
   gl_FrontColor = ndotl * diff + amb;
   gl_FrontColor *= gl_Color;
}
