#version 110

void basiclighting(out vec4 amb, out vec4 diff);

//void gettbn(out vec3 t, out vec3 b, out vec3 n);

//varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec4 ambient;//, diffuse;
varying vec3 worldcoords;
varying vec3 view, lightdir;

attribute vec3 tangent;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
   vec4 diffuse;
   
   //basiclighting(ambient, diffuse);
   ambient = vec4(.4, .4, .4, 1);
   //gl_FrontColor = gl_Color * vec4(.4, .4, .4, 1);//gl_LightSource[0].ambient;
   //gl_FrontColor = vec4(.4, .4, .4, 1);
   //gl_BackColor = gl_FrontColor;
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
   using the texture matrix. */
   //shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   //worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   /* For fogging */
   dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   
   /* Used in reflection */
   worldcoords.xyz = gl_Vertex.xyz;
   
   vec3 t, b, n;
   n = normalize(gl_Normal);
   t = normalize(tangent);
   b = normalize(cross(n, t));
   
   vec3 location = gl_ModelViewMatrixInverse[3].xyz;
   worldcoords = gl_Vertex.xyz;
   //lightdir = normalize(gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz;
   lightdir = vec3(-1, 0, -1);
   lightdir = normalize(lightdir);
   //lightdir = normalize(gl_LightSource[0].position.xyz);
   //lightdir.x *= -1.; // Not entirely clear on why this is necessary, but it is
   //lightdir.z *= -1.;
   
   vec3 tmp = lightdir;
   lightdir.x = dot(tmp, t);
   lightdir.y = dot(tmp, b);
   lightdir.z = dot(tmp, n);
   
   view = normalize(worldcoords - location);
   tmp = view;
   view.x = dot(tmp, t);
   view.y = dot(tmp, b);
   view.z = dot(tmp, n);
   
   gl_Position = ftransform();
}


/*void gettbn(out vec3 t, out vec3 b, out vec3 n)
{
   vec3 tangent;
   vec3 binormal;
   vec3 normal = normalize(gl_NormalMatrix * gl_Normal);
   
   vec3 c1 = cross(normal, vec3(0.0, 0.0, 1.0)); 
   vec3 c2 = cross(normal, vec3(0.0, 1.0, 0.0)); 
   
   if (length(c1) > length(c2))
   {
      tangent = c1;
   }
   else
   {
      tangent = c2;
   }
   
   tangent = normalize(tangent);
   
   binormal = cross(normal, tangent); 
   binormal = normalize(binormal);
   
   t = tangent;
   b = binormal;
   n = normal;
}*/
