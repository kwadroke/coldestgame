// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008, 2011 Ben Nemec
// @End License@


#include "SoundManager.h"

SoundManager::SoundManager()
{
   sources = SourceList(16);
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
   listenpos = v;
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


void SoundManager::SetPosition(const Vector3& v, SoundSource* s)
{
   if (s->id == sources[s->source]->soundsource->id)
      sources[s->source]->SetPosition(v);
}


void SoundManager::StopSource(SoundSource* s)
{
   if (s->id == sources[s->source]->soundsource->id)
      sources[s->source]->Stop();
}


SoundSourcePtr SoundManager::PlaySound(const string& filename, const Vector3& pos, bool loop)
{
#ifdef DEDICATED
   return SoundSourcePtr(new SoundSource());
#endif
   size_t num = SelectSource(pos);
   if (num >= sources.size() || filename == "")
      return SoundSourcePtr(new SoundSource());

   SoundSourcePtr retval(new SoundSource(num, this));
   ALSourcePtr selected = sources[num];
   if (selected)
   {
      selected->loop = loop;
      selected->position = pos;
      selected->soundsource = retval;
      selected->Stop();
      selected->Play(GetBuffer(filename));
   }
   return retval;
}


size_t SoundManager::SelectSource(const Vector3& pos)
{
   for (size_t i = 0; i <= sources.size(); ++i)
   {
      if (!sources[i])
         sources[i] = ALSourcePtr(new ALSource());
      if (!sources[i]->Playing())
         return i;
   }
   for (size_t i = 0; i <= sources.size(); ++i)
   {
      if (sources[i]->position.distance2(listenpos) < pos.distance2(listenpos))
         return i;
   }
   logout << "Warning: Failed to find sound source" << endl;
   return sources.size();
}


void SoundManager::SetMaxSources(const size_t num)
{
   if (num < sources.size())
      logout << "Warning: Setting max sources to a smaller value.  This may cause undesired behavior." << endl;
   
   while (sources.size() < num)
   {
      ALSourcePtr newsource(new ALSource());
      sources.push_back(newsource);
   }
}


