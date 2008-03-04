#version 110

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec3 worldcoords;
varying vec3 view, lightdir;

attribute vec3 tangent;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   gl_FrontColor = vec4(1, 1, 1, 1);
   
   /* Shadow calculations, the grunt work is done on the CPU and passed in
   using the texture matrix. */
   shadowmappos = gl_TextureMatrix[6] * gl_Vertex;
   worldshadowmappos = gl_TextureMatrix[7] * gl_Vertex;
   
   /* For fogging */
   dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]);
   
   /* Used in reflection */
   worldcoords.xyz = gl_Vertex.xyz;
   
   vec3 t, b, n;
   n = normalize(gl_Normal);
   t = normalize(tangent);
   b = normalize(cross(t, n));
   
   vec3 location = gl_ModelViewMatrixInverse[3].xyz;
   worldcoords = gl_Vertex.xyz;
   lightdir = normalize(gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz;
   //lightdir = vec3(-1, 1, -1);
   //lightdir = normalize(lightdir);
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

