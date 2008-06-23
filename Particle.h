#ifndef __PARTICLE
#define __PARTICLE

#include <list>
#include <stack>
#include "CollisionDetection.h"
#include "Vector3.h"
#include "Timer.h"
#include "SDL.h"
#include "SDL_thread.h"

using namespace std;
using boost::shared_ptr;

class Particle
{
   public:
      Particle(Mesh&);
      Particle(unsigned long, Vector3, Vector3, float, float, float, float, bool, Uint32, Mesh&);
      Vector3 Update();
      void Render(Mesh *rendermesh = NULL, const Vector3& campos = Vector3());
      
      short playernum;
      unsigned long id;
      
      Vector3 dir;
      Vector3 pos;
      Vector3 origin;
      Vector3 rots;
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
      int weapid;
      
      MeshPtr tracer;
      Uint32 tracertime;
      
   private:
      Timer t;
};


#endif
