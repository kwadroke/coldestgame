#include "Light.h"

long int Light::infinity = 10000;


Light::Light()
{
}


int Light::Add()
{
   vector<GLfloat> temp;
   for (int i = 0; i < 4; ++i)
      temp.push_back(1);
   posdir.push_back(Vector3());
   diffuse.push_back(temp);
   ambient.push_back(temp);
   specular.push_back(temp);
   view.push_back(GraphicMatrix());
   proj.push_back(GraphicMatrix());
   type.push_back(0);
   return 0; // Why does this function return a value?
}


/* Note that SetPos and SetDir are mutually exclusive.  If you use one
   then you shouldn't use the other or the type of your light will
   change.
   */
void Light::SetPos(int num, Vector3 position)
{
   if (!isvalid(num)) return;
   posdir[num] = position;
   type[num] = 1;
}


void Light::SetDir(int num, Vector3 direction)
{
   if (!isvalid(num)) return;
   posdir[num] = direction;
   posdir[num].normalize();
   type[num] = 0;
}


/* This works for either type because returning a point very far away
   on the vector posdir approximates a directional light position,
   which is useful for shadowing.
   */
Vector3 Light::GetPos(int num)
{
   if (!isvalid(num)) return Vector3();
   if (type[num] == 1) return posdir[num];
   return (posdir[num]  * infinity);
}


// Returns 0 vector for positional lights, returns posdir for directional ones
Vector3 Light::GetDir(int num)
{
   if (!isvalid(num)) return Vector3();
   if (type[num] == 1) return Vector3();
   return posdir[num];
}


void Light::SetDiffuse(int num, GLfloat values[4])
{
   if (!isvalid(num)) return;
   for (int i = 0; i < 4; ++i)
      diffuse[num][i] = values[i];
}


void Light::SetAmbient(int num, GLfloat values[4])
{
   if (!isvalid(num)) return;
   for (int i = 0; i < 4; ++i)
      ambient[num][i] = values[i];
}


void Light::SetSpecular(int num, GLfloat values[4])
{
   if (!isvalid(num)) return;
   for (int i = 0; i < 4; ++i)
      specular[num][i] = values[i];
}


// Note: As you can see, only two lights are currently supported.
void Light::Place()
{
   GLfloat v[4];
   // Place the lights
   for (int i = 0; i < NumLights(); ++i)
   {
      v[0] = posdir[i].x;
      v[1] = posdir[i].y;
      v[2] = posdir[i].z;
      v[3] = type[i];
      
      switch(i)
      {
         case 0:
            glLightfv(GL_LIGHT0, GL_POSITION, v);
            glLightfv(GL_LIGHT0, GL_DIFFUSE, &diffuse[i][0]);
            glLightfv(GL_LIGHT0, GL_AMBIENT, &ambient[i][0]);
            glLightfv(GL_LIGHT0, GL_SPECULAR, &specular[i][0]);
            break;
         case 1:
            glLightfv(GL_LIGHT1, GL_POSITION, v);
            glLightfv(GL_LIGHT1, GL_DIFFUSE, &diffuse[i][0]);
            glLightfv(GL_LIGHT1, GL_AMBIENT, &ambient[i][0]);
            glLightfv(GL_LIGHT1, GL_SPECULAR, &specular[i][0]);
            break;
      }
   }
}


GraphicMatrix Light::GetView(int num, Vector3 lookat)
{
   if (!isvalid(num)) return GraphicMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   glPushMatrix();
   {
      glLoadIdentity();
      Vector3 up(0, 1, 0);
      Vector3 p = GetPos(num);
      p += lookat;
      
      // Not allowed to look straight down the up vector
      if (p.x == lookat.x && p.z == lookat.z)
         up = Vector3(0, 0, 1);
      gluLookAt(p.x, p.y, p.z, lookat.x, lookat.y, lookat.z, up.x, up.y, up.z);
      glGetFloatv(GL_MODELVIEW_MATRIX, view[num]);
   }
   glPopMatrix();
   
   return view[num];
}


GraphicMatrix Light::GetProj(int num, float viewsize)
{
   if (!isvalid(num)) return GraphicMatrix();
   
   glMatrixMode(GL_MODELVIEW);
   glPushMatrix();
   {
      glLoadIdentity();
      glOrtho(-viewsize, viewsize, -viewsize, viewsize, infinity - 5000, infinity + 5000);
      glGetFloatv(GL_MODELVIEW_MATRIX, proj[num]);
   }
   glPopMatrix();
   
   return proj[num];
}


// These really only need to be calculated once, but for now this works
Vector3 Light::GetRots(int num)
{
   if (!isvalid(num)) return Vector3();
   
   Vector3 rots;
   Vector3 dir = GetDir(num);
   Vector3 start(0, 0, -1); // Initial view direction
   
   dir *= -1; // Dir is where it's coming from, we need where it's going to
   dir.y = 0;
   dir.normalize();
   rots.y = acos(start.dot(dir)) * 180.f / 3.14159265;
   if (start.cross(dir).y >= 0)
      rots.y *= -1;
   dir = GetDir(num);
   dir *= -1;
   GraphicMatrix rotm;
   rotm.rotatey(rots.y);
   start.transform(rotm);
   rots.x = acos(start.dot(dir)) * 180.f / 3.14159265;
   /*rots.print();  // Debugging
   
   start = Vector3(0, 0, -1);
   rotm.identity();
   rotm.rotatex(rots.x);
   rotm.rotatey(rots.y);
   start.transform(rotm);
   start.print();
   dir.print();
   logout << endl;*/
   return rots;
}


int Light::NumLights()
{
   return posdir.size();
}


bool Light::isvalid(int num)
{
   return (num >= 0 || num < NumLights());
}


