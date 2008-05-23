#include "Item.h"

Item::Item(const int newtype, Meshlist& ml) : id(0), usesleft(1), hp(100), team(0), mesh(ml.end()), type(newtype), coolmultiplier(1.f), ammomultiplier(1.f),
           weight(0.f), name("None"), modelfile("models/empty/base")
           
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
      case Item::Radar:
         LoadFromFile("items/radar");
         break;
      case Item::Base:
         LoadFromFile("items/base");
         break;
      default:
         cout << "Warning: attempted to create non-existent item " << newtype << "." << endl;
         break;
   };
}


void Item::LoadFromFile(const string& file)
{
   IniReader read(file);
   
   read.Read(usesleft, "Uses");
   read.Read(coolmultiplier, "CoolMult");
   read.Read(ammomultiplier, "AmmoMult");
   read.Read(weight, "Weight");
   read.ReadLine(name, "Name");
   read.Read(modelfile, "Model");
   read.Read(hp, "HP");
}



