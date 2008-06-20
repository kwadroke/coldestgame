#ifndef __VERTEX_H
#define __VERTEX_H

#include <vector>
#include <map>
#include "Vector3.h"
#include "glinc.h"
#include "types.h"
#include <boost/shared_ptr.hpp>

using std::map;

// We pass this structure directly to OpenGL, so it needs to be aligned on single bytes
// Edit: Maybe.  It seems to work without doing that, but it may waste memory to align this
// Performance subjectively appears to be the same either way
#pragma pack(push, 1)
struct VBOData
{
   GLfloat x;
   GLfloat y;
   GLfloat z;
   GLfloat nx;
   GLfloat ny;
   GLfloat nz;
   GLfloat tx;
   GLfloat ty;
   GLfloat tz;
   GLfloat tc[8][2]; // [Texture unit][x/y]
   GLubyte r;
   GLubyte g;
   GLubyte b;
   GLubyte a;
   GLfloat terrainwt[3];
   GLfloat terrainwt1[3];
};
#pragma pack(pop)

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Vertex
{
   public:
      Vertex();
      VBOData& GetVboData();
      
      Vector3 pos;
      Vector3 norm;
      Vector3 tangent;
      vector<floatvec> texcoords; // [Texture unit][x/y]
      GLubytevec color;
      floatvec terrainwt;
      unsigned short index;
      string id;
      
   private:
      VBOData vbodata;

};

typedef vector<Vertex> Vertexvec;
typedef boost::shared_ptr<Vertex> VertexPtr;
typedef vector<VertexPtr> VertexPtrvec;
typedef map<string, VertexPtr> VertMap;

#endif
