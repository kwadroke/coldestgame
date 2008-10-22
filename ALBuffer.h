#ifndef __ALBUFFER_H
#define __ALBUFFER_H

#include <AL/al.h>
#include <AL/alut.h>
#include <vorbis/vorbisfile.h>
#include <boost/shared_ptr.hpp>
#include <string>
#include <iostream>
#include "logout.h"

using std::string;
using std::endl;
using boost::shared_ptr;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class ALBuffer
{
   friend class ALSource;
   public:
      ALBuffer(const string&);
      ~ALBuffer();
      static void CheckError();
      
   private:
      ALBuffer(const ALBuffer&); // No copying allowed
      ALBuffer& operator=(const ALBuffer&);
      
      ALuint id;
      ALenum format;
      ALsizei size;
      ALvoid* data;
      ALsizei freq;
      ALboolean loop;

};

typedef shared_ptr<ALBuffer> ALBufferPtr;

#endif
