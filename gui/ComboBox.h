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

#ifndef __COMBOBOX_H
#define __COMBOBOX_H

#include "GUI.h"
#include "Table.h"
#include "TableItem.h"
#include "Button.h"

class ComboBox : public GUI
{
   friend class GUI;
   public:
      ComboBox(GUI*, TextureManager*);
      ~ComboBox();
      int Selected();
      string SelectedText();
      void Select(int, bool doaction = true);
      void ReadNodeExtra(DOMNode* current, GUI* parentw);
      virtual bool FloatsInWidget(float, float);
      void Add(const string&);
      void Clear();
      
   protected:
      virtual void CustomProcessEvent(SDL_Event*);
      virtual void LeftDown(SDL_Event*);
      virtual void LeftClick(SDL_Event*);
      virtual void ReadSpecialNodes(DOMNode* current, GUI* parentw);
      virtual void PostReadNode(DOMNode*, GUI*);
      virtual void RenderWidget();
      
      Table* table;
      Button* button;
      float menuheight;
};

#endif
