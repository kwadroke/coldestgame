void fog(float dist, inout vec4 color)
{
   float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
   //color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   color.a *= 1. - clamp(fogval, 0., 1.);  // I like this way better
}