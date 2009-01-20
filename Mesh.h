#ifndef __MESH_H
#define __MESH_H

#include <map>
#include "Vector3.h"
#include "Triangle.h"
#include "types.h"
#include "SDL.h"
#include "IniReader.h"
#include "ResourceManager.h"
#include "Quad.h"
#include "MeshNode.h"
#include "FBO.h"
#include "util.h"
#include "VectorHeap.h"
#include "Timer.h" // Debugging

using std::map;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Mesh
{
   friend class MeshCache;
   public:
      Mesh(const string&, ResourceManager&, IniReader read = IniReader(), bool gl = false);
      ~Mesh();
      Mesh(const Mesh&);
      Mesh& operator=(const Mesh&);
      bool operator<(const Mesh&) const;
      bool operator>(const Mesh&) const;
      void CalcBounds();
      void Load(const IniReader&);
      void Move(const Vector3&, bool movetris = false);
      const Vector3 GetPosition() const;
      void Rotate(const Vector3&, bool movetris = false);
      const Vector3 GetRotation() const {return rots;}
      void GenVbo();
      void BindAttribs();
      void UnbindAttribs();
      void Render(Material* overridemat = NULL);
      void RenderImpostor(Mesh&, FBO&, const Vector3&);
      void Add(TrianglePtr&);
      void Add(Quad&);
      void Add(Mesh&);
      void Add(Mesh*);
      void Clear();
      void InsertIntoContainer(const string&, Mesh&);
      void LoadMaterials();
      void Scale(const float&);
      void ScaleZ(const float&);
      void SetAnimSpeed(const float);
      void ResetAnimation();
      void SetAnimation(const int);
      void SetState(const Vector3&, const Vector3&, const int, const int, const float);
      void ReadState(Vector3&, Vector3&, int&, int&, float&, float&);
      float GetWidth(){return width;}
      float GetHeight(){return height;}
      void SetGL();
      string GetFile() const{return basefile;}
      float GetAnimSpeed() const{return animspeed;}
      float GetScale() const{return scale;}
      
      void Begin();
      bool HasNext() const;
      Triangle& Next();
      
      int Size() const; // Not related to size member
      void AdvanceAnimation(const Vector3& campos = Vector3());
      
      bool render;
      bool dynamic;
      bool collide;
      bool terrain;
      float size; // I'm not sure this should be public, but for the moment we'll go with it
      float drawdistmult;
      string name;
      
      float impdist;
      float dist;
      int impostorfbo;
      GLuint impostortex;
      Uint32 lastimpupdate;
      bool debug;
      
      bool glops; // Whether to do things like GenVbo
      
      VectorHeap<Vertex> vertheap;
      
   private:
      void UpdateTris(int, const Vector3&);
      void BindVbo();
      void ResetTriMaxDims();
      
      TrianglePtrvec tris;
      TrianglePtrvec trantris;
      VertexVHPvec vertices;
      intvec vbosteps;
      GLuint vbo;
      GLuint ibo;
      vector<VBOData> vbodata;
      ushortvec indexdata;
      vector<MeshNodePtr> frameroot;
      intvec frametime;
      vector<map<string, MeshNodePtr> > framecontainer;
      bool hasvbo;
      int vbosize, ibosize;
      vector<Mesh*> childmeshes;
      
      int animtime;
      int currkeyframe;
      Uint32 lastanimtick;
      float animspeed;
      int curranimation, nextanimation;
      intvec numframes;
      intvec startframe;
      bool newchildren;
      bool boundschanged;
      
      Vector3 position;
      Vector3 rots;
      float height, width;
      Vector3 max, min;
      
      ResourceManager& resman;
      
      shared_ptr<Mesh> impostor;
      MaterialPtr impmat;

      int next;
      
      bool havemats;
      string basefile;
      float scale;
};

typedef list<Mesh> Meshlist;
typedef map<int, MeshNodePtr> MeshNodeMap;
typedef shared_ptr<Mesh> MeshPtr;

const string objectfilever = "Version4";

#endif
