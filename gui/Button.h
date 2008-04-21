#ifndef __BUTTON_H
#define __BUTTON_H

#include <string>
#include "GUI.h"

using namespace std;

class Button : public GUI
{
   friend class GUI;
   friend class ComboBox;
   friend class Slider;
   friend class TabWidget;
   public:
      Button(GUI*, TextureManager*);
      ~Button();
      
      bool toggle;
      int togglestate;
      
   protected:
      virtual void RenderWidget();
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      virtual void LeftClick(SDL_Event*);
      
      // Copying not allowed
      Button(const Button&);
      Button& operator=(const Button&);
};

typedef shared_ptr<Button> ButtonPtr;

#endif
