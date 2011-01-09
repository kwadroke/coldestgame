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


#ifndef __TABWIDGET_H
#define __TABWIDGET_H

#include "GUI.h"
#include "Button.h"
#include "ScrollView.h"
#include <vector>

using std::vector;

class TabWidget : public GUI
{
   friend class GUI;
   public:
      TabWidget(GUI*, TextureManager*);
      ~TabWidget();
      virtual GUI* GetWidget(string);
      
   protected:
      virtual void RenderWidget();
      virtual void ReadSpecialNodes(DOMNode*, GUI*);
      virtual void CustomProcessEvent(SDL_Event*);
      virtual void LeftClick(SDL_Event*);
      void GetNextButtonPosition(float&, float&);
      
      // Copying not allowed
      TabWidget(const TabWidget&);
      TabWidget& operator=(const TabWidget&);
      
      vector<ButtonPtr> buttons;
      vector<ScrollViewPtr> scrollviews;
      float buttonspacing, buttonheight;
};

#endif
