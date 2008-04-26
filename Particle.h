#ifndef __PARTICLE
#define __PARTICLE

#include <list>
#include <stack>
#include "CollisionDetection.h"
#include "Vector3.h"
#include "Timer.h"
#include "DynamicObject.h"
#include "SDL.h"
#include "SDL_thread.h"

using namespace std;

class Particle
{
   public:
      Particle(Mesh&);
      Particle(Vector3, Vector3, float, float, float, float, bool, Uint32, Mesh&);
      Vector3 Update();
      void Render(Mesh *rendermesh = NULL, const Vector3& campos = Vector3());
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
      int damage;
      float dmgrad;
      Mesh mesh;
      int rewind;
      bool collide;
      Uint32 ttl;
      bool expired;
      
   private:
      static unsigned long nextid;
      Timer t;
};

#endif
