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
// Copyright 2008, 2010 Ben Nemec
// @End License@


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
      Uint32 ReloadTime() const {return reloadtime;}
      bool Explode() const {return explode;}
      string ModelFile() const {return modelfile;}
      string Name() const {return name;}
      string Tracer() const {return tracerfile;}
      string FireSound() const {return firesound;}
      int TracerTime() const {return tracertime;}
      string ExpFile() const {return expfile;}
      
      enum Weapons{NoWeapon, MachineGun, Laser, Autocannon, GaussRifle, NeutrinoCannon, Mortar, Rocket, Sight, numweapons};
      
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
      Uint32 reloadtime;
      bool explode;
      string modelfile;
      string name;
      string tracerfile;
      string expfile;
      string firesound;
      int tracertime;

};

#endif
