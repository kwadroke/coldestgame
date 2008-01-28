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
      void Render();
      void Append(string);
      void Refresh();
      
   protected:
      void ReadNode(DOMNode*, GUI*);
      void CustomProcessEvent(SDL_Event*);
      
      Table *table;
      int maxlines;
};

#endif
