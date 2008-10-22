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
#include "TabWidget.h"
#include "../globals.h"


GUI::GUI(float aw, float ah, TextureManager* texm, const string file)
{
   actualw = aw;
   actualh = ah;
   virtualw = virtualh = 1000.f;
   wratio = actualw / virtualw;
   hratio = actualh / virtualh;
   name = "root";
   xoff = yoff = 0;
   Init(this, texm);
   if (file != "")
      InitFromFile(file);
}


GUI::~GUI()
{
   Cleanup();
}


void GUI::Init(GUI* p, TextureManager* tm)
{
   visible = true;
   x = y = 0.f;
   width = 20.f;//p->width;
   height = 20.f;//p->height;
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
   basefontsize = 12.f; // Font is rendered at this pt size and scaled
   fontscale = 12.f / basefontsize; // Default font size is 12
   text = oldtext = "";
   for (size_t i = 0; i < numdefaults; ++i)
      defaulttextures.push_back(vector<string>());
   for (int i = 0; i < 3; ++i)
   {
      texids.push_back(0);
      for (size_t j = 0; j < numdefaults; ++j)
         defaulttextures[j].push_back("");
   }
   for (size_t j = 0; j < numdefaults; ++j)
      defaulttextures[j] = p->defaulttextures[j];
   textures = vector<string>(3, "");
   glGenTextures(1, &texttexture);
   
   sounds = vector<string>(2, "");
   sounds = p->sounds;
   if (p == this)
   {
      soundsource = ALSourcePtr(new ALSource());
   }
   soundsource = p->soundsource;
}


void GUI::Cleanup()
{
   // Smart pointers should make this unnecessary
   //guiiter i;
   //for (i = children.begin(); i != children.end(); ++i)
   //   delete *i;
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


void GUI::SetActive(bool act)
{
   active = act;
}


void GUI::Render()
{
   if (visible)
   {
      glEnable(GL_DEPTH_TEST);
      glDisable(GL_CULL_FACE);
      
      xoff = parent->xoff + parent->x;
      yoff = parent->yoff + parent->y;
      RenderWidget();
      
      guiiter i;
      for (i = children.begin(); i != children.end(); ++i)
      {
         (*i)->Render();
      }
      // Some widgets, such as ScrollView, want to render their children using the scissor test
      // This virtual function allows them to enable it in RenderWidget and disable it again
      // after all the children have been rendered.  It could be used for other things in the
      // future too.
      PostRender();
      glDisable(GL_DEPTH_TEST);
   }
}


void GUI::RenderBase()
{
   if (textures[state] == "") return;
   if (textures[state] != "USEID")
   {
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
   else
   {
      texman->texhand->BindTexture(texids[state]);
      // Need to flip texcoords for FBO textures, which is what this is used for
      glBegin(GL_QUADS);
      glTexCoord2i(0, 1);
      glVertex2f((x + xoff) * wratio, (y + yoff) * hratio);
      glTexCoord2i(0, 0);
      glVertex2f((x + xoff) * wratio, (y + yoff + height) * hratio);
      glTexCoord2i(1, 0);
      glVertex2f((x + xoff + width) * wratio, (y + yoff + height) * hratio);
      glTexCoord2i(1, 1);
      glVertex2f((x + xoff + width) * wratio, (y + yoff) * hratio);
      glEnd();
   }
}


/* Although this function is still virtual, you probably want to override the LeftClick, RightClick, etc.
   functions instead.  Unique requirements can be implemented in CustomProcessEvent.  The only reason it
   should be necessary to override this function itself is if you for some reason didn't want these standard
   actions to happen, but that seems highly unlikely (they're all no-ops by default anyway). */
void GUI::ProcessEvent(SDL_Event* event)
{
   if (!visible) return;
   
   CustomProcessEvent(event);
   
   switch (event->type)
   {
      case SDL_MOUSEBUTTONDOWN:
         if (InWidget(event))
         {
            state = Clicked;
            active = true;
            if (event->button.button == SDL_BUTTON_LEFT)
            {
               LeftDown(event);
               DoAction(leftdownaction);
            }
            else if (event->button.button == SDL_BUTTON_RIGHT)
            {
               RightDown(event);
               DoAction(rightdownaction);
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
            if (event->button.button == SDL_BUTTON_LEFT)
               GlobalLeftDown(event);
            else if (event->button.button == SDL_BUTTON_RIGHT)
               GlobalRightDown(event);
         }
         break;
         
      case SDL_MOUSEBUTTONUP:
         if (InWidget(event))
         {
            state = Hover;
            if (event->button.button == SDL_BUTTON_LEFT)
            {
               if (sounds[LeftSound] != "")
                  soundsource->Play(resman.soundman.GetBuffer(sounds[LeftSound]));
               LeftClick(event);
               GlobalLeftClick(event); // The globals get done regardless of whether the click is in the widget
               DoAction(leftclickaction);
            }
            else if (event->button.button == SDL_BUTTON_RIGHT)
            {
               if (sounds[RightSound] != "")
                  soundsource->Play(resman.soundman.GetBuffer(sounds[RightSound]));
               RightClick(event);
               GlobalRightClick(event);
               DoAction(rightclickaction);
            }
         }
         else
         {
            state = Normal;
            if (event->button.button == SDL_BUTTON_LEFT)
            {
               GlobalLeftClick(event);
            }
            else if (event->button.button == SDL_BUTTON_RIGHT)
            {
               GlobalRightClick(event);
            }
         }
         break;
      
      case SDL_MOUSEMOTION:
         if (InWidget(event))
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
void GUI::Add(GUIPtr widget)
{
   children.push_back(widget);
}


void GUI::ClearChildren()
{
   children.clear();
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
            logout << "Warning: Attempted to parse empty XML file" << endl;
         else
            ReadNode(element, this);
      }
      else
      {
         logout << "Error getting document object" << endl;
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
}


void GUI::ReadNode(DOMNode *current, GUI* parent)
{
   bool rootnode = false;
   DOMNode* currnode; // General purpose, not necessarily == current
   if (current->getNodeType() &&
       current->getNodeType() == DOMNode::ELEMENT_NODE)
   {
      // GUI elements have to be handled differently because in this case there was no parent to call ReadNode on,
      // so GUI has to construct itself first and then call ReadNode on itself, but pass in the child nodes
      // Other widgets are constructed by their parent's ReadNode call, which then also calls ReadNode on them
      // passing in their child nodes.  
      if (XMLString::equals(current->getNodeName(), XSWrapper("GUI")))
      {
         if (parent != this)
         {
            logout << "Warning, GUI element detected that is not the root node.\n";
         }
         else
         {
            char* currstr;
            DOMNamedNodeMap* attribs = current->getAttributes();
            
            // Read the attributes
            virtualw = atof(ReadAttribute(current, XSWrapper("virtualw")).c_str());
            virtualh = atof(ReadAttribute(current, XSWrapper("virtualh")).c_str());
            wratio = actualw / virtualw;
            hratio = actualh / virtualh;
            string fontname = ReadAttribute(current, XSWrapper("font"));
            if (!TTF_WasInit())
               logout << "Warning: GUI detected that SDL_ttf was not initialized" << endl;
            else
            {
               font = TTF_OpenFont(fontname.c_str(), 48);
               if (!font)
               {
                  logout << "Failed to initialize font: " << TTF_GetError() << endl;
                  exit(1);
               }
            }
            sounds[LeftSound] = ReadAttribute(current, XSWrapper("leftclicksound"));
            sounds[RightSound] = ReadAttribute(current, XSWrapper("rightclicksound"));
            string val = ReadAttribute(current, XSWrapper("visible"));
            if (val == "false") visible = false; // Defaults to true
            
            defaulttextures[BackgroundTex] = ReadTextures(current, "bg");
            defaulttextures[ButtonTex] = ReadTextures(current, "button");
            defaulttextures[GutterTex] = ReadTextures(current, "gutter");
            defaulttextures[SliderTex] = ReadTextures(current, "slider");
            defaulttextures[TableCellTex] = ReadTextures(current, "tablecell");
            defaulttextures[TableRowTex] = ReadTextures(current, "tablerow");
            defaulttextures[CursorTex] = ReadTextures(current, "cursor");
            
            rootnode = true;
         }
         DOMNodeList* children = current->getChildNodes();
         for (int i = 0; i < children->getLength(); ++i)
         {
            currnode = children->item(i);
            ReadNode(currnode, this);
         }
      }
      else
      {
         GUIPtr newwidget;
         
         const XMLCh* name = current->getNodeName();
         if (name == XSWrapper("Button") || name == XSWrapper("Label"))
            newwidget = GUIPtr(new Button(parent, texman));
         else if (name == XSWrapper("LineEdit"))
            newwidget = GUIPtr(new LineEdit(parent, texman));
         else if (name == XSWrapper("ScrollView"))
            newwidget = GUIPtr(new ScrollView(parent, texman));
         else if (name == XSWrapper("ProgressBar"))
            newwidget = GUIPtr(new ProgressBar(parent, texman));
         else if (name == XSWrapper("Table"))
            newwidget = GUIPtr(new Table(parent, texman));
         else if (name == XSWrapper("ComboBox"))
            newwidget = GUIPtr(new ComboBox(parent, texman));
         else if (name == XSWrapper("TextArea"))
            newwidget = GUIPtr(new TextArea(parent, texman));
         else if (name == XSWrapper("Slider"))
            newwidget = GUIPtr(new Slider(parent, texman));
         else if (name == XSWrapper("TabWidget"))
            newwidget = GUIPtr(new TabWidget(parent, texman));
         else // Not a node we recognize
         {
            ReadSpecialNodes(current, this);
            return;
         }
         
         // Read basic attributes
         newwidget->x = atof(ReadAttribute(current, XSWrapper("x")).c_str());
         newwidget->y = atof(ReadAttribute(current, XSWrapper("y")).c_str());
         newwidget->width = atof(ReadAttribute(current, XSWrapper("width")).c_str());
         newwidget->height = atof(ReadAttribute(current, XSWrapper("height")).c_str());
         newwidget->text = ReadAttribute(current, XSWrapper("text"));
         newwidget->name = ReadAttribute(current, XSWrapper("name"));
         newwidget->fontscale = atof(ReadAttribute(current, XSWrapper("fontsize")).c_str()) / basefontsize;
         newwidget->xmargin = atof(ReadAttribute(current, XSWrapper("xmargin")).c_str());
         newwidget->ymargin = atof(ReadAttribute(current, XSWrapper("ymargin")).c_str());
         newwidget->leftclickaction = ReadAttribute(current, XSWrapper("leftclick"));
         newwidget->valuechanged = ReadAttribute(current, XSWrapper("valuechanged"));
         
         string val = ReadAttribute(current, XSWrapper("visible"));
         if (val == "false") newwidget->visible = false; // Defaults to true
         
         val = ReadAttribute(current, XSWrapper("readonly"));
         if (val == "true") newwidget->readonly = true; // Defaults to false
         
         val = ReadAttribute(current, XSWrapper("align")); // Defaults to Left
         if (val == "center")
            newwidget->align = Center;
         else if (val == "right")
            newwidget->align = Right;
         
         val = ReadAttribute(current, XSWrapper("leftclicksound"));
         if (val != "")
            newwidget->sounds[LeftSound] = val;
         val = ReadAttribute(current, XSWrapper("rightclicksound"));
         if (val != "")
            newwidget->sounds[RightSound] = val;
         
         // Load textures
         newwidget->textures = ReadTextures(current);
         
         newwidget->ReadNodeExtra(current, parent);
         children.push_back(newwidget);
         
         DOMNodeList* children = current->getChildNodes();
         for (int i = 0; i < children->getLength(); ++i)
         {
            currnode = children->item(i);
            newwidget->ReadNode(currnode, newwidget.get());
         }
         newwidget->PostReadNode(current, parent);
      }
   }
}


vector<string> GUI::ReadTextures(DOMNode* current, const string& prefix)
{
   vector<string> ret(numstates);
   string val = ReadAttribute(current, XSWrapper(prefix + "normal"));
   if (val != "")
   {
      ret[Normal] = val;
      if (ret[Hover] == "")
         ret[Hover] = ret[Normal];
      if (ret[Clicked] == "")
         ret[Clicked] = ret[Normal];
      texman->LoadTexture(ret[Normal], false);
   }
   val = ReadAttribute(current, XSWrapper(prefix + "hover"));
   if (val != "")
   {
      ret[Hover] = val;
      texman->LoadTexture(ret[Hover], false);
   }
   val = ReadAttribute(current, XSWrapper(prefix + "pressed"));
   if (val != "")
   {
      ret[Clicked] = val;
      texman->LoadTexture(ret[Clicked], false);
   }
   return ret;
}


void GUI::UseDefaultTextures(int index)
{
   if (textures[0] == "" && textures[1] == "" && textures[2] == "")
      textures = defaulttextures[index];
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


bool GUI::FloatsInWidget(float xcoord, float ycoord)
{
   if (xcoord > ((x + xoff) * wratio) &&
       xcoord < ((x + xoff + width) * wratio) &&
       ycoord > ((y + yoff) * hratio) &&
       ycoord < ((y + yoff + height) * hratio))
      return true;
   return false;
}


bool GUI::InWidget(float xcoord, float ycoord)
{
   return FloatsInWidget(xcoord, ycoord);
}


// Convenience function because we do this a lot.
// Note that it does honor custom FloatsInWidget functions, which is why it's not virtual
bool GUI::InWidget(const SDL_Event* event)
{
   return FloatsInWidget(event->motion.x, event->motion.y);
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
      logout << "Error rendering text: " << text << endl;
      exit(-10);
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
      logout << "Error rendering text: " << str << endl;
      exit(-11);
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
   Action(action);
}


void GUI::SetTextureID(int state, GLuint id)
{
   if (state == Normal && textures[Hover] == textures[Normal])
   {
      texids[Hover] = id;
      textures[Hover] = "USEID";
   }
   if (state == Normal && textures[Clicked] == textures[Normal])
   {
      texids[Clicked] = id;
      textures[Clicked] = "USEID";
   }
   texids[state] = id;
   textures[state] = "USEID";
}


void GUI::SetTexture(int state, const string& file)
{
   if (textures[state] != "" && (state == Normal || textures[state] != textures[Normal]))
      logout << "Warning: Possible memory leak in GUI::SetTexture" << endl;
   textures[state] = file;
   texman->LoadTexture(file, false);
   if (state == Normal && textures[Hover] == "")
      textures[Hover] = textures[Normal];
   if (state == Normal && textures[Clicked] == "")
      textures[Clicked] = textures[Normal];
}

