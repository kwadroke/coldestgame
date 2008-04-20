#ifndef __SLIDER_H
#define __SLIDER_H

#include "GUI.h"
#include "Button.h"

class Slider : public GUI
{
   friend class GUI;
   public:
      Slider(GUI*, TextureManager*);
      ~Slider();
      void SetRange(int, int);
      int value;
      
   protected:
      int GetMousePos(const SDL_Event*);
      virtual void CustomProcessEvent(SDL_Event*);
      virtual void MouseMotion(SDL_Event*);
      virtual void LeftDown(SDL_Event*);
      virtual void WheelDown(SDL_Event*);
      virtual void WheelUp(SDL_Event*);
      virtual void GlobalLeftClick(SDL_Event*);
      void RenderWidget();
      
      Button *button;
      int minvalue, maxvalue;
      int sliderheight, sliderwidth;
      bool drag;
      float dragoffset;
};

#endif
