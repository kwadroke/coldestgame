#ifndef __SCROLLVIEW_H
#define __SCROLLVIEW_H

#include "GUI.h"

class ScrollView : public GUI
{
   friend class GUI;
   friend class Table; // Allow table to add children
   public:
      ScrollView(GUI*, TextureManager*);
      ~ScrollView();
      void Render();
      bool InWidget(float, float);
      float scrollbarwidth;
      
   protected:
      float vpoffsetx, vpoffsety;
      float canvasx, canvasy;
      float scrollbarsize;
      float scrollamount;
      bool drag;
      
      void ReadNodeLocal(DOMNode*, GUI*);
      void ProcessEvent(SDL_Event*);
      void RecalculateSize();
};

#endif
