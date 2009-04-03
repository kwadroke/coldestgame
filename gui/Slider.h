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


#ifndef __SLIDER_H
#define __SLIDER_H

#include "GUI.h"
#include "Button.h"

class Slider : public GUI
{
   friend class GUI;
   public:
      Slider(GUI*, TextureManager*);
      ~Slider();
      void SetRange(int, int);
      int value;
      int orientation;
      float forceslidersize;
      enum Orientation{Horizontal, Vertical};
      
   protected:
      int GetMousePos(const SDL_Event*);
      virtual void CustomProcessEvent(SDL_Event*);
      virtual void MouseMotion(SDL_Event*);
      virtual void LeftDown(SDL_Event*);
      virtual void WheelDown(SDL_Event*);
      virtual void WheelUp(SDL_Event*);
      virtual void GlobalLeftClick(SDL_Event*);
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      void RenderWidget();
      void UpdateValueWidget();
      void CalculateSliderSize();
      
      Button *button;
      int minvalue, maxvalue;
      float sliderheight, sliderwidth;
      bool drag;
      float dragoffset;
};

typedef shared_ptr<Slider> SliderPtr;

#endif
