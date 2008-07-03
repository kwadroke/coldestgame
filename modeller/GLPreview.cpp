// Largely ripped from QT documentation

#include "GLPreview.h"
#include <qspinbox.h>
#include <qlistview.h>
#include <qslider.h>
#include <qimage.h>
#include <qtable.h>
#include <qcheckbox.h>

void GLPreview::initializeGL()
{
   // Set up the rendering context, define display lists etc.:
   glClearColor( 0.0, 0.0, 0.0, 0.0 );
   glEnable(GL_DEPTH_TEST);
   glEnable(GL_LIGHTING);
   glEnable(GL_LIGHT0);
   glEnable(GL_COLOR_MATERIAL);
   glShadeModel(GL_SMOOTH);
   glEnable( GL_TEXTURE_2D );
   glEnable(GL_BLEND);
   glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   
   GLenum err = glewInit();
   if (err != GLEW_OK)
   {
      cout << "Failed to init glew: " << glewGetErrorString(err) << endl << flush;
      exit(-1);
   }
   
   rendervert = "-1";
}

void GLPreview::resizeGL( int w, int h )
{
   // setup viewport, projection etc.:
   glViewport( 0, 0, (GLint)w, (GLint)h );
   glMatrixMode(GL_PROJECTION);
   glLoadIdentity();
   gluPerspective(90, (float)w / (float)h, 1, 100000);
}

void GLPreview::paintGL()
{
   if (!tris || tris->empty()) return;
   
   glMatrixMode(GL_MODELVIEW);
   glLoadIdentity();
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

   // Global zoom and rotation
   float zoom = p->zoomslider->value();
   gluLookAt(0, 0, zoom, 0, 0, 0, 0, 1, 0);
   float s = 3.f;
   glTranslatef(p->globalxtran->value() * s, p->globalytran->value() * s, p->globalztran->value() * s);
   glRotatef(p->globalxslider->value(), 1, 0, 0);
   glRotatef(p->globalyslider->value(), 0, 1, 0);
   glRotatef(p->globalzslider->value(), 0, 0, 1);

 // Place the light so we can see
   float lv[4] = {50, 50, -50, 1};
   glLightfv(GL_LIGHT0, GL_POSITION, lv);
   lv[0] = lv[1] = lv[2] = lv[3] = .7;
   glLightfv(GL_LIGHT0, GL_DIFFUSE, lv);
   lv[0] = lv[1] = lv[2] = lv[3] = .3;
   glLightfv(GL_LIGHT0, GL_AMBIENT, lv);
   lv[0] = lv[1] = lv[2] = lv[3] = .9;
   glLightfv(GL_LIGHT0, GL_SPECULAR, lv);
   
   glDisable(GL_CULL_FACE);
   if (p->cullfacecheck->isChecked())
      glEnable(GL_CULL_FACE);
   
   rootprim->Transform(GraphicMatrix());

   RenderTris();
   
   // Render sphere to indicate current vertex or container
   if (rendervert != "-1")
   {
      VertexPtr renderv = rootprim->GetVertex(rendervert);
      glPushMatrix();
      glDisable(GL_DEPTH_TEST);
      glDisable(GL_LIGHTING);
      glDisable(GL_TEXTURE_2D);
      glTranslatef(renderv->pos.x, renderv->pos.y, renderv->pos.z);
      GLUquadricObj *sphere = gluNewQuadric();
      glColor4f(0, 1, 0, .5);
      gluSphere(sphere, 100, 25, 25);
      gluDeleteQuadric(sphere);
      glColor4f(1, 1, 1, 1);
      glEnable(GL_TEXTURE_2D);
      glEnable(GL_LIGHTING);
      glEnable(GL_DEPTH_TEST);
      glPopMatrix();
   }

   rootprim->Restore();
}


void GLPreview::RenderTris()
{
   float temp[3];
   for (map<string, Triangle>::iterator i = tris->begin(); i != tris->end(); ++i)
   {
      if (i->second.material) i->second.material->UseTextureOnly();
      else cout << "Warning: NULL material" << endl;
      
      glBegin(GL_TRIANGLES);
      glTexCoord2fv(&i->second.v[0]->texcoords[0][0]);
      glVertex3fv(i->second.v[0]->pos.array(temp));
      glTexCoord2fv(&i->second.v[1]->texcoords[0][0]);
      glVertex3fv(i->second.v[1]->pos.array(temp));
      glTexCoord2fv(&i->second.v[2]->texcoords[0][0]);
      glVertex3fv(i->second.v[2]->pos.array(temp));
      glEnd();
   }
   //if (textures.contains(current->texture[0]))
   //{
      /* If we access a non-existent texture it adds the key we
      were looking for to the map, so don't do lookups unless
      the key is already in the map*/
   /*   GLuint texnum = textures[current->texture[0]];
      glBindTexture(GL_TEXTURE_2D, texnum);
      glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
      glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
   }*/
   
   /*Material* currmat = &resman.LoadMaterial(current->material);
   if (currmat) currmat->UseTextureOnly();
   
   if (current->type == "Quad")
   {
      glColor3f(1, 1, 1);
      float temp[3];
      Vector3 tempv = (current->point[1] - current->point[0]).cross(
      current->point[2] - current->point[0]);
      tempv.normalize();
      
      glBegin(GL_QUADS);
      glTexCoord2fv(&(current->texcoords[0][0][0]));
      glNormal3fv(tempv.array(temp));
      glVertex3fv(current->point[0].array(temp));
      glTexCoord2fv(&(current->texcoords[0][1][0]));
      glVertex3fv(current->point[1].array(temp));
      glTexCoord2fv(&(current->texcoords[0][2][0]));
      glVertex3fv(current->point[2].array(temp));
      glTexCoord2fv(&(current->texcoords[0][3][0]));
      glVertex3fv(current->point[3].array(temp));
      glEnd();
   }*/
}


void GLPreview::setTriangleMap(std::map<string, Triangle> *map)
{
   tris = map;
}


void GLPreview::setRootPrim(Primitive* newroot)
{
   rootprim = newroot;
}


void GLPreview::setParent(GLModeller *parent)
{
   p = parent;
}


void GLPreview::wheelEvent(QWheelEvent* e)
{
   e->accept();
   if (e->delta() > 0) emit zoomin();
   else emit zoomout();
   
}


void GLPreview::mouseMoveEvent(QMouseEvent* e)
{
   int mx = e->x() - mpos.x();
   int my = e->y() - mpos.y();
   unsigned int xcount = abs(mx);
   unsigned int ycount = abs(my);
   if (!xcount && !ycount) return;
   if (e->state() & Qt::LeftButton)
   {
      for (size_t i = 0; i < xcount; ++i)
      {
         if (mx > 0) emit rotateypos();
         else emit rotateyneg();
      }
      for (size_t i = 0; i < ycount; ++i)
      {
         if (my > 0) emit rotatexpos();
         else emit rotatexneg();
      }
      e->accept();
   }
   else if (e->state() & Qt::RightButton)
   {
      for (size_t i = 0; i < xcount; ++i)
      {
         if (mx > 0) emit translatexpos();
         else emit translatexneg();
      }
      for (size_t i = 0; i < ycount; ++i)
      {
         if (my > 0) emit translateypos();
         else emit translateyneg();
      }
      e->accept();
   }
   else
   {
      e->ignore();
   }
   mpos = e->pos();
}


void GLPreview::mousePressEvent(QMouseEvent* e)
{
   e->accept();
   mpos = e->pos();
}
