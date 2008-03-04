#ifndef __QUAD_H
#define __QUAD_H

#include "Triangle.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Quad
{
   public:
      Quad();
      void SetVertex(const int, const Vector3&);
      Vector3 GetVertex(const int) const;
      void SetNormal(const int, const Vector3&);
      void SetCollide(bool);
      void SetMaterial(Material*);
      void SetColor(const int, const GLubytevec);
      void SetTexCoords(const int, const int, const floatvec);
      void SetTerrainWeight(const int, const int, const float);
      Triangle First();
      Triangle Second();
      
   private:
      void GetVertNums(const int, int&, int&) const;
      
      Triangle first, second;

};

typedef vector<Quad> Quadvec;

#endif
