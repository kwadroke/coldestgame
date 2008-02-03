#ifndef __LIGHT_H
#define __LIGHT_H

#include <vector>
#include "Vector3.h"
#include "GraphicMatrix.h"
#include "glinc.h"

using namespace std;

typedef vector<GLfloat> glfvec;

class Light
{
   public:
      Light();
      void SetPos(int, Vector3);
      void SetDir(int, Vector3);
      Vector3 GetPos(int);
      Vector3 GetDir(int);
      Vector3 GetRots(int);
      int Add();
      void SetDiffuse(int, GLfloat[]);
      void SetAmbient(int, GLfloat[]);
      void SetSpecular(int, GLfloat[]);
      void Place();
      int NumLights();
      GraphicMatrix GetView(int, Vector3);
      GraphicMatrix GetProj(int, float);
      static long int infinity;
      
   private:
      bool isvalid(int);
      
      vector<Vector3> posdir;
      vector<glfvec> diffuse;
      vector<glfvec> ambient;
      vector<glfvec> specular;
      vector<bool> type;
      vector<GraphicMatrix> view;
      vector<GraphicMatrix> proj;
      
};

#endif
