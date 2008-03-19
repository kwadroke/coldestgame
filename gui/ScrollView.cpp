#include "ScrollView.h"

ScrollView::ScrollView(GUI* p, TextureManager* tm) : vpoffsetx(0), vpoffsety(0),
                       scrollbarwidth(10.f), scrollbarsize(10.f), drag(false)
{
   Init(p, tm);
}


ScrollView::~ScrollView()
{
   //Cleanup();
}


void ScrollView::Render()
{
   if (!visible) return;
   xoff = parent->x + parent->xoff;
   yoff = parent->y + parent->yoff;
   RenderBase();
   // xoff and yoff are slightly different for scrollviews, the rest of the class expects
   // xoff - vpoffsetx as the value for xoff (same for yoff)
   xoff -= vpoffsetx;
   yoff -= vpoffsety;
   
   // Render scrollbar
   float scrollbarpos = vpoffsety / scrollamount / hratio;
   texman->BindTexture(textures[0]);
   glBegin(GL_TRIANGLE_STRIP);
   glTexCoord2i(0, 0);
   glVertex2f((x + xoff + vpoffsetx + width - scrollbarwidth) * wratio, (y + yoff + vpoffsety + scrollbarpos) * hratio);
   glTexCoord2i(0, 1);
   glVertex2f((x + xoff + vpoffsetx + width - scrollbarwidth) * wratio, (y + yoff + scrollbarsize + vpoffsety + scrollbarpos) * hratio);
   glTexCoord2i(1, 0);
   glVertex2f((x + xoff + vpoffsetx + width) * wratio, (y + yoff + vpoffsety + scrollbarpos) * hratio);
   glTexCoord2i(1, 1);
   glVertex2f((x + xoff + vpoffsetx + width) * wratio, (y + yoff + scrollbarsize + vpoffsety + scrollbarpos) * hratio);
   glEnd();
   
   // Render children, clipped to the scrollview using the scissor test
   glEnable(GL_SCISSOR_TEST);
   int scissorcoords[4];
   scissorcoords[0] = (int)((x + xoff + vpoffsetx) * wratio);
   scissorcoords[1] = (int)(actualh - (y + yoff + height + vpoffsety) * hratio);
   scissorcoords[2] = (int)((width - scrollbarwidth) * wratio);
   scissorcoords[3] = (int)(height * hratio);
   glScissor(scissorcoords[0], scissorcoords[1], scissorcoords[2], scissorcoords[3]);
   
   guiiter i;
   for (i = children.begin(); i != children.end(); ++i)
   {
      (*i)->Render();
   }
   glDisable(GL_SCISSOR_TEST);
}


// ScrollView needs to use the base ReadNode, so don't override it
void ScrollView::ReadNodeLocal(DOMNode* current, GUI* parent)
{
   InitTags();
   short type = current->getNodeType();
   if (type)
   {
      if (type == DOMNode::ELEMENT_NODE)
      {
         ReadTextures(current);
      }
   }
   DestroyTags();
}


void ScrollView::CustomProcessEvent(SDL_Event* event)
{
   RecalculateSize();
   
   if (event->type == SDL_MOUSEBUTTONUP && event->button.button == SDL_BUTTON_LEFT)
      drag = false;
}


void ScrollView::MouseMotion(SDL_Event* event)
{
   if (drag)
   {
      vpoffsety += event->motion.yrel * scrollamount;
      yoff -= event->motion.yrel * scrollamount;
      if (vpoffsety < 0)
      {
         yoff += vpoffsety;
         vpoffsety = 0;
      }
      else if (vpoffsety + height > canvasy)
      {
         yoff += (vpoffsety + height - canvasy);
         vpoffsety = canvasy - height;
      }
   }
}


void ScrollView::LeftDown(SDL_Event* event)
{
   if (event->motion.x / wratio >= x + xoff + width - scrollbarwidth &&
       event->motion.x / wratio <= x + xoff + width &&
       canvasy > height && event->button.button == SDL_BUTTON_LEFT)
      drag = true;
}


void ScrollView::LeftClick(SDL_Event* event)
{
   drag = false;
}


void ScrollView::WheelDown(SDL_Event* event)
{
   vpoffsety += 50.f;
   yoff -= 50.f;
   if (vpoffsety + height > canvasy)
   {
      yoff += (vpoffsety + height - canvasy);
      vpoffsety = canvasy - height;
   }
}


void ScrollView::WheelUp(SDL_Event* event)
{
   vpoffsety -= 50.f;
   yoff += 50.f;
   if (vpoffsety < 0)
   {
      yoff += vpoffsety;
      vpoffsety = 0;
   }
}


void ScrollView::KeyDown(SDL_Event* event)
{
   switch (event->key.keysym.sym)
   {
      case SDLK_UP:
         vpoffsety -= 5.f;
         yoff += 5.f;
         if (vpoffsety < 0)
         {
            yoff += vpoffsety;
            vpoffsety = 0;
         }
         break;
      case SDLK_DOWN:
         vpoffsety += 5.f;
         yoff -= 5.f;
         if (vpoffsety + height > canvasy)
         {
            yoff += (vpoffsety + height - canvasy);
            vpoffsety = canvasy - height;
         }
         break;
      default:
         break;
   }
}


void ScrollView::RecalculateSize()
{
   canvasx = width;
   canvasy = height;
   guiiter i;
   for (i = children.begin(); i != children.end(); ++i)
   {
      GUI* iptr = *i;
      if (iptr->x + iptr->width > canvasx) canvasx = iptr->x + iptr->width;
      if (iptr->y + iptr->height > canvasy) canvasy = iptr->y + iptr->height;
   }
   scrollbarsize = canvasy < .00001f ? 0 : height * (height / canvasy);
   //if (scrollbarsize < 10.f) scrollbarsize = 10.f;
   float availablebar = height - scrollbarsize;
   if (availablebar < .00001) 
   {
      scrollamount = 1.f;
      return;
   }
   scrollamount = (canvasy - height) / availablebar / hratio;
}


bool ScrollView::FloatsInWidget(float xcoord, float ycoord)
{
   if (xcoord > ((x + xoff + vpoffsetx) * wratio) &&
       xcoord < ((x + xoff + width + vpoffsetx) * wratio) &&
       ycoord > ((y + yoff + vpoffsety) * hratio) &&
       ycoord < ((y + yoff + height + vpoffsety) * hratio))
      return true;
   return false;
}


void ScrollView::ScrollToBottom()
{
   RecalculateSize();
   vpoffsety = canvasy - height;
}
