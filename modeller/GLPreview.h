#ifndef __GLPreview__
#define __GLPreview__

#include "ResourceManager.h"
#include "Material.h"
#include <qobject.h>
#include <qwidget.h>
#include <qgl.h>
#include <qmap.h>
#include <vector>
#include "Primitive.h"
#include "mainform.h"
#include "Triangle.h"
#include "Vertex.h"

using std::vector;


class GLPreview : public QGLWidget
{
   Q_OBJECT
   
   public:
      GLPreview( QWidget *parent, const char *name )
               : QGLWidget(parent, name) {}
      void setTriangleMap(std::map<string, Triangle> *);
      void setRootPrim(Primitive*);
      void setParent(GLModeller *p);
      
      typedef QMap<QString, GLuint> TextureMap;
      TextureMap textures;
      ResourceManager resman;
      QString rendervert;
      
   private:
      void RenderTris();
      
      std::map<string, Triangle> *tris;
      GLModeller *p;
      Primitive* rootprim;
      QPoint mpos;
   
   signals:
      void zoomout();
      void zoomin();
      void rotatexpos();
      void rotatexneg();
      void rotateypos();
      void rotateyneg();
      void translatexpos();
      void translatexneg();
      void translateypos();
      void translateyneg();
   
   protected slots:
      void wheelEvent(QWheelEvent*);
      void mouseMoveEvent(QMouseEvent*);
      void mousePressEvent(QMouseEvent*);
   
   protected:
      void initializeGL();
      void resizeGL(int, int);
      void paintGL();
};

#endif
