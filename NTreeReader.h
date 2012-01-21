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


#ifndef __NTREEREADER_H
#define __NTREEREADER_H

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

/*
   Reads NTree (Node Tree) files.  These are files in a custom format somewhat like a simplified YAML, though the NTree
   variation happens to also match the format used by some Unix-like tools such as df, or the format of the file /etc/mtab on Linux.
   Essentially any text file where each entry has its own line and uses whitespace as a delimiter can be read by this class.
   At this time the format is only documented by this code, but that may change in the future.

   Historical Note: This class used to be named IniReader, because the original intent was only to read ini-style files.  Since it
   grew to be more than that, a name change was in order.  Also, there is a different inireader library unrelated to this class.
*/

class NTreeReader
{
   public:
      explicit NTreeReader(int lev = 0, const string& n = "");
      NTreeReader(string); // Allow implicit conversion from string though
      const NTreeReader& GetItem(const int) const;
      const NTreeReader& operator()(const int) const;
      const NTreeReader& GetItemByName(const string) const;
      int GetItemIndex(const string) const;
      template <typename T>
      T Read(T&, const string&, const int num = 0) const;
      string ReadLine(string&, const string) const;
      size_t NumChildren() const;
      string GetPath() const;
      string GetName() const {return name;}
      bool Error() const {return error;}

   private:
      void Parse(istringstream&);
      string ReadVal(const string&, const int) const;
      bool HaveValue(const string&, const int) const;

      vector<shared_ptr<NTreeReader> > children;
      /* This mutable is a workaround for the fact that operator[] on a map is non-const,
         yet we want to be able to use it in const functions (after ensuring that the
         key actually exists in the map, so we know that it will in fact not make any
         changes to the map).  This is probably somewhat dangerous, as we might forget
         to make this check or just plain change the map in a const function, but I don't
         think that would be a serious problem so this stays (for now).
      */
      mutable map<string, string, std::less<string> > values;
      size_t level;
      string name;
      string path;
      bool error;
};

typedef shared_ptr<NTreeReader> NTreeReaderPtr;


template <typename T>
T NTreeReader::Read(T& ret, const string& name, const int num) const
{
   if (HaveValue(name, num))
   {
      istringstream convert(ReadVal(values[name], num));
      convert >> ret;
   }
   return ret;
}

#endif
