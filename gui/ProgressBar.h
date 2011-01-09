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


#ifndef __PROGRESS_BAR_H
#define __PROGRESS_BAR_H

#include "GUI.h"

class ProgressBar : public GUI
{
   friend class GUI;
   public:
      ProgressBar(GUI*, TextureManager*);
      ~ProgressBar();
      void SetRange(int, int);
      int value;
      
   protected:
      void RenderWidget();
      
      int minvalue, maxvalue;
      
};

#endif
