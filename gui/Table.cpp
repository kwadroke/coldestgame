#include "Table.h"

Table::Table(GUI* p, TextureManager* tm)
{
   Init(p, tm);
   colwidths = "";
   rowheight = 0;
   scrollview = new ScrollView(this, texman);
}


Table::~Table()
{
   delete scrollview;
   //Cleanup();
}


void Table::ReadNode(DOMNode *current, GUI* parentw)
{
   if (current->getNodeType() &&
       current->getNodeType() == DOMNode::ELEMENT_NODE)
   {
      InitTags();
      ReadTextures(current);
      
      GUI* newwidget;
      
      if (XMLString::equals(current->getNodeName(), tag.tableitem))
         newwidget = new TableItem(parentw, texman);
      else return; // Not a node we recognize
      
      string val = ReadAttribute(current, attrib.readonly);
      if (val == "true") newwidget->readonly = true; // Defaults to false
      
      DOMNodeList* tichildren = current->getChildNodes();
      for (int i = 0; i < tichildren->getLength(); ++i)
         ((TableItem*)newwidget)->ReadNode(tichildren->item(i), this);
      newwidget->parent = scrollview;
      scrollview->children.push_back((TableItem*)newwidget);
      
      DestroyTags();
   }
}


void Table::Render()
{
   if (!visible) return;
   xoff = parent->xoff + parent->x;
   yoff = parent->yoff + parent->y;
   RenderBase();
   
   // Can't be done in the constructor because these values haven't been set yet
   scrollview->x = 0;
   scrollview->y = 10;
   scrollview->width = width;
   scrollview->height = height - 10;
   scrollview->Render();
}


void Table::CustomProcessEvent(SDL_Event* event)
{
   if (event->type == SDL_MOUSEBUTTONDOWN && event->button.button == SDL_BUTTON_LEFT && InWidget(event))
   {
      guiiter i;
      for (i = scrollview->children.begin(); i != scrollview->children.end(); ++i)
         ((TableItem*)(*i))->selected = false;
   }
   
   scrollview->ProcessEvent(event);
}


void Table::LeftDown(SDL_Event* event)
{
   
}


void Table::clear()
{
   
   delete scrollview;  // Leaking memory like a sieve is fun for the whole family!!!
                       // Ah, learned something about virtual destructors from this...
                       // (i.e. it no longer leaks, but I'm leaving the comment because it amuses me:-)
   scrollview = new ScrollView(this, texman);
}


void Table::Add(string vals)
{
   TableItem* newitem = new TableItem(this, texman);
   newitem->Build(vals, this);
   newitem->parent = scrollview;
   scrollview->children.push_back(newitem);
}


int Table::Selected()
{
   int selected = 0;
   guiiter i;
   for (i = scrollview->children.begin(); i != scrollview->children.end(); ++i)
   {
      if ( (dynamic_cast<TableItem*>(*i))->selected )
      {
         return selected;
      }
      ++selected;
   }
   return -1;
}


string Table::GetSelectedString(int num)
{
   guiiter i;
   for (i = scrollview->children.begin(); i != scrollview->children.end(); ++i)
   {
      TableItem* item = dynamic_cast<TableItem*>(*i);
      if ( item->selected )
      {
         return item->Text(num);
      }
   }
   return "";
}


bool Table::InScrollbar(float xcoord, float ycoord)
{
   if (xcoord > ((x + xoff + width - scrollview->scrollbarwidth) * wratio) &&
       xcoord < ((x + xoff + width) * wratio) &&
       ycoord > ((y + yoff) * hratio) &&
       ycoord < ((y + yoff + height) * hratio))
      return true;
   return false;
}

