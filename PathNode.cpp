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
   CollisionDetection cd;
   start.y = position.y;
   move.y = 0.f;
   Vector3 end = start + move;
   for (size_t i = 0; i < nodes.size(); ++i)
   {
      // Because DistanceBetween... checks an infinite line, we need to check that the node is in the direction
      // of the movement, and is not past the end of the movement
      if (nodes[i])
      {
         Vector3 flatpos = nodes[i]->position;
         flatpos.y = position.y;
         
         Vector3 flatvec = flatpos - position;
         flatvec.normalize();
         Vector3 movenorm = move;
         movenorm.normalize();
         float dot = flatvec.dot(movenorm);
         
         if (dot > 1e-4f &&
             flatpos.distance(start) < move.distance() + radius &&
             cd.DistanceBetweenPointAndLine(flatpos, start, move, 1.f / move.magnitude()) < radius + step / 2.f)
         {
            if (!passable[i] || !nodes[i]->Validate(start, move, radius))
            {
               return false;
            }
         }
      }
   }
   return true;
}
