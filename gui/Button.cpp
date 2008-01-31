#include "Button.h"

Button::Button(GUI* p, TextureManager* tm)
{
   Init(p, tm);
}


Button::~Button()
{
   //Cleanup();
}


void Button::ReadNode(DOMNode* current, GUI* parent)
{
   /* This is not the most efficient way to handle tags, but it's the least troublesome and
      I somehow doubt that XML parsing performance is going to be a gating factor for us.*/
   InitTags();
   short type = current->getNodeType();
   if (type)
   {
      if (type == DOMNode::ELEMENT_NODE)
      {
         ReadTextures(current);
         string curr;
         curr = ReadStringTag(current, tag.leftclickaction);
         if (curr != "")
         {
            leftclickaction = curr;
         }
      }
   }
   DestroyTags();
}


void Button::Render()
{
   if (!visible) return;
   xoff = parent->xoff + parent->x;
   yoff = parent->yoff + parent->y;
   RenderBase();
   int w, h;
   StringDim(font, text, w, h);
   float fh = (float)h / hratio;
   float fw = (float)w / wratio;
   
   float scale = (width - xmargin * 2.f) / fw;
   fh *= scale;
   if (fh > height - ymargin * 2.f)
   {
      fh = (float)h / hratio;
      scale = (height - ymargin * 2.f) / fh;
      fh *= scale;
   }
   float centery = height / 2.f - fh / 2.f;
   fw *= scale;
   float centerx = 0.f;
   if (align == Center)
      centerx = (width - fw) / 2.f - xmargin;
   RenderText(text, oldtext, int((x + xoff + xmargin + centerx) * wratio), int((y + yoff + centery) * hratio), 0, font, texttexture, scale);
   oldtext = text;
}

