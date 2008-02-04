#include "Slider.h"

Slider::Slider(GUI* p, TextureManager* tm) : value(5), minvalue(0),
               maxvalue(100), drag(false), sliderheight(30), sliderwidth(30), dragoffset(0.f)
{
   Init(p, tm);
   button = new Button(this, tm);
   maxvalue = 10;
   minvalue = 5;
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


void Slider::Render()
{
   if (!visible) return;
   xoff = parent->x + parent->xoff;
   yoff = parent->y + parent->yoff;
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
}


void Slider::ReadNode(DOMNode* current, GUI* parent)
{
   /* This is not the most efficient way to handle tags, but it's the least troublesome and
      I somehow doubt that XML parsing performance is going to be a gating factor for us.*/
   InitTags();
   short type = current->getNodeType();
   if (type)
   {
      if (type == DOMNode::ELEMENT_NODE)
      {
         ReadTextures(current);
      }
   }
   DestroyTags();
}


void Slider::CustomProcessEvent(SDL_Event* event)
{
   button->ProcessEvent(event);
   if (event->type == SDL_MOUSEBUTTONUP && event->button.button == SDL_BUTTON_LEFT)
      drag = false;
}


void Slider::MouseMotion(SDL_Event* event)
{
   if (drag)
   {
      value = minvalue + GetMousePos(event);
   }
}


void Slider::LeftClick(SDL_Event* event)
{
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

