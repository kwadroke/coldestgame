#ifndef __PROGRESS_BAR_H
#define __PROGRESS_BAR_H

#include "GUI.h"

class ProgressBar : public GUI
{
   friend class GUI;
   public:
      ProgressBar(GUI*, TextureManager*);
      ~ProgressBar();
      void Render();
      void SetRange(int, int);
      int value;
      
   protected:
      void ReadNode(DOMNode*, GUI*);
      int minvalue, maxvalue;
      
};

#endif
