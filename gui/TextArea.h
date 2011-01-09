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


#ifndef __TEXTAREA_H
#define __TEXTAREA_H

#include "GUI.h"
#include "Table.h"
#include "SDL.h"
#include <string>
#include <deque>

using std::string;
using std::vector;

class TextArea : public GUI
{
   friend class GUI;
   public:
      TextArea(GUI*, TextureManager*);
      ~TextArea();
      void Append(string);
      void Refresh();
      void ScrollToBottom();
      
   protected:
      void ReadNodeExtra(DOMNode*, GUI*);
      void CustomProcessEvent(SDL_Event*);
      void RenderWidget();
      
      Table *table;
      int maxlines;
};

#endif
