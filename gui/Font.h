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
// Copyright 2008-2012 Ben Nemec
// @End License@
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
      bool IsColorTag(const string&, size_t);
      void RemoveColorTag(string&, size_t);
      
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
