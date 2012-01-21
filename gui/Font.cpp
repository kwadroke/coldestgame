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
#include "Font.h"
#include "../util.h"
#include "../globals.h"

// Currently this is the ideal base size for the fonts we're using to maximize our texture memory efficiency
float Font::basesize = 55.f;

Font::Font(const string& name) : font(NULL),
                                 texwidth(0),
                                 texheight(0),
                                 first(' '),
                                 last('~'),
                                 fontname(name)
{
   InitFont(name);
   InitAtlas();
}


Font::~Font()
{
   glDeleteTextures(1, &texture);
}


void Font::InitFont(const string& name)
{
   if (!TTF_WasInit())
      logout << "Warning: GUI detected that SDL_ttf was not initialized" << endl;
   else
   {
      font = TTF_OpenFont(name.c_str(), basesize);
      if (!font)
      {
         logout << "Failed to initialize font: " << TTF_GetError() << endl;
         exit(1);
      }
   }
}


void Font::InitAtlas()
{
   if (!TTF_WasInit())
      return;
   
   SDL_Color white;
   white.r = 255;
   white.g = 255;
   white.b = 255;
   
   string allchars;
   
   for (char c = first; c <= last; ++c)
      allchars += c;
   
   SDL_Surface *t = TTF_RenderText_Solid(font, allchars.c_str(), white);
   if (!t)  // Had some problems with sdl-ttf at one point
   {        // At least this way it won't segfault
      logout << "Error rendering text: " << allchars << endl;
      exit(-11);
   }
   texwidth = PowerOf2(t->w);
   texheight = PowerOf2(t->h);
   
   logout << "Font atlas size: " << texwidth << "  " << texheight << endl;
   
   
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
   SDL_Surface *text = SDL_CreateRGBSurface(SDL_SWSURFACE, texwidth, texheight, 32,
                                             rmask, gmask, bmask, amask);
   
   
   SDL_BlitSurface(t, NULL, text, NULL);
   
   SDL_LockSurface(text);
   glGenTextures(1, &texture);
   resman.texhand.BindTexture(texture);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
   glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, text->w, text->h, 0, GL_RGBA, GL_UNSIGNED_BYTE, text->pixels);
   
   SDL_FreeSurface(text);
   SDL_FreeSurface(t);
   
   LoadMaterial();
   
   string working;
   int height, width;
   for (char c = first; c <= last; ++c)
   {
      CharData cd;
      cd.top = 0;
      InternalStringDim(working, width, height);
      cd.left = width;
      cd.height = height;
      if (chardata.size())
         chardata.back().width = cd.left - chardata.back().left;
      chardata.push_back(cd);
      working += c;
   }
   InternalStringDim(working, width, height);
   chardata.back().width = width - chardata.back().left;
}


Quad& Font::GetChar(const char c, Quad& q)
{
   CharData cd = GetCharData(c);
   q.SetMaterial(material);
   float texstart = (float)cd.left / (float)texwidth;
   float texend = (float)(cd.left + cd.width) / (float)texwidth;
   float texbottom = (float)cd.height / (float)texheight;
   floatvec v(2, 0.f);
   v[0] = texstart;
   q.SetTexCoords(0, 0, v);
   v[1] = texbottom;
   q.SetTexCoords(1, 0, v);
   v[0] = texend;
   q.SetTexCoords(2, 0, v);
   v[1] = 0.f;
   q.SetTexCoords(3, 0, v);
   
   q.SetVertex(0, Vector3(0.f, 0.f, 0.f));
   q.SetVertex(1, Vector3(0.f, cd.height, 0.f));
   q.SetVertex(2, Vector3(cd.width, cd.height, 0.f));
   q.SetVertex(3, Vector3(cd.width, 0.f, 0.f));
   
   return q;
}


// This should be a lot faster than the internal version
void Font::StringDim(const string& s, int& w, int& h)
{
   h = GetCharData(s[0]).height;
   w = 0;
   for (size_t i = 0; i < s.size(); ++i)
   {
      if (IsColorTag(s, i)) // Color tags aren't rendered, so they shouldn't be included in the length
      {
         i += 3;
         continue;
      }
      CharData cd = GetCharData(s[i]);
      w += cd.width;
      if (cd.height > h)
         h = cd.height;
   }
}


// Returns the height and width in pixels of the text in the height and width params
void Font::InternalStringDim(const string& text, int& width, int& height)
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
      logout << "TTF Error: " << TTF_GetError() << endl;
      exit(-10);
   }
   
   height = t->h;
   width = t->w;
   
   SDL_FreeSurface(t);
}


void Font::LoadMaterial()
{
   Material newmat("materials/ui", resman.texman, resman.shaderman);
   newmat.SetTexture(0, texture);
   resman.AddMaterial(fontname, newmat);
   material = &resman.LoadMaterial(fontname);
}


void Font::RemoveColorTag(string& s, size_t i)
{
   if (IsColorTag(s, i))
      s.erase(i, 4);
}


bool Font::IsColorTag(const string& s, size_t i)
{
   if (i + 3 < s.size())
      return (s[i] == '#' && isdigit(s[i + 1]) && isdigit(s[i + 2]) && isdigit(s[i + 3]));
   return false;
}