#ifndef __ITEM_H
#define __ITEM_H

#include "IniReader.h"
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
