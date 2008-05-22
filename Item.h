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
      float Weight() const{return weight;}
      string Name() const{return name;}
      string ModelFile() const{return modelfile;}
      
      enum Items{NoItem, SpawnPoint, HeatSink, AmmoCarrier, Radar, Base, numitems};
      
      unsigned long id;
      int usesleft;
      int hp;
      Meshlist::iterator mesh;
      int team;
      
   private:
      void LoadFromFile(const string&);
      
      int type;
      float coolmultiplier;
      float ammomultiplier;
      float weight;
      string name;
      string modelfile;
      

};

#endif
