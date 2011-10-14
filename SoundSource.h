#ifndef SOUNDSOURCE_H
#define SOUNDSOURCE_H

#include "IDGen.h"
#include "Vector3.h"
#include <boost/shared_ptr.hpp>

class SoundManager;

class SoundSource
{
   friend class SoundManager;
   public:
      SoundSource() : valid(false) {}
      SoundSource(size_t s, SoundManager* sm) : valid(true), source(s), id(nextid), soundman(sm) {}
      ~SoundSource();
      void SetPosition(const Vector3&);
      
   private:
      // Copying this object would require reference counting - just use a smart pointer
      SoundSource(const SoundSource&);
      SoundSource& operator=(const SoundSource&);
      
      bool valid;
      size_t source, id;
      static IDGen nextid;
      SoundManager* soundman;
};

typedef boost::shared_ptr<SoundSource> SoundSourcePtr;

#endif // SOUNDSOURCE_H
