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
// Copyright 2008, 2011 Ben Nemec
// @End License@


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
#include "Layout.h"
#include "../globals.h"
#include "Font.h"

using std::hex;


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
   doubleclickaction = "";
   state = 0;
   parent = p;
   texman = tm;
   wratio = p->wratio;
   hratio = p->hratio;
   fontname = p->fontname;
   actualw = p->actualw;
   actualh = p->actualh;
   active = false;
   readonly = false;
   align = Left;
   xmargin = 6.f;
   ymargin = 2.f;
   fontscale = 12.f / Font::basesize; // Default font size is 12
   text = "";
   textcolor.r = textcolor.g = textcolor.b = textcolor.unused = 255;
   lastclick = 0;
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
   
   sounds = vector<string>(2, "");
   sounds = p->sounds;
}


void GUI::Cleanup()
{
}


void GUI::SetTextureManager(TextureManager* texm)
{
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
      
      if (textmesh)
      {
         textmesh->Render();
      }
      if (shadowtextmesh)
      {
         shadowtextmesh->Render();
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
            active = false;
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
               Uint32 currtick = SDL_GetTicks();
               if (currtick - lastclick > 400)
               {
                  if (sounds[LeftSound] != "")
                     resman.soundman.PlaySound(sounds[LeftSound], Vector3(), false, true);
                  LeftClick(event);
                  GlobalLeftClick(event); // The globals get done regardless of whether the click is in the widget
                  DoAction(leftclickaction);
                  lastclick = currtick;
               }
               else
               {
                  DoAction(doubleclickaction);
               }
            }
            else if (event->button.button == SDL_BUTTON_RIGHT)
            {
               if (sounds[RightSound] != "")
                  resman.soundman.PlaySound(sounds[RightSound], Vector3(), false, true);
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
// Err, I think that's not true anymore.  I believe the minimap uses this
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
      logout << "XML toolkit initialization error: " << message << endl;
      XMLString::release(&message);
      return;
   }
   
   parser = new XercesDOMParser;
   parser->setValidationScheme(XercesDOMParser::Val_Never);
   try
   {
      parser->parse(filename.c_str());
   
      // doc is owned by the parser, we don't need to worry about it
      xercesc::DOMDocument* doc = parser->getDocument();
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
         logout << filename << endl;
      }
      // Cleanup
      delete parser;
   }
   catch(xercesc::XMLException& e)
   {
      char* message = xercesc::XMLString::transcode( e.getMessage() );
      cerr << "Error parsing file: " << message << endl;
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
            // Read the attributes
            virtualw = atof(ReadAttribute(current, XSWrapper("virtualw")).c_str());
            virtualh = atof(ReadAttribute(current, XSWrapper("virtualh")).c_str());
            wratio = actualw / virtualw;
            hratio = actualh / virtualh;
            fontname = ReadAttribute(current, XSWrapper("font"));
            
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
         for (size_t i = 0; i < children->getLength(); ++i)
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
         else if (name == XSWrapper("Layout"))
            newwidget = GUIPtr(new Layout(parent, texman));
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
         newwidget->fontscale = atof(ReadAttribute(current, XSWrapper("fontsize")).c_str()) / Font::basesize;
         newwidget->xmargin = atof(ReadAttribute(current, XSWrapper("xmargin")).c_str());
         newwidget->ymargin = atof(ReadAttribute(current, XSWrapper("ymargin")).c_str());
         newwidget->leftclickaction = ReadAttribute(current, XSWrapper("leftclick"));
         newwidget->doubleclickaction = ReadAttribute(current, XSWrapper("doubleclick"));
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
         
         val = ReadAttribute(current, XSWrapper("textcolor"));
         if (val.length() == 4)
         {
            newwidget->textcolor.r = ToInt(val[0], hex) * 16 + 15;
            newwidget->textcolor.g = ToInt(val[1], hex) * 16 + 15;
            newwidget->textcolor.b = ToInt(val[2], hex) * 16 + 15;
            newwidget->textcolor.unused = ToInt(val[3], hex) * 16 + 15;
         }
         else if (val.length() == 8)
         {
            newwidget->textcolor.r = ToInt(val.substr(0, 2), hex);
            newwidget->textcolor.g = ToInt(val.substr(2, 2), hex);
            newwidget->textcolor.b = ToInt(val.substr(4, 2), hex);
            newwidget->textcolor.unused = ToInt(val.substr(6, 2), hex);
         }
         else
         {
            newwidget->textcolor.r = newwidget->textcolor.g = newwidget->textcolor.b = newwidget->textcolor.unused = 255;
         }
         
         // Load textures
         newwidget->textures = ReadTextures(current);
         
         newwidget->ReadNodeExtra(current, parent);
         children.push_back(newwidget);
         
         DOMNodeList* children = current->getChildNodes();
         for (size_t i = 0; i < children->getLength(); ++i)
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


/* Call SDL_GL_Enter2dMode before using this function.  After finishing with it call
   SDL_GL_Exit2dMode to undo the changes.

   justify: 0 = left, 1 = right
*/
void GUI::RenderText(string str, int x, int y, int justify, SDL_Color col, float scale, bool shadow)
{
   if (!str.length() && !textquads.size() && !shadowquads.size())
      return;
   
   if (shadow)
   {
      SDL_Color black = col;
      black.r = black.g = black.b = 0;
      RenderText(str, x + 2, y + 2, justify, black, scale, false);
   }
   
   FontPtr font = fontcache.GetFont(fontname);
   
   int currx = x;
   int width = 0;
   int height; // Don't actually care about this right now
   float z = 0.f;
   GLubytevec color(4, 255);
   color[0] = col.r;
   color[1] = col.g;
   color[2] = col.b;
   color[3] = col.unused;
   
   // Only allocate these objects for widgets that actually use them
   if (!textmesh && !shadow)
      textmesh = meshcache->GetNewMesh("models/empty");
   else if (!shadowtextmesh && shadow)
      shadowtextmesh = meshcache->GetNewMesh("models/empty");
   
   Quadlist& quads = shadow ? shadowquads : textquads;
   MeshPtr mesh = shadow ? shadowtextmesh : textmesh;
   while (quads.size() < str.size())
   {
      quads.push_back(Quad());
      if (!mesh)
         logout << "Textmesh not initialized before rendering text" << endl;
      mesh->AddNoCopy(quads.back());
   }
   
   Quadlist::iterator j = quads.begin();
   for (size_t i = 0; i < str.size(); ++i)
   {
      if (font->IsColorTag(str, i))
      {
         if (shadow) // This won't work right for unshadowed text.  Right now there isn't any, but it's a potential issue.
         {
            for (uint j = 1; j < 4; ++j)
               color[j - 1] = float(ToInt(str[i + j])) / 9.f * 255.f;
         }
         font->RemoveColorTag(str, i);
         i -= 1;
         continue;
      }
      
      Quad& q = *j;
      ++j;
      if (i >= oldchars.size() || oldchars[i] != str[i] || oldfont != font)
      {
         font->GetChar(str[i], q);
         q.Scale(scale);
         q.Translate(Vector3(currx, y, z));
         for (size_t j = 0; j < 4; ++j)
            q.SetColor(j, color);
         mesh->Clear(false);
      }
      font->StringDim(str.substr(0, std::min(i + 1, str.size())), width, height);
      currx = width * scale + x;
   }
   // Blank out the remaining quads so we don't end up with leftover characters
   size_t i = str.size();
   for (; j != quads.end(); ++j)
   {
      if (i >= oldchars.size() || oldchars[i] != ' ' || oldfont != font)
      {
         Quad& q = *j;
         font->GetChar(' ', q);
      }
   }
   if (shadow)
   {
      oldchars = str + string(' ', quads.size() - str.size());
      oldfont = font;
   }
}


void GUI::StringDim(const string& s, int& w, int& h)
{
   FontPtr font = fontcache.GetFont(fontname);
   font->StringDim(s, w, h);
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


float GUI::MaxX()
{
   float retval = x + width;
   float tempval = 0.f;
   for (guiiter i = children.begin(); i != children.end(); ++i)
   {
      tempval = (*i)->MaxX() + x;
      if (tempval > retval)
         retval = tempval;
   }
   return retval;
}

float GUI::MaxY()
{
   float retval = y + height;
   float tempval = 0.f;
   for (guiiter i = children.begin(); i != children.end(); ++i)
   {
      tempval = (*i)->MaxY() + y;
      if (tempval > retval)
         retval = tempval;
   }
   return retval;
}

