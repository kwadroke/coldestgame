#ifndef FONTCACHE_H
#define FONTCACHE_H

#include "Font.h"
#include <string>
#include <map>

using std::string;

class FontCache
{
   public:
      FontCache();
      FontPtr GetFont(const string&);
      void Clear();
      
   private:
      std::map<string, FontPtr> fonts;
};

#endif // FONTCACHE_H
