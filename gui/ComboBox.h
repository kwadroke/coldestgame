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
      void Select(int, bool doaction = true);
      void ReadNodeExtra(DOMNode* current, GUI* parentw);
      virtual bool FloatsInWidget(float, float);
      void Add(const string&);
      void Clear();
      
   protected:
      virtual void CustomProcessEvent(SDL_Event*);
      virtual void LeftDown(SDL_Event*);
      virtual void LeftClick(SDL_Event*);
      virtual void ReadSpecialNodes(DOMNode* current, GUI* parentw);
      virtual void PostReadNode(DOMNode*, GUI*);
      virtual void RenderWidget();
      
      Table* table;
      Button* button;
      float menuheight;
};

#endif
