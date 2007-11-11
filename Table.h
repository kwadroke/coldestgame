#ifndef __TABLE_H
#define __TABLE_H

#include "GUI.h"
#include "TableItem.h"
#include "ScrollView.h"

class Table : public GUI
{
   friend class GUI;
   friend class TableItem;
   friend class ComboBox;
   public:
      Table(GUI*, TextureManager*);
      ~Table();
      void Render();
      void ProcessEvent(SDL_Event*);
      void clear();
      void Add(string);
      int Selected();
      string GetSelectedString(int);
      bool InScrollbar(float, float);
      
   protected:
      void ReadNode(DOMNode*, GUI*);
      
      //vector<TableItem*> rows;
      ScrollView* scrollview;
      //int columns;
      string colwidths;
      float rowheight;
};

#endif
