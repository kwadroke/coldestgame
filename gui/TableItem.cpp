#include "TableItem.h"
#include "Table.h" // Circular dependency, so can't go in header file

TableItem::TableItem(GUI* p, TextureManager* tm)
{
   Init(p, tm);
   tablep = p;
   selected = false;
}


TableItem::~TableItem()
{
   //Cleanup();
}


void TableItem::Build(string vals, GUI* parentw)
{
   Table* p = (Table*)parentw;
   string remaining = p->colwidths;
   height = p->rowheight;
   y = p->scrollview->children.size() * p->rowheight;
   string currval;
   vector<float> widths;
   vector<string> values;
   while (remaining.length())
   {
      currval = remaining.substr(0, remaining.find("|"));
      if (remaining.find("|") != string::npos)
         remaining = remaining.substr(remaining.find("|") + 1);
      else remaining = "";
      widths.push_back(atof(currval.c_str()));
   }
   
   remaining = vals;
   while (remaining.length())
   {
      currval = remaining.substr(0, remaining.find("|"));
      if (remaining.find("|") != string::npos)
         remaining = remaining.substr(remaining.find("|") + 1);
      else remaining = "";
      values.push_back(currval);
   }
   
   int len = widths.size() < values.size() ? widths.size() : values.size();
   float pos = 0;
   for (int i = 0; i < len; ++i)
   {
      GUIPtr newle = GUIPtr(new LineEdit(this, texman));
      newle->x = pos;
      newle->y = 0;
      newle->width = widths[i];
      newle->height = p->rowheight;
      newle->text = values[i];
      newle->readonly = true;
      children.push_back(newle);
      pos += widths[i];
   }
   width = pos;
   textures[Clicked] = parentw->textures[Clicked];
}


void TableItem::RenderWidget()
{
   if (selected) state = Clicked;
   else state = Normal;
   RenderBase();
}


void TableItem::LeftDown(SDL_Event* event)
{
   selected = true;
}


string TableItem::Text(int num)
{
   int i = 0;
   guiiter it = children.begin();
   while (i < num)
   {
      ++it;
      ++i;
   }
   return (*it)->text;
}
