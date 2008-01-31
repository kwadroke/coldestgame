#include "GUI.h"

// These must be included here because they have a circular dependency with GUI
#include "Button.h"
#include "LineEdit.h"
#include "ScrollView.h"
#include "ProgressBar.h"
#include "Table.h"
#include "ComboBox.h"
#include "TextArea.h"
#include "Slider.h"

GUI::GUI(float aw, float ah, TextureManager* texm)
{
   actualw = aw;
   actualh = ah;
   virtualw = virtualh = 1000.f;
   wratio = actualw / virtualw;
   hratio = actualh / virtualh;
   name = "root";
   xoff = yoff = 0;
   Init(this, texm);
}


GUI::~GUI()
{
   Cleanup();
}


void GUI::Init(GUI* p, TextureManager* tm)
{
   visible = true;
   x = y = 0.f;
   width = p->width;
   height = p->height;
   xoff = p->x + p->xoff;
   yoff = p->y + p->yoff;
   name = "";
   leftclickaction = "";
   state = 0;
   parent = p;
   texman = tm;
   wratio = p->wratio;
   hratio = p->hratio;
   font = p->font;
   actualw = p->actualw;
   actualh = p->actualh;
   active = false;
   readonly = false;
   align = Left;
   xmargin = 6.f;
   ymargin = 2.f;
   basefontsize = 24.f; // Font is rendered at this pt size and scaled
   fontscale = 12.f / basefontsize; // Default font size is 12
   text = oldtext = "";
   for (int i = 0; i < 3; ++i)
      textures.push_back("");
   glGenTextures(1, &texttexture);
}


void GUI::Cleanup()
{
   guiiter i;
   for (i = children.begin(); i != children.end(); ++i)
      delete *i;
   glDeleteTextures(1, &texttexture);
}


void GUI::SetTextureManager(TextureManager* texm)
{
   //realtm = texm;
   texman = texm;
}


void GUI::SetActualSize(int w, int h)
{
   actualw = w;
   actualh = h;
   wratio = actualw / virtualw;
   hratio = actualh / virtualh;
}


void GUI::Render()
{
   if (visible)
   {
      glEnable(GL_DEPTH_TEST);
      list<GUI*>::iterator i;
      for (i = children.begin(); i != children.end(); ++i)
      {
         (*i)->Render();
      }
      glDisable(GL_DEPTH_TEST);
   }
}


void GUI::RenderBase()
{
   if (textures[state] == "") return;
   texman->BindTexture(textures[state]);
   glBegin(GL_TRIANGLE_STRIP);
   glTexCoord2i(0, 0);
   glVertex2f((x + xoff) * wratio, (y + yoff) * hratio);
   glTexCoord2i(0, 1);
   glVertex2f((x + xoff) * wratio, (y + yoff + height) * hratio);
   glTexCoord2i(1, 0);
   glVertex2f((x + xoff + width) * wratio, (y + yoff) * hratio);
   glTexCoord2i(1, 1);
   glVertex2f((x + xoff + width) * wratio, (y + yoff + height) * hratio);
   glEnd();
}


/* Although this function is still virtual, you probably want to override the LeftClick, RightClick, etc.
   functions instead.  Unique requirements can be implemented in CustomProcessEvent.  The only reason it
   should be necessary to override this function itself is if you for some reason didn't want these standard
   actions to happen, but that seems highly unlikely. */
void GUI::ProcessEvent(SDL_Event* event)
{
   if (!visible) return;
   
   CustomProcessEvent(event);
   
   switch (event->type)
   {
      case SDL_MOUSEBUTTONDOWN:
         if (EventInWidget(event))
         {
            state = Clicked;
            active = true;
            if (event->button.button == SDL_BUTTON_LEFT)
            {
               DoAction(leftdownaction);
               LeftDown(event);
            }
            else if (event->button.button == SDL_BUTTON_RIGHT)
            {
               DoAction(rightdownaction);
               RightDown(event);
            }
            else if (event->button.button == SDL_BUTTON_WHEELUP)
            {
               WheelUp(event);
            }
            else if (event->button.button == SDL_BUTTON_WHEELDOWN)
            {
               WheelDown(event);
            }
         }
         else 
         {
            state = Normal;
         }
         break;
         
      case SDL_MOUSEBUTTONUP:
         if (EventInWidget(event))
         {
            state = Hover;
            if (event->button.button == SDL_BUTTON_LEFT)
            {
               DoAction(leftclickaction);
               LeftClick(event);
            }
            else if (event->button.button == SDL_BUTTON_RIGHT)
            {
               DoAction(rightclickaction);
               RightClick(event);
            }
         }
         else
         {
            state = Normal;
            break;
         }
         break;
      
      case SDL_MOUSEMOTION:
         if (EventInWidget(event))
         {
            if (state != Clicked)
               state = Hover;
         }
         else state = Normal;
         MouseMotion(event);
         break;
         
      case SDL_KEYDOWN:
         if (active)
            KeyDown(event);
         break;
         
      case SDL_KEYUP:
         if (active)
            KeyUp(event);
         break;
   }
   
   guiiter i;
   for (i = children.begin(); i != children.end(); ++i)
      (*i)->ProcessEvent(event);
}


// I'm not sure this works, since I've never had occasion to use it
void GUI::Add(GUI* widget, string parentname)
{
   if (parentname == name)
   {
      widget->parent = this;
      children.push_back(widget);
      return;
   }
   
   guiiter i;
   for (i = children.begin(); i != children.end(); ++i)
      (*i)->Add(widget, parentname);
}


GUI* GUI::GetWidget(string findname)
{
   if (name == findname)
      return this;
   
   GUI* tempret = NULL;
   guiiter i;
   for (i = children.begin(); i != children.end(); ++i)
   {
      tempret = (*i)->GetWidget(findname);
      if (tempret != NULL) return tempret;
   }
   return NULL;
}


void GUI::InitFromFile(string filename)
{
   XercesDOMParser *parser;
   try
   {
      XMLPlatformUtils::Initialize();
   }
   catch (XMLException &e)
   {
      char* message = XMLString::transcode(e.getMessage());
      cerr << "XML toolkit initialization error: " << message << endl;
      XMLString::release(&message);
      return;
   }
   
   InitTags();
   
   parser = new XercesDOMParser;
   parser->setValidationScheme(XercesDOMParser::Val_Never);
   try
   {
      parser->parse(filename.c_str());
   
      // doc is owned by the parser, we don't need to worry about it
      DOMDocument* doc = parser->getDocument();
      if (doc)
      {
         DOMElement* element = doc->getDocumentElement();
         
         if (!element)
            cout << "Warning: Attempted to parse empty XML file" << endl;
         else
            ReadNode(element, this);
      }
      else
      {
         cout << "Error getting document object" << endl;
      }
      // Cleanup
      delete parser;
   }
   catch(xercesc::XMLException& e)
   {
      char* message = xercesc::XMLString::transcode( e.getMessage() );
      cerr << "Error parsing file: " << message << flush;
      XMLString::release( &message );
   }
   try
   {
      XMLPlatformUtils::Terminate();  // Terminate Xerces
   }
   catch(xercesc::XMLException& e)
   {
      char* message = xercesc::XMLString::transcode(e.getMessage());
      cerr << "XML toolkit termination error: " << message << endl;
      XMLString::release(&message);
   }
   DestroyTags();
}


void GUI::InitTags()
{
   tag.gui = XMLString::transcode("GUI");
   tag.button = XMLString::transcode("Button");
   tag.lineedit = XMLString::transcode("LineEdit");
   tag.scrollview = XMLString::transcode("ScrollView");
   tag.progressbar = XMLString::transcode("ProgressBar");
   tag.label = XMLString::transcode("Label");
   tag.table = XMLString::transcode("Table");
   tag.tableitem = XMLString::transcode("TableItem");
   tag.combobox = XMLString::transcode("ComboBox");
   tag.comboboxitem = XMLString::transcode("ComboBoxItem");
   tag.textarea = XMLString::transcode("TextArea");
   tag.slider = XMLString::transcode("Slider");
   
   attrib.x = XMLString::transcode("x");
   attrib.y = XMLString::transcode("y");
   attrib.width = XMLString::transcode("width");
   attrib.height = XMLString::transcode("height");
   attrib.virtualw = XMLString::transcode("virtualw");
   attrib.virtualh = XMLString::transcode("virtualh");
   attrib.name = XMLString::transcode("name");
   attrib.text = XMLString::transcode("text");
   attrib.font = XMLString::transcode("font");
   attrib.fontsize = XMLString::transcode("fontsize");
   attrib.visible = XMLString::transcode("visible");
   attrib.readonly = XMLString::transcode("readonly");
   attrib.xmargin = XMLString::transcode("xmargin");
   attrib.ymargin = XMLString::transcode("ymargin");
   attrib.columns = XMLString::transcode("columns");
   attrib.colwidths = XMLString::transcode("colwidths");
   attrib.rowheight = XMLString::transcode("rowheight");
   attrib.align = XMLString::transcode("align");
   attrib.headerheight = XMLString::transcode("headerheight");
   attrib.menuheight = XMLString::transcode("menuheight");
   
   tag.normal = XMLString::transcode("Normal");
   tag.hover = XMLString::transcode("Hover");
   tag.pressed = XMLString::transcode("Pressed");
   tag.scrollbar = XMLString::transcode("Scrollbar");
   tag.leftclickaction = XMLString::transcode("LeftClickAction");
   tag.valuechanged = XMLString::transcode("ValueChangedAction");
}


void GUI::DestroyTags()
{
   try
   {
      XMLString::release(&tag.gui);
      XMLString::release(&tag.button);
      XMLString::release(&tag.lineedit);
      XMLString::release(&tag.scrollview);
      XMLString::release(&tag.progressbar);
      XMLString::release(&tag.label);
      XMLString::release(&tag.table);
      XMLString::release(&tag.tableitem);
      XMLString::release(&tag.combobox);
      XMLString::release(&tag.comboboxitem);
      XMLString::release(&tag.textarea);
      XMLString::release(&tag.slider);
      
      XMLString::release(&attrib.x);
      XMLString::release(&attrib.y);
      XMLString::release(&attrib.width);
      XMLString::release(&attrib.height);
      XMLString::release(&attrib.virtualw);
      XMLString::release(&attrib.virtualh);
      XMLString::release(&attrib.name);
      XMLString::release(&attrib.text);
      XMLString::release(&attrib.font);
      XMLString::release(&attrib.fontsize);
      XMLString::release(&attrib.visible);
      XMLString::release(&attrib.readonly);
      XMLString::release(&attrib.xmargin);
      XMLString::release(&attrib.ymargin);
      XMLString::release(&attrib.columns);
      XMLString::release(&attrib.colwidths);
      XMLString::release(&attrib.rowheight);
      XMLString::release(&attrib.align);
      XMLString::release(&attrib.headerheight);
      XMLString::release(&attrib.menuheight);
      
      XMLString::release(&tag.normal);
      XMLString::release(&tag.hover);
      XMLString::release(&tag.pressed);
      XMLString::release(&tag.scrollbar);
      XMLString::release(&tag.leftclickaction);
      XMLString::release(&tag.valuechanged);
   }
   catch(...)
   {
      cerr << "Unknown exception releasing XML resources." << endl;
   }
}


void GUI::ReadNode(DOMNode *current, GUI* parent)
{
   bool rootnode = false;
   DOMNode* currnode; // General purpose, not necessarily == current
   if (current->getNodeType() &&
       current->getNodeType() == DOMNode::ELEMENT_NODE)
   {
      if (XMLString::equals(current->getNodeName(), tag.gui))
      {
         if (parent != this) // Hmm, this may not work.  Wait to see how the parent situation ends up being handled
         {
            cout << "Warning, GUI element detected that is not the root node.\n";
         }
         else
         {
            char* currstr;
            DOMNamedNodeMap* attribs = current->getAttributes();
            
            // Read the attributes
            virtualw = atof(ReadAttribute(current, attrib.virtualw).c_str());
            virtualh = atof(ReadAttribute(current, attrib.virtualh).c_str());
            wratio = actualw / virtualw;
            hratio = actualh / virtualh;
            string fontname = ReadAttribute(current, attrib.font);
            if (!TTF_WasInit())
               cout << "Warning: GUI detected that SDL_ttf was not initialized" << endl;
            else
            {
               font = TTF_OpenFont(fontname.c_str(), 48);
               if (!font)
               {
                  cout << "Failed to initialize font: " << TTF_GetError() << endl;
                  exit(1);
               }
            }
            string val = ReadAttribute(current, attrib.visible);
               if (val == "false") visible = false; // Defaults to true
            
            rootnode = true;
         }
      }
      else
      {
         GUI* newwidget;
         
         if (XMLString::equals(current->getNodeName(), tag.button) || 
             XMLString::equals(current->getNodeName(), tag.label))
            newwidget = new Button(parent, texman);
         else if (XMLString::equals(current->getNodeName(), tag.lineedit))
            newwidget = new LineEdit(parent, texman);
         else if (XMLString::equals(current->getNodeName(), tag.scrollview))
            newwidget = new ScrollView(parent, texman);
         else if (XMLString::equals(current->getNodeName(), tag.progressbar))
            newwidget = new ProgressBar(parent, texman);
         else if (XMLString::equals(current->getNodeName(), tag.table))
            newwidget = new Table(parent, texman);
         else if (XMLString::equals(current->getNodeName(), tag.combobox))
            newwidget = new ComboBox(parent, texman);
         else if (XMLString::equals(current->getNodeName(), tag.textarea))
            newwidget = new TextArea(parent, texman);
         else if (XMLString::equals(current->getNodeName(), tag.slider))
            newwidget = new Slider(parent, texman);
         else return; // Not a node we recognize
         
         // Read basic attributes
         newwidget->x = atof(ReadAttribute(current, attrib.x).c_str());
         newwidget->y = atof(ReadAttribute(current, attrib.y).c_str());
         newwidget->width = atof(ReadAttribute(current, attrib.width).c_str());
         newwidget->height = atof(ReadAttribute(current, attrib.height).c_str());
         newwidget->text = ReadAttribute(current, attrib.text);
         newwidget->name = ReadAttribute(current, attrib.name);
         newwidget->fontscale = atof(ReadAttribute(current, attrib.fontsize).c_str()) / basefontsize;
         newwidget->xmargin = atof(ReadAttribute(current, attrib.xmargin).c_str());
         newwidget->ymargin = atof(ReadAttribute(current, attrib.ymargin).c_str());
         
         string val = ReadAttribute(current, attrib.visible);
         if (val == "false") newwidget->visible = false; // Defaults to true
         
         val = ReadAttribute(current, attrib.readonly);
         if (val == "true") newwidget->readonly = true; // Defaults to false
         
         val = ReadAttribute(current, attrib.align); // Defaults to Left
         if (val == "center")
            newwidget->align = Center;
         else if (val == "right")
            newwidget->align = Right;
         // Done with basic attributes, now do widget-specific init
         
         if (XMLString::equals(current->getNodeName(), tag.button) ||
             XMLString::equals(current->getNodeName(), tag.label))
         {
            // Now read any children of the button
            DOMNodeList* buttonchildren = current->getChildNodes();
            for (int i = 0; i < buttonchildren->getLength(); ++i)
            {
               newwidget->ReadNode(buttonchildren->item(i), newwidget);
            }
            children.push_back((Button*)newwidget);
         }
         else if (XMLString::equals(current->getNodeName(), tag.lineedit))
         {
            DOMNodeList* lechildren = current->getChildNodes();
            for (int i = 0; i < lechildren->getLength(); ++i)
               newwidget->ReadNode(lechildren->item(i), newwidget);
            children.push_back((LineEdit*)newwidget);
         }
         else if (XMLString::equals(current->getNodeName(), tag.scrollview))
         {
            DOMNodeList* svchildren = current->getChildNodes();
            for (int i = 0; i < svchildren->getLength(); ++i)
            {
               ((ScrollView*)newwidget)->ReadNodeLocal(svchildren->item(i), newwidget);
               // ReadNodeLocal does an Init/DestroyTags, so we have to do it every iteration as well
               newwidget->InitTags();
               newwidget->ReadNode(svchildren->item(i), newwidget);
               newwidget->DestroyTags();
            }
            children.push_back((ScrollView*)newwidget);
            return;
         }
         else if (XMLString::equals(current->getNodeName(), tag.progressbar))
         {
            DOMNodeList* pbchildren = current->getChildNodes();
            for (int i = 0; i < pbchildren->getLength(); ++i)
            {
               newwidget->ReadNode(pbchildren->item(i), newwidget);
            }
            children.push_back((ProgressBar*)newwidget);
         }
         else if (XMLString::equals(current->getNodeName(), tag.table))
         {
            ((Table*)newwidget)->colwidths = ReadAttribute(current, attrib.colwidths);
            ((Table*)newwidget)->rowheight = atof(ReadAttribute(current, attrib.rowheight).c_str());
            DOMNodeList* tabchildren = current->getChildNodes();
            for (int i = 0; i < tabchildren->getLength(); ++i)
            {
               newwidget->ReadNode(tabchildren->item(i), newwidget);
            }
            children.push_back((Table*)newwidget);
         }
         else if (XMLString::equals(current->getNodeName(), tag.combobox))
         {
            DOMNodeList* cbchildren = current->getChildNodes();
            for (int i = 0; i < cbchildren->getLength(); ++i)
            {
               newwidget->ReadNode(cbchildren->item(i), newwidget);
            }
            children.push_back((ComboBox*)newwidget);
         }
         else if (XMLString::equals(current->getNodeName(), tag.textarea))
         {
            DOMNodeList* tachildren = current->getChildNodes();
            for (int i = 0; i < tachildren->getLength(); ++i)
            {
               newwidget->ReadNode(tachildren->item(i), newwidget);
            }
            children.push_back((TextArea*)newwidget);
         }
         else if (XMLString::equals(current->getNodeName(), tag.slider))
         {
            DOMNodeList* schildren = current->getChildNodes();
            for (int i = 0; i < schildren->getLength(); ++i)
            {
               newwidget->ReadNode(schildren->item(i), newwidget);
            }
            children.push_back((Slider*)newwidget);
         }
      }
   }
   
   if (!current->hasChildNodes() || !rootnode) return;
   DOMNodeList* children = current->getChildNodes();
   for (int i = 0; i < children->getLength(); ++i)
   {
      currnode = children->item(i);
      ReadNode(currnode, this);
   }
}


string GUI::ReadAttribute(DOMNode* node, XMLCh* attribname)
{
   char* currstr;
   DOMNamedNodeMap* attribs = node->getAttributes();
   string retval = "";
   
   DOMNode* currnode = attribs->getNamedItem(attribname);
   if (currnode)
   {
      currstr = XMLString::transcode(currnode->getNodeValue());
      retval = currstr;
      XMLString::release(&currstr);
   }
   return retval;
}


// Read the string value between tags of an element node
string GUI::ReadStringTag(DOMNode* node, XMLCh* tagname)
{
   char* currstr;
   string retval = "";
   if (XMLString::equals(node->getNodeName(), tagname))
   {
      DOMNode* child = node->getFirstChild();
      currstr = XMLString::transcode(child->getNodeValue());
      retval = currstr;
      XMLString::release(&currstr);
   }
   return retval;
}


// Essentially all widgets will have to read some subset of these textures
void GUI::ReadTextures(DOMNode* current)
{
   string curr;
   curr = ReadStringTag(current, tag.normal);
   if (curr != "")
   {
      textures[0] = curr;
      if (textures[1] == "")
         textures[1] = textures[0];
      if (textures[2] == "")
         textures[2] = textures[0];
      texman->LoadTexture(textures[0]);
   }
   curr = ReadStringTag(current, tag.hover);
   if (curr != "")
   {
      textures[1] = curr;
      texman->LoadTexture(textures[1]);
   }
   curr = ReadStringTag(current, tag.pressed);
   if (curr != "")
   {
      textures[2] = curr;
      texman->LoadTexture(textures[2]);
   }
}


bool GUI::InWidget(float xcoord, float ycoord)
{
   if (xcoord > ((x + xoff) * wratio) &&
       xcoord < ((x + xoff + width) * wratio) &&
       ycoord > ((y + yoff) * hratio) &&
       ycoord < ((y + yoff + height) * hratio))
      return true;
   return false;
}


// Convenience function because we do this a lot.
// Note that it does honor custom InWidget functions, which is why it's not virtual
bool GUI::EventInWidget(SDL_Event* event)
{
   return InWidget(event->motion.x, event->motion.y);
}


// Returns the height and width in pixels of the text in the height and width params
void GUI::StringDim(TTF_Font* font, string text, int& width, int& height)
{
   if (text.length() == 0 || !TTF_WasInit())
   {
      width = 0;
      height = 0;
      return;
   }
   
   SDL_Color col;
   col.r = 255;
   col.g = 255;
   col.b = 255;
   
   SDL_Surface *t = TTF_RenderText_Solid(font, text.c_str(), col);
   if (!t)  // Had some problems with sdl-ttf at one point
   {        // At least this way it won't segfault
      cout << "Error rendering text: " << text << endl;
      exit(-1);
   }
   
   height = t->h;
   width = t->w;
   
   SDL_FreeSurface(t);
}


/* Call SDL_GL_Enter2dMode before using this function.  After finishing with it call
   SDL_GL_Exit2dMode to undo the changes.

   justify: 0 = left, 1 = right
   
   If str == oldstr then it won't re-render the text, it will just properly display the texture
*/
void GUI::RenderText(string str, string oldstr, int x, int y, int justify, TTF_Font *font, GLuint tex, float scale, bool shadow)
{
   SDL_Surface *text;
         
   if (str.length() == 0 || !TTF_WasInit())
      return;
   SDL_Color col;
   col.r = 255;
   col.g = 255;
   col.b = 255;
   
   SDL_Surface *t = TTF_RenderText_Solid(font, str.c_str(), col);
   if (!t)  // Had some problems with sdl-ttf at one point
   {        // At least this way it won't segfault
      cout << "Error rendering text: " << str << endl;
      exit(-1);
   }
   int neww = PowerOf2(t->w);
   int newh = PowerOf2(t->h);
   
   texman->texhand->BindTexture(tex);
   
   if (oldstr != str)
   {
      Uint32 rmask, gmask, bmask, amask;
#if SDL_BYTEORDER == SDL_BIG_ENDIAN
      rmask = 0xff000000;
      gmask = 0x00ff0000;
      bmask = 0x0000ff00;
      amask = 0x000000ff;
#else
      rmask = 0x000000ff;
      gmask = 0x0000ff00;
      bmask = 0x00ff0000;
      amask = 0xff000000;
#endif
      text = SDL_CreateRGBSurface(SDL_SWSURFACE, neww, newh, 32,
                              rmask, gmask, bmask, amask);
   
  
      SDL_BlitSurface(t, NULL, text, NULL);
      
      SDL_LockSurface(text);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, text->w, text->h, 0, GL_RGBA, GL_UNSIGNED_BYTE, text->pixels);
   }
   
   float texwidth = (float)t->w / (float)neww;
   float texheight = (float)t->h / (float)newh;
   
   int offset = 2;
   int shadowpass = shadow ? 1 : 0;
   while (shadowpass >= 0)
   {
      if (shadow)
      {
         if (shadowpass)
         {
            glColor4f(0, 0, 0, 1);
            x += offset;
            y += offset;
         }
         else 
         {
            glColor4f(1, 1, 1, 1);
            x -= offset;
            y -= offset;
         }
      }
      glBegin(GL_TRIANGLE_STRIP);
      if (justify == 0)
      {
         glTexCoord2f(0, 0);
         glVertex2f(x, y);
         glTexCoord2f(0, texheight);
         glVertex2f(x, y + t->h * scale);
         glTexCoord2f(texwidth, 0);
         glVertex2f(x + t->w * scale, y);
         glTexCoord2f(texwidth, texheight);
         glVertex2f(x + t->w * scale, y + t->h * scale);
      }
      else if (justify == 1)
      {
         glTexCoord2f(0, 0);
         glVertex2f(x - t->w, y);
         glTexCoord2f(0, texheight);
         glVertex2f(x - t->w, y + t->h);
         glTexCoord2f(texwidth, 0);
         glVertex2f(x, y);
         glTexCoord2f(texwidth, texheight);
         glVertex2f(x, y + t->h);
      }
      glEnd();
      --shadowpass;
   }
   glColor4f(1, 1, 1, 1);
   
   SDL_FreeSurface(t);
   if (oldstr != str)
      SDL_FreeSurface(text);
}


// Translates string values into the appropriate function call
void GUI::DoAction(string action)
{
   if (action == "exit")
      Quit();
   else if (action == "connect")
      Connect();
   else if (action == "connectip")
      ConnectToIp();
   else if (action == "showprogress")
      TestAction();
   else if (action == "resume")
      Resume();
   else if (action == "spawn")
      Spawn();
   else if (action == "loadouttomain")
      LoadoutToMain();
   else if (action == "updateunitselection")
      UpdateUnitSelection();
   else if (action == "submitcommand")
      SubmitCommand();
}


// The following functions are all no-ops in the base class, but may be overriden in derived classes
void GUI::CustomProcessEvent(SDL_Event* event){}
void GUI::MouseMotion(SDL_Event* event){}
void GUI::LeftClick(SDL_Event* event){}
void GUI::LeftDown(SDL_Event* event){}
void GUI::RightClick(SDL_Event* event){}
void GUI::RightDown(SDL_Event* event){}
void GUI::WheelDown(SDL_Event* event){}
void GUI::WheelUp(SDL_Event* event){}
void GUI::KeyDown(SDL_Event* event){}
void GUI::KeyUp(SDL_Event* event){}
