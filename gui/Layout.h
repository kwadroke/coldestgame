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

#ifndef __LAYOUT_H
#define __LAYOUT_H

#include "GUI.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
   
   This is a very simple layout class that simply arranges GUI widgets in either a
   vertical or horizontal fashion.  It does no resizing of widgets.
*/
class Layout : public GUI
{
   public:
      Layout(GUI*, TextureManager*);
      ~Layout();
      
      float padding;
      enum Orientation{Vertical, Horizontal};
      Orientation orientation;
      
   protected:
      virtual void RenderWidget();
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      virtual void UpdatePositions();

};

#endif
