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
   vec4 shiftamount;
   //vec2 shiftamount1;
   shiftamount.x = texture2D(noisetex, gl_TexCoord[1].st * 30.).r - .5;
   shiftamount.y = texture2D(noisetex, gl_TexCoord[1].st * 25.).r - .5;
   shiftamount.z = texture2D(noisetex, gl_TexCoord[1].st * 5.).r - .5;
   shiftamount.w = texture2D(noisetex, gl_TexCoord[1].st * 4.).r - .5;
   //shiftamount1.x = texture2D(noisetex, gl_TexCoord[1].st * 150.).r - .5;
   //shiftamount1.y = texture2D(noisetex, gl_TexCoord[1].st * 140.).r - .5;
   //shiftamount *= .9;
   shiftamount.zw *= 3.;
   shiftamount.x += shiftamount.z;
   shiftamount.y += shiftamount.w;
   shiftedtc += vec4(shiftamount.x, shiftamount.y, shiftamount.x, shiftamount.x);
   vec3 normal = vec3(0., 1.5, 0.);
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