#ifndef __LINEEDIT_H
#define __LINEEDIT_H

#include <string>
#include "GUI.h"

class LineEdit : public GUI
{
   public:
      LineEdit(GUI*, TextureManager*);
      ~LineEdit();
      void Render();
      
   protected:
      void ReadNode(DOMNode*, GUI*);
      void ProcessEvent(SDL_Event*);
      int CalculateMousePos(int, int);
      void InsertChar(char);
      void BSChar();
      void DeleteChar();
      string GetVisible();
      
      int cursorpos;
      int offset;
      int dragstart, dragend;
      
      // Copying not allowed
      LineEdit(const LineEdit&);
      LineEdit& operator=(const LineEdit&);
};

#endif
