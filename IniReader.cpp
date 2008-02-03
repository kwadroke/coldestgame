#include "IniReader.h"

IniReader::IniReader(string filename, int lev) : level(lev), name("")
{
   if (filename == "") return;
   
   ifstream in(filename.c_str(), ios::in);
   
   string contents = "";
   string buffer;
   while (getline(in, buffer))
   {
      contents += buffer + '\n';
   }
   
   Parse(contents);
}


string IniReader::Parse(string instr)
{
   stringstream in;
   in.str(instr);
   
   string currline = "";
   int linelevel = level;
   string valname = "";
   stringstream line;
   int strpos = 0;
   bool firstline = true;
   while(getline(in, currline))
   {
      linelevel = currline.find_first_not_of(" \t");
      if (linelevel == string::npos) // Skip whitespace
      {
         continue;
      }
      
      if (firstline)
      {
         name = currline.substr(linelevel);
         firstline = false;
      }
      
      if (linelevel > level)
      {
         IniReader newreader("", linelevel);
         string currstr = in.str().substr(strpos);
         currstr = newreader.Parse(currstr);
         in.clear();
         in.str(currstr);
         children.push_back(newreader);
      }
      else if (linelevel < level)
      {
         return in.str().substr(strpos);
      }
      else // We need to read the value
      {
         line.clear();
         line.str(currline);
         line >> valname;
         values[valname] = currline;
      }
      strpos = in.tellg();
   }
   return ""; // Means we reached the end of the file
}


const IniReader& IniReader::GetItem(const int num) const
{
   return children.at(num);
}


const IniReader& IniReader::operator()(const int num) const
{
   return GetItem(num);
}


const IniReader& IniReader::GetItemByName(const string name) const
{
   return GetItem(GetItemIndex(name));
}


int IniReader::GetItemIndex(const string name) const
{
   for (int i = 0; i < children.size(); ++i)
   {
      if (children[i].name == name)
         return i;
   }
   return -1;
}


string IniReader::Read(string& ret, const string name, const int num)
{
   if (HaveValue(name))
   {
      ret = ReadVal(values[name], num);
      return ret;
   }
   return "";
}


int IniReader::Read(int& ret, const string name, const int num)
{
   if (HaveValue(name))
   {
      ret = atoi(ReadVal(values[name], num).c_str());
      return ret;
   }
   return 0;
}


float IniReader::Read(float& ret, const string name, const int num)
{
   if (HaveValue(name))
   {
      ret = atof(ReadVal(values[name], num).c_str());
      return ret;
   }
   return 0;
}


bool IniReader::Read(bool& ret, const string name, const int num)
{
   if (HaveValue(name))
   {
      ret = ReadVal(values[name], num) != "0";
      return ret;
   }
   return false;
}


string IniReader::ReadVal(const string line, const int num)
{
   stringstream readval(line);
   int i = -1; // Always need to read at least two values even if they pass in 0
   string retval;
   while (readval >> retval && i < num)
      ++i;
   return retval;
}


bool IniReader::HaveValue(const string name) const
{
   bool retval = values.find(name) != values.end();
   //if (!retval)
   //   cout << "Warning: Attempt to read non-existent value " << name << endl;
   return retval;
}


int IniReader::NumChildren() const
{
   return children.size();
}
