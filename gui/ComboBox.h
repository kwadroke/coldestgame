#ifndef __COMBOBOX_H
#define __COMBOBOX_H

#include "GUI.h"
#include "Table.h"
#include "TableItem.h"
#include "Button.h"

class ComboBox : public GUI
{
   friend class GUI;
   public:
      ComboBox(GUI*, TextureManager*);
      ~ComboBox();
      void Render();
      void ReadNode(DOMNode* current, GUI* parentw);
      int Selected();
      virtual bool InWidget(float, float);
      
   protected:
      void CustomProcessEvent(SDL_Event*);
      void LeftDown(SDL_Event*);
      void LeftClick(SDL_Event*);
      
      Table* table;
      Button* button;
      float menuheight;
};

#endif
