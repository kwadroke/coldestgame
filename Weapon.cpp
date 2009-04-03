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
// Copyright 2008, 2009 Ben Nemec
// @End License@


#include "Weapon.h"

Weapon::Weapon(const int newid) : ammo(-1), id(newid), damage(0), weight(0), radius(1.f), velocity(1.f), acceleration(0.f),
               splashradius(0.f), projectileweight(1.f), heat(0.f), reloadtime(50000), explode(true), modelfile("empty"),
               name("None"), tracerfile(""), expfile("particles/emitters/none"), firesound("sounds/beep-3.ogg"), tracertime(10000)
{
   switch (newid)
   {
      case Weapon::NoWeapon:
         break;
      case Weapon::MachineGun:
         LoadFromFile("weapons/machinegun");
         break;
      case Weapon::Laser:
         LoadFromFile("weapons/laser");
         break;
      case Weapon::Autocannon:
         LoadFromFile("weapons/autocannon");
         break;
      case Weapon::GaussRifle:
         LoadFromFile("weapons/gauss");
         break;
      case Weapon::NeutrinoCannon:
         LoadFromFile("weapons/neutrino");
         break;
      case Weapon::Mortar:
         LoadFromFile("weapons/mortar");
         break;
      case Weapon::Rocket:
         LoadFromFile("weapons/rocket");
         break;
      default:
         logout << "Warning: attempted to create non-existent weapon." << endl;
         break;
   };
}


void Weapon::LoadFromFile(const string& file)
{
   IniReader read(file);
   
   read.Read(ammo, "Ammo");
   read.Read(damage, "Damage");
   read.Read(radius, "Radius");
   read.Read(velocity, "Velocity");
   read.Read(acceleration, "Acceleration");
   read.Read(splashradius, "Splash");
   read.Read(weight, "Weight");
   read.Read(projectileweight, "ProjectileWeight");
   read.Read(heat, "Heat");
   read.Read(reloadtime, "ReloadTime");
   read.Read(explode, "Explode");
   read.ReadLine(modelfile, "Model");
   read.ReadLine(name, "Name");
   read.ReadLine(tracerfile, "Tracer");
   read.Read(tracertime, "TracerTime");
   read.ReadLine(expfile, "ExplosionEmitter");
   read.ReadLine(firesound, "FireSound");
}



