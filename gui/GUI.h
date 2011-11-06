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


#ifndef __GUI_H
#define __GUI_H

// Xerces-C includes
#include <xercesc/parsers/XercesDOMParser.hpp>
#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/util/XMLString.hpp>
#include <xercesc/dom/DOM.hpp>
#include <xercesc/dom/DOMDocument.hpp>
#include <xercesc/dom/DOMElement.hpp>
#include <xercesc/dom/DOMNodeList.hpp>
#include <xercesc/dom/DOMText.hpp>
#include <xercesc/dom/DOMNamedNodeMap.hpp>
#include <stdexcept>
#include <boost/shared_ptr.hpp>

#include <iostream>
#include <list>
#include <set>
#include <vector>
#include <string>
#include <SDL/SDL.h>
#include "../TextureManager.h"
#include "XSWrapper.h"
#include "../util.h"
#include "../Quad.h"

using xercesc::DOMElement;
using xercesc::XercesDOMParser;
using xercesc::XMLPlatformUtils;
using xercesc::XMLException;
//using xercesc::DOMDocument;
using xercesc::DOMNode;
using xercesc::DOMNodeList;
using xercesc::DOMNamedNodeMap;
using xercesc::XMLString;
using boost::shared_ptr;
using std::list;
using std::vector;
using std::string;

enum {Normal, Hover, Clicked, numstates};
enum {ButtonTex, GutterTex, SliderTex, BackgroundTex, TableCellTex, TableRowTex, CursorTex, numdefaults};
enum Alignment {Left, Center, Right};
enum {LeftSound, RightSound, numsounds};

class GUI
{
   friend class Button;
   friend class LineEdit;
   friend class ScrollView;
   friend class Table;
   friend class TableItem;
   friend class ComboBox;
   friend class TextArea;
   friend class Slider;
   public:
      // The TextureManager can be removed if you alter all references to it to use global resman
      GUI() {} // So inheriting classes don't call the other constructor
      GUI(float, float, TextureManager* texm = NULL, const string file = "");
      virtual ~GUI();
      void Render();
      virtual void ProcessEvent(SDL_Event*);
      void Add(shared_ptr<GUI>);
      void ClearChildren();
      virtual GUI* GetWidget(string);
      void InitFromFile(string);
      string ReadAttribute(DOMNode*, XMLCh*);
      string ReadStringTag(DOMNode*, XMLCh*);
      void SetTextureManager(TextureManager*);
      void SetActualSize(int, int);
      virtual bool FloatsInWidget(float, float);
      bool InWidget(float, float);
      bool InWidget(const SDL_Event*);
      void RenderText(const string&, int, int, int, SDL_Color, float scale = 1.f, bool shadow = true);
      void SetActive(bool act = true);
      void SetTextureID(int, GLuint);
      void SetTexture(int, const string&);
      float MaxX();
      float MaxY();
      void StringDim(const string&, int&, int&);
      
      bool visible;
      bool readonly;
      float width, height;
      float x, y;
      string text;
      float xmargin, ymargin;
      Alignment align;
      string leftclickaction, rightclickaction, valuechanged;
      string leftdownaction, rightdownaction;
      string doubleclickaction;
      SDL_Color textcolor;
   
   protected:
      void DoAction(string);
      void ReadNode(DOMNode*, GUI*);
      virtual void ReadNodeExtra(DOMNode*, GUI*){}
      virtual void ReadSpecialNodes(DOMNode*, GUI*){}
      virtual void PostReadNode(DOMNode*, GUI*){}
      virtual void Cleanup();
      virtual void RenderWidget(){}
      virtual void PostRender(){}
      void Init(GUI*, TextureManager*);
      void RenderBase();
      vector<string> ReadTextures(DOMNode*, const string& prefix = "");
      void UseDefaultTextures(int);
      
      // Event handlers
      virtual void CustomProcessEvent(SDL_Event*){}
      virtual void MouseMotion(SDL_Event*){}
      virtual void LeftClick(SDL_Event*){}
      virtual void LeftDown(SDL_Event*){}
      virtual void RightClick(SDL_Event*){}
      virtual void RightDown(SDL_Event*){}
      virtual void WheelDown(SDL_Event*){}
      virtual void WheelUp(SDL_Event*){}
      virtual void KeyDown(SDL_Event*){}
      virtual void KeyUp(SDL_Event*){}
      virtual void GlobalLeftClick(SDL_Event*){}
      virtual void GlobalLeftDown(SDL_Event*){}
      virtual void GlobalRightClick(SDL_Event*){}
      virtual void GlobalRightDown(SDL_Event*){}
      
      // Copying of this object is not allowed, just use InitFromFile again
      // with the same file on a new object
      GUI(const GUI&);
      GUI& operator=(const GUI&);
      
      list<shared_ptr<GUI> > children;
      vector<vector<string> > defaulttextures;
      GUI* parent;
      float virtualw, virtualh;
      float actualw, actualh;
      float wratio, hratio;
      float xoff, yoff;
      float fontscale;
      int state;
      bool active;
      string name;
      Quadvec textquads;
      Quadvec shadowquads;
      vector<string> sounds;
      vector<string> textures;
      vector<GLuint> texids;
      TextureManager *texman;
      // Store the font name instead of a pointer to it so that fonts can be reloaded easily when necessary
      string fontname;
      Uint32 lastclick;
      
};

typedef shared_ptr<GUI> GUIPtr;
// Used frequently, and only one change if we change containers (which we already have)
typedef list<GUIPtr>::iterator guiiter;

// Necessary externs
//void RenderText(string, int, int, int, TTF_Font*, float scale = 1.f, bool shadow = true);
int PowerOf2(int);
void Action(const string&);

template <typename T>
string ToString(const T &input);

#endif
