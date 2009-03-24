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

#include "IniReader.h"

IniReader::IniReader(int lev) : level(lev), name(""), path("")
{
}

IniReader::IniReader(string filename) : level(0), name(""), path(filename)
{
   if (filename == "") return; // Don't think this is necessary anymore, but it doesn't hurt

   ifstream in(filename.c_str(), ios::in|ios::binary);

   if (in.fail())
   {
      logout << "Failed to open file " << filename << endl;
      return;
   }

   string contents = "";
   string buffer;
   while (getline(in, buffer))
   {
      contents += buffer + '\n';
   }

   istringstream instr(contents);
   Parse(instr);
}


void IniReader::Parse(istringstream& in)
{
   string currline = "";
   int linelevel = level;
   string valname = "";
   istringstream line;
   bool firstline = true;
   size_t strpos = 0;

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
         IniReaderPtr newreader(new IniReader(linelevel));
         in.seekg(strpos);
         newreader->Parse(in);
         children.push_back(newreader);
      }
      else if (linelevel < level)
      {
         in.seekg(strpos);
         return;
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
   // No need for a return statement here anymore, but the comment is useful.
   return; // Means we reached the end of the file
}


const IniReader& IniReader::GetItem(const int num) const
{
   return *children.at(num);
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
      if (children[i]->name == name)
         return i;
   }
   return -1;
}


string IniReader::ReadLine(string& ret, const string name) const
{
   if (HaveValue(name, 0))
   {
      string tempret = "";
      istringstream readval(values[name]);
      readval >> tempret;
      readval.ignore();
      getline(readval, tempret);
      if (tempret != "")
         ret = tempret;
   }
   return ret;
}


string IniReader::ReadVal(const string& line, const int num) const
{
   istringstream readval(line);
   int i = -1; // Always need to read at least two values even if they pass in 0
   string retval;
   while (i <= num)
   {
      if (!(readval >> retval))
         return "";
      ++i;
   }
   return retval;
}


bool IniReader::HaveValue(const string& name, const int num) const
{
   bool retval = values.find(name) != values.end();
   if (retval)
   {
      istringstream readval(values[name]);
      int i = -1;
      string dummy;
      while (readval >> dummy && i < num)
         ++i;
      if (i != num) retval = false; // This may not work as intended, testing is needed
   }
   //if (!retval)
   //   logout << "Warning: Attempt to read non-existent value " << name << endl;
   return retval;
}


int IniReader::NumChildren() const
{
   return children.size();
}


string IniReader::GetPath() const
{
   return path;
}
