uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;
uniform vec3 worldlightpos;

varying vec4 shadowmappos, worldshadowmappos;

float chebyshev(vec2 moments, float mean, float minvar)
{
   // Possibly do a standard shadow map compare here
   float lit = mean < moments.x;  // Fails on  ATI hardware
   
   float variance = moments.y - moments.x * moments.x;
   variance = max(variance, minvar);
   
   float d = mean - moments.x;
   float pmax = variance / (variance + d * d);
   return max(smoothstep(.1, 1., pmax), lit);
}


float negchebyshev(vec2 moments, float mean, float minvar)
{
   // Possibly do a standard shadow map compare here
   
   float variance = moments.y - moments.x * moments.x;
   variance = max(variance, minvar);
   
   float d = mean - moments.x;
   float pmax = variance / (variance + d * d);
   return smoothstep(.4, 1., pmax);
}


float vsm(sampler2DShadow tex, vec4 pos, float d)
{
   float eps = .00000001;
   float c = 5.;
   
   float dist = 2. * d - 1.;
   float posd = exp(exp(c * dist));
   float negd = -exp(exp(-c * dist));
   
   vec4 m = shadow2DProj(tex, pos); // Shadow2D is a legacy thing, should probably replace it with texture2D
   m.zw *= -1;
   
   float posscale = c * posd;
   float posminvar = exp(exp(c * eps));//eps * posscale * posscale;
   float poscon = chebyshev(m.xy, posd, posminvar);
   
   float negscale = c * negd;
   float negminvar = eps;//negscale * negscale;
   float negcon = negchebyshev(m.zw, negd, negminvar);
   return poscon;
   //return negcon;
   return min(poscon, negcon);
   
   /*float poseps = exp(c * eps);
   float negeps = -exp(-c * eps);
   
   float dist = 2. * d - 1.;
   float posd = exp(c * dist);
   float negd = -exp(-c * dist);
   
   vec4 m = shadow2DProj(tex, pos); // Shadow2D is a legacy thing, should probably replace it with texture2D
   
   float m2 = m.x * m.x;
   float variance = min(max(m.y - m2, 0.) + poseps, 1.);
   float md = m.x - posd;
   float pmax = variance / (variance + md * md);
   
   m2 = m.z * m.z;
   variance = min(max(m.w - m2, 0.) + eps, 1.);
   md = m.z - negd;
   float pneg = variance / (variance + md * md);
   return pneg;
   return min(pmax, pneg);*/
   
   /*
   eps = exp(c * eps);
   
   float dadj = 2. * d - 1.;
   float negd = dadj;
   dadj = exp(c * dadj);
   negd = -exp(-c * negd);
   
   vec4 m = shadow2DProj(tex, pos);
   
   float lit = 0;//step(.000001, m.x - dadj); // Standard shadow map comparison
   
   float x2 = m.x * m.x;
   float variance = min(max(m.y - x2, 0.) + eps, 1.);
   float md = m.x - dadj;
   float pmax = variance / (variance + md * md);
   
   x2 = m.z * m.z;
   variance = min(max(m.w - x2, 0.) + eps, 1.);
   //pmax = smoothstep(.1, 1.0, pmax);  // Oh yeah, that looks much nicer
   return max(lit, pmax);*/
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
