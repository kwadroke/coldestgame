#ifndef STABLERANDOM_H
#define STABLERANDOM_H

/**
	@author Ben Nemec <cybertron@nemebean.com>
   
   This is a not-so-random number generator guaranteed to return the same values
   on any system given the same seed.
*/
class StableRandom
{
   public:
      StableRandom(int seed = 0);
      float Random(float min, float max);
      void Seed(int seed = 0);
      
   private:
      static float vals[1024];
      int currindex;

};



#endif
