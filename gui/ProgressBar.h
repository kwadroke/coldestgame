#ifndef __PROGRESS_BAR_H
#define __PROGRESS_BAR_H

#include "GUI.h"

class ProgressBar : public GUI
{
   friend class GUI;
   public:
      ProgressBar(GUI*, TextureManager*);
      ~ProgressBar();
      void SetRange(int, int);
      int value;
      
   protected:
      void RenderWidget();
      
      int minvalue, maxvalue;
      
};

#endif
