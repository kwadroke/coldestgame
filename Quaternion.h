#ifndef __QUATERNION
#define __QUATERNION

#include "Vector3.h"
#include "GraphicMatrix.h"

class Quaternion
{
   public:
      Quaternion();
      Quaternion(Vector3, float);
      Quaternion operator*(Quaternion);
      void operator*=(Quaternion);
      Quaternion operator+(Quaternion);
      void operator+=(Quaternion);
      void rotate(Vector3, float);
      GraphicMatrix matrix();
      
      Vector3 v;
      float w;
      
   private:
      float pi;
      
};

#endif
