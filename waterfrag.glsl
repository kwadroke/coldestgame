uniform sampler2D tex;
uniform sampler2D noisetex;

varying float dist;
varying vec3 location;
varying vec3 worldcoords;
varying vec3 lightdir;

void main()
{
   // Texturing
   vec4 shiftedtc = gl_TexCoord[0];
//    vec3 v1, v2, v3;
//    v1 = vec3(0, 0, 0);
//    v2 = vec3(3, 0, 0);
//    v3 = vec3(0, 0, 3);
//    v1.y = texture2D(noisetex, gl_TexCoord[1].st * 100.).r - .5;
//    v2.y = texture2D(noisetex, gl_TexCoord[1].st * 101.).r - .5;
//    v3.y = texture2D(noisetex, gl_TexCoord[1].st * 101.).r - .5;
//    vec3 normal = normalize(cross((v3 - v1), (v2 - v1)));
//    vec4 shiftamount;
//    shiftamount.x = normal.x;
//    shiftamount.y = normal.z;
   vec4 shiftamount;
   shiftamount.x = texture2D(noisetex, gl_TexCoord[1].st * 100.).r - .5;
   shiftamount.y = texture2D(noisetex, gl_TexCoord[1].st * 100.).r - .5;
   shiftamount.z = texture2D(noisetex, gl_TexCoord[1].st * 50.).r - .5;
   shiftamount.w = texture2D(noisetex, gl_TexCoord[1].st * 50.).r - .5;
   shiftamount.zw *= 3.;
   shiftamount.x += shiftamount.z;
   shiftamount.y += shiftamount.w;
   shiftamount /= 2.;
   shiftedtc += vec4(shiftamount.x, shiftamount.y, shiftamount.x, shiftamount.x);
   vec3 normal = vec3(0., 2, 0.);
   normal += vec3(shiftamount.x, 0, shiftamount.y);
   vec4 color = texture2DProj(tex, shiftedtc);
   
   // Specular is still a little flickery, but per-pixel it looks alright
   vec3 view = normalize(worldcoords - location);
   vec3 halfvector = normalize(view + lightdir);
   float ndothv = max(0., dot(normalize(normal), halfvector));
   float specval = pow(ndothv, 16.) * .8;
   
   color.a = .3;
   color *= vec4(.6, .6, .8, 1.);
   color.a = .6;
   
   color += vec4(specval, specval, specval, specval);
   //color += gl_FrontMaterial.specular * gl_LightSource[0].specular * pow(ndothv, gl_FrontMaterial.shininess);
   
   // Fogging
   if (dist > gl_Fog.start)
   {
      float fogval = (dist - gl_Fog.start) * gl_Fog.scale;
      color = mix(color, gl_Fog.color, clamp(fogval, 0.0, 1.0));
   }
   
   gl_FragColor = color;
}