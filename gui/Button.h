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
   public:
      Button(GUI*, TextureManager*);
      ~Button();
      
   protected:
      void RenderWidget();
      
      // Copying not allowed
      Button(const Button&);
      Button& operator=(const Button&);
};

#endif
