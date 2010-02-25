#ifndef CAMERA_H
#define CAMERA_H

#include "Vector3.h"
#include "glinc.h"
#include "util.h"

/**
	@author Ben Nemec <coldest@nemebean.com>
*/
class Camera
{
	public:
		Camera();
      void Place();
      void Update();
      
      Vector3 position, lookat;
      float interp;
      
   private:
      Vector3 actual;
      Timer timer;

};

#endif
