uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;
uniform float shadowres;
uniform int samplesize;
uniform float detailmapsize;

varying vec4 shadowmappos, worldshadowmappos;

void shadow(vec4 amb, vec4 diff, float d, inout vec4 col)
{
   float alpha = col.a;
   vec4 color1 = col;
   
   float total = 0.;
   for (int x = -samplesize / 2; x < samplesize / 2 + 1; ++x)
   {
      for (int y = -samplesize / 2; y < samplesize / 2 + 1; ++y)
      {
         total += shadow2DProj(shadowtex, shadowmappos + vec4(float(x) / shadowres, float(y) / shadowres, 0., 0.)).r;
      }
   }
   //col.rgb -= diff.rgb * (1 - shadow2DProj(shadowtex, shadowmappos).r);
   col.rgb -= diff.rgb * (1. - smoothstep(0., .95 - float((samplesize - 3) / 2) * .1, total / float(samplesize * samplesize)));
   col.a = alpha;
   
   color1.rgb -= diff.rgb * (1. - shadow2DProj(worldshadowtex, worldshadowmappos).r);
   color1.a = alpha;
   
   col = mix(col, color1, smoothstep(0.8, 1.0, d / detailmapsize));
}
