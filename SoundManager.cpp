#include "SoundManager.h"

SoundManager::SoundManager()
{
}


ALBufferPtr SoundManager::GetBuffer(const string& filename)
{
   if (buffers.find(filename) == buffers.end())
   {
      ALBufferPtr newbuffer(new ALBuffer(filename));
      buffers[filename] = newbuffer;
   }
   return buffers[filename];
}


void SoundManager::SetListenPos(Vector3& v)
{
   float temp[3];
   v.array(temp);
   alListenerfv(AL_POSITION, temp);
}


void SoundManager::SetListenDir(Vector3& v)
{
   floatvec temp(6, 0.f);
   temp[0] = v.x;
   temp[1] = v.y;
   temp[2] = v.z;
   temp[4] = 1.f;
   alListenerfv(AL_ORIENTATION, &temp[0]);
}


