varying float dist;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
   
   dist = distance(gl_Vertex, gl_ModelViewMatrixInverse[3]) / 15000.;// + 2. / 15000.;
   
   gl_Position = ftransform();
}
