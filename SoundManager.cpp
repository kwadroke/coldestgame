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


void SoundManager::PlaySound(const string& filename, const Vector3& pos)
{
   ALSourcePtr newsource(new ALSource());
   newsource->SetPosition(pos);
   newsource->Play(GetBuffer(filename));
   sources.push_back(newsource);
}


void SoundManager::Update()
{
   vector<list<ALSourcePtr>::iterator> remove;
   for (list<ALSourcePtr>::iterator i = sources.begin(); i != sources.end(); ++i)
   {
      ALSourcePtr p = *i;
      if (!p->Playing())
         remove.push_back(i);
   }
   for (size_t i = 0; i < remove.size(); ++i)
      sources.erase(remove[i]);
}


