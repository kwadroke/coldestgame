#include "TextArea.h"

TextArea::TextArea(GUI* p, TextureManager* tm)
{
   Init(p, tm);
   table = new Table(this, texman);
   table->rowheight = 20;
   table->colwidths = ToString(width);
   table->x = 0;
   table->y = 0;
   maxlines = 100;
}


TextArea::~TextArea()
{
   delete table;
}


void TextArea::ReadNode(DOMNode *current, GUI* parentw)
{
   short type = current->getNodeType();
   if (type)
   {
      if (type == DOMNode::ELEMENT_NODE)
      {
         InitTags();
         
         ReadTextures(current);
         
         string curr;
         curr = ReadStringTag(current, tag.leftclickaction);
         if (curr != "")
         {
            leftclickaction = curr;
         }
         
         DestroyTags();
      }
      else if (type == DOMNode::TEXT_NODE)
      {
         char *currstr;
         currstr = XMLString::transcode(current->getNodeValue());
         if (string(currstr).find_first_not_of(" \n") != string::npos)
            Append(currstr);
         XMLString::release(&currstr);
      }
   }
}


void TextArea::Render()
{
   if (!visible) return;
   xoff = parent->xoff + parent->x;
   yoff = parent->yoff + parent->y;
   
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
}


void TextArea::Refresh()
{
   string currstring = "";
   string working = text;
   int swidth, sheight;
   int lastbreak = 0;
   bool foundbreak = false;
   bool newline = false;
   table->clear();
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
