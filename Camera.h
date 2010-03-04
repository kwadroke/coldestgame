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
// Copyright 2008, 2010 Ben Nemec
// @End License@
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
