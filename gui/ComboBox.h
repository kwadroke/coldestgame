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
      int Selected();
      void ReadNodeExtra(DOMNode* current, GUI* parentw);
      virtual bool FloatsInWidget(float, float);
      void Add(const string&);
      void Clear();
      
   protected:
      void CustomProcessEvent(SDL_Event*);
      void LeftDown(SDL_Event*);
      void LeftClick(SDL_Event*);
      void ReadSpecialNodes(DOMNode* current, GUI* parentw);
      void RenderWidget();
      
      Table* table;
      Button* button;
      float menuheight;
};

#endif
