#ifndef __SOUNDMANAGER_H
#define __SOUNDMANAGER_H

#include <map>
#include <string>
#include <list>
#include <vector>
#include "ALBuffer.h"
#include "ALSource.h"
#include "Vector3.h"
#include "types.h"

using std::map;
using std::string;
using std::list;
using std::vector;

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
      void PlaySound(const string&, const Vector3&);
      void Update();
      
   private:
      map<string, ALBufferPtr> buffers;
      list<ALSourcePtr> sources;

};

#endif
