#ifndef __BUTTON_H
#define __BUTTON_H

#include <string>
#include "GUI.h"

using namespace std;

/**********************************************************************************
** When you make changes to this file make sure they are duplicated in the forward
** declaration in GUI.cpp as well - UPDATE: Fwd dec should no longer be needed
**********************************************************************************/
class Button : public GUI
{
   friend class GUI;
   friend class ComboBox;
   friend class Slider;
   public:
      Button(GUI*, TextureManager*);
      ~Button();
      void Render();
      
   protected:
      void ReadNode(DOMNode*, GUI*);
      
      // Copying not allowed
      Button(const Button&);
      Button& operator=(const Button&);
};

#endif
