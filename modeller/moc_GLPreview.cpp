/****************************************************************************
** GLPreview meta object code from reading C++ file 'GLPreview.h'
**
** Created: Sat Jun 21 13:19:58 2008
**      by: The Qt MOC ($Id: qt/moc_yacc.cpp   3.3.8   edited Feb 2 14:59 $)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#undef QT_NO_COMPAT
#include "GLPreview.h"
#include <qmetaobject.h>
#include <qapplication.h>

#include <private/qucomextra_p.h>
#if !defined(Q_MOC_OUTPUT_REVISION) || (Q_MOC_OUTPUT_REVISION != 26)
#error "This file was generated using the moc from 3.3.8. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

const char *GLPreview::className() const
{
    return "GLPreview";
}

QMetaObject *GLPreview::metaObj = 0;
static QMetaObjectCleanUp cleanUp_GLPreview( "GLPreview", &GLPreview::staticMetaObject );

#ifndef QT_NO_TRANSLATION
QString GLPreview::tr( const char *s, const char *c )
{
    if ( qApp )
	return qApp->translate( "GLPreview", s, c, QApplication::DefaultCodec );
    else
	return QString::fromLatin1( s );
}
#ifndef QT_NO_TRANSLATION_UTF8
QString GLPreview::trUtf8( const char *s, const char *c )
{
    if ( qApp )
	return qApp->translate( "GLPreview", s, c, QApplication::UnicodeUTF8 );
    else
	return QString::fromUtf8( s );
}
#endif // QT_NO_TRANSLATION_UTF8

#endif // QT_NO_TRANSLATION

QMetaObject* GLPreview::staticMetaObject()
{
    if ( metaObj )
	return metaObj;
    QMetaObject* parentObject = QGLWidget::staticMetaObject();
    static const QUParameter param_slot_0[] = {
	{ 0, &static_QUType_ptr, "QWheelEvent", QUParameter::In }
    };
    static const QUMethod slot_0 = {"wheelEvent", 1, param_slot_0 };
    static const QUParameter param_slot_1[] = {
	{ 0, &static_QUType_ptr, "QMouseEvent", QUParameter::In }
    };
    static const QUMethod slot_1 = {"mouseMoveEvent", 1, param_slot_1 };
    static const QUParameter param_slot_2[] = {
	{ 0, &static_QUType_ptr, "QMouseEvent", QUParameter::In }
    };
    static const QUMethod slot_2 = {"mousePressEvent", 1, param_slot_2 };
    static const QMetaData slot_tbl[] = {
	{ "wheelEvent(QWheelEvent*)", &slot_0, QMetaData::Protected },
	{ "mouseMoveEvent(QMouseEvent*)", &slot_1, QMetaData::Protected },
	{ "mousePressEvent(QMouseEvent*)", &slot_2, QMetaData::Protected }
    };
    static const QUMethod signal_0 = {"zoomout", 0, 0 };
    static const QUMethod signal_1 = {"zoomin", 0, 0 };
    static const QUMethod signal_2 = {"rotatexpos", 0, 0 };
    static const QUMethod signal_3 = {"rotatexneg", 0, 0 };
    static const QUMethod signal_4 = {"rotateypos", 0, 0 };
    static const QUMethod signal_5 = {"rotateyneg", 0, 0 };
    static const QUMethod signal_6 = {"translatexpos", 0, 0 };
    static const QUMethod signal_7 = {"translatexneg", 0, 0 };
    static const QUMethod signal_8 = {"translateypos", 0, 0 };
    static const QUMethod signal_9 = {"translateyneg", 0, 0 };
    static const QMetaData signal_tbl[] = {
	{ "zoomout()", &signal_0, QMetaData::Private },
	{ "zoomin()", &signal_1, QMetaData::Private },
	{ "rotatexpos()", &signal_2, QMetaData::Private },
	{ "rotatexneg()", &signal_3, QMetaData::Private },
	{ "rotateypos()", &signal_4, QMetaData::Private },
	{ "rotateyneg()", &signal_5, QMetaData::Private },
	{ "translatexpos()", &signal_6, QMetaData::Private },
	{ "translatexneg()", &signal_7, QMetaData::Private },
	{ "translateypos()", &signal_8, QMetaData::Private },
	{ "translateyneg()", &signal_9, QMetaData::Private }
    };
    metaObj = QMetaObject::new_metaobject(
	"GLPreview", parentObject,
	slot_tbl, 3,
	signal_tbl, 10,
#ifndef QT_NO_PROPERTIES
	0, 0,
	0, 0,
#endif // QT_NO_PROPERTIES
	0, 0 );
    cleanUp_GLPreview.setMetaObject( metaObj );
    return metaObj;
}

void* GLPreview::qt_cast( const char* clname )
{
    if ( !qstrcmp( clname, "GLPreview" ) )
	return this;
    return QGLWidget::qt_cast( clname );
}

// SIGNAL zoomout
void GLPreview::zoomout()
{
    activate_signal( staticMetaObject()->signalOffset() + 0 );
}

// SIGNAL zoomin
void GLPreview::zoomin()
{
    activate_signal( staticMetaObject()->signalOffset() + 1 );
}

// SIGNAL rotatexpos
void GLPreview::rotatexpos()
{
    activate_signal( staticMetaObject()->signalOffset() + 2 );
}

// SIGNAL rotatexneg
void GLPreview::rotatexneg()
{
    activate_signal( staticMetaObject()->signalOffset() + 3 );
}

// SIGNAL rotateypos
void GLPreview::rotateypos()
{
    activate_signal( staticMetaObject()->signalOffset() + 4 );
}

// SIGNAL rotateyneg
void GLPreview::rotateyneg()
{
    activate_signal( staticMetaObject()->signalOffset() + 5 );
}

// SIGNAL translatexpos
void GLPreview::translatexpos()
{
    activate_signal( staticMetaObject()->signalOffset() + 6 );
}

// SIGNAL translatexneg
void GLPreview::translatexneg()
{
    activate_signal( staticMetaObject()->signalOffset() + 7 );
}

// SIGNAL translateypos
void GLPreview::translateypos()
{
    activate_signal( staticMetaObject()->signalOffset() + 8 );
}

// SIGNAL translateyneg
void GLPreview::translateyneg()
{
    activate_signal( staticMetaObject()->signalOffset() + 9 );
}

bool GLPreview::qt_invoke( int _id, QUObject* _o )
{
    switch ( _id - staticMetaObject()->slotOffset() ) {
    case 0: wheelEvent((QWheelEvent*)static_QUType_ptr.get(_o+1)); break;
    case 1: mouseMoveEvent((QMouseEvent*)static_QUType_ptr.get(_o+1)); break;
    case 2: mousePressEvent((QMouseEvent*)static_QUType_ptr.get(_o+1)); break;
    default:
	return QGLWidget::qt_invoke( _id, _o );
    }
    return TRUE;
}

bool GLPreview::qt_emit( int _id, QUObject* _o )
{
    switch ( _id - staticMetaObject()->signalOffset() ) {
    case 0: zoomout(); break;
    case 1: zoomin(); break;
    case 2: rotatexpos(); break;
    case 3: rotatexneg(); break;
    case 4: rotateypos(); break;
    case 5: rotateyneg(); break;
    case 6: translatexpos(); break;
    case 7: translatexneg(); break;
    case 8: translateypos(); break;
    case 9: translateyneg(); break;
    default:
	return QGLWidget::qt_emit(_id,_o);
    }
    return TRUE;
}
#ifndef QT_NO_PROPERTIES

bool GLPreview::qt_property( int id, int f, QVariant* v)
{
    return QGLWidget::qt_property( id, f, v);
}

bool GLPreview::qt_static_property( QObject* , int , int , QVariant* ){ return FALSE; }
#endif // QT_NO_PROPERTIES
