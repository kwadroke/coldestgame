uniform sampler2D tex;

varying float dist;

void main()
{
   // Texturing
   vec4 color = texture2D(tex, gl_TexCoord[0].st);
   
   // Write VSM values
   vec2 m = vec2(dist, dist * dist); // Not sure which we want to use yet
   //m = vec2(gl_FragCoord.z, gl_FragCoord.z * gl_FragCoord.z);
   
   gl_FragColor = vec4(m, 0, color.a);
}