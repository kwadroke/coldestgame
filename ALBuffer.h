// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
#ifndef __ALBUFFER_H
#define __ALBUFFER_H

#include <AL/al.h>
#include <AL/alut.h>
#include <vorbis/vorbisfile.h>
#include <boost/shared_ptr.hpp>
#include <string>
#include <iostream>
#include "logout.h"

using std::string;
using std::endl;
using boost::shared_ptr;

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class ALBuffer
{
   friend class ALSource;
   public:
      ALBuffer(const string&);
      ~ALBuffer();
      static void CheckError();
      
   private:
      ALBuffer(const ALBuffer&); // No copying allowed
      ALBuffer& operator=(const ALBuffer&);
      
      ALuint id;
      ALenum format;
      ALsizei size;
      ALvoid* data;
      ALsizei freq;
      ALboolean loop;

};

typedef shared_ptr<ALBuffer> ALBufferPtr;

#endif
