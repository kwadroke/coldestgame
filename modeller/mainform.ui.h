/****************************************************************************
** ui.h extension file, included from the uic-generated form implementation.
**
** If you want to add, delete, or rename functions or slots, use
** Qt Designer to update this file, preserving your code.
**
** You should not define a constructor or destructor in this file.
** Instead, write your code in functions called init() and destroy().
** These will automatically be called by the form's constructor and
** destructor.
*****************************************************************************/

#include <qlistview.h>
#include <qfiledialog.h>
#include <iostream>
#include <vector>
#include <map>
#include "Vector3.h"
#include "Primitive.h"
#include "Vertex.h"
#include "Triangle.h"
#include "Quad.h"
#include "trivertselection.h"

using namespace std;

int nextid;
bool loadingprim;
map<string, Triangle> tris;
int currvert;
Primitive rootprim;
QString fileversion;
QString currentfilename;
QString windowname;
QListViewItem *copyparent;
TriVertSelection *trivertsel;

void GLModeller::init()
{
   nextid = 0;
   currvert = 0;
   display->setTriangleMap(&tris);
   display->setRootPrim(&rootprim);
   display->setParent(this);
   loadingprim = false;
   fileversion = "Version4"; // No spaces allowed
   matlist->setColumnStretchable(0, true);
   currentfilename = "";
   windowname = "GL Modeller";
   chdir("../coldest");
   trivertsel = new TriVertSelection(this);
}


void GLModeller::Add()
{
   QString idstr;
   idstr.setNum(nextid);
   if (typecombo->currentText() == "Container")
   {
      if (vertlist->selectedItem())
      {
         AddContainer(vertlist->selectedItem(), idstr);
      }
      else
      {
         AddContainer(NULL, idstr);
      }
   }
   else if (typecombo->currentText() == "Vertex")
   {
      AddVertex(vertlist->selectedItem(), idstr);
   }
   else if (typecombo->currentText() == "Triangle")
   {
      AddTriangle();
   }
   else if (typecombo->currentText() == "Quad")
   {
      AddQuad(vertlist->selectedItem());
   }
   UpdateDisplay();
#if 0
   cout << "Calling add" << endl;
   QString parent = "-1";
   if (!vertlist->selectedItem())
   {
      if (typecombo->currentText() == "Vertex")
         return;
      new QListViewItem(vertlist, typecombo->currentText(), "", QString().setNum(nextid));
   }
   else 
   {
      new QListViewItem(vertlist->selectedItem(), typecombo->currentText(), "", QString().setNum(nextid));
      parent = vertlist->selectedItem()->text(idcol);
   }
   
   QString idstr;
   idstr.setNum(nextid);
   if (typecombo->currentText() == "Vertex")
   {
      if (parent == "-1")
      {
         cout << "Error: Vertex must be inserted in container\n";
         return;
      }
      VertexPtr newvert(new Vertex());
      Primitive* newp = rootprim.GetPrimitive(parent);
      newvert->id = idstr.ascii();
      newp->vertices[idstr] = newvert;
   }
   else if (typecombo->currentText() == "Container")
   {
      Primitive newp;
      newp.id = idstr;
      newp.parentid = parent;
      newp.name = "";
   
      newp.rot1 = Vector3();
      newp.trans = Vector3();
      newp.rot2 = Vector3();
   
      newp.collide = false;
      newp.facing = false;
      newp.type = "Container";
      
      if (parent == "-1")
         rootprim.prims[idstr] = newp;
      else
      {
         Primitive* parentp = rootprim.GetPrimitive(parent);
         parentp->prims[idstr] = newp;
      }
   }
   ++nextid;
   UpdateDisplay();
#endif
}


void GLModeller::AddVertex( QListViewItem * parent, const QString & id )
{
   cout << "Calling addvertex" << endl;
   if (!parent || parent->text(primcol) != "Container")
   {
      cout << "Error: Vertices must be inserted in containers" << endl;
      return;
   }
   
   new QListViewItem(parent, "Vertex", "", id);
   QString parentid = parent->text(idcol);
   
   VertexPtr newvert(new Vertex());
   Primitive* newp = rootprim.GetPrimitive(parentid);
   newvert->id = id.ascii();
   newp->vertices[id] = newvert;
   ++nextid;
}


QListViewItem* GLModeller::AddContainer( QListViewItem * parent, const QString & id )
{
   cout << "Calling addcontainer" << endl;
   QString parentid = "-1";
   QListViewItem* ret;
   
   if (!parent)
   {
      ret = new QListViewItem(vertlist, "Container", "", id);
   }
   else
   {
      if (parent->text(primcol) != "Container")
      {
         cout << "Error: Containers can only be inserted in other containers\n";
         return NULL; // May cause a crash if it happens in AddQuad
      }
      ret = new QListViewItem(parent, "Container", "", id);
      parentid = parent->text(idcol);
   }
   
   Primitive newp;
   newp.id = id;
   newp.parentid = parentid;
   newp.name = "";

   newp.rot1 = Vector3();
   newp.trans = Vector3();
   newp.rot2 = Vector3();

   newp.collide = false;
   newp.facing = false;
   newp.type = "Container";
   
   if (parentid == "-1")
      rootprim.prims[id] = newp;
   else
   {
      Primitive* parentp = rootprim.GetPrimitive(parentid);
      parentp->prims[id] = newp;
   }
   ++nextid;
   return ret;
}



void GLModeller::AddQuad( QListViewItem * parent )
{
   QString idstr;
   idstr.setNum(nextid);
   // Add container
   QListViewItem* container;
   if (vertlist->selectedItem())
   {
      container = AddContainer(vertlist->selectedItem(), idstr);
   }
   else
   {
      container = AddContainer(NULL, idstr);
   }
   
   // Add vertices
   int firstvert = nextid;
   for (size_t i = 0; i < 4; ++i)
   {
      idstr.setNum(nextid);
      AddVertex(container, idstr);
   }
   
   //  Add triangles and attach them to appropriate verts
   idstr.setNum(nextid);
   QString firsttri = idstr;
   AddTriangle();
   idstr.setNum(nextid);
   QString secondtri = idstr;
   AddTriangle();
   
   Quad q; // Use quad class to help us populate this
   q.SetVertex(0, Vector3(-1000, 1000, 0));
   q.SetVertex(1, Vector3(-1000, -1000, 0));
   q.SetVertex(2, Vector3(1000, -1000, 0));
   q.SetVertex(3, Vector3(1000, 1000, 0));
   TrianglePtr qtrione = q.First();
   TrianglePtr qtritwo = q.Second();
   
   idstr.setNum(firstvert);
   VertexPtr currv = rootprim.GetVertex(idstr);
   tris[firsttri].v[0] = currv;
   *tris[firsttri].v[0] = *qtrione->v[0];
   currv->id = idstr.ascii();
   
   idstr.setNum(firstvert + 1);
   currv = rootprim.GetVertex(idstr);
   tris[firsttri].v[1] = currv;
   tris[secondtri].v[1] = currv;
   *tris[firsttri].v[1] = *qtrione->v[1];
   currv->id = idstr.ascii();
   
   idstr.setNum(firstvert + 2);
   currv = rootprim.GetVertex(idstr);
   tris[firsttri].v[2] = currv;
   tris[secondtri].v[0] = currv;
   *tris[firsttri].v[2] = *qtrione->v[2];
   currv->id = idstr.ascii();
   
   idstr.setNum(firstvert + 3);
   currv = rootprim.GetVertex(idstr);
   tris[secondtri].v[2] = currv;
   *tris[secondtri].v[2] = *qtritwo->v[1];
   currv->id = idstr.ascii();
}


void GLModeller::DeleteVertex()
{
   if (vertlist->selectedItem())
   {
      while (vertlist->selectedItem()->childCount())
         DeletePrim(vertlist->selectedItem()->firstChild());
      
      DeletePrimByID(vertlist->selectedItem()->text(idcol));
      delete vertlist->selectedItem();
   }
   UpdateDisplay();
}


// Recursively delete children, if any
void GLModeller::DeletePrim( QListViewItem *i )
{
   if (i)  // Just to be safe
   {
      while (i->childCount())
      {
         //QString id = i->firstChild()->text(1);
         DeletePrim(i->firstChild());
      }
      DeletePrimByID(i->text(idcol));
      delete i;
   }
}


void GLModeller::AddTriangle()
{
   tris[QString().setNum(nextid)] = Triangle();
   int newnumrows = trilist->numRows() + 1;
   trilist->setNumRows(newnumrows);
   trilist->setText(newnumrows - 1, 0, QString().setNum(nextid));
   ++nextid;
}


/* Update the display, including putting any changed values from the
   input boxes into the appropriate data structure. */
void GLModeller::UpdateDisplay()
{
   QListViewItem *current = vertlist->selectedItem();
   if (current && !loadingprim)
   {
      QString id = current->text(idcol);
      if (current->text(primcol) == "Container")
      {
         Primitive* currprim = rootprim.GetPrimitive(id);
         // Rotations
         currprim->rot1.x = frotxbox->value();
         currprim->rot1.y = frotybox->value();
         currprim->rot1.z = frotzbox->value();
         currprim->rot2.x = srotxbox->value();
         currprim->rot2.y = srotybox->value();
         currprim->rot2.z = srotzbox->value();
         
         // Translation
         currprim->trans.x = tranxbox->value();
         currprim->trans.y = tranybox->value();
         currprim->trans.z = tranzbox->value();
         
         currprim->name = nameedit->text();
         current->setText(namecol, currprim->name);
      }
      else if (current->text(primcol) == "Vertex")
      {
         QListViewItem* parent = current->parent();
         Primitive* currprim = rootprim.GetPrimitive(parent->text(idcol));
         VertexPtr vert = currprim->vertices[id];
         // Position
         vert->pos.x = vertx->value();
         vert->pos.y = verty->value();
         vert->pos.z = vertz->value();
         
         // Texture coordinates
         int tn = texunitcombo->currentText().toInt();
         vert->texcoords[tn][0] = texcoordx->value() / 1000.f;
         vert->texcoords[tn][1] = texcoordy->value() / 1000.f;
      }
   }
   
   // Update triangles
   QString selid = trilist->text(trilist->currentRow(), 0);
   if (trivertsel->isVisible())
   {
      current = trivertsel->vertlist->selectedItem();
      tris[selid].v[currvert] = rootprim.GetVertex(current->text(idcol));
   }
   
   if (trilist->currentRow() >= 0 && !loadingprim)
   {
      if (matlist->numRows() > 0 && matlist->currentRow() >= 0)
      {
         QString check = matlist->text(matlist->currentRow(), 0);
         if (check != QString::null)
         {
            tris[selid].matname = matlist->text(matlist->currentRow(), 0).ascii();
            tris[selid].material = &display->resman.LoadMaterial(tris[selid].matname);
         }
      }
      tris[selid].collide = collidebox->isChecked();
   }
   for (size_t j = 0; j < trilist->numRows(); ++j)
   {
      QString verts = "";
      selid = trilist->text(j, 0);
      for (size_t i = 0; i < 3; ++i)
      {
         if (i) verts += ", ";
         verts += tris[selid].v[i]->id;
      }
      trilist->setText(j, 1, verts);
   }
   
   display->updateGL();
   
#if 0
   QListViewItem *current = vertlist->selectedItem();
   if (current && !loadingprim)
   {
      QString id = current->text(idcol);
      Primitive *currprim = GetPrimByID(id);
      if (currprim->type == "Quad")
      {
         // Vertices
         currprim->point[0].x = vert1x->value();
         currprim->point[0].y = vert1y->value();
         currprim->point[0].z = vert1z->value();
         currprim->point[1].x = vert2x->value();
         currprim->point[1].y = vert2y->value();
         currprim->point[1].z = vert2z->value();
         currprim->point[2].x = vert3x->value();
         currprim->point[2].y = vert3y->value();
         currprim->point[2].z = vert3z->value();
         currprim->point[3].x = vert4x->value();
         currprim->point[3].y = vert4y->value();
         currprim->point[3].z = vert4z->value();
         
         // Rotations
         currprim->rot1.x = frotxbox->value();
         currprim->rot1.y = frotybox->value();
         currprim->rot1.z = frotzbox->value();
         currprim->rot2.x = srotxbox->value();
         currprim->rot2.y = srotybox->value();
         currprim->rot2.z = srotzbox->value();
         
         // Translation
         currprim->trans.x = tranxbox->value();
         currprim->trans.y = tranybox->value();
         currprim->trans.z = tranzbox->value();
         
         // Material
         //currprim->texture[tn] = texlist->text(texlist->currentRow(), 0);
         currprim->material = matlist->text(matlist->currentRow(), 0);
         
         // Texture coordinates
         int tn = texunitcombo->currentText().toInt();
         currprim->texcoords[tn][0][0] = texcoordx0->value() / 1000.f;
         currprim->texcoords[tn][1][0] = texcoordx1->value() / 1000.f;
         currprim->texcoords[tn][2][0] = texcoordx2->value() / 1000.f;
         currprim->texcoords[tn][3][0] = texcoordx3->value() / 1000.f;
         currprim->texcoords[tn][0][1] = texcoordy0->value() / 1000.f;
         currprim->texcoords[tn][1][1] = texcoordy1->value() / 1000.f;
         currprim->texcoords[tn][2][1] = texcoordy2->value() / 1000.f;
         currprim->texcoords[tn][3][1] = texcoordy3->value() / 1000.f;
         
         // Miscellaneous
         currprim->collide = collidebox->isChecked();
         currprim->facing = facingbox->isChecked();
      }
      else if (currprim->type == "Container")
      {
         // Rotations
         currprim->rot1.x = frotxbox->value();
         currprim->rot1.y = frotybox->value();
         currprim->rot1.z = frotzbox->value();
         currprim->rot2.x = srotxbox->value();
         currprim->rot2.y = srotybox->value();
         currprim->rot2.z = srotzbox->value();
         
         // Translation
         currprim->trans.x = tranxbox->value();
         currprim->trans.y = tranybox->value();
         currprim->trans.z = tranzbox->value();
      }
      currprim->name = nameedit->text();
      current->setText(namecol, currprim->name);
   }
   
   display->updateGL();
#endif
}


// Update input fields with new item's data
void GLModeller::vertlist_selectionChanged( QListViewItem *item )
{
   if (item)
   {
      loadingprim = true;
      QString id = item->text(idcol);
      if (item->text(primcol) == "Container")
      {
         Primitive* currprim = rootprim.GetPrimitive(id);
         
         // Rotations
         frotxbox->setValue(int(currprim->rot1.x));
         frotybox->setValue(int(currprim->rot1.y));
         frotzbox->setValue(int(currprim->rot1.z));
         srotxbox->setValue(int(currprim->rot2.x));
         srotybox->setValue(int(currprim->rot2.y));
         srotzbox->setValue(int(currprim->rot2.z));
         
         // Translation
         tranxbox->setValue(int(currprim->trans.x));
         tranybox->setValue(int(currprim->trans.y));
         tranzbox->setValue(int(currprim->trans.z));
         
         // Material
         /*
         int tn = texunitcombo->currentText().toInt();
         bool found = false;
         matlist->clearSelection();
         for (int i = 0; i < matlist->numRows(); ++i)
         {
            if (matlist->text(i, 0) == currprim.material)
            {
               found = true;
               cout << "Found\n" << flush;
               matlist->selectRow(i);
               break;
            }
         }
         if (!found)
            matlist->selectRow(0);
         
         // Miscellaneous
         facingbox->setChecked(currprim.facing);
         collidebox->setChecked(currprim.collide);
         */
         nameedit->setText(currprim->name);
      }
      
      else if (item->text(primcol) == "Vertex")
      {
         QListViewItem* parent = item->parent();
         Primitive* currprim = rootprim.GetPrimitive(parent->text(idcol));
         VertexPtr vert = currprim->vertices[item->text(idcol)];
         // Position
         vertx->setValue(int(vert->pos.x));
         verty->setValue(int(vert->pos.y));
         vertz->setValue(int(vert->pos.z));
         display->rendervert = item->text(idcol);
         
         // Texture coordinates
         int tn = texunitcombo->currentText().toInt();
         texcoordx->setValue(int(vert->texcoords[tn][0] * 1000));
         texcoordy->setValue(int(vert->texcoords[tn][1] * 1000));
      }
      
      loadingprim = false;
   }
}



void GLModeller::DeletePrimByID( QString id )
{
#if 0
   vector<Primitive>::iterator i;
   for (i = prims->begin(); i != prims->end(); i++)
   {
      if (i->id == id)
      {
         cout << "Deleting: " << id << endl << flush;
         prims->erase(i);
         return;
      }
   }
   // Didn't find it, somebody did something bad if we hit this
   cout << "Warning: Attempted to delete a non-existent primitive.\n";
   cout << "Num: " << id << endl << flush;
#endif
}


void GLModeller::fileSaveAction_activated()
{
   if (currentfilename == "")
   {
      fileSaveAsAction_activated();
      return;
   }
   SaveToFile(currentfilename);
}


void GLModeller::fileSaveAsAction_activated()
{
   QString filename = QFileDialog::getSaveFileName("/home/cybertron/source/coldest/models");
   if (filename == "") return;  // Clicked cancel
   currentfilename = filename;
   QFileInfo fi(filename);
   this->setCaption(fi.baseName(true) + " - " + windowname);
   SaveToFile(filename);
}


void GLModeller::SaveToFile( QString filename )
{
   cout << "Saving to: " << filename << endl << flush;
   QFile ofile(filename);
   QTextStream o(&ofile);
   ofile.open(IO_WriteOnly);
   o << "Version " << fileversion << endl;
   o << "NextID " << nextid << endl;
   o << "TimeToNextFrame " << 1000 << endl; // Temp hardcoded
   
   // Write containers
   Primitive* currprim;
   QString strid;
   for (size_t i = 0; i < nextid; ++i)
   {
      // This could perform badly with large models.  Just keep that in mind...
      strid.setNum(i);
      currprim = rootprim.GetPrimitive(strid);
      if (!currprim) continue;
      o << "Container\n";
      o << "   ID " << currprim->id << endl;
      o << "   ParentID " << currprim->parentid << endl;
      o << "   Name " << currprim->name << endl;
      o << "   Facing " << currprim->facing << endl;
      o << "   Rot1 " << currprim->rot1.x << " " << currprim->rot1.y << " " << currprim->rot1.z << endl;
      o << "   Rot2 " << currprim->rot2.x << " " << currprim->rot2.y << " " << currprim->rot2.z << endl;
      o << "   Trans " << currprim->trans.x << " " << currprim->trans.y << " " << currprim->trans.z << endl;
      for (map<string, VertexPtr>::iterator j = currprim->vertices.begin();
           j != currprim->vertices.end(); ++j)
      {
         o << "   Vertex\n";
         o << "      ID " << j->second->id << endl;
         o << "      Pos " << j->second->pos.x << " " << j->second->pos.y << " " << j->second->pos.z << endl;
         o << "      Norm " << j->second->norm.x << " " << j->second->norm.y << " " << j->second->norm.z << endl;
         o << "      TC ";
         for (int k = 0; k < 8; ++k)
         {
            o << j->second->texcoords[k][0] << " " << j->second->texcoords[k][1] << " ";
         }
         o << endl;
      }
   }
   
   // Write triangles
   o << "Node\n"; // Close off Primitive list
   o << "   Triangles\n";
   for (map<string, Triangle>::iterator i = tris.begin(); i != tris.end(); ++i)
   {
      Triangle& curr = i->second;
      o << "   Tri\n";
      o << "      ID " << i->first << endl;
      o << "      Verts " << curr.v[0]->id << " " << curr.v[1]->id << " " << curr.v[2]->id << endl;
      o << "      Material " << i->second.matname << endl;
      o << "      Collide " << i->second.collide << endl;
   }
   
#if 0
   vector<Primitive>::iterator i;
   for (i = prims->begin(); i != prims->end(); i++)
   {
      o << "Primitive\n";
      o << "   Type " << i->type << endl;
      o << "   ID " << i->id << endl;
      o << "   ParentID " << i->parentid << endl;
      if (i->name != "")
         o << "   Name " << i->name << endl;
      o << "   Material " << i->material << endl;
      o << "   Rot1 " << i->rot1.x << " " << i->rot1.y << " " << i->rot1.z << endl;
      o << "   Rot2 " << i->rot2.x << " " << i->rot2.y << " " << i->rot2.z << endl;
      o << "   Trans " << i->trans.x << " " << i->trans.y << " " << i->trans.z << endl;
      if (i->type == "Quad")
      {
         QString fillzero = "";
         for (int j = 0; j < 4; ++j)
         {
            o << "   p" << j << " " <<  i->point[j].x << " " << i->point[j].y << " " << i->point[j].z << endl;
            o << "   tc" << j << "x ";
            for (int k = 0; k < 8; ++k)
            {
               o << i->texcoords[k][j][0] << " ";
               /*if (i->texture[k] != "")
               {
                  fillzero = (k < 10) ? "0" : "";
                  o << "   tc" << fillzero << k << j << "x = " << i->texcoords[k][j][0] << endl;
                  o << "   tc" << fillzero << k << j << "y = " << i->texcoords[k][j][1] << endl;
               }*/
            }
            o << endl;
            o << "   tc" << j << "y ";
            for (int k = 0; k < 8; ++k)
            {
               o << i->texcoords[k][j][1] << " ";
            }
            o << endl;
         }
         o << "   Collide " << i->collide << endl;
         o << "   Facing " << i->facing << endl;
      }
      /*if (i->type == "cylinder")
      {
         o << "Radius 1 = " << i->rad1 << endl;
         o << "Radius 2 = " << i->rad2 << endl;
         o << "Height = " << i->height << endl;
         o << "Slices = " << i->slices << endl;
         o << "Stacks = " << i->stacks << endl;
         
         o << "Transparent = " << i->transparent << endl;
         o << "Translucent = " << i->translucent << endl;
         o << "Collide = " << i->collide << endl;
      }*/
   }
#endif
   ofile.close();   
}


void GLModeller::fileOpenAction_activated()
{
   QString filename = QFileDialog::getOpenFileName("/home/cybertron/source/coldest/models");
   if (filename == "") return;
   cout << "Loading " << filename << endl;
   
   IniReader read(filename);
   string strbuffer;
   read.Read(strbuffer, "Version");
   if (strbuffer != fileversion)
   {
      cout << "File version mismatch\n";
      return;
   }
   read.Read(nextid, "NextID");
   
   vector<Primitive> newprims;
   rootprim = Primitive();
   for (size_t i = 0; i < read.GetItemIndex("Triangles"); ++i)
   {
      const IniReader& curr = read(i);
      Primitive pbuffer;
      curr.Read(strbuffer, "ID");
      pbuffer.id = strbuffer;
      curr.Read(strbuffer, "ParentID");
      pbuffer.parentid = strbuffer;
      curr.Read(strbuffer, "Name");
      pbuffer.name = strbuffer;
      curr.Read(pbuffer.rot1.x, "Rot1", 0);
      curr.Read(pbuffer.rot1.y, "Rot1", 1);
      curr.Read(pbuffer.rot1.z, "Rot1", 2);
      curr.Read(pbuffer.rot2.x, "Rot2", 0);
      curr.Read(pbuffer.rot2.y, "Rot2", 1);
      curr.Read(pbuffer.rot2.z, "Rot2", 2);
      curr.Read(pbuffer.trans.x, "Trans", 0);
      curr.Read(pbuffer.trans.y, "Trans", 1);
      curr.Read(pbuffer.trans.z, "Trans", 2);
      
      for (size_t j = 0; j < curr.NumChildren(); ++j)
      {
         const IniReader& currvert = curr(j);
         VertexPtr newv(new Vertex());
         currvert.Read(strbuffer, "ID");
         newv->id = strbuffer;
         currvert.Read(newv->pos.x, "Pos", 0);
         currvert.Read(newv->pos.y, "Pos", 1);
         currvert.Read(newv->pos.z, "Pos", 2);
         currvert.Read(newv->norm.x, "Norm", 0);
         currvert.Read(newv->norm.y, "Norm", 1);
         currvert.Read(newv->norm.z, "Norm", 2);
         for (int k = 0; k < 8; ++k)
         {
            currvert.Read(newv->texcoords[k][0], "TC", k * 2);
            currvert.Read(newv->texcoords[k][1], "TC", k * 2 + 1);
         }
         pbuffer.vertices[newv->id] = newv;
      }
      
      rootprim.InsertPrimitive(pbuffer, pbuffer.parentid);
      newprims.push_back(pbuffer);
   }
   
   // Repopulate the listview - note that this assumes the parent will always
   // have a lower id than the child...a safe assumption right now but
   // consider it an invariant for the future
   vertlist->clear();
   for (vector<Primitive>::iterator i = newprims.begin(); i != newprims.end(); i++)
   {
      QListViewItem *parent = FindPrimInList(i->parentid);
      if (parent)
      {
         new QListViewItem(parent, "Container", i->name, i->id);
      }
      else if (i->parentid == "-1") // Magic number...or is it;-)
      {
         new QListViewItem(vertlist, "Container", i->name, i->id);
      }
      
      parent = FindPrimInList(i->id);
      for (map<string, VertexPtr>::iterator j = i->vertices.begin(); j != i->vertices.end(); ++j)
      {
         new QListViewItem(parent, "Vertex", "", j->second->id);
      }
   }
   
   tris.clear();
   const IniReader& readtris = read.GetItemByName("Triangles");
   trilist->setNumRows(readtris.NumChildren());
   for (size_t i = 0; i < readtris.NumChildren(); ++i)
   {
      const IniReader& curr = readtris(i);
      Triangle newtri;
      for (int j = 0; j < 3; ++j)
      {
         curr.Read(strbuffer, "Verts", j);
         newtri.v[j] = rootprim.GetVertex(strbuffer);
      }
      curr.Read(strbuffer, "Material");
      newtri.matname = strbuffer;
      if (newtri.matname != "")
         newtri.material = &display->resman.LoadMaterial(strbuffer);
      curr.Read(newtri.collide, "Collide");
      curr.Read(strbuffer, "ID");
      tris[strbuffer] = newtri;
      trilist->setText(i, 0, strbuffer);
   }
   
   currentfilename = filename;
   QFileInfo fi(filename);
   this->setCaption(fi.baseName(true) + " - " + windowname);
   UpdateDisplay();
   cout << "Finished" << endl;
#if 0
   QString filename = QFileDialog::getOpenFileName("/home/cybertron/source/coldest/models");
   if (filename == "") return;
   
   IniReader read(filename);
   string strbuffer;
   read.Read(strbuffer, "Version");
   if (strbuffer != fileversion)
   {
      cout << "File version mismatch\n";
      return;
   }
   read.Read(nextid, "NextID");
   
    // Load data into vector
   vector<Primitive> *newv = new vector<Primitive>();
   for (int i = 0; i < read.NumChildren(); ++i)
   {
      IniReader currprim = read(i);
      Primitive pbuffer;
      currprim.Read(strbuffer, "Type");
      pbuffer.type = strbuffer;
      currprim.Read(strbuffer, "ID");
      pbuffer.id = strbuffer;
      currprim.Read(strbuffer, "ParentID");
      pbuffer.parentid = strbuffer;
      currprim.Read(strbuffer, "Material");
      pbuffer.material = strbuffer;
      currprim.ReadLine(strbuffer, "Name");
      pbuffer.name = strbuffer;
      currprim.Read(pbuffer.rot1.x, "Rot1", 0);
      currprim.Read(pbuffer.rot1.y, "Rot1", 1);
      currprim.Read(pbuffer.rot1.z, "Rot1", 2);
      currprim.Read(pbuffer.rot2.x, "Rot2", 0);
      currprim.Read(pbuffer.rot2.y, "Rot2", 1);
      currprim.Read(pbuffer.rot2.z, "Rot2", 2);
      currprim.Read(pbuffer.trans.x, "Trans", 0);
      currprim.Read(pbuffer.trans.y, "Trans", 1);
      currprim.Read(pbuffer.trans.z, "Trans", 2);
      
      if (pbuffer.type == "Quad")
      {
         string pname, tcname;
         QString num;
         for (int k = 0; k < 4; ++k)
         {
            pname = "p" + string(num.setNum(k).ascii());
            tcname = "tc" + string(num.setNum(k).ascii());
            currprim.Read(pbuffer.point[k].x, pname, 0);
            currprim.Read(pbuffer.point[k].y, pname, 1);
            currprim.Read(pbuffer.point[k].z, pname, 2);
            for (int m = 0; m < 8; ++m)
            {
               currprim.Read(pbuffer.texcoords[m][k][0], tcname + "x", m);
               currprim.Read(pbuffer.texcoords[m][k][1], tcname + "y", m);
            }
         }
         currprim.Read(pbuffer.collide, "Collide");
         currprim.Read(pbuffer.facing, "Facing");
      }
      
      newv->push_back(pbuffer);
   }
   
   /* Add primitives to listview - let's be clear, this was
   written to be as simple as possible, so it's going to
   be one awful algorithm, but as long as it works I don't
   care.  Be careful though, with large numbers of primitives
   this could get extremely slow.
   */
   primlist->clear();
   uint placed = 0;
   vector<Primitive>::iterator i;
   while (placed != newv->size())
   {
      for (i = newv->begin(); i != newv->end(); i++)
      {
         if (!FindPrimInList(i->id))
         {
            QListViewItem *parent = FindPrimInList(i->parentid);
            if (parent)
            {
               new QListViewItem(parent, i->type, i->name, i->id);
               ++placed;
            }
            else if (i->parentid == "-1") // Magic number...or is it;-)
            {
               new QListViewItem(primlist, i->type, i->name, i->id);
               ++placed;
            }
            //cout << placed << "  " << newv->size() << endl << flush;
         }
      }
   }
   
   // Can someone explain to me why I did this this way?
   delete prims;
   prims = newv;
   currentfilename = filename;
   QFileInfo fi(filename);
   this->setCaption(fi.baseName(true) + " - " + windowname);
   UpdateDisplay();
#endif
}


// Return a pointer to the QListViewItem with the id of id
QListViewItem * GLModeller::FindPrimInList( QString id )
{
   QListViewItemIterator i(vertlist);
   while (i.current())
   {
      if (i.current()->text(idcol) == id)
         return i.current();
      i++;
   }
   // Didn't find it
   return NULL;
}


void GLModeller::fileNewAction_activated()
{
   nextid = 0;
   UpdateDisplay();
   currentfilename = "";
   this->setCaption(windowname);
}



void GLModeller::addmatbutton_clicked()
{
   matlist->setNumRows(matlist->numRows() + 1);
}


void GLModeller::fileSave_MaterialsAction_activated()
{
   QString filename = QFileDialog::getSaveFileName("/home/cybertron/source/coldest/models");
   if (filename == "") return;  // Clicked cancel
   
   cout << "Saving to: " << filename << endl << flush;
   QFile ofile(filename);
   QTextStream o(&ofile);
   ofile.open(IO_WriteOnly);
   o << fileversion + "Materials" << endl;
   o << matlist->numRows() << endl;
   
   for (int i = 0; i < matlist->numRows(); ++i)
   {
      o << matlist->item(i, 0)->text() << endl << flush;
   }
   ofile.close();
}


void GLModeller::fileOpen_MaterialsAction_activated()
{
   QString filename = QFileDialog::getOpenFileName("/home/cybertron/source/coldest/models");
   if (filename == "") return;  // clicked cancel
   
   cout << "Loading: " << filename << endl << flush;
   QFile ifile(filename);
   QTextStream in(&ifile);
   ifile.open(IO_ReadOnly);
   QString buffer;
   in >> buffer;
   if (buffer != fileversion + "Materials")
   {
      cout << "File version mismatch\n";
      return;
   }
   
   // Load texture data
   while (matlist->numRows())  // Clear list
      matlist->removeRow(0);
   
   int numtex;
   in >> numtex;
   matlist->insertRows(0, numtex);
   for (int i = 0; i < numtex; ++i)
   {
      in >> buffer; // Should be texture filename
      matlist->setText(i, 0, buffer);
   }
   
   ifile.close();
}


void GLModeller::editCopyAction_activated()
{
//    copyparent = primlist->selectedItem();
}


void GLModeller::editPasteAction_activated()
{
//    if (!copyparent) return; // No primitives to paste
//    
//    QString parent = "-1";
//    
//    PasteAdd(copyparent, primlist->selectedItem());
//    
//    UpdateDisplay();
}


void GLModeller::PasteAdd( QListViewItem *i, QListViewItem *parent )
{
//    if (!i) return;
//    
//    QString newparent = "-1";
//    QListViewItem *newparentitem;
//    
//    Primitive newp = *(GetPrimByID(i->text(idcol)));
//    newp.id.setNum(nextid);
//    
//    if (!parent)
//       newparentitem = new QListViewItem(primlist, newp.type, newp.name, QString().setNum(nextid));
//    else 
//    {
//       newparentitem = new QListViewItem(parent, newp.type, newp.name, QString().setNum(nextid));
//       newparent = parent->text(idcol);
//    }
//    
//    newp.parentid = newparent;
//    
//    prims->push_back(newp);
//    nextid++;
//    
//    // Paste children then next sibling
//    QListViewItem *temp = i->firstChild();
//    if (temp)
//       PasteAdd(temp, newparentitem);
//    
//    temp = i->nextSibling();
//    if (temp && i != copyparent)
//       PasteAdd(temp, parent);
}



void GLModeller::texunitcombo_activated( int )
{
   vertlist_selectionChanged(vertlist->currentItem());
}



void GLModeller::vert1button_clicked()
{
   currvert = 0;
   trivertsel->vertlist->clear();
   QListViewItemIterator i(vertlist);
   while (i.current())
   {
      new QListViewItem(trivertsel->vertlist, (*i)->text(0), (*i)->text(1), (*i)->text(2));
      ++i;
   }
   trivertsel->show();
}


void GLModeller::vert2button_clicked()
{
   currvert = 1;
   trivertsel->vertlist->clear();
   QListViewItemIterator i(vertlist);
   while (i.current())
   {
      new QListViewItem(trivertsel->vertlist, (*i)->text(0), (*i)->text(1), (*i)->text(2));
      ++i;
   }
   trivertsel->show();
}


void GLModeller::vert3button_clicked()
{
   currvert = 2;
   trivertsel->vertlist->clear();
   QListViewItemIterator i(vertlist);
   while (i.current())
   {
      new QListViewItem(trivertsel->vertlist, (*i)->text(0), (*i)->text(1), (*i)->text(2));
      ++i;
   }
   trivertsel->show();
}




void GLModeller::trilist_selectionChanged()
{
   trivertsel->hide();
   QString selid = trilist->text(trilist->currentRow(), 0);
   loadingprim = true;
   
   collidebox->setChecked(false);
   if (tris[selid].collide)
      collidebox->setChecked(true);
   
   loadingprim = false;
}
