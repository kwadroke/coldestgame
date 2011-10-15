#include "SoundSource.h"
#include "SoundManager.h"

IDGen SoundSource::nextid;

SoundSource::~SoundSource()
{
#ifndef DEDICATED
   if (valid)
      soundman->StopSource(this);
#endif
}

void SoundSource::SetPosition(const Vector3& pos)
{
#ifndef DEDICATED
   if (valid)
      soundman->SetPosition(pos, this);
#endif
}


void SoundSource::SetGain(const float gain)
{
   #ifndef DEDICATED
   if (valid)
      soundman->SetGain(gain, this);
   #endif
}