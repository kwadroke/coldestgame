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
#ifndef SOUNDSOURCE_H
#define SOUNDSOURCE_H

#include "IDGen.h"
#include "Vector3.h"
#include <boost/shared_ptr.hpp>

class SoundManager;

class SoundSource
{
   friend class SoundManager;
   public:
      SoundSource() : valid(false) {}
      SoundSource(size_t s, SoundManager* sm) : valid(true), source(s), id(nextid), soundman(sm) {}
      ~SoundSource();
      void SetPosition(const Vector3&);
      void SetGain(const float);
      
   private:
      // Copying this object would require reference counting - just use a smart pointer
      SoundSource(const SoundSource&);
      SoundSource& operator=(const SoundSource&);
      
      bool valid;
      size_t source, id;
      static IDGen nextid;
      SoundManager* soundman;
};

typedef boost::shared_ptr<SoundSource> SoundSourcePtr;

#endif // SOUNDSOURCE_H
