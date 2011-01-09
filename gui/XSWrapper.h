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


// This class is a wrapper around XMLCh pointers used by Xerces in parsing XML documents.
// It provides some XMLString functionality in a more object-oriented manner as well as
// automatically handling the memory management of dynamically allocated XMLCh*'s.

// Note that not all of the existing functions have been tested properly

#ifndef __XSWRAPPER_H
#define __XSWRAPPER_H

#include <iostream>
#include <string>
#include <xercesc/util/XMLString.hpp>

using std::cerr;
using std::endl;

using std::string;
using xercesc::XMLString;

class XSWrapper
{
   public:
      XSWrapper();
      XSWrapper(const string&);
      XSWrapper(const XSWrapper&);
      XSWrapper(XMLCh*);
      XSWrapper& operator=(const XSWrapper&);
      XSWrapper& operator=(const string&);
      bool operator==(const string&) const;
      bool operator==(const XMLCh*) const;
      ~XSWrapper();
      
      operator XMLCh*() const;
      operator const XMLCh*() const;
      operator string() const;
      
   private:
      XMLCh* data;
};

bool operator==(const XMLCh*, const XSWrapper&);

#endif
