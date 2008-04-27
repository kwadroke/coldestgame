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

