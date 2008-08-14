#include "Slider.h"

Slider::Slider(GUI* p, TextureManager* tm) : value(5), minvalue(0),
               maxvalue(100), drag(false), sliderheight(30), sliderwidth(30), dragoffset(0.f)
{
   Init(p, tm);
   button = new Button(this, tm);
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
   
   float position = float(value - minvalue) / float(maxvalue - minvalue) * (width - xmargin * 2.f - sliderwidth) + xmargin + sliderwidth / 2.f;
   
   button->textures[Normal] = textures[Normal];
   button->textures[Hover] = textures[Hover];
   button->textures[Clicked] = textures[Clicked];
   button->x = position - sliderwidth / 2.f;
   button->y = 0;
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
      dragoffset = event->motion.x / wratio - (float(value - minvalue) / float(maxvalue - minvalue) * (width - xmargin * 2.f - sliderwidth) + xmargin + sliderwidth / 2.f + x + xoff);
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
   // const_cast is a kludge because EventInWidget is not const correct
   if (!InWidget(const_cast<SDL_Event*>(event))) return value - minvalue;
   
   float fx = event->motion.x / wratio;
   float clampedx = fx - dragoffset - x - xoff;
   int retval = int((clampedx - xmargin - sliderwidth / 2.f) / (width - xmargin * 2.f - sliderwidth) * (maxvalue - minvalue));
   if (retval < 0 || retval > (maxvalue - minvalue)) return value - minvalue;
   return retval;
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
}

