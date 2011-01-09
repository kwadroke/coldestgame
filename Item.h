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


#ifndef __ITEM_H
#define __ITEM_H

#include "NTreeReader.h"
#include "Mesh.h"

/**
   @author Ben Nemec <cybertron@nemebean.com>
*/
class Item
{
   public:
      Item(const int, Meshlist&);
      int Type() const{return type;}
      int Uses() const{return usesleft;}
      float CoolMult() const{return coolmultiplier;}
      float AmmoMult() const{return ammomultiplier;}
      float ArmorMult() const{return armormultiplier;}
      int Weight() const{return weight;}
      string Name() const{return name;}
      string ModelFile() const{return modelfile;}
      
      enum Items{NoItem, SpawnPoint, HeatSink, AmmoCarrier, Armor, Base, numitems};
      
      unsigned long id;
      int usesleft;
      int hp;
      Meshlist::iterator mesh;
      int team;
      Vector3 position; // Only used temporarily to store position - normally it is defined by the mesh
      
   private:
      void LoadFromFile(const string&);
      
      int type;
      float coolmultiplier;
      float ammomultiplier;
      float armormultiplier;
      int weight;
      string name;
      string modelfile;
      

};

#endif
