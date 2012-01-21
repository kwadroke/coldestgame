// @Begin License@
// This file is part of Coldest.
//
// Coldest is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Coldest is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008-2012 Ben Nemec
// @End License@


#include "ComboBox.h"

ComboBox::ComboBox(GUI* p, TextureManager* tm)
{
   Init(p, tm);
   table = new Table(this, tm);
   table->visible = false;
   table->colwidths = ToString(width);
   table->rowheight = 30;
   button = new Button(this, tm);
   menuheight = 300.f;
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
}


void ComboBox::LeftClick(SDL_Event* event)
{
   if (table->InWidget(event) && table->visible && !table->InScrollbar(event->motion.x, event->motion.y))
   {
      button->text = table->GetSelectedString(0);
      DoAction(valuechanged);
      table->visible = false;
      event->type = SDL_USEREVENT; // ComboBox tables eat events, so make sure nobody else processes this
   }
   
   if (button->InWidget(event) && !table->visible)
   {
      table->visible = true;
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
   float buffer;
   buffer = atof(ReadAttribute(current, XSWrapper("rowheight")).c_str());
   if (!floatzero(buffer))
      table->rowheight = buffer;
   buffer = atof(ReadAttribute(current, XSWrapper("menuheight")).c_str());
   if (!floatzero(buffer))
      menuheight = buffer;
}


void ComboBox::ReadSpecialNodes(DOMNode* current, GUI* parentw)
{
   if (current->getNodeName() == XSWrapper("ComboBoxItem"))
   {
      string newline = ReadStringTag(current, XSWrapper("ComboBoxItem"));
      table->Add(newline);
   }
}


void ComboBox::PostReadNode(DOMNode* current, GUI* parentw)
{
   string val = ReadAttribute(current, XSWrapper("selected"));
   if (val != "")
      Select(atoi(val.c_str()), false);
}


int ComboBox::Selected()
{
   return table->Selected();
}


string ComboBox::SelectedText()
{
   return button->text;
}


void ComboBox::Select(int i, bool doaction)
{
   table->Select(i);
   if (doaction)
      DoAction(valuechanged);
   button->text = table->GetSelectedString(0);
}


void ComboBox::Add(const string& str)
{
   table->Add(str);
}


void ComboBox::Clear()
{
   table->Clear();
   button->text = "";
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
