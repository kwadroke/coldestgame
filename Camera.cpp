#include "Camera.h"

Camera::Camera() : interp(1.f), lookinterp(1.f), absolute(false)
{
}


void Camera::SetPosition(const Vector3& newpos)
{
   position = newpos;
}


void Camera::Place()
{
   gluLookAt(actual.x, actual.y, actual.z, actuallook.x, actuallook.y, actuallook.z, 0, 1, 0);
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



