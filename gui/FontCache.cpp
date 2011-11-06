#include "FontCache.h"

FontCache::FontCache()
{
}

FontPtr FontCache::GetFont(const string& name)
{
   if (fonts.find(name) == fonts.end())
   {
      logout << "Loading font " << name << endl;
      fonts[name] = FontPtr(new Font(name));
   }
   return fonts[name];
}


void FontCache::Clear()
{
   fonts.clear();
}
