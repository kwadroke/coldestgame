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
// Copyright 2008, 2011 Ben Nemec
// @End License@
#include "Camera.h"

Camera::Camera() : interp(50.f), lookinterp(50.f), absolute(false)
{
}


void Camera::SetPosition(const Vector3& newpos)
{
   position = newpos;
}


void Camera::Place()
{
   gluLookAt(actual.x, actual.y, actual.z, actuallook.x, actuallook.y, actuallook.z, 0.f, 1.f, 0.f);
}


void Camera::Update()
{
   float currtime = timer.elapsed();
   timer.start();
   float interpval = interp * currtime / 50.f;
   float lookinterpval = lookinterp * currtime / 50.f;
   interpval = clamp(0.f, 1.f, interpval);
   lookinterpval = clamp(0.f, 1.f, lookinterpval);
   
   actual = lerp(position, actual, interpval);
   if (!absolute)
      actuallook = lerp(lookat, actuallook, lookinterpval);
   else
      actuallook = actual + lookat;
}


Vector3 Camera::GetActual() const
{
   return actual;
}

Vector3 Camera::GetActualLook() const
{
   return actuallook;
}


