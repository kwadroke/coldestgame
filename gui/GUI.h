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
#include <SDL.h>
#include <SDL_ttf.h>
#include "../TextureManager.h"
#include "XSWrapper.h"

using namespace std;
using xercesc::DOMElement;
using xercesc::XercesDOMParser;
using xercesc::XMLPlatformUtils;
using xercesc::XMLException;
using xercesc::DOMDocument;
using xercesc::DOMNode;
using xercesc::DOMNodeList;
using xercesc::DOMNamedNodeMap;
using xercesc::XMLString;
using boost::shared_ptr;

enum {Normal, Hover, Clicked};
enum Alignment {Left, Center, Right};

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
      GUI(float aw = 640.f, float ah = 480.f, TextureManager* texm = NULL);
      virtual ~GUI();
      void Render();
      virtual void ProcessEvent(SDL_Event*);
      void Add(shared_ptr<GUI>, string);
      virtual GUI* GetWidget(string);
      void InitFromFile(string);
      string ReadAttribute(DOMNode*, XMLCh*);
      string ReadStringTag(DOMNode*, XMLCh*);
      void SetTextureManager(TextureManager*);
      void SetActualSize(int, int);
      virtual bool FloatsInWidget(float, float);
      bool InWidget(float, float);
      bool InWidget(const SDL_Event*);
      void RenderText(string, string, int, int, int, TTF_Font*, GLuint, float scale = 1.f, bool shadow = true);
      void SetActive(bool act = true);
      void SetTextureID(int, GLuint);
      
      bool visible;
      bool readonly;
      float width, height;
      float x, y;
      string text;
      float xmargin, ymargin;
      Alignment align;
   
   protected:
      void DoAction(string);
      void ReadNode(DOMNode*, GUI*);
      virtual void ReadNodeExtra(DOMNode*, GUI*){}
      virtual void ReadSpecialNodes(DOMNode*, GUI*){}
      virtual void Cleanup();
      virtual void RenderWidget(){}
      virtual void PostRender(){}
      void Init(GUI*, TextureManager*);
      void StringDim(TTF_Font*, string, int&, int&);
      void RenderBase();
      
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
      GUI* parent;
      float virtualw, virtualh;
      float actualw, actualh;
      float wratio, hratio;
      float xoff, yoff;
      float fontscale;
      float basefontsize;
      int state;
      bool active;
      string name;
      string leftclickaction, rightclickaction, valuechanged;
      string leftdownaction, rightdownaction;
      string oldtext;
      GLuint texttexture;
      vector<string> textures;
      vector<GLuint> texids;
      TextureManager *texman;
      TTF_Font* font;
      
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
