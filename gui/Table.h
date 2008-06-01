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
   friend class TextArea;
   public:
      Table(GUI*, TextureManager*);
      ~Table();
      void Clear();
      void Add(string);
      int Selected();
      void Select(int);
      string GetSelectedString(int);
      bool InScrollbar(float, float);
      void ScrollToBottom();
      
   protected:
      virtual void RenderWidget();
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      virtual void ReadSpecialNodes(DOMNode*, GUI*);
      virtual void CustomProcessEvent(SDL_Event*);
      
      ScrollView* scrollview;
      string colwidths;
      float rowheight;
};

#endif
