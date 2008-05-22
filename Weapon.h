#ifndef __WEAPON_H
#define __WEAPON_H

#include "IniReader.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Weapon
{
   public:
      Weapon(const int);
      int Id(){return id;}
      int Damage(){return damage;}
      float Radius(){return radius;}
      float Velocity(){return velocity;}
      float Acceleration(){return acceleration;}
      float Splash(){return splashradius;}
      float Weight(){return weight;}
      float Heat(){return heat;}
      int ReloadTime(){return reloadtime;}
      bool Explode(){return explode;}
      string ModelFile(){return modelfile;}
      string Name(){return name;}
      
      enum Weapons{NoWeapon, MachineGun, Laser, Autocannon, GaussRifle, NeutrinoCannon, Mortar, numweapons};
      
      int ammo;
      
   private:
      void LoadFromFile(const string&);
      
      int id;
      int damage;
      float radius;
      float velocity;
      float acceleration;
      float splashradius;
      float weight;
      float heat;
      int reloadtime;
      bool explode;
      string modelfile;
      string name;

};

#endif
