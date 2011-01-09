#ifndef MESH_H
#define MESH_H

#include "MeshData.h"
#include "NTreeReader.h"
#include "Timer.h"
#include "types.h"
#include "ResourceManager.h"
#include "MeshNode.h"
#include "Triangle.h"
#include "Quad.h"
#include "VBO.h"
#include "FBO.h"
#include <SDL/SDL.h>

class Mesh
{
   friend class MeshCache;  // So the cache can reset internal timers
   public:
      Mesh(NTreeReader, ResourceManager&);
      
      void Move(const Vector3&, const bool movetris = false);
      void Rotate(const Vector3&, const bool movetris = false);
      void Scale(const float&);
      void ScaleZ(const float&);

      const Vector3 GetPosition() const {return position;}
      const Vector3 GetRotation() const {return rotation;}
      string GetFile() const {return basefile;}
      float GetAnimSpeed() const{return animspeed;}
      float GetScale() const {return scale;}

      void Render(Material* overridemat = NULL);
      void SetAnimation(const int);
      void Update(const Vector3& campos = Vector3(), bool noanimation = false);
      void RenderImpostor(Mesh&, FBO&, const Vector3&);

      void Add(Triangle&);
      void Add(Quad&);
      void Add(Mesh&);
      void Clear();
      void GenTangents();
      void EnsureMaterials();

      void Begin() {next = 0;}
      bool HasNext() const {return next < NumTris();}
      Triangle& Next() {++next; return meshdata.tris[next - 1];}
      size_t NumTris() const {return meshdata.tris.size();}
      float GetHeight() {return height;}
      float GetWidth() {return width;}
      float GetSize() {return size;}

      void SetState(const Vector3&, const Vector3&, const int, const int, const float);
      void ReadState(Vector3&, Vector3&, int&, int&, float&, float&);
      void SetAnimSpeed(const float);
      void SetGL();

      void debug();

      bool render;
      bool dynamic;
      bool collide;
      bool terrain;
      bool reverseanim;
      string name;
      float dist;
      float impdist;
      Timer ImpTimer;
      size_t impostorfbo;
      unsigned int updatedelay;
      float drawdistmult;
      

   private:
      void Load(const NTreeReader&);
      void CalcBounds();
      void ResetTriMaxDims();

      void AdvanceAnimation();
      void UpdateTris(const Vector3& campos = Vector3(.003, .004, .005));
      void GenVbo();
      void GenVboData();
      void GenIboData();
      void BindAttribs();
      void UnbindAttribs();

      // Primary Mesh data
      MeshData meshdata;
      intvec vbosteps;
      vector<void*> offsets;
      intvec minindex, maxindex;
      vector<Material*> materials;
      VBO vbo;

      // Mesh state
      intvec frametime;
      Vector3 position;
      Vector3 rotation;
      size_t next;
      float size, height, width;
      float scale;
      string basefile;

      // Flags
      bool trismoved;
      bool trischanged;
      bool boundschanged;
      bool updatevbo;

      // Animation data
      Timer animtimer;
      int animtime;
      int currkeyframe;
      float animspeed;
      int curranimation, nextanimation;
      intvec numframes;
      intvec startframe;
};

typedef list<Mesh> Meshlist;
typedef map<int, MeshNodePtr> MeshNodeMap;
typedef shared_ptr<Mesh> MeshPtr;

const string objectfilever = "Version4";

#endif // MESH_H
