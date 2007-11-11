uniform sampler2D tex;

varying float dist;

void main()
{
   /* Texturing */
   vec4 color = gl_Color * texture2D(tex, gl_TexCoord[0].st);
   
   /* Fogging */
   if (dist > gl_Fog.start)
   {
      float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
      color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   }
   
   gl_FragColor = color;
}