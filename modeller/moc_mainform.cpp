/****************************************************************************
** GLModeller meta object code from reading C++ file 'mainform.h'
**
** Created: Sat Jun 21 23:03:43 2008
**      by: The Qt MOC ($Id: qt/moc_yacc.cpp   3.3.8   edited Feb 2 14:59 $)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#undef QT_NO_COMPAT
#include "mainform.h"
#include <qmetaobject.h>
#include <qapplication.h>

#include <private/qucomextra_p.h>
#if !defined(Q_MOC_OUTPUT_REVISION) || (Q_MOC_OUTPUT_REVISION != 26)
#error "This file was generated using the moc from 3.3.8. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

const char *GLModeller::className() const
{
    return "GLModeller";
}

QMetaObject *GLModeller::metaObj = 0;
static QMetaObjectCleanUp cleanUp_GLModeller( "GLModeller", &GLModeller::staticMetaObject );

#ifndef QT_NO_TRANSLATION
QString GLModeller::tr( const char *s, const char *c )
{
    if ( qApp )
	return qApp->translate( "GLModeller", s, c, QApplication::DefaultCodec );
    else
	return QString::fromLatin1( s );
}
#ifndef QT_NO_TRANSLATION_UTF8
QString GLModeller::trUtf8( const char *s, const char *c )
{
    if ( qApp )
	return qApp->translate( "GLModeller", s, c, QApplication::UnicodeUTF8 );
    else
	return QString::fromUtf8( s );
}
#endif // QT_NO_TRANSLATION_UTF8

#endif // QT_NO_TRANSLATION

QMetaObject* GLModeller::staticMetaObject()
{
    if ( metaObj )
	return metaObj;
    QMetaObject* parentObject = QMainWindow::staticMetaObject();
    static const QUMethod slot_0 = {"init", 0, 0 };
    static const QUMethod slot_1 = {"Add", 0, 0 };
    static const QUParameter param_slot_2[] = {
	{ "parent", &static_QUType_ptr, "QListViewItem", QUParameter::In },
	{ "id", &static_QUType_QString, 0, QUParameter::In }
    };
    static const QUMethod slot_2 = {"AddVertex", 2, param_slot_2 };
    static const QUParameter param_slot_3[] = {
	{ 0, &static_QUType_ptr, "QListViewItem", QUParameter::Out },
	{ "parent", &static_QUType_ptr, "QListViewItem", QUParameter::In },
	{ "id", &static_QUType_QString, 0, QUParameter::In }
    };
    static const QUMethod slot_3 = {"AddContainer", 3, param_slot_3 };
    static const QUParameter param_slot_4[] = {
	{ "parent", &static_QUType_ptr, "QListViewItem", QUParameter::In }
    };
    static const QUMethod slot_4 = {"AddQuad", 1, param_slot_4 };
    static const QUMethod slot_5 = {"DeleteVertex", 0, 0 };
    static const QUParameter param_slot_6[] = {
	{ "i", &static_QUType_ptr, "QListViewItem", QUParameter::In }
    };
    static const QUMethod slot_6 = {"DeletePrim", 1, param_slot_6 };
    static const QUMethod slot_7 = {"AddTriangle", 0, 0 };
    static const QUMethod slot_8 = {"UpdateDisplay", 0, 0 };
    static const QUParameter param_slot_9[] = {
	{ "item", &static_QUType_ptr, "QListViewItem", QUParameter::In }
    };
    static const QUMethod slot_9 = {"vertlist_selectionChanged", 1, param_slot_9 };
    static const QUParameter param_slot_10[] = {
	{ "id", &static_QUType_QString, 0, QUParameter::In }
    };
    static const QUMethod slot_10 = {"DeletePrimByID", 1, param_slot_10 };
    static const QUMethod slot_11 = {"fileSaveAction_activated", 0, 0 };
    static const QUMethod slot_12 = {"fileSaveAsAction_activated", 0, 0 };
    static const QUParameter param_slot_13[] = {
	{ "filename", &static_QUType_QString, 0, QUParameter::In }
    };
    static const QUMethod slot_13 = {"SaveToFile", 1, param_slot_13 };
    static const QUMethod slot_14 = {"fileOpenAction_activated", 0, 0 };
    static const QUParameter param_slot_15[] = {
	{ 0, &static_QUType_ptr, "QListViewItem", QUParameter::Out },
	{ "id", &static_QUType_QString, 0, QUParameter::In }
    };
    static const QUMethod slot_15 = {"FindPrimInList", 2, param_slot_15 };
    static const QUMethod slot_16 = {"fileNewAction_activated", 0, 0 };
    static const QUMethod slot_17 = {"addmatbutton_clicked", 0, 0 };
    static const QUMethod slot_18 = {"fileSave_MaterialsAction_activated", 0, 0 };
    static const QUMethod slot_19 = {"fileOpen_MaterialsAction_activated", 0, 0 };
    static const QUMethod slot_20 = {"editCopyAction_activated", 0, 0 };
    static const QUMethod slot_21 = {"editPasteAction_activated", 0, 0 };
    static const QUParameter param_slot_22[] = {
	{ "i", &static_QUType_ptr, "QListViewItem", QUParameter::In },
	{ "parent", &static_QUType_ptr, "QListViewItem", QUParameter::In }
    };
    static const QUMethod slot_22 = {"PasteAdd", 2, param_slot_22 };
    static const QUParameter param_slot_23[] = {
	{ 0, &static_QUType_int, 0, QUParameter::In }
    };
    static const QUMethod slot_23 = {"texunitcombo_activated", 1, param_slot_23 };
    static const QUMethod slot_24 = {"vert1button_clicked", 0, 0 };
    static const QUMethod slot_25 = {"vert2button_clicked", 0, 0 };
    static const QUMethod slot_26 = {"vert3button_clicked", 0, 0 };
    static const QUMethod slot_27 = {"trilist_selectionChanged", 0, 0 };
    static const QUMethod slot_28 = {"languageChange", 0, 0 };
    static const QMetaData slot_tbl[] = {
	{ "init()", &slot_0, QMetaData::Public },
	{ "Add()", &slot_1, QMetaData::Public },
	{ "AddVertex(QListViewItem*,const QString&)", &slot_2, QMetaData::Public },
	{ "AddContainer(QListViewItem*,const QString&)", &slot_3, QMetaData::Public },
	{ "AddQuad(QListViewItem*)", &slot_4, QMetaData::Public },
	{ "DeleteVertex()", &slot_5, QMetaData::Public },
	{ "DeletePrim(QListViewItem*)", &slot_6, QMetaData::Public },
	{ "AddTriangle()", &slot_7, QMetaData::Public },
	{ "UpdateDisplay()", &slot_8, QMetaData::Public },
	{ "vertlist_selectionChanged(QListViewItem*)", &slot_9, QMetaData::Public },
	{ "DeletePrimByID(QString)", &slot_10, QMetaData::Public },
	{ "fileSaveAction_activated()", &slot_11, QMetaData::Public },
	{ "fileSaveAsAction_activated()", &slot_12, QMetaData::Public },
	{ "SaveToFile(QString)", &slot_13, QMetaData::Public },
	{ "fileOpenAction_activated()", &slot_14, QMetaData::Public },
	{ "FindPrimInList(QString)", &slot_15, QMetaData::Public },
	{ "fileNewAction_activated()", &slot_16, QMetaData::Public },
	{ "addmatbutton_clicked()", &slot_17, QMetaData::Public },
	{ "fileSave_MaterialsAction_activated()", &slot_18, QMetaData::Public },
	{ "fileOpen_MaterialsAction_activated()", &slot_19, QMetaData::Public },
	{ "editCopyAction_activated()", &slot_20, QMetaData::Public },
	{ "editPasteAction_activated()", &slot_21, QMetaData::Public },
	{ "PasteAdd(QListViewItem*,QListViewItem*)", &slot_22, QMetaData::Public },
	{ "texunitcombo_activated(int)", &slot_23, QMetaData::Public },
	{ "vert1button_clicked()", &slot_24, QMetaData::Public },
	{ "vert2button_clicked()", &slot_25, QMetaData::Public },
	{ "vert3button_clicked()", &slot_26, QMetaData::Public },
	{ "trilist_selectionChanged()", &slot_27, QMetaData::Public },
	{ "languageChange()", &slot_28, QMetaData::Protected }
    };
    metaObj = QMetaObject::new_metaobject(
	"GLModeller", parentObject,
	slot_tbl, 29,
	0, 0,
#ifndef QT_NO_PROPERTIES
	0, 0,
	0, 0,
#endif // QT_NO_PROPERTIES
	0, 0 );
    cleanUp_GLModeller.setMetaObject( metaObj );
    return metaObj;
}

void* GLModeller::qt_cast( const char* clname )
{
    if ( !qstrcmp( clname, "GLModeller" ) )
	return this;
    return QMainWindow::qt_cast( clname );
}

bool GLModeller::qt_invoke( int _id, QUObject* _o )
{
    switch ( _id - staticMetaObject()->slotOffset() ) {
    case 0: init(); break;
    case 1: Add(); break;
    case 2: AddVertex((QListViewItem*)static_QUType_ptr.get(_o+1),(const QString&)static_QUType_QString.get(_o+2)); break;
    case 3: static_QUType_ptr.set(_o,AddContainer((QListViewItem*)static_QUType_ptr.get(_o+1),(const QString&)static_QUType_QString.get(_o+2))); break;
    case 4: AddQuad((QListViewItem*)static_QUType_ptr.get(_o+1)); break;
    case 5: DeleteVertex(); break;
    case 6: DeletePrim((QListViewItem*)static_QUType_ptr.get(_o+1)); break;
    case 7: AddTriangle(); break;
    case 8: UpdateDisplay(); break;
    case 9: vertlist_selectionChanged((QListViewItem*)static_QUType_ptr.get(_o+1)); break;
    case 10: DeletePrimByID((QString)static_QUType_QString.get(_o+1)); break;
    case 11: fileSaveAction_activated(); break;
    case 12: fileSaveAsAction_activated(); break;
    case 13: SaveToFile((QString)static_QUType_QString.get(_o+1)); break;
    case 14: fileOpenAction_activated(); break;
    case 15: static_QUType_ptr.set(_o,FindPrimInList((QString)static_QUType_QString.get(_o+1))); break;
    case 16: fileNewAction_activated(); break;
    case 17: addmatbutton_clicked(); break;
    case 18: fileSave_MaterialsAction_activated(); break;
    case 19: fileOpen_MaterialsAction_activated(); break;
    case 20: editCopyAction_activated(); break;
    case 21: editPasteAction_activated(); break;
    case 22: PasteAdd((QListViewItem*)static_QUType_ptr.get(_o+1),(QListViewItem*)static_QUType_ptr.get(_o+2)); break;
    case 23: texunitcombo_activated((int)static_QUType_int.get(_o+1)); break;
    case 24: vert1button_clicked(); break;
    case 25: vert2button_clicked(); break;
    case 26: vert3button_clicked(); break;
    case 27: trilist_selectionChanged(); break;
    case 28: languageChange(); break;
    default:
	return QMainWindow::qt_invoke( _id, _o );
    }
    return TRUE;
}

bool GLModeller::qt_emit( int _id, QUObject* _o )
{
    return QMainWindow::qt_emit(_id,_o);
}
#ifndef QT_NO_PROPERTIES

bool GLModeller::qt_property( int id, int f, QVariant* v)
{
    return QMainWindow::qt_property( id, f, v);
}

bool GLModeller::qt_static_property( QObject* , int , int , QVariant* ){ return FALSE; }
#endif // QT_NO_PROPERTIES
