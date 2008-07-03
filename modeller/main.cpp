#include <qapplication.h>
#include "mainform.h"
#include "Vector3.h"
#include "Primitive.h"

int main( int argc, char ** argv )
{
    QApplication a( argc, argv );
    GLModeller w;
    w.show();
    a.connect( &a, SIGNAL( lastWindowClosed() ), &a, SLOT( quit() ) );
    return a.exec();
}
