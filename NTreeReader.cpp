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


#include "NTreeReader.h"

NTreeReader::NTreeReader(int lev, const string& n) : level(lev), name(n), path(""), error(false)
{
}

NTreeReader::NTreeReader(string filename) : level(0), name(""), path(filename), error(false)
{
   if (filename == "") return; // Don't think this is necessary anymore, but it doesn't hurt

   ifstream in(filename.c_str(), ios::in|ios::binary);
   
   if (in.fail())
   {
      logout << "Failed to open file " << filename << endl;
      error = true;
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


void NTreeReader::Parse(istringstream& in)
{
   string currline = "";
   size_t linelevel = level;
   string valname = "";
   string nextname = "";
   istringstream line;
   size_t strpos = 0;

   while(getline(in, currline))
   {
      // Ooh, nasty.  On CR/LF formatted files the \r is left in currline, which messes up lots of things
      if (currline[currline.length() - 1] == '\r')
         currline = currline.substr(0, currline.length() - 1);
      linelevel = currline.find_first_not_of(" \t");
      if (linelevel == string::npos) // Skip whitespace
      {
         continue;
      }

      if (linelevel > level)
      {
         NTreeReaderPtr newreader(new NTreeReader(linelevel, nextname));
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
      nextname = currline.substr(linelevel);
   }
   // No need for a return statement here anymore, but the comment is useful.
   return; // Means we reached the end of the file
}


const NTreeReader& NTreeReader::GetItem(const int num) const
{
   return *children.at(num);
}


const NTreeReader& NTreeReader::operator()(const int num) const
{
   return GetItem(num);
}


const NTreeReader& NTreeReader::GetItemByName(const string name) const
{
   return GetItem(GetItemIndex(name));
}


int NTreeReader::GetItemIndex(const string name) const
{
   for (size_t i = 0; i < children.size(); ++i)
   {
      if (children[i]->name == name)
         return i;
   }
   logout << "Failed to find Node named: " << name << endl;
   return -1;
}


string NTreeReader::ReadLine(string& ret, const string name) const
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


string NTreeReader::ReadVal(const string& line, const int num) const
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


bool NTreeReader::HaveValue(const string& name, const int num) const
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


size_t NTreeReader::NumChildren() const
{
   return children.size();
}


string NTreeReader::GetPath() const
{
   return path;
}
