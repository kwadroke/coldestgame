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

#include <iostream>
#include <list>
#include <set>
#include <vector>
#include <string>
#include <SDL.h>
#include <SDL_ttf.h>
#include "TextureManager.h"

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

struct Tags
{
   // Base tags
   XMLCh* gui;
   XMLCh* button;
   XMLCh* lineedit;
   XMLCh* scrollview;
   XMLCh* progressbar;
   XMLCh* label;
   XMLCh* table;
   XMLCh* tableitem;
   XMLCh* combobox;
   XMLCh* comboboxitem;
   XMLCh* textarea;
   
   // General tags
   XMLCh* normal;
   XMLCh* hover;
   XMLCh* pressed;
   XMLCh* scrollbar;
   XMLCh* leftclickaction;
   XMLCh* valuechanged;
};

struct Attribs
{
   XMLCh* x;
   XMLCh* y;
   XMLCh* width;
   XMLCh* height;
   XMLCh* virtualw;
   XMLCh* virtualh;
   XMLCh* name;
   XMLCh* text;
   XMLCh* font;
   XMLCh* fontsize;
   XMLCh* visible;
   XMLCh* readonly;
   XMLCh* xmargin;
   XMLCh* ymargin;
   XMLCh* columns;
   XMLCh* colwidths;
   XMLCh* rowheight;
   XMLCh* align;
   XMLCh* headerheight;
   XMLCh* menuheight;
};

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
   public:
      GUI(float aw = 480.f, float ah = 640.f, TextureHandler* th = NULL);
      virtual ~GUI();
      virtual void Render();
      virtual void ProcessEvent(SDL_Event*);
      void Add(GUI*, string);
      GUI* GetWidget(string);
      void InitFromFile(string);
      string ReadAttribute(DOMNode*, XMLCh*);
      string ReadStringTag(DOMNode*, XMLCh*);
      void SetTextureHandler(TextureHandler*);
      void SetActualSize(int, int);
      virtual bool InWidget(float, float);
      void RenderText(string, string, int, int, int, TTF_Font*, GLuint, float scale = 1.f, bool shadow = true);
      
      bool visible;
      bool readonly;
      float width, height;
      float x, y;
      string text;
      float xmargin, ymargin;
      Alignment align;
   
   protected:
      void DoAction(string);
      virtual void ReadNode(DOMNode*, GUI*);
      void ReadTextures(DOMNode*);
      virtual void InitTags();
      virtual void DestroyTags();
      virtual void Cleanup();
      void Init(GUI*, TextureManager*);
      void StringDim(TTF_Font*, string, int&, int&);
      void RenderBase();
      
      // Copying of this object is not allowed, just use InitFromFile again
      // with the same file on a new object
      GUI(const GUI&);
      GUI& operator=(const GUI&);
      
      list<GUI*> children;
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
      string leftclickaction, valuechanged;
      string oldtext;
      GLuint texttexture;
      vector<string> textures;
      Tags tag;
      Attribs attrib;
      TextureManager realtm;
      TextureManager *texman;
      TTF_Font* font;
      
};

// Used frequently, and only one change if we change containers for some reason
typedef list<GUI*>::iterator guiiter;

// Necessary externs, mostly for action functions
//void RenderText(string, int, int, int, TTF_Font*, float scale = 1.f, bool shadow = true);
int PowerOf2(int);
void Connect();
void ConnectToIp();
void Quit();
void TestAction();
void Resume();
void Spawn();
void LoadoutToMain();
void UpdateUnitSelection();

template <typename T>
string ToString(const T &input);

#endif
