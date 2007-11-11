#ifndef __HIT_H
#define __HIT_H

class Hit
{
   public:
      Hit();
      Hit(unsigned long);
      int damage;
      int player;
      unsigned long id;
      
   private:
      static unsigned long nextid;
};

#endif
