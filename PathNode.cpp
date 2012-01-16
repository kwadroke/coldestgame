#include "PathNode.h"
#include "CollisionDetection.h"

PathNode::PathNode(const Vector3& pos) : position(pos),
                                         nodes(8),
                                         passable(8, false),
                                         num(8, -1),
                                         step(50.f)
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


bool PathNode::Validate(Vector3 start, Vector3 move, const float radius)
{
   set<PathNode*> dummy;
   return Validate(start, move, radius, dummy);
}

bool PathNode::Validate(Vector3 start, Vector3 move, const float radius, set<PathNode*>& checked)
{
   CollisionDetection cd;
   start.y = position.y;
   move.y = 0.f;
   Vector3 end = start + move;
   float movemaginv = 1.f / move.magnitude();
   for (size_t i = 0; i < nodes.size(); ++i)
   {
      if (nodes[i] && checked.find(nodes[i].get()) == checked.end())
      {
         checked.insert(nodes[i].get());
         Vector3 flatpos = nodes[i]->position;
         flatpos.y = position.y;
         
         Vector3 flatvec = flatpos - position;
         flatvec.normalize();
         Vector3 movenorm = move;
         movenorm.normalize();
         float dot = flatvec.dot(movenorm);
         
         // Because DistanceBetween... checks an infinite line, we need to check that the node is in the direction
         // of the movement, and is not past the end of the movement
         if (dot > 1e-4f &&
             flatpos.distance(start) < move.distance() + radius &&
             cd.DistanceBetweenPointAndLine(flatpos, start, move, movemaginv) < radius + step / 2.f)
         {
            if (!passable[i] || !nodes[i]->Validate(start, move, radius, checked))
            {
               return false;
            }
         }
      }
   }
   return true;
}
