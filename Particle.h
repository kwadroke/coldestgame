#ifndef __PARTICLE
#define __PARTICLE

#define SDL_NO_GLEXT
#include <list>
#include <stack>
#include "CollisionDetection.h"
#include "Vector3.h"
#include "Timer.h"
#include "SDL.h"
#include "SDL_thread.h"

using namespace std;

class Particle
{
   public:
      Particle();
      Particle(Vector3, Vector3, float, float, float, float, bool, list<DynamicObject>::iterator, Uint32);
      bool Update(list<DynamicObject>*);
      CollisionDetection *cd;
      list<DynamicObject>::iterator obj;
      bool unsent;
      unsigned short senttimes;
      short playernum;
      unsigned long id;
      unsigned long playerid;
      
      
      Vector3 dir;
      Vector3 pos;
      float velocity;
      float accel;
      float weight;
      float radius;
      bool explode;
      Uint32 lasttick;
      stack<list<DynamicObject>::iterator> hitobjs;
      int damage;
      float dmgrad;
      
   private:
      static unsigned long nextid;
};

#endif
