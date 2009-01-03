uniform sampler2D tex, tex1, tex2, tex3, tex4, tex5;

void texterrain(inout vec4 color, in vec3 texweight, in vec3 texweight1, in float normweight, in float detailweight)
{
   color += texweight.r * texture2D(tex, gl_TexCoord[0].st) * detailweight;
   color += texweight.r * texture2D(tex, gl_TexCoord[0].pq) * normweight;
}