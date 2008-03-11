#ifndef __MESH_H
#define __MESH_H

#include "Vector3.h"
#include "Triangle.h"
#include "types.h"
#include "SDL.h"
#include "IniReader.h"
#include "ResourceManager.h"
#include "Quad.h"
#include "MeshNode.h"
#include <map>

using std::map;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Mesh
{
   friend class ProceduralTree;
   friend class ObjectKDTree; // Not entirely sure this is still necessary...
   public:
      Mesh(IniReader&, ResourceManager&, bool gl = false);
      ~Mesh();
      Mesh(const Mesh&);
      Mesh& operator=(const Mesh&);
      bool operator<(const Mesh&) const;
      bool operator>(const Mesh&) const;
      void CalcBB();
      void Load(const IniReader&);
      void Move(const Vector3&);
      const Vector3& GetPosition() const;
      void Rotate(const Vector3&);
      void GenVbo();
      void BindAttribs();
      void UnbindAttribs();
      void Render(Material* overridemat = NULL);
      void RenderImpostor();
      void Add(Triangle&);
      void Add(Quad&);
      void Add(Mesh&);
      void InsertIntoContainer(const string&, Mesh&);
      
      void Begin();
      bool HasNext() const;
      const Triangle& Next();
      
      int Size() const; // Not related to size member
      void AdvanceAnimation();
      
      bool render;
      float size; // I'm not sure this should be public, but for the moment we'll go with it
      
      float impdist;
      int impostorfbo;
      GLuint impostortex;
      
   private:
      void UpdateTris(int);
      void BindVbo();
      
      Trianglevec tris;
      Trianglevec trantris;
      intvec vbosteps;
      GLuint vbo;
      vector<VBOData> vbodata;
      vector<MeshNodePtr> frameroot;
      vector<int> frametime;
      vector<map<string, MeshNodePtr> > framecontainer;
      bool hasvbo;
      
      int animtime;
      int currkeyframe;
      Uint32 lastanimtick;
      
      Vector3 position;
      Vector3 rots;
      float height, width;
      
      ResourceManager& resman;
      
      Mesh* impostor;

      int next;
      bool glops; // Whether to do things like GenVbo
};

typedef list<Mesh> Meshlist;
typedef map<int, MeshNodePtr> MeshNodeMap;
typedef shared_ptr<Mesh> MeshPtr;

#endif