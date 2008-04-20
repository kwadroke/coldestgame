#include "ProgressBar.h"

ProgressBar::ProgressBar(GUI* p, TextureManager* tm)
{
   value = 0;
   minvalue = 0;
   maxvalue = 100;
   Init(p, tm);
}


ProgressBar::~ProgressBar()
{
   //Cleanup();
}


void ProgressBar::SetRange(int min, int max)
{
   minvalue = min;
   maxvalue = max;
}


void ProgressBar::RenderWidget()
{
   RenderBase();
   
   float position = (float)(value - minvalue) / (float)(maxvalue - minvalue) * width;
   texman->BindTexture(textures[Hover]);
   glBegin(GL_TRIANGLE_STRIP);
   glTexCoord2i(0, 0);
   glVertex2f((x + xoff) * wratio, (y + yoff) * hratio);
   glTexCoord2i(0, 1);
   glVertex2f((x + xoff) * wratio, (y + yoff + height) * hratio);
   glTexCoord2i(1, 0);
   glVertex2f((x + xoff + position) * wratio, (y + yoff) * hratio);
   glTexCoord2i(1, 1);
   glVertex2f((x + xoff + position) * wratio, (y + yoff + height) * hratio);
   glEnd();
}

