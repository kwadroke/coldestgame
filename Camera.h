#ifndef CAMERA_H
#define CAMERA_H

#include "Vector3.h"
#include "glinc.h"
#include "util.h"
#include "Timer.h"

/**
	@author Ben Nemec <coldest@nemebean.com>

	This class's behavior differs depending on the value of absolute.
	If absolute is false (default), the class interpolates toward position and lookat.
	If true, lookat is interpreted as a direction vector from the interpolated position, which
	is primarily intended for first person cameras.
*/
class Camera
{
	public:
		Camera();
      void Place();
      void Update();
      void SetPosition(const Vector3&);
      Vector3 GetActual() const;
      Vector3 GetActualLook() const;
      
      Vector3 position, lookat;
      float interp, lookinterp;
      bool absolute;
      
   private:
      Vector3 actual, actuallook;
      Timer timer;

};

#endif
