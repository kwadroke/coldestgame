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


#ifndef __SCROLLVIEW_H
#define __SCROLLVIEW_H

#include "GUI.h"
#include "Slider.h"

class ScrollView : public GUI
{
   friend class GUI;
   friend class Table; // Allow table to add children
   friend class TabWidget;
   public:
      ScrollView(GUI*, TextureManager*);
      ~ScrollView();
      bool FloatsInWidget(float, float);
      float scrollbarwidth;
      void ScrollToBottom();
      
   protected:
      float vpoffsetx, vpoffsety;
      float canvasx, canvasy;
      float scrollamount;
      bool drag;
      SliderPtr vertbar;
      SliderPtr horizbar;
      
      void RecalculateSize();
      void RenderWidget();
      void PostRender();
      virtual void CustomProcessEvent(SDL_Event*);
      virtual void MouseMotion(SDL_Event*);
      virtual void LeftDown(SDL_Event*);
      virtual void WheelDown(SDL_Event*);
      virtual void WheelUp(SDL_Event*);
      virtual void KeyDown(SDL_Event*);
      virtual void GlobalLeftClick(SDL_Event*);
      virtual void ReadNodeExtra(DOMNode*, GUI*);
};

typedef shared_ptr<ScrollView> ScrollViewPtr;

#endif
