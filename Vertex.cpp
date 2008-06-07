#include "Vertex.h"

Vertex::Vertex()
{
   floatvec tc(2, 0.f);
   texcoords = vector<floatvec>(8, tc);
   color = GLubytevec(4, 255);
   terrainwt = floatvec(6, 0.f);
}



