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
      IniReader(string, int lev = 0);
      const IniReader& GetItem(const int) const;
      const IniReader& operator()(const int num) const;
      const IniReader& GetItemByName(const string) const;
      int GetItemIndex(const string) const;
      string ReadString(string&, const string, const int num = 0);
      int ReadInt(int&, const string, const int num = 0);
      float ReadFloat(float&, const string, const int num = 0);
      int NumChildren() const;
      
   private:
      string Parse(string);
      string ReadVal(const string, const int);
      bool HaveValue(const string) const;
      
      vector<IniReader> children;
      map<string, string, std::less<string> > values;
      int level;
      string name;
};

#endif
