#include "TabWidget.h"

TabWidget::TabWidget(GUI* p, TextureManager* tm) : buttonspacing(10.f), buttonheight(30.f)
{
   Init(p, tm);
}


TabWidget::~TabWidget()
{
}


void TabWidget::RenderWidget()
{
   RenderBase();
   
   for (int i = 0; i < buttons.size(); ++i)
   {
      buttons[i]->Render();
      scrollviews[i]->Render();
   }
}


void TabWidget::ReadSpecialNodes(DOMNode* current, GUI* parentw)
{
   if (current->getNodeName() == XSWrapper("Tab"))
   {
      float buttonwidth = atof(ReadAttribute(current, XSWrapper("buttonwidth")).c_str());
      string buttontext = ReadAttribute(current, XSWrapper("text"));
      
      ButtonPtr newbutton = ButtonPtr(new Button(this, texman));
      float newx, newy;
      GetNextButtonPosition(newx, newy);
      newbutton->x = newx;
      newbutton->y = newy;
      newbutton->width = buttonwidth;
      newbutton->height = buttonheight;
      newbutton->text = buttontext;
      newbutton->toggle = true;
      if (!buttons.size())
         newbutton->togglestate = 1;
      newbutton->textures = ReadTextures(current, "button");
      buttons.push_back(newbutton);
      
      ScrollViewPtr newsv = ScrollViewPtr(new ScrollView(this, texman));
      newsv->x = 0;
      newsv->y = buttonheight;
      newsv->width = width;
      newsv->height = height - buttonheight;
      newsv->name = buttontext + " Tab";
      newsv->textures = ReadTextures(current);
      if (scrollviews.size())
      {
         newsv->visible = false;
      }
      scrollviews.push_back(newsv);
      
      // This is a weird case - we're reading a node without actually creating a new GUI object for it,
      // so we have to read the children of the Tab here (maybe not strictly true, there's probably some
      // way to make it work in ReadNode, but it would probably be a bit messy)
      DOMNodeList* c = current->getChildNodes();
      for (int i = 0; i < c->getLength(); ++i)
      {
         DOMNode* currnode = c->item(i);
         newsv->ReadNode(currnode, newsv.get());
      }
   }
}


void TabWidget::GetNextButtonPosition(float& x, float& y)
{
   y = 0.f; // Only one row of buttons currently supported, so they'll all be here
   x = 0.f;
   for (int i = 0; i < buttons.size(); ++i)
   {
      x += buttons[i]->width + buttonspacing;
   }
}


void TabWidget::CustomProcessEvent(SDL_Event* event)
{
   for (int i = 0; i < buttons.size(); ++i)
   {
      buttons[i]->ProcessEvent(event);
      scrollviews[i]->ProcessEvent(event);
   }
}


void TabWidget::LeftClick(SDL_Event* event)
{
   int selected = -1;
   for (int i = 0; i < buttons.size(); ++i)
   {
      if (buttons[i]->InWidget(event))
      {
         selected = i;
         if (!buttons[i]->togglestate)
            buttons[i]->togglestate = 1;
         scrollviews[i]->visible = true;
      }
   }
   
   if (selected == -1) return;
   
   for (int i = 0; i < buttons.size(); ++i)
   {
      if (i == selected) continue;
      buttons[i]->togglestate = 0;
      scrollviews[i]->visible = false;
   }
}


// Essentially the same as in GUI, except we iterate over scrollviews instead of children
GUI* TabWidget::GetWidget(string findname)
{
   if (name == findname)
      return this;
   
   GUI* ret;
   for (int i = 0; i < scrollviews.size(); ++i)
   {
      ret = scrollviews[i]->GetWidget(findname);
      if (ret) return ret;
   }
   return NULL;
}

