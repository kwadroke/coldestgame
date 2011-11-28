#include "PathNode.h"

PathNode::PathNode(const Vector3& pos) : position(pos),
                                         nodes(8),
                                         passable(8, false),
                                         num(8, -1)
{
}


Vector3vec PathNode::GetAdjacent(const float step)
{
   Vector3vec ret;
   ret.push_back(position + Vector3(-step, 0, -step));
   ret.push_back(position + Vector3(0, 0, -step));
   ret.push_back(position + Vector3(step, 0, -step));
   ret.push_back(position + Vector3(-step, 0, 0));
   ret.push_back(position + Vector3(step, 0, 0));
   ret.push_back(position + Vector3(-step, 0, step));
   ret.push_back(position + Vector3(0, 0, step));
   ret.push_back(position + Vector3(step, 0, step));
   return ret;
}


bool PathNode::Validate(const Vector3& v, const float radius)
{
   
}
