// @Begin License@
/***********************************************************************
   This file is part of Coldest.

   Coldest is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Coldest is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Coldest.  If not, see <http://www.gnu.org/licenses/>.
   
   Copyright 2008, 2009 Ben Nemec
***********************************************************************/
// @End License@
#include "Item.h"

Item::Item(const int newtype, Meshlist& ml) : id(0), usesleft(1), hp(100), team(0), mesh(ml.end()), type(newtype), 
           coolmultiplier(1.f), ammomultiplier(1.f), armormultiplier(1.f), weight(0), name("None"), modelfile("models/empty/base")
           
{
   switch (newtype)
   {
      case Item::NoItem:
         break;
      case Item::SpawnPoint:
         LoadFromFile("items/spawn");
         break;
      case Item::HeatSink:
         LoadFromFile("items/heatsink");
         break;
      case Item::AmmoCarrier:
         LoadFromFile("items/ammocarrier");
         break;
      case Item::Armor:
         LoadFromFile("items/armor");
         break;
      case Item::Base:
         LoadFromFile("items/base");
         break;
      default:
         logout << "Warning: attempted to create non-existent item " << newtype << "." << endl;
         break;
   };
}


void Item::LoadFromFile(const string& file)
{
   IniReader read(file);
   
   read.Read(usesleft, "Uses");
   read.Read(coolmultiplier, "CoolMult");
   read.Read(ammomultiplier, "AmmoMult");
   read.Read(armormultiplier, "ArmorMult");
   read.Read(weight, "Weight");
   read.ReadLine(name, "Name");
   read.Read(modelfile, "Model");
   read.Read(hp, "HP");
}



