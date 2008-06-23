#include "MeshNode.h"
#include "globals.h" // Causes problems if included in header
#include "Mesh.h"

MeshNode::MeshNode() : id(0), parentid(0), rot1(Vector3()), rot2(Vector3()),
                  trans(Vector3()), facing(false),
                  name(""), parent(NULL)
{
}


void MeshNode::Transform(const MeshNodePtr& interpnode, const float interpval, map<string, VertexPtr>& verts, 
                         const GraphicMatrix& parentm, const Vector3& campos)
{
   Vector3 interprot1 = lerp(interpnode->rot1, rot1, interpval);
   Vector3 interprot2 = lerp(interpnode->rot2, rot2, interpval);
   Vector3 interptrans = lerp(interpnode->trans, trans, interpval);
   
   m.identity();
   
   if (!facing)
   {
      m.rotatez(interprot2.z);
      m.rotatey(interprot2.y);
      m.rotatex(interprot2.x);
      
      m.translate(interptrans);
      
      m.rotatez(interprot1.z);
      m.rotatey(interprot1.y);
      m.rotatex(interprot1.x);
   }
   else
   {
      Vector3 norm(0, 0, 1);
      Vector3 dir;
      Vector3 start = -norm; // Initial view direction
      Vector3 facerot, currpos;
      
      // Find the current position - note that this duplicates code, but with facing containers
      // it is necessary to do this twice so there's not a good way around that
      GraphicMatrix facem;
      facem.translate(interptrans);
      if (parent) facem *= parent->m;
      facem *= parentm;
      currpos.transform(facem);
      dir = campos - currpos;
      
      facerot = RotateBetweenVectors(start, dir);
      
      m.rotatex(facerot.x);
      m.rotatey(facerot.y);
      m.translate(interptrans);
   }

   if (parent)
   {
      m *= parent->m;
   }
   m *= parentm;
   
   // Reset vertices then transform them to new positions
   GraphicMatrix normalm = m;
   normalm.members[12] = normalm.members[13] = normalm.members[14] = 0.f;
   for (size_t i = 0; i < vertices.size(); ++i)
   {
      *verts[vertices[i]->id] = *vertices[i];
      verts[vertices[i]->id]->pos.transform(m);
      verts[vertices[i]->id]->norm.transform(normalm);
   }
   
   // Recursively call this on our children
   for (size_t i = 0; i < children.size(); ++i)
   {
      children[i]->Transform(interpnode->children[i], interpval, verts, m, campos);
   }
}


// Currently this function keeps parent the same, even though that may not always be
// what is wanted.  It causes problems if we don't do this, however, because this gets
// called when inserting a mesh into an STL container, which is a fairly common
// operation and expected to insert an exact copy, not a copy with this pointer null'd
MeshNodePtr MeshNode::Clone()
{
   MeshNodePtr newmn(new MeshNode(*this));
   newmn->children.clear();
   newmn->parent = parent;
   
   for (size_t i = 0; i < vertices.size(); ++i)
   {
      newmn->vertices[i] = VertexPtr(new Vertex(*vertices[i]));
   }
   
   for (int i = 0; i < children.size(); ++i)
   {
      newmn->children.push_back(children[i]->Clone());
   }
   return newmn;
}


void MeshNode::GetContainers(map<string, MeshNodePtr>& cont, MeshNodePtr& thisptr)
{
   cont[name] = thisptr;
   for (int i = 0; i < children.size(); ++i)
      children[i]->GetContainers(cont, children[i]);
}


void MeshNode::Scale(const float& sval)
{
   for (size_t i = 0; i < vertices.size(); ++i)
   {
      vertices[i]->pos *= sval;
   }
   trans *= sval;
   for (int i = 0; i < children.size(); ++i)
   {
      children[i]->Scale(sval);
   }
}


void MeshNode::ScaleZ(const float& sval)
{
   for (size_t i = 0; i < vertices.size(); ++i)
   {
      vertices[i]->pos.z *= sval;
   }
   trans.z *= sval;
   for (int i = 0; i < children.size(); ++i)
   {
      children[i]->ScaleZ(sval);
   }
}



