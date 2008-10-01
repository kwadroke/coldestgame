uniform sampler2D basenoise;
uniform float noiseres;

void main()
{
   float nval = 0.;
   float frequency = 32.;
   float persistence = .5;
   float amplitude = 1.;
   float wval;
   int octaves = 0;
   
   for (int i = 0; i < 10; ++i)
   {
      // Need the noise value back in [-1, 1] rather than [0, 1] 
      wval = texture2D(basenoise, gl_FragCoord.xy / frequency / noiseres).r;
      wval *= 2.;
      wval -= 1.;
      nval += wval * amplitude;
      frequency *= .45; // divided by ~2, but not exactly 2 to avoid potential artifacting
      amplitude *= persistence;
      ++octaves;
   }
   
   nval /= float(octaves);
   
   nval *= .5;
   nval += .5;
   
   float cloudcover = .450; /* Lower values mean more clouds [0, 1] */
   float cloudsharpness = .1; /* Higher values mean brighter clouds [0, 1] */
   
   nval = clamp((nval - cloudcover), 0.0, 1.0);
   
   gl_FragColor.rgb = vec3(1, 1, 1) * (pow(cloudsharpness, nval));
   gl_FragColor.a = nval * float(octaves);
}