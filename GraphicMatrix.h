#ifndef __GRAPHIC_MATRIX
#define __GRAPHIC_MATRIX

#include "glinc.h"
#include <math.h>
#include <iostream>
#include "Vector3.h"

using std::cout;
using std::endl;

class GraphicMatrix
{
   private:
      float pi;
      
   public: 
      GLfloat members[16];
      
      GraphicMatrix();
      void translate(float, float, float);
      void translate(Vector3);
      void rotatex(float);
      void rotatey(float);
      void rotatez(float);
      void operator*= (GraphicMatrix);
      void rotateq(Vector3, float);
      GLfloat* array(GLfloat*);
      void print();
      void identity();
      GLfloat* row(int, GLfloat*);
      
      operator float* () const {return (float*) members;}
      operator const float* () const {return (const float*) members;}
      
};
#endif
