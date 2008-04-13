#include "MeshNode.h"
#include "globals.h" // Causes problems if included in header

MeshNode::MeshNode() : id(0), parentid(0), rot1(Vector3()), rot2(Vector3()),
                  trans(Vector3()), vert(Vector3vec(3, Vector3())), facing(false),
                  collide(false), render(true), material(NULL), name(""), parent(NULL),
                  matname("")
{
   floatvec tc(2, 0.f);
   vector<floatvec> tcv(3, tc);
   texcoords = vector< vector<floatvec> >(8, tcv);
}


// Returned triangles go directly into tris
void MeshNode::GenTris(const MeshNodePtr& interpnode, const float interpval, const GraphicMatrix& parentm, Trianglevec& tris)
{
   Vector3 interprot1 = lerp(interpnode->rot1, rot1, interpval);
   Vector3 interprot2 = lerp(interpnode->rot2, rot2, interpval);
   Vector3 interptrans = lerp(interpnode->trans, trans, interpval);
   
   m = GraphicMatrix();
   
   m.rotatex(interprot2.x);
   m.rotatey(interprot2.y);
   m.rotatez(interprot2.z);
   
   m.translate(interptrans);
   
   m.rotatex(interprot1.x);
   m.rotatey(interprot1.y);
   m.rotatez(interprot1.z);
   
   if (parent) // If we are the virtual child of a Node in another Mesh
   {
      m *= parent->m;
   }
   m *= parentm;
   
   // Save vertices for next time...
   Vector3vec savevert = vert;
   for (int i = 0; i < vert.size(); ++i)
      vert[i].transform(m);
   
   if (render)
   {
      Trianglevec newtris(vert.size() - 2);
      
      if (vert.size() == 3) // Generate one triangle
      {
         newtris[0].vert = vert;
         newtris[0].texcoords = texcoords;
      }
      else if (vert.size() == 4) // Generate quad
      {
         Quad newquad;
         for (int i = 0; i < 4; ++i)
         {
            newquad.SetVertex(i, vert[i]);
            for (int j = 0; j < 8; ++j)
            {
               newquad.SetTexCoords(i, j, texcoords[j][i]);
            }
         }
         newtris[0] = newquad.First();
         newtris[1] = newquad.Second();
      }
      
      // Set per-tri properties
      for (int i = 0; i < newtris.size(); ++i)
      {
         newtris[i].material = material;
         
         Vector3 norm = newtris[i].vert[1] - newtris[i].vert[0];
         norm = norm.cross(newtris[i].vert[2] - newtris[i].vert[0]);
         for (int j = 0; j < 3; ++j)
         {
            newtris[i].norm[j] = norm;
         }
         newtris[i].collide = collide;
         tris.push_back(newtris[i]);
      }
   }
   vert = savevert;
   
   // Recursively call this on our children
   for (int i = 0; i < children.size(); ++i)
   {
      children[i]->GenTris(interpnode->children[i], interpval, m, tris);
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
   
   for (int i = 0; i < children.size(); ++i)
   {
      newmn->children.push_back(children[i]->Clone());
   }
   return newmn;
}


// Note: This just returns all nodes where render == false.  This is not necessarily only containers,
// but since we don't store the type in the Node it's as good as we can do (unless we _do_ start storing
// types, but I'm not sure we want to do that)
void MeshNode::GetContainers(map<string, MeshNodePtr>& cont, MeshNodePtr& thisptr)
{
   if (!render)
   {
      cont[name] = thisptr;
   }
   for (int i = 0; i < children.size(); ++i)
      children[i]->GetContainers(cont, children[i]);
}


void MeshNode::LoadMaterials(ResourceManager& resman)
{
   material = &resman.LoadMaterial(matname);
   for (int i = 0; i < children.size(); ++i)
   {
      if (children[i]->matname != "")
         children[i]->LoadMaterials(resman);
   }
}


