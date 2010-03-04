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

#include "Layout.h"

Layout::Layout(GUI* p, TextureManager* tm) : padding(3.f), orientation(Vertical)
{
   Init(p, tm);
}

Layout::~Layout()
{
}


void Layout::RenderWidget()
{
   UpdatePositions();
   RenderBase();
}


void Layout::ReadNodeExtra(DOMNode* current, GUI* parentw)
{
   string o = ReadAttribute(current, XSWrapper("orientation"));
   padding = atof(ReadAttribute(current, XSWrapper("padding")).c_str());
   
   if (o == "horizontal")
      orientation = Horizontal;
   else
      orientation = Vertical;
}


void Layout::UpdatePositions()
{
   GUI* previous = NULL;
   float max = 0.f;
   if (orientation == Vertical)
   {
      for (guiiter i = children.begin(); i != children.end(); ++i)
      {
         GUI& curr = **i;
         float currwidth = curr.MaxX() - curr.x;
         if (!previous)
         {
            curr.x = xmargin;
            curr.y = ymargin;
         }
         else
         {
            curr.y = padding + previous->MaxY();
            curr.x = xmargin;
         }
         previous = &(**i);
         if (currwidth > max)
            max = currwidth;
      }
      height = previous->MaxY() + ymargin;
      width = max + xmargin * 2.f;
   }
   else
   {
      for (guiiter i = children.begin(); i != children.end(); ++i)
      {
         GUI& curr = **i;
         float currheight = curr.MaxY() - curr.y;
         if (!previous)
         {
            curr.x = xmargin;
            curr.y = ymargin;
         }
         else
         {
            curr.x = padding + previous->MaxX();
            curr.y = ymargin;
         }
         previous = &(**i);
         if (currheight > max)
            max = currheight;
      }
      height = max + ymargin * 2.f;
      width = previous->MaxX() + xmargin;
   }
}
