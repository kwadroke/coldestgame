uniform sampler2D tex;

varying float dist;

void main()
{
   // Texturing
   vec4 color = texture2D(tex, gl_TexCoord[0].st);
   
   // Write VSM values
   float c = 5.;
   float d = dist * 2. - 1;
   float adjdist = exp(exp(c * d));
   vec2 m = vec2(adjdist, adjdist * adjdist);
   // Note: this should be -exp(exp(-c * d)), but that messes up our floating point precision, so we add the - in the receiving shader
   adjdist = exp(exp(-c * d));
   vec2 mneg = vec2(adjdist, adjdist * adjdist);
   mneg.y *= step(.5, color.a); // Simulate alpha test
   gl_FragColor = vec4(m, mneg);
}