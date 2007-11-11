#ifndef __TABLEITEM_H
#define __TABLEITEM_H

#include "GUI.h"
#include "LineEdit.h"

class TableItem : public GUI
{
   friend class Table;
   friend class ComboBox;
   public:
      TableItem(GUI*, TextureManager*);
      ~TableItem();
      void Render();
      void ProcessEvent(SDL_Event*);
      void Build(string, GUI*);
      string Text(int);
      
   protected:
      void ReadNode(DOMNode*, GUI*);
      
      GUI* tablep;
      bool selected;
};

#endif
