// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
#ifndef __INIREADER_H
#define __INIREADER_H

#include <string>
#include <map>
#include <vector>
#include <fstream>
#include <sstream>
#include <iostream>
#include "logout.h"
#include <boost/shared_ptr.hpp>

using std::string;
using std::map;
using std::vector;
using std::ifstream;
using std::istringstream;
using std::ios;
using std::endl;
using boost::shared_ptr;

class IniReader
{
   public:
      explicit IniReader(int lev = 0);
      IniReader(string); // Allow implicit conversion from string though
      const IniReader& GetItem(const int) const;
      const IniReader& operator()(const int) const;
      const IniReader& GetItemByName(const string) const;
      int GetItemIndex(const string) const;
      template <typename T>
      T Read(T&, const string&, const int num = 0) const;
      string ReadLine(string&, const string) const;
      int NumChildren() const;
      string GetPath() const;

   private:
      void Parse(istringstream&);
      string ReadVal(const string&, const int) const;
      bool HaveValue(const string&, const int) const;

      vector<shared_ptr<IniReader> > children;
      /* This mutable is a workaround for the fact that operator[] on a map is non-const,
         yet we want to be able to use it in const functions (after ensuring that the
         key actually exists in the map, so we know that it will in fact not make any
         changes to the map).  This is probably somewhat dangerous, as we might forget
         to make this check or just plain change the map in a const function, but I don't
         think that would be a serious problem so this stays (for now).
      */
      mutable map<string, string, std::less<string> > values;
      int level;
      string name;
      string path;
};

typedef shared_ptr<IniReader> IniReaderPtr;


template <typename T>
T IniReader::Read(T& ret, const string& name, const int num) const
{
   if (HaveValue(name, num))
   {
      istringstream convert(ReadVal(values[name], num));
      convert >> ret;
   }
   return ret;
}

#endif
