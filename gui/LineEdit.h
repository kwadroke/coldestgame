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

#ifndef __LINEEDIT_H
#define __LINEEDIT_H

#include <string>
#include "GUI.h"

class LineEdit : public GUI
{
   public:
      LineEdit(GUI*, TextureManager*);
      ~LineEdit();
      
   protected:
      int CalculateMousePos(int, int);
      void InsertChar(char);
      void BSChar();
      void DeleteChar();
      string GetVisible();
      void RenderWidget();
      virtual void MouseMotion(SDL_Event*);
      virtual void LeftClick(SDL_Event*);
      virtual void LeftDown(SDL_Event*);
      virtual void KeyDown(SDL_Event*);
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      
      int cursorpos;
      int offset;
      int dragstart, dragend;
      
      // Copying not allowed - this may not be necessary anymore
      LineEdit(const LineEdit&);
      LineEdit& operator=(const LineEdit&);
};

#endif
