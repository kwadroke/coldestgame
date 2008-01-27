#include "ScrollView.h"

ScrollView::ScrollView(GUI* p, TextureManager* tm)
{
   vpoffsetx = vpoffsety = 0;
   scrollbarwidth = 10.f;
   drag = false;
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


void ScrollView::ProcessEvent(SDL_Event* event)
{
   if (!visible) return;
   RecalculateSize();
   switch (event->type)
   {
      case SDL_MOUSEBUTTONDOWN:
         if (InWidget(event->motion.x, event->motion.y))
         {
            active = true;
            if (event->motion.x / wratio >= x + xoff + width - scrollbarwidth &&
                event->motion.x / wratio <= x + xoff + width &&
               canvasy > height && event->button.button == SDL_BUTTON_LEFT)
               drag = true;
            else if (event->button.button == SDL_BUTTON_WHEELUP)
            {
               vpoffsety -= 10.f;
               yoff += 10.f;
               if (vpoffsety < 0)
               {
                  yoff += vpoffsety;
                  vpoffsety = 0;
               }
            }
            else if (event->button.button == SDL_BUTTON_WHEELDOWN)
            {
               vpoffsety += 10.f;
               yoff -= 10.f;
               if (vpoffsety + height > canvasy)
               {
                  yoff += (vpoffsety + height - canvasy);
                  vpoffsety = canvasy - height;
               }
            }
         }
         else active = false;
         break;
         
      case SDL_MOUSEBUTTONUP:
         drag = false;
         break;
      
      case SDL_MOUSEMOTION:
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
         break;
         
      case SDL_KEYDOWN:
         if (!active) break;
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
   
   guiiter i;
   for (i = children.begin(); i != children.end(); ++i)
      (*i)->ProcessEvent(event);
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
   scrollbarsize = height * (height / canvasy);
   if (scrollbarsize < 10.f) scrollbarsize = 10.f;
   float availablebar = height - scrollbarsize;
   if (availablebar < .00001) 
   {
      scrollamount = 1.f;
      return;
   }
   scrollamount = (canvasy - height) / availablebar / hratio;
}


bool ScrollView::InWidget(float xcoord, float ycoord)
{
   if (xcoord > ((x + xoff + vpoffsetx) * wratio) &&
       xcoord < ((x + xoff + width + vpoffsetx) * wratio) &&
       ycoord > ((y + yoff + vpoffsety) * hratio) &&
       ycoord < ((y + yoff + height + vpoffsety) * hratio))
      return true;
   return false;
}
