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


#ifndef __TABLE_H
#define __TABLE_H

#include "GUI.h"
#include "TableItem.h"
#include "ScrollView.h"

class Table : public GUI
{
   friend class GUI;
   friend class TableItem;
   friend class ComboBox;
   friend class TextArea;
   public:
      Table(GUI*, TextureManager*);
      ~Table();
      void Clear();
      void Add(string);
      int Selected();
      void Select(int);
      string GetSelectedString(int);
      bool InScrollbar(float, float);
      void ScrollToBottom();
      
   protected:
      virtual void RenderWidget();
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      virtual void ReadSpecialNodes(DOMNode*, GUI*);
      virtual void CustomProcessEvent(SDL_Event*);
      
      ScrollView* scrollview;
      string colwidths;
      float rowheight;
};

#endif
