#ifndef __LINEEDIT_H
#define __LINEEDIT_H

#include <string>
#include "GUI.h"

class LineEdit : public GUI
{
   public:
      LineEdit(GUI*, TextureManager*);
      ~LineEdit();
      
   protected:
      int CalculateMousePos(int, int);
      void InsertChar(char);
      void BSChar();
      void DeleteChar();
      string GetVisible();
      void RenderWidget();
      virtual void MouseMotion(SDL_Event*);
      virtual void LeftClick(SDL_Event*);
      virtual void LeftDown(SDL_Event*);
      virtual void KeyDown(SDL_Event*);
      virtual void ReadNodeExtra(DOMNode*, GUI*);
      
      int cursorpos;
      int offset;
      int dragstart, dragend;
      
      // Copying not allowed - this may not be necessary anymore
      LineEdit(const LineEdit&);
      LineEdit& operator=(const LineEdit&);
};

#endif
