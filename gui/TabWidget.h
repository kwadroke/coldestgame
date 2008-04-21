#ifndef __TABWIDGET_H
#define __TABWIDGET_H

#include "GUI.h"
#include "Button.h"
#include "ScrollView.h"
#include <vector>

using std::vector;

class TabWidget : public GUI
{
   friend class GUI;
   public:
      TabWidget(GUI*, TextureManager*);
      ~TabWidget();
      virtual GUI* GetWidget(string);
      
   protected:
      virtual void RenderWidget();
      virtual void ReadSpecialNodes(DOMNode*, GUI*);
      virtual void CustomProcessEvent(SDL_Event*);
      virtual void LeftClick(SDL_Event*);
      void GetNextButtonPosition(float&, float&);
      
      // Copying not allowed
      TabWidget(const TabWidget&);
      TabWidget& operator=(const TabWidget&);
      
      vector<ButtonPtr> buttons;
      vector<ScrollViewPtr> scrollviews;
      float buttonspacing, buttonheight;
};

#endif
