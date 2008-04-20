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
