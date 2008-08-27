#include "Table.h"

// TODO (maybe): There's an awful lot of downcasting going on in this class.  Can we get rid of it?
// It's relatively safe right now because it's all with scrollview's children, which is a private
// member so we know what gets put into it, but it still seems like a kludge

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


void Table::ReadNodeExtra(DOMNode *current, GUI* parentw)
{
   colwidths = ReadAttribute(current, XSWrapper("colwidths"));
   rowheight = atof(ReadAttribute(current, XSWrapper("rowheight")).c_str());
   scrollview->ReadNodeExtra(current, this);
}
      
      
void Table::ReadSpecialNodes(DOMNode *current, GUI* parentw)
{
   if (current->getNodeName() == XSWrapper("TableItem"))
   {
      string newitem = ReadStringTag(current, XSWrapper("TableItem"));
      Add(newitem);
   }
}


void Table::RenderWidget()
{
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
   // This has to stay here (not in LeftDown) because it has to happen before scrollview processes the event
   if (event->type == SDL_MOUSEBUTTONDOWN && event->button.button == SDL_BUTTON_LEFT && InWidget(event))
   {
      guiiter i;
      for (i = scrollview->children.begin(); i != scrollview->children.end(); ++i)
         ((TableItem*)(*i).get())->selected = false;
   }
   
   scrollview->ProcessEvent(event);
}


void Table::Clear()
{
   delete scrollview;  // Leaking memory like a sieve is fun for the whole family!!!
                       // Ah, learned something about virtual destructors from this...
                       // (i.e. it no longer leaks, but I'm leaving the comment because it amuses me:-)
   scrollview = new ScrollView(this, texman);
}


void Table::Add(string vals)
{
   GUIPtr newitemptr = GUIPtr(new TableItem(this, texman));
   TableItem* newitem = (TableItem*)newitemptr.get();
   newitem->Build(vals, this);
   newitem->parent = scrollview;
   scrollview->children.push_back(newitemptr);
}


int Table::Selected()
{
   int selected = 0;
   guiiter i;
   for (i = scrollview->children.begin(); i != scrollview->children.end(); ++i)
   {
      if ( (dynamic_cast<TableItem*>((*i).get()))->selected )
      {
         return selected;
      }
      ++selected;
   }
   return -1;
}


void Table::Select(int n)
{
   int selected = 0;
   guiiter i;
   for (i = scrollview->children.begin(); i != scrollview->children.end(); ++i)
   {
      TableItem* curritem = (dynamic_cast<TableItem*>((*i).get()));
      if (selected == n)
      {
         curritem->selected = true;
      }
      else curritem->selected = false;
      ++selected;
   }
}


string Table::GetSelectedString(int num)
{
   guiiter i;
   for (i = scrollview->children.begin(); i != scrollview->children.end(); ++i)
   {
      TableItem* item = dynamic_cast<TableItem*>((*i).get());
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


void Table::ScrollToBottom()
{
   scrollview->height = height - 10; // This must be done first, or in some cases we get strange behavior
   scrollview->ScrollToBottom();
}

