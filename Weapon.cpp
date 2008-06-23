#include "Weapon.h"

Weapon::Weapon(const int newid) : ammo(-1), id(newid), damage(10), weight(0), radius(10.f), velocity(1.f), acceleration(1.f),
               splashradius(0.f), projectileweight(1.f), heat(0.f), reloadtime(50), explode(true), modelfile("projectile"),
               name("None"), tracerfile(""), tracertime(10000)
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
         cout << "Warning: attempted to create non-existent weapon." << endl;
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
}



