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


#ifndef __BUTTON_H
#define __BUTTON_H

#include <string>
#include "GUI.h"

class Button : public GUI
{
   friend class GUI;
   friend class ComboBox;
   friend class Slider;
   friend class TabWidget;
   public:
      Button(GUI*, TextureManager*);
      ~Button();
      
      bool toggle;
      int togglestate;
      
   protected:
      virtual void RenderWidget();
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      virtual void LeftClick(SDL_Event*);
      
      // Copying not allowed
      Button(const Button&);
      Button& operator=(const Button&);
};

typedef shared_ptr<Button> ButtonPtr;

#endif
