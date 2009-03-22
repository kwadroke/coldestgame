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
