#ifndef __SOUNDMANAGER_H
#define __SOUNDMANAGER_H

#include <map>
#include <string>
#include "ALBuffer.h"
#include "Vector3.h"
#include "types.h"

using std::map;
using std::string;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class SoundManager
{
   public:
      SoundManager();
      ALBufferPtr GetBuffer(const string&);
      void SetListenPos(Vector3&);
      void SetListenDir(Vector3&);
      
   private:
      map<string, ALBufferPtr> buffers;

};

#endif
