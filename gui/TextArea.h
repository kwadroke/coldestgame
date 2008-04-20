#ifndef __TEXTAREA_H
#define __TEXTAREA_H

#include "GUI.h"
#include "Table.h"
#include "SDL.h"
#include <string>
#include <deque>

using std::string;
using std::vector;

class TextArea : public GUI
{
   friend class GUI;
   public:
      TextArea(GUI*, TextureManager*);
      ~TextArea();
      void Append(string);
      void Refresh();
      void ScrollToBottom();
      
   protected:
      void ReadNodeExtra(DOMNode*, GUI*);
      void CustomProcessEvent(SDL_Event*);
      void RenderWidget();
      
      Table *table;
      int maxlines;
};

#endif
