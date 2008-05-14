#include "Weapon.h"

Weapon::Weapon(const int newid) : id(newid), damage(10), radius(10.f), velocity(1.f), acceleration(1.f),
               splashradius(0.f), weight(1.f), heat(0.f), reloadtime(50), explode(true), modelfile("projectile"),
               name("None")
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
      default:
         cout << "Warning: attempted to create non-existent weapon." << endl;
         break;
   };
}


void Weapon::LoadFromFile(const string& file)
{
   IniReader read(file);
   
   read.Read(damage, "Damage");
   read.Read(radius, "Radius");
   read.Read(velocity, "Velocity");
   read.Read(acceleration, "Acceleration");
   read.Read(splashradius, "Splash");
   read.Read(weight, "Weight");
   read.Read(heat, "Heat");
   read.Read(reloadtime, "ReloadTime");
   read.Read(explode, "Explode");
   read.Read(modelfile, "Model");
   read.ReadLine(name, "Name");
}



