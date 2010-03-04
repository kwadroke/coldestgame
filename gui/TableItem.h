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
// Copyright 2008, 2010 Ben Nemec
// @End License@


#ifndef __TABLEITEM_H
#define __TABLEITEM_H

#include "GUI.h"
#include "LineEdit.h"

class TableItem : public GUI
{
   friend class Table;
   friend class ComboBox;
   public:
      TableItem(GUI*, TextureManager*);
      ~TableItem();
      void Build(string, GUI*);
      string Text(int);
      
   protected:
      virtual void RenderWidget();
      virtual void LeftDown(SDL_Event*);
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      
      GUI* tablep;
      bool selected;
};

#endif
