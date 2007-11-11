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
      void ProcessEvent(SDL_Event*);
      void ReadNode(DOMNode* current, GUI* parentw);
      int Selected();
      
   protected:
      Table* table;
      Button* button;
      float menuheight;
};

#endif
