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
// Copyright 2008-2012 Ben Nemec
// @End License@


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
   if (s->id == sources[s->source]->managerid)
      sources[s->source]->SetPosition(v);
}


void SoundManager::SetGain(const float g, SoundSource* s)
{
   if (s->id == sources[s->source]->managerid)
      sources[s->source]->SetGain(g);
}


void SoundManager::StopSource(SoundSource* s)
{
   if (s->id == sources[s->source]->managerid)
      sources[s->source]->Stop();
}


SoundSourcePtr SoundManager::PlaySound(const string& filename, const Vector3& pos, const bool loop, const bool relative)
{
#ifdef DEDICATED
   return SoundSourcePtr(new SoundSource());
#endif
   SetMaxSources(16); // Can't do this in the constructor because OpenAL hasn't been initialized yet
   if (filename == "")
      return SoundSourcePtr(new SoundSource());
   size_t num = SelectSource(pos);
   if (num >= sources.size())
   {
      return SoundSourcePtr(new SoundSource());
   }
   
   ALSourcePtr selected = sources[num];
   selected->loop = loop ? AL_TRUE : AL_FALSE;
   selected->relative = relative ? AL_TRUE: AL_FALSE;
   selected->position = pos;
   selected->Stop();
   selected->Play(GetBuffer(filename));
   
   // If we're looping then the caller needs to keep track of it so it can be stopped at some point
   if (loop)
   {
      SoundSourcePtr retval(new SoundSource(num, this));
      selected->managerid = retval->id;
      return retval;
   }
   // Otherwise we don't actually bind a SoundSource or it will immediately stop playback when the object is destroyed
   return SoundSourcePtr(new SoundSource());
}


size_t SoundManager::SelectSource(const Vector3& pos)
{
   for (size_t i = 0; i < sources.size(); ++i)
   {
      if (!sources[i]->Playing())
      {
         return i;
      }
   }
   size_t selected = 0;
   for (size_t i = 1; i < sources.size(); ++i)
   {
      if (sources[i]->position.distance2(listenpos) > sources[selected]->position.distance2(listenpos) && !sources[i]->relative)
         selected = i;
   }
   if (sources[selected]->position.distance2(listenpos) > pos.distance2(listenpos) && !sources[selected]->relative)
   {
      return selected;
   }
   //logout << "Warning: Failed to find sound source" << endl;
   //logout << listenpos << "  " << pos << endl;
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


// v should be [0 - 100]
void SoundManager::SetVolume(const float v)
{
   for (size_t i = 0; i < sources.size(); ++i)
   {
      sources[i]->SetGain(v / 100.f);
   }
}


