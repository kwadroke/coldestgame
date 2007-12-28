void fog(float dist, inout vec4 color)
{
//   if (dist > gl_Fog.start)
   {
      float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
      color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   }
}