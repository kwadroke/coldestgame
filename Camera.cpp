#include "Camera.h"

Camera::Camera() : interp(0.f)
{
}


void Camera::SetPosition(const Vector3& newpos)
{
   position = newpos;
}


void Camera::Place()
{
   //viewoff = units[localplayer.unit].viewoffset + Vector3(0, 0, console.GetFloat("viewoffset"));
   //gluLookAt(viewoff.x, viewoff.y, viewoff.z + .01f, viewoff.x, viewoff.y, viewoff.z, 0, 1, 0);
}


void Camera::Update()
{
   float interpval = float(timer.elapsed()) / 1000.f * interp;
   timer.start();
   actual = lerp(position, actual, interpval);
}



