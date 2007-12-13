uniform sampler2D tex;
uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;
uniform float reflectval;

varying vec4 shadowmappos, worldshadowmappos;
varying float dist;
varying vec4 ambient, diffuse;
varying vec3 worldcoords;

void main()
{
   /* Texturing */
   vec4 color = gl_Color * texture2D(tex, gl_TexCoord[0].st);
   vec4 color1 = color;
   float alpha = color.a;
   float detailmapsize = 200;
   
   /* Shadows */
   /*if (dist < detailmapsize)*/
   {
      color *= ambient + (shadow2DProj(shadowtex, shadowmappos) * diffuse);
      color.a = alpha;
   }
   /*else color *= ambient + diffuse;*/
   
   color1 *= ambient + (shadow2DProj(worldshadowtex, worldshadowmappos) * diffuse);
   color1.a = alpha;
   
   color = mix(color, color1, smoothstep(0.8, 1.0, dist / detailmapsize));
   
   /* Fogging */
   /*if (dist > gl_Fog.start)*/
   {
      float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
      color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   }
   
   /* Reflection */
   if (worldcoords.y < 0 && reflectval > .5) discard;
   
   gl_FragColor = color;
}