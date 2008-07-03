#include "Primitive.h"

Primitive::Primitive() : id(""), material(""), type(""),
                     parentid(""), name(""),
                     rot1(Vector3()), trans(Vector3()), rot2(Vector3()), collide(false),
                     facing(false)
{
   /*vector<float> tc(2, 0.f);
   vector<vector<float> > tcv(4, tc);
   tcv[1][1] = 1;
   tcv[2][0] = 1;
   tcv[2][1] = 1;
   tcv[3][0] = 1;
   texcoords = vector<vector<vector<float> > >(8, tcv);*/
}


Primitive* Primitive::GetPrimitive(const string& pid)
{
   if (prims.find(pid) != prims.end())
      return &prims[pid];
   
   for (map<string, Primitive>::iterator i = prims.begin(); i != prims.end(); ++i)
   {
      Primitive* ret = i->second.GetPrimitive(pid);
      if (ret)
         return ret;
   }
   
   return NULL;
}


VertexPtr Primitive::GetVertex(const string& pid)
{
   if (vertices.find(pid) != vertices.end())
      return vertices[pid];
   
   for (map<string, Primitive>::iterator i = prims.begin(); i != prims.end(); ++i)
   {
      VertexPtr ret = i->second.GetVertex(pid);
      if (ret)
         return ret;
   }
   
   return VertexPtr();
}


void Primitive::InsertPrimitive(Primitive& newp, const string& pid)
{
   if (id == pid || pid == "-1")
      prims[newp.id] = newp;
   else
   {
      for (map<string, Primitive>::iterator i = prims.begin(); i != prims.end(); ++i)
      {
         i->second.InsertPrimitive(newp, pid);
      }
   }
}


void Primitive::Transform(const GraphicMatrix& min)
{
   GraphicMatrix m;
   m.rotatez(rot2.z);
   m.rotatey(rot2.y);
   m.rotatex(rot2.x);
   m.translate(trans);
   m.rotatez(rot1.z);
   m.rotatey(rot1.y);
   m.rotatex(rot1.x);
   
   m *= min;
   
   for (map<string, VertexPtr>::iterator i = vertices.begin(); i != vertices.end(); ++i)
   {
      saveverts[i->first] = VertexPtr(new Vertex(*i->second));
      i->second->pos.transform(m);
   }
   
   for (map<string, Primitive>::iterator i = prims.begin(); i != prims.end(); ++i)
   {
      i->second.Transform(m);
   }
}


void Primitive::Restore()
{
   for (map<string, VertexPtr>::iterator i = saveverts.begin(); i != saveverts.end(); ++i)
   {
      *vertices[i->first] = *i->second;
   }
   
   for (map<string, Primitive>::iterator i = prims.begin(); i != prims.end(); ++i)
   {
      i->second.Restore();
   }
}
