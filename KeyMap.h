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
// Copyright 2008, 2009 Ben Nemec
// @End License@

#ifndef __KEYMAP_H
#define __KEYMAP_H
#include <SDL.h>

class KeyMap
{
   public:
      KeyMap() : keyforward(SDLK_F13), keyback(SDLK_F13), keyleft(SDLK_F13), keyright(SDLK_F13), keyloadout(SDLK_F13),
	         mousefire(255), mousezoom(255), mouseuse(255), mousenextweap(255), mouseprevweap(255)
		 {};
      SDLKey keyforward;
      SDLKey keyback;
      SDLKey keyleft;
      SDLKey keyright;
      SDLKey keyloadout;
      Uint8 mousefire;
      Uint8 mousezoom;
      Uint8 mouseuse;
      Uint8 mousenextweap;
      Uint8 mouseprevweap;
};

#endif
