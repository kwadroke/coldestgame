#ifndef __WEAPON_H
#define __WEAPON_H

#include "IniReader.h"
#include "logout.h"

/**
	@author Ben Nemec <cybertron@nemebean.com>
*/
class Weapon
{
   public:
      Weapon(const int);
      int Id() const {return id;}
      int Damage() const {return damage;}
      int Weight() const {return weight;}
      float Radius() const {return radius;}
      float Velocity() const {return velocity;}
      float Acceleration() const {return acceleration;}
      float Splash() const {return splashradius;}
      float ProjectileWeight() const {return projectileweight;}
      float Heat() const {return heat;}
      int ReloadTime() const {return reloadtime;}
      bool Explode() const {return explode;}
      string ModelFile() const {return modelfile;}
      string Name() const {return name;}
      string Tracer() const {return tracerfile;}
      int TracerTime() const {return tracertime;}
      string ExpFile() const {return expfile;}
      
      enum Weapons{NoWeapon, MachineGun, Laser, Autocannon, GaussRifle, NeutrinoCannon, Mortar, Rocket, numweapons};
      
      int ammo;
      
   private:
      void LoadFromFile(const string&);
      
      int id;
      int damage;
      int weight;
      float radius;
      float velocity;
      float acceleration;
      float splashradius;
      float projectileweight;
      float heat;
      int reloadtime;
      bool explode;
      string modelfile;
      string name;
      string tracerfile;
      string expfile;
      int tracertime;

};

#endif
