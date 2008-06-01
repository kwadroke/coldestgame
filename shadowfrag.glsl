uniform sampler2DShadow shadowtex;
uniform sampler2DShadow worldshadowtex;
uniform vec3 worldlightpos;

varying vec4 shadowmappos, worldshadowmappos;

float vsm(sampler2DShadow tex, vec4 pos, float d)
{
   float eps = .0000001; // .000001 seems to work best for this value
   
   vec2 m = shadow2DProj(tex, pos).rg;
   
   float lit = (d <= m.x); // Standard shadow map comparison
   
   float x2 = m.x * m.x;
   float variance = min(max(m.y - x2, 0.) + eps, 1.);
   float md = m.x - d;
   float pmax = variance / (variance + md * md);
   return max(lit, pmax);
}

void shadow(vec3 coords, vec4 amb, vec4 diff, float d, inout vec4 col)
{
   float detailmapsize = 200.;
   float alpha = col.a;
   vec4 color1 = col;
   
   vec3 light = gl_ModelViewMatrixInverse * gl_LightSource[0].position;
   float distfromlight = distance(coords, light);
   
   //col.rgb -= diff.rgb * (1 - shadow2DProj(shadowtex, shadowmappos).r);
   col.rgb -= diff.rgb * (1 - vsm(shadowtex, shadowmappos, distfromlight / 15000.));
   col.a = alpha;
   
   distfromlight = distance(coords, worldlightpos);
   //color1.rgb -= diff.rgb * (1 - shadow2DProj(worldshadowtex, worldshadowmappos).r);
   color1.rgb -= diff.rgb * (1 - vsm(worldshadowtex, worldshadowmappos, distfromlight / 15000.));
   color1.a = alpha;
   
   col = mix(col, color1, smoothstep(0.8, 1.0, d / detailmapsize));
}
