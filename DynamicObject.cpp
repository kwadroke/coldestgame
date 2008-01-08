#include "DynamicObject.h"
#include "DynamicPrimitive.h"

DynamicObject::DynamicObject()
{
   position = Vector3();
   rotation = pitch = roll = 0.f;
   // Etc, this is not complete yet
}

DynamicPrimitive* DynamicObject::GetDynPrimById(const string id, const int frame) const
{
   DPList primlist = prims[frame];
   list<DynamicPrimitive*>::iterator i;
   for (i = primlist.begin(); i != primlist.end(); ++i)
   {
      if ((*i)->id == id)
         return *i;
   }
   // Passed in an id that was not in list
   cout << "Error: Could not find primitive: " << id << endl;
   return NULL;
}
