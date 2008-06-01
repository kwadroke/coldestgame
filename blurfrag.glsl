uniform vec2 offsets[25];
uniform float kernel[25];
uniform sampler2D tex;

void main()
{
   vec4 total = vec4(0.);
   for (int i = 0; i < 25; ++i)
   {
      total += texture2D(tex, gl_TexCoord[0].st + offsets[i] / 1024) * kernel[i];
   }
   gl_FragColor = total / 331.;
   //gl_FragColor = texture2D(tex, gl_TexCoord[0].st);
}