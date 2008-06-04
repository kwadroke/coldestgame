uniform sampler2D tex;

varying float dist;

void main()
{
   // Texturing
   vec4 color = texture2D(tex, gl_TexCoord[0].st);
   
   // Write VSM values
   float c = 6.;
   float d = dist * 2. - 1;
   float adjdist = exp(exp(c * d));
   vec2 m = vec2(adjdist, adjdist * adjdist);
   float distfactor = 32.;
   vec2 mdist = fract(m * distfactor);
   mdist.y = step(.5, color.a); // Simulate alpha test
   m -= mdist / distfactor;
   gl_FragColor = vec4(m, mdist);
}