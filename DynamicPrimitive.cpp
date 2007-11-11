#include "DynamicPrimitive.h"
#include "DynamicObject.h"

DynamicPrimitive::DynamicPrimitive()
{
   list<DynamicObject> dummy;
   parentobj = dummy.end();
}
