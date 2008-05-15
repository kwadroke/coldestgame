#ifndef __ITEM_H
#define __ITEM_H

#include "IniReader.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Item
{
   public:
      Item(const int);
      int Id(){return id;}
      int Uses(){return usesleft;}
      float CoolMult(){return coolmultiplier;}
      float AmmoMult(){return ammomultiplier;}
      float Weight(){return weight;}
      string Name(){return name;}
      
      enum Items{NoItem, SpawnPoint, HeatSink, AmmoCarrier, Radar, numitems};
      
   private:
      void LoadFromFile(const string&);
      
      int id;
      int usesleft;
      float coolmultiplier;
      float ammomultiplier;
      float weight;
      string name;

};

#endif
