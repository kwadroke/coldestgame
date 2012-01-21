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
// Copyright 2008-2012 Ben Nemec
// @End License@


#include "Slider.h"

Slider::Slider(GUI* p, TextureManager* tm) : value(0), orientation(Horizontal), forceslidersize(-1.f), minvalue(0),
               maxvalue(100), sliderheight(30), sliderwidth(30), drag(false), dragoffset(0.f)
{
   Init(p, tm);
   button = new Button(this, tm);
   button->textures = defaulttextures[SliderTex];
}


Slider::~Slider()
{
   //Cleanup();
}


void Slider::SetRange(int min, int max)
{
   minvalue = min;
   maxvalue = max;
}


void Slider::RenderWidget()
{
   state = Normal;
   RenderBase();
   
   CalculateSliderSize();
   
   float position;
   if (orientation == Horizontal)
   {
      position = float(value - minvalue) / float(maxvalue - minvalue) * (width - xmargin * 2.f - sliderwidth) + xmargin + sliderwidth / 2.f;
      button->x = position - sliderwidth / 2.f;
      button->y = 0;
   }
   else
   {
      position = float(value - minvalue) / float(maxvalue - minvalue) * (height - ymargin * 2.f - sliderheight) + ymargin + sliderheight / 2.f;
      button->x = 0;
      button->y = position - sliderheight / 2.f;
   }
   
   button->width = sliderwidth;
   button->height = sliderheight;
   button->state = Hover;
   button->Render();
   
   UpdateValueWidget();
}


void Slider::CustomProcessEvent(SDL_Event* event)
{
   button->ProcessEvent(event);
}


void Slider::GlobalLeftClick(SDL_Event* event)
{
   drag = false;
}


void Slider::MouseMotion(SDL_Event* event)
{
   if (drag)
   {
      value = minvalue + GetMousePos(event);
   }
}


void Slider::LeftDown(SDL_Event* event)
{
   if (button->InWidget(event))
   {
      drag = true;
      if (orientation == Horizontal)
      {
         dragoffset = event->motion.x / wratio - (float(value - minvalue) / float(maxvalue - minvalue) * (width - xmargin * 2.f - sliderwidth) + xmargin + sliderwidth / 2.f + x + xoff);
      }
      else
      {
         dragoffset = event->motion.y / hratio - (float(value - minvalue) / float(maxvalue - minvalue) * (height - ymargin * 2.f - sliderheight) + ymargin + sliderheight / 2.f + y + yoff);
      }
   }
}


void Slider::WheelDown(SDL_Event* event)
{
   if (value < maxvalue) ++value;
}


void Slider::WheelUp(SDL_Event* event)
{
   if (value > minvalue) --value;
}


int Slider::GetMousePos(const SDL_Event* event)
{
   float mousepos, localratio, localpos, localoff, localslidersize, localmargin, localsize;
   mousepos = orientation == Vertical ? event->motion.y : event->motion.x;
   localratio = orientation == Vertical ? hratio : wratio;
   localpos = orientation == Vertical ? y : x;
   localoff = orientation == Vertical ? yoff : xoff;
   localslidersize = orientation == Vertical ? sliderheight : sliderwidth;
   localmargin = orientation == Vertical ? ymargin : xmargin;
   localsize = orientation == Vertical ? height : width;
   
   float fpos = mousepos / localratio;
   float clamped = fpos - dragoffset - localpos - localoff;
   int retval = int((clamped - localmargin - localslidersize / 2.f) / (localsize - localmargin * 2.f - localslidersize) * (maxvalue - minvalue));
   if (retval < 0 || retval > (maxvalue - minvalue)) return value - minvalue;
   return retval;
}


void Slider::CalculateSliderSize()
{
   if (orientation == Vertical)
   {
      sliderwidth = width;
      sliderheight = height / (maxvalue - minvalue + 1);
      if (sliderheight < 30)
         sliderheight = 30;
      if (forceslidersize > 0.f)
         sliderheight = forceslidersize;
   }
   else
   {
      sliderwidth = width / (maxvalue - minvalue + 1);
      sliderheight = height;
      if (sliderwidth < 30)
         sliderwidth = 30;
      if (forceslidersize > 0.f)
         sliderwidth = forceslidersize;
   }
}


void Slider::UpdateValueWidget()
{
   for (guiiter i = children.begin(); i != children.end(); ++i)
   {
      if ((*i)->name == name + "value")
      {
         (*i)->text = ToString(value);
      }
   }
}


void Slider::ReadNodeExtra(DOMNode* current, GUI* parentw)
{
   string val = ReadAttribute(current, XSWrapper("min"));
   if (val != "")
      minvalue = atoi(val.c_str());
   val = ReadAttribute(current, XSWrapper("max"));
   if (val != "")
      maxvalue = atoi(val.c_str());
   val = ReadAttribute(current, XSWrapper("value"));
   if (val != "")
      value = atoi(val.c_str());
   val = ReadAttribute(current, XSWrapper("orientation"));
   if (val == "vertical")
      orientation = Vertical;
   else
      orientation = Horizontal;
   UseDefaultTextures(GutterTex);
}

