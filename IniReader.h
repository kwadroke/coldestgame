#ifndef __INIREADER_H
#define __INIREADER_H

#include <string>
#include <map>
#include <vector>
#include <fstream>
#include <sstream>
#include <iostream>

using std::string;
using std::map;
using std::vector;
using std::ifstream;
using std::stringstream;
using std::ios;
using std::cout;
using std::endl;

class IniReader
{
   public:
      explicit IniReader(int lev = 0);
      IniReader(string); // Allow implicit conversion from string though
      const IniReader& GetItem(const int) const;
      const IniReader& operator()(const int num) const;
      const IniReader& GetItemByName(const string) const;
      int GetItemIndex(const string) const;
      string Read(string&, const string, const int num = 0) const;
      string ReadLine(string&, const string) const;
      int Read(int&, const string, const int num = 0) const;
      float Read(float&, const string, const int num = 0) const;
      bool Read(bool&, const string, const int num = 0) const;
      int NumChildren() const;
      string GetPath() const;
      
   private:
      string Parse(string);
      string ReadVal(const string, const int) const;
      bool HaveValue(const string, const int) const;
      
      vector<IniReader> children;
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

#endif
