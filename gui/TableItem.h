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
      void Build(string, GUI*);
      string Text(int);
      
   protected:
      void ReadNode(DOMNode*, GUI*);
      void LeftDown(SDL_Event*);
      
      GUI* tablep;
      bool selected;
};

#endif
