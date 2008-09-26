uniform sampler2D tex;

varying vec3 normal;
varying vec3 light;

void main()
{
   float val = dot(normal, light);
   /*if (val < .45 && val > -.45) discard;*/
   /* Texturing */
   gl_FragColor = texture2D(tex, gl_TexCoord[0].st);
}