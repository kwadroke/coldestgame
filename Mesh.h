// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2009 Ben Nemec
// @End License@

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
      void UpdateTris();
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
      float GetWidth(){UpdateTris(); return width;}
      float GetHeight(){UpdateTris(); return height;}
      float GetSize(){UpdateTris(); return size;}
      void SetGL();
      string GetFile() const{return basefile;}
      float GetAnimSpeed() const{return animspeed;}
      float GetScale() const{return scale;}
      
      void Begin() {next = 0; UpdateTris();}
      bool HasNext() const {return next < tris.size();}
      Triangle& Next() {++next; return *tris[next - 1];}
      
      int NumTris() const; // Not related to size member
      void AdvanceAnimation(const Vector3& campos = Vector3());
      
      bool render;
      bool dynamic;
      bool collide;
      bool terrain;
      float drawdistmult;
      string name;
      
      float impdist;
      float dist;
      int impostorfbo;
      GLuint impostortex;
      Uint32 lastimpupdate;
      bool debug;
      
      bool glops;
      int updatedelay;
      
      VectorHeap<Vertex> vertheap;
      
   private:
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
      float size;
      float height, width;
      Vector3 max, min;
      
      ResourceManager& resman;
      
      shared_ptr<Mesh> impostor;
      MaterialPtr impmat;

      int next;
      
      bool havemats;
      bool updatevbo;
      string basefile;
      float scale;
      
      Vector3 campos;
      bool trisdirty;
      Mesh* parent;
      Uint32 lasttick;
};

typedef list<Mesh> Meshlist;
typedef map<int, MeshNodePtr> MeshNodeMap;
typedef shared_ptr<Mesh> MeshPtr;

const string objectfilever = "Version4";

#endif
