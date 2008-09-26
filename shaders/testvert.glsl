varying float dist;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
   gl_FrontColor = gl_Color;
   
   gl_Position = ftransform();
   
   /* For fogging - this method is not ideal, but the other per-vertex method
      doesn't work in some cases. */
   dist = gl_Position.z;
}
