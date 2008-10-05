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
      void Build(string, GUI*);
      string Text(int);
      
   protected:
      virtual void RenderWidget();
      virtual void LeftDown(SDL_Event*);
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      
      GUI* tablep;
      bool selected;
};

#endif
