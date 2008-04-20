#include "ComboBox.h"

ComboBox::ComboBox(GUI* p, TextureManager* tm)
{
   Init(p, tm);
   table = new Table(this, tm);
   table->visible = false;
   table->colwidths = ToString(width);
   table->rowheight = 20;
   button = new Button(this, tm);
   menuheight = 200.f;
}


ComboBox::~ComboBox()
{
   delete table;
   delete button;
}


void ComboBox::RenderWidget()
{
   table->textures[Normal] = textures[Normal];
   table->textures[Hover] = textures[Hover];
   table->textures[Clicked] = textures[Clicked];
   table->x = 0;
   table->y = height;
   table->width = width;
   table->height = menuheight;
   
   button->textures[Normal] = textures[Normal];
   button->textures[Hover] = textures[Hover];
   button->textures[Clicked] = textures[Clicked];
   button->x = 0;
   button->y = 0;
   button->width = width;
   button->height = height;
   
   glTranslatef(0, 0, 1);
   table->Render();
   glTranslatef(0, 0, -1);
   button->Render();
}


void ComboBox::LeftDown(SDL_Event* event)
{
   if (button->InWidget(event) && !table->visible)
   {
      table->visible = true;
   }
}


void ComboBox::LeftClick(SDL_Event* event)
{
   if (table->InWidget(event) && table->visible && !table->InScrollbar(event->motion.x, event->motion.y))
   {
      button->text = table->GetSelectedString(0);
      DoAction(valuechanged);
      table->visible = false;
   }
}


void ComboBox::CustomProcessEvent(SDL_Event* event)
{
   button->ProcessEvent(event);
   table->ProcessEvent(event);
   
   if (!InWidget(event) && event->type == SDL_MOUSEBUTTONDOWN)
      table->visible = false;
}


void ComboBox::ReadNodeExtra(DOMNode* current, GUI* parentw)
{
   table->colwidths = ToString(width);
   button->text = text;
}


void ComboBox::ReadSpecialNodes(DOMNode* current, GUI* parentw)
{
   if (current->getNodeName() == XSWrapper("ComboBoxItem"))
   {
      string newline = ReadStringTag(current, XSWrapper("ComboBoxItem"));
      table->Add(newline);
   }
}


int ComboBox::Selected()
{
   return table->Selected();
}


void ComboBox::Add(const string& str)
{
   table->Add(str);
}


void ComboBox::Clear()
{
   table->Clear();
}


bool ComboBox::FloatsInWidget(float xcoord, float ycoord)
{
   float extraheight = table->visible ? table->height : 0;
   if (xcoord > ((x + xoff) * wratio) &&
       xcoord < ((x + xoff + width) * wratio) &&
       ycoord > ((y + yoff) * hratio) &&
       ycoord < ((y + yoff + height + extraheight) * hratio))
      return true;
   return false;
}
