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


#include "ProgressBar.h"

ProgressBar::ProgressBar(GUI* p, TextureManager* tm)
{
   value = 0;
   minvalue = 0;
   maxvalue = 100;
   Init(p, tm);
}


ProgressBar::~ProgressBar()
{
   //Cleanup();
}


void ProgressBar::SetRange(int min, int max)
{
   minvalue = min;
   maxvalue = max;
}


void ProgressBar::RenderWidget()
{
   RenderBase();
   
   float position = (float)(value - minvalue) / (float)(maxvalue - minvalue) * width;
   texman->BindTexture(textures[Hover]);
   glBegin(GL_TRIANGLE_STRIP);
   glTexCoord2i(0, 0);
   glVertex2f((x + xoff) * wratio, (y + yoff) * hratio);
   glTexCoord2i(0, 1);
   glVertex2f((x + xoff) * wratio, (y + yoff + height) * hratio);
   glTexCoord2i(1, 0);
   glVertex2f((x + xoff + position) * wratio, (y + yoff) * hratio);
   glTexCoord2i(1, 1);
   glVertex2f((x + xoff + position) * wratio, (y + yoff + height) * hratio);
   glEnd();
}

