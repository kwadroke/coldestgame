#include "ALSource.h"

ALSource::ALSource() : position(floatvec(3, 0.f)), velocity(floatvec(3, 0.f)),
                   pitch(1.f), gain(1.f), loop(0)
{
   alGenSources(1, &id);
}


ALSource::~ALSource()
{
   alDeleteSources(1, &id);
}


void ALSource::Play(const ALBuffer& buffer)
{
   alSourcei(id, AL_BUFFER, buffer.id);
   alSourcef(id, AL_PITCH, pitch);
   alSourcef(id, AL_GAIN, gain);
   alSourcefv(id, AL_POSITION, &position[0]);
   alSourcefv(id, AL_VELOCITY, &velocity[0]);
   alSourcei(id, AL_LOOPING, loop);
   alSourcePlay(id);
}


void ALSource::Play(const ALBufferPtr& buffer)
{
   Play(*buffer);
}


