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
// Copyright 2008, 2009 Ben Nemec
// @End License@

#include "XSWrapper.h"

XSWrapper::XSWrapper() : data(XMLString::transcode(""))
{
}


// Note: We take ownership of d
XSWrapper::XSWrapper(XMLCh* d) : data(d)
{
}


XSWrapper::XSWrapper(const string& text) : data(XMLString::transcode(text.c_str()))
{
}


XSWrapper::XSWrapper(const XSWrapper& x) : data(XMLString::replicate(x))
{
}


XSWrapper& XSWrapper::operator=(const XSWrapper& x)
{
   data = XMLString::replicate(x);
   return *this;
}


XSWrapper& XSWrapper::operator=(const string& s)
{
   data = XMLString::transcode(s.c_str());
   return *this;
}


XSWrapper::~XSWrapper()
{
   try
   {
      XMLString::release(&data);
   }
   catch (...)
   {
      cerr << "Error in XMLString::release" << endl;
      cerr << string(*this) << endl;
   }
}


bool XSWrapper::operator==(const string& s) const
{
   return XMLString::equals(data, XSWrapper(s));
}


bool XSWrapper::operator==(const XMLCh* x) const
{
   return XMLString::equals(data, x);
}


bool operator==(const XMLCh* x, const XSWrapper& xw)
{
   return XMLString::equals(x, xw);
}


XSWrapper::operator XMLCh*() const
{
   return data;
}


XSWrapper::operator const XMLCh*() const
{
   return data;
}


XSWrapper::operator string() const
{
   char* buffer;
   buffer = XMLString::transcode(data);
   string retval(buffer);
   XMLString::release(&buffer);
   return retval;
}

