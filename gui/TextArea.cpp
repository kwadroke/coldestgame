#include "TextArea.h"

TextArea::TextArea(GUI* p, TextureManager* tm)
{
   Init(p, tm);
   table = new Table(this, texman);
   table->rowheight = 20;
   table->colwidths = ToString(width);
   table->x = 0;
   table->y = 0;
   table->width = width;
   table->height = height;
   maxlines = 100;
}


TextArea::~TextArea()
{
   delete table;
}


void TextArea::ReadNodeExtra(DOMNode *current, GUI* parentw)
{
   string newval = ReadStringTag(current, XSWrapper("TextArea"));
   if (newval.find_first_not_of(" \n\t") != string::npos)
      Append(newval);
   table->ReadNodeExtra(current, this);
}


void TextArea::RenderWidget()
{
   RenderBase();
   
   table->width = width;
   table->height = height;
   table->Render();
}


void TextArea::CustomProcessEvent(SDL_Event* event)
{
   table->ProcessEvent(event);
}


void TextArea::Append(string s)
{
   text += s;
   Refresh();
   ScrollToBottom();
}


void TextArea::Refresh()
{
   string currstring = "";
   string working = text + "\n"; // \n because otherwise the last line is not read properly
   int swidth, sheight;
   int lastbreak = 0;
   bool foundbreak = false;
   bool newline = false;
   table->Clear();
   for (int i = 1; i < working.length(); ++i)
   {
      if (working[i] == ' ' || working[i] == '\n')
      {
         lastbreak = i;
         foundbreak = true;
         if (working[i] == '\n')
         {
            newline = true;
            foundbreak = false;
         }
      }
      
      StringDim(font, working.substr(0, i), swidth, sheight);
      float scale = (table->rowheight - ymargin * 2.f) * hratio / (float)sheight;
      float fw = (float)swidth / wratio * scale;
      
      if ((fw > width - xmargin * 2.f) || newline)
      {
         if (!foundbreak)
            lastbreak = i;
         
         table->Add(working.substr(0, lastbreak));
         
         // If we didn't actually find a space then don't skip a character
         if (!foundbreak && !newline)
            --lastbreak;
         working = working.substr(lastbreak + 1);
         foundbreak = false;
         newline = false;
         lastbreak = 0;
         i = 1;
      }
   }
}


void TextArea::ScrollToBottom()
{
   table->height = height;
   table->ScrollToBottom();
}
