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


#include "ALSource.h"

ALSource::ALSource() : position(Vector3()),
                   pitch(1.f), gain(1.f), loop(AL_FALSE), refdist(200.f), maxdist(5000.f),
                         rolloff(1.f), relative(AL_FALSE), velocity(floatvec(3, 0.f)), managerid(0)
{
   alGenSources(1, &id);
}


ALSource::ALSource(const ALSource& s) : position(s.position),
                   pitch(s.pitch), gain(s.gain), loop(s.loop), refdist(s.refdist), maxdist(s.maxdist),
                         rolloff(s.rolloff), relative(s.relative), velocity(s.velocity), managerid(s.managerid)
{
   alGenSources(1, &id);
}

ALSource& ALSource::operator=(const ALSource& s)
{
   position = s.position;
   velocity = s.velocity;
   pitch = s.pitch;
   gain = s.gain;
   loop = s.loop;
   managerid = s.managerid;
   alGenSources(1, &id);
   return *this;
}


ALSource::~ALSource()
{
   alSourceStop(id);
   alSourcei(id, AL_BUFFER, AL_NONE);
   alDeleteSources(1, &id);
}


void ALSource::Play(const ALBuffer& buffer)
{
   ALenum state;
   alGetSourcei(id, AL_SOURCE_STATE, &state);
   if (state == AL_PLAYING)
      return;
   if (state != AL_PAUSED)
      alSourcei(id, AL_BUFFER, buffer.id);
   alSourcef(id, AL_PITCH, pitch);
   alSourcef(id, AL_GAIN, gain);
   floatvec arrpos(3);
   arrpos[0] = position.x;
   arrpos[1] = position.y;
   arrpos[2] = position.z;
   alSourcefv(id, AL_POSITION, &arrpos[0]);
   alSourcefv(id, AL_VELOCITY, &velocity[0]);
   alSourcei(id, AL_LOOPING, loop);
   alSourcef(id, AL_MAX_DISTANCE, maxdist);
   alSourcef(id, AL_REFERENCE_DISTANCE, refdist);
   alSourcef(id, AL_ROLLOFF_FACTOR, rolloff);
   alSourcei(id, AL_SOURCE_RELATIVE, relative);
   alSourcePlay(id);
}


void ALSource::Play(const ALBufferPtr& buffer)
{
   Play(*buffer);
}


void ALSource::Stop()
{
   alSourceStop(id);
}


void ALSource::SetPosition(const Vector3& v)
{
   position = v;
   floatvec arrpos(3);
   arrpos[0] = position.x;
   arrpos[1] = position.y;
   arrpos[2] = position.z;
   alSourcefv(id, AL_POSITION, &arrpos[0]);
}

void ALSource::SetGain(const float g)
{
   alSourcef(id, AL_GAIN, g);
   gain = g;
}


bool ALSource::Playing()
{
   ALenum state;
   alGetSourcei(id, AL_SOURCE_STATE, &state);
   if (state == AL_PLAYING)
      return true;
   return false;
}


void ALSource::CheckError()
{
   ALenum err = alGetError();
   if (err == AL_NO_ERROR)
   {
      logout << "AL_NO_ERROR" << endl;
   }
   else if (err == AL_INVALID_NAME)
   {
      logout << "AL_INVALID_NAME" << endl;
   }
   else if (err == AL_INVALID_ENUM)
   {
      logout << "AL_INVALID_ENUM" << endl;
   }
   else if (err == AL_INVALID_VALUE)
   {
      logout << "AL_INVALID_VALUE" << endl;
   }
   else if (err == AL_INVALID_OPERATION)
   {
      logout << "AL_INVALID_OPERATION" << endl;
   }
   else if (err == AL_OUT_OF_MEMORY)
   {
      logout << "AL_OUT_OF_MEMORY" << endl;
   }
}


