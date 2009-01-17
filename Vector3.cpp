#include "Vector3.h"

using namespace std;

Vector3::Vector3() : x(0), y(0), z(0)
{
}


Vector3::Vector3(const float& xin, const float& yin, const float& zin) : x(xin), y(yin), z(zin)
{
}


#ifndef INLINEME
float Vector3::dot(const Vector3& v) const
{
   return x * v.x + y * v.y + z * v.z;
}

Vector3 Vector3::cross(const Vector3& v) const
{
   return Vector3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x);
}

void Vector3::normalize()
{
   float mag = sqrt(x * x + y * y + z * z);
   if (mag > .000001f)
   {
      x /= mag;
      y /= mag;
      z /= mag;
   }
}

float Vector3::magnitude() const
{
   return sqrt(x * x + y * y + z * z);
}


Vector3 Vector3::operator* (const float& i) const
{
   return Vector3(x * i, y * i, z * i);
}
 
 
void Vector3::operator*= (const float& i)
{
   x *= i;
   y *= i;
   z *= i;
}


Vector3 operator*(const float i, const Vector3& v)
{
   return (v * i);
}


Vector3 Vector3::operator+ (const Vector3& v) const
{
   return Vector3(x + v.x, y + v.y, z + v.z);
}


void Vector3::operator+= (const Vector3& v)
{
   x += v.x;
   y += v.y;
   z += v.z;
}


Vector3 Vector3::operator- (const Vector3& v) const
{
   return Vector3(x - v.x, y - v.y, z - v.z);
}


void Vector3::operator-= (const Vector3& v)
{
   x -= v.x;
   y -= v.y;
   z -= v.z;
}


Vector3 operator-(const Vector3& v)
{
   return -1 * v;
}


Vector3 Vector3::operator/ (const float& i) const
{
   return Vector3(x / i, y / i, z / i);
}


void Vector3::operator/= (const float& i)
{
   x /= i;
   y /= i;
   z /= i;
}


float Vector3::distance(const Vector3& v) const
{
   return sqrt((x - v.x) * (x - v.x) + 
         (y - v.y) * (y - v.y) + 
         (z - v.z) * (z - v.z));
}


// Return the distance ^ 2 because it's faster and may be sufficient
float Vector3::distance2(const Vector3& v) const
{
   return (x - v.x) * (x - v.x) + 
         (y - v.y) * (y - v.y) + 
         (z - v.z) * (z - v.z);
}


float* Vector3::array(float *output)
{
   output[0] = x;
   output[1] = y;
   output[2] = z;
   return output;
}


void Vector3::transform(const GLfloat matrix[16])
{
   float oldx, oldy, oldz;
   oldx = x;
   oldy = y;
   oldz = z;
   x = matrix[0] * oldx + matrix[4] * oldy + matrix[8] * oldz + matrix[12];
   y = matrix[1] * oldx + matrix[5] * oldy + matrix[9] * oldz + matrix[13];
   z = matrix[2] * oldx + matrix[6] * oldy + matrix[10] * oldz + matrix[14];
}


void Vector3::print() const
{
   logout << x << "  " << y << "  " << z << endl;
}


void Vector3::rotate(float pitch, float rotation, float roll)
{
   float pi = 3.14159265;
   float radrotation = rotation * pi / 180.;
   float radpitch = pitch * pi / 180.;
   float radroll = roll * pi / 180.;
   
   float dx, dy, dz;
   float tempx = x;
   float tempy = y;
   float tempz = z;
      
   dx = tempx * cos(radroll) - tempy * sin(radroll);
   dy = tempx * sin(radroll) + tempy * cos(radroll);
   tempx = dx;
   tempy = dy;
   dy = tempy * cos(radpitch) - tempz * sin(radpitch);
   dz = tempy * sin(radpitch) + tempz * cos(radpitch);
   tempy = dy;
   tempz = dz;
   dz = tempz * cos(radrotation) - tempx * sin(radrotation);
   dx = tempz * sin(radrotation) + tempx * cos(radrotation);
   x = dx;
   y = dy;
   z = dz;
}


void Vector3::translate(float xt, float yt, float zt)
{
   x += xt;
   y += yt;
   z += zt;
}


void Vector3::transform4(const GLfloat matrix[16])
{
   float oldx, oldy, oldz, w;
   oldx = x;
   oldy = y;
   oldz = z;
   x = matrix[0] * oldx + matrix[4] * oldy + matrix[8] * oldz;// + matrix[12];
   y = matrix[1] * oldx + matrix[5] * oldy + matrix[9] * oldz;// + matrix[13];
   z = matrix[2] * oldx + matrix[6] * oldy + matrix[10] * oldz;// + matrix[14];
   w = matrix[3] * oldx + matrix[7] * oldy + matrix[11] * oldz;// + matrix[15];
   
   /*x = matrix[0] * oldx + matrix[1] * oldy + matrix[2] * oldz;// + matrix[12];
   y = matrix[4] * oldx + matrix[5] * oldy + matrix[6] * oldz;// + matrix[13];
   z = matrix[8] * oldx + matrix[9] * oldy + matrix[10] * oldz;// + matrix[14];
   w = matrix[12] * oldx + matrix[13] * oldy + matrix[14] * oldz;// + matrix[15];*/
   
   if (w < .0001) return; // Div by zero bad:-)
   x /= w;
   y /= w;
   z /= w;
   
}
#endif



