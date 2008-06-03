uniform sampler2D shadowtex;
uniform sampler2D worldshadowtex;
uniform vec3 worldlightpos;

varying vec4 shadowmappos, worldshadowmappos;

float chebyshev(vec2 moments, float mean, float minvar)
{
   float lit = step(.00000001, moments.x - mean);//mean < moments.x;  // Fails on  ATI hardware
   
   float variance = moments.y - moments.x * moments.x;
   variance = max(variance, minvar);
   
   float d = mean - moments.x;
   float pmax = variance / (variance + d * d);
   return max(smoothstep(.15, 1., pmax), lit);
}


float vsm(sampler2D tex, vec4 pos, float d)
{
   float eps = .00000001;
   float c = 5.;
   
   float dist = 2. * d - 1.;
   float posd = exp(exp(c * dist));
   
   float distfactor = 32.;
   vec4 m = texture2DProj(tex, pos);
   m.xy += m.zw / distfactor;
   
   float posscale = c * posd;
   float posminvar = exp(exp(c * eps));//eps * posscale * posscale;
   float poscon = chebyshev(m.xy, posd, posminvar);
   
   return poscon;
}

void shadow(vec3 coords, vec4 amb, vec4 diff, float d, inout vec4 col)
{
   float detailmapsize = 200.;
   float alpha = col.a;
   vec4 color1 = col;
   
   vec3 light = (gl_ModelViewMatrixInverse * gl_LightSource[0].position).xyz;
   float distfromlight = distance(coords, light);
   
   //col.rgb -= diff.rgb * (1 - shadow2DProj(shadowtex, shadowmappos).r);
   col.rgb -= diff.rgb * (1. - vsm(shadowtex, shadowmappos, distfromlight / 15000.));
   col.a = alpha;
   
   distfromlight = distance(coords, worldlightpos);
   //color1.rgb -= diff.rgb * (1 - shadow2DProj(worldshadowtex, worldshadowmappos).r);
   color1.rgb -= diff.rgb * (1. - vsm(worldshadowtex, worldshadowmappos, distfromlight / 15000.));
   color1.a = alpha;
   
   col = mix(col, color1, smoothstep(0.8, 1.0, d / detailmapsize));
}
