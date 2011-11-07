#ifndef FONT_H
#define FONT_H

#include "../Quad.h"
#include <string>
#include <boost/shared_ptr.hpp>
#include <SDL/SDL_ttf.h>

using std::string;

struct CharData
{
   int left, top;
   int width, height;
};

class Font
{
   public:
      Font(const string&);
      ~Font();
      Quad& GetChar(const char, Quad&);
      void StringDim(const string&, int&, int&);
      void LoadMaterial();
      
      static float basesize;
      
   private:
      // No copying, this should be used through the FontCache, which returns smart pointers
      Font(const Font&);
      Font& operator=(const Font&);
      
      void InitFont(const string&);
      void InitAtlas();
      
      void InternalStringDim(const string&, int&, int&);
      // Use this function to do lookups into chardata so you don't have to remember to subtract first
      CharData& GetCharData(char c) {return chardata[c - first];}
      
      TTF_Font* font;
      GLuint texture;
      int texwidth, texheight;
      
      char first, last;
      vector<CharData> chardata;
      string fontname;
      
      Material* material;
};

typedef boost::shared_ptr<Font> FontPtr;

#endif // FONT_H
