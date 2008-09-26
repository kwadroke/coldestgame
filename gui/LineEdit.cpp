#include "LineEdit.h"

LineEdit::LineEdit(GUI* p, TextureManager* tm)
{
   cursorpos = dragstart = dragend = offset = 0;
   Init(p, tm);
}


LineEdit::~LineEdit()
{
   //Cleanup();
}


void LineEdit::RenderWidget()
{
   RenderBase();
   int w, h;
   if (active)
   {
      if (offset > text.length()) offset = 0;
      if (cursorpos > text.length()) cursorpos = 0;
      string textlen = text.substr(offset, cursorpos);
      StringDim(font, textlen, w, h);
      float fw = (float)w / wratio * fontscale;
      texman->BindTexture(textures[Hover]);
      glBegin(GL_TRIANGLE_STRIP);
      glTexCoord2i(0, 0);
      glVertex2f((x + xoff + fw) * wratio, (y + yoff) * hratio);
      glTexCoord2i(0, 1);
      glVertex2f((x + xoff + fw) * wratio, (y + yoff + height) * hratio);
      glTexCoord2i(1, 0);
      glVertex2f((x + xoff + fw + 2) * wratio, (y + yoff) * hratio);
      glTexCoord2i(1, 1);
      glVertex2f((x + xoff + fw + 2) * wratio, (y + yoff + height) * hratio);
      glEnd();
   }
   
   if (text != "") // Empty text messes up our scale calculations, and there's no need to do them if we're not rendering any
   {
      StringDim(font, text, w, h);
      float fh = (float)h / hratio;
      float fw = (float)w / wratio;
      
      float scale = (height - ymargin * 2.f) / fh;
      fh *= scale;
      
      float centery = height / 2.f - fh / 2.f;
      RenderText(text, oldtext, int((x + xoff + xmargin) * wratio), int((y + yoff + centery) * hratio), 0, font, texttexture, scale);
      oldtext = text;
      fontscale = scale;
   }
   
   /*StringDim(font, GetVisible(), w, h);
   float centery = height / 2.f - h * fontscale / hratio / 2.f;
   RenderText(GetVisible(), int((x + xoff + 1.f) * wratio), int((y + yoff + centery) * hratio), 0, font, texttexture, fontscale);*/
}


void LineEdit::LeftDown(SDL_Event* event)
{
   dragstart = CalculateMousePos(event->motion.x, event->motion.y);
   cursorpos = dragstart;
}


void LineEdit::LeftClick(SDL_Event* event)
{
   dragend = CalculateMousePos(event->motion.x, event->motion.y);
}


void LineEdit::MouseMotion(SDL_Event* event)
{
   if (state == Clicked)
   {
      dragend = CalculateMousePos(event->motion.x, event->motion.y);
      //Drag
   }
}


void LineEdit::KeyDown(SDL_Event* event)
{
   if (readonly) return;
   switch (event->key.keysym.sym) 
   {
      case SDLK_BACKSPACE:
         BSChar();
         break;
      case SDLK_DELETE:
         DeleteChar();
         break;
      case SDLK_LEFT:
         --cursorpos;
         if (cursorpos < 0)
         {
            if (offset > 0) --offset;
            
            cursorpos = 0;
         }
         break;
      case SDLK_RIGHT:
         if (cursorpos + offset < text.length())
            ++cursorpos;
         if (cursorpos > GetVisible().length())
         {
            ++offset;
            --cursorpos;
         }
         break;
      default:
         char c = event->key.keysym.unicode;
         if (int(c) != 0)
            InsertChar(c);
         break;
   }
   cout << event->key.keysym.unicode << endl;
}


// Determine where the mouse is relative to the characters currently visible
int LineEdit::CalculateMousePos(int mx, int my)
{
   float vx;
   vx = (float)mx / wratio;
   
   if (vx <= x + xoff) return 0;
   int counter = 1;
   int strw, strh;
   string temp = GetVisible().substr(0, counter);
   StringDim(font, temp, strw, strh);
   while (vx > x + xoff + strw / wratio * fontscale && temp.length() < GetVisible().length())
   {
      ++counter;
      temp = GetVisible().substr(0, counter);
      StringDim(font, temp, strw, strh);
   }
   if (vx > x + xoff + strw / wratio * fontscale)
      ++counter;
   return counter - 1;
}


void LineEdit::InsertChar(char c)
{
   text.insert(offset + cursorpos, 1, c);
   ++cursorpos;
   if (cursorpos > GetVisible().length())
   {
      ++offset;
      --cursorpos;
   }
}


void LineEdit::BSChar()
{
   if (cursorpos == 0) return;
   text.replace(offset + cursorpos - 1, 1, "");
   --cursorpos;
   if (cursorpos < 0)
   {
      --offset;
      if (offset < 0)
         offset = 0;
      cursorpos = 0;
   }
}


void LineEdit::DeleteChar()
{
   if (cursorpos == GetVisible().length()) return;
   text.replace(offset + cursorpos, 1, "");
}


string LineEdit::GetVisible()
{
   string available = text.substr(offset);
   int counter = 1;
   int strw, strh;
   StringDim(font, available.substr(0, counter), strw, strh);
   while (strw / wratio * fontscale < width - 2.f && available.substr(0, counter).length() < available.length())
   {
      ++counter;
      StringDim(font, available.substr(0, counter), strw, strh);
   }
   if (counter < available.length() || strw / wratio * fontscale >= width - 2.f) --counter;
   return available.substr(0, counter);
}

