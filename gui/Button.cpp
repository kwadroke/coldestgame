#include "Button.h"

Button::Button(GUI* p, TextureManager* tm) : toggle(false), togglestate(0)
{
   Init(p, tm);
}


Button::~Button()
{
}


void Button::RenderWidget()
{
   if (togglestate == 1)
      state = Clicked;
   else if (toggle && togglestate == 0 && state == Clicked)
      state = Normal;
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


void Button::ReadNodeExtra(DOMNode* current, GUI* parentw)
{
   string val = ReadAttribute(current, XSWrapper("toggle"));
   if (val == "true") toggle = true;
   UseDefaultTextures(ButtonTex);
}


void Button::LeftClick(SDL_Event* event)
{
   if (toggle)
   {
      if (togglestate == 0) togglestate = 1;
      else togglestate = 0;
   }
}

