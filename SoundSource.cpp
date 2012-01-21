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