#ifndef __Primitive__
#define __Primitive__

#include "Vector3.h"
#include "Vertex.h"
#include "GraphicMatrix.h"
#include <vector>
#include <map>
#include <qstring.h>

using namespace std;

// This maybe doesn't belong here, but it's not outrageously out of place
// and it saves me from creating a header file for a single definition
enum Columns{primcol, namecol, idcol};

// This is now a rather poorly named class, but for the moment I'm not too
// concerned about that
class Primitive
{
   public:
      Primitive();
      Primitive* GetPrimitive(const string&);
      VertexPtr GetVertex(const string&);
      void InsertPrimitive(Primitive&, const string& id);
      void Transform(const GraphicMatrix&);
      void Restore();
      
      QString id;
      QString material;
      QString type;
      QString parentid;
      QString name;
      //vector<Vector3> point;
      Vector3 rot1;
      Vector3 trans;
      Vector3 rot2;
      //vector<vector<vector<float> > > texcoords;
      //bool transparent;
      //bool translucent;
      bool collide;
      bool facing;
      map<string, VertexPtr> vertices;
      map<string, VertexPtr> saveverts;
      map<string, Primitive> prims;
};

#endif

