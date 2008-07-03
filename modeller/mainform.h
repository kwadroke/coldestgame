/****************************************************************************
** Form interface generated from reading ui file 'mainform.ui'
**
** Created: Sat Jun 21 23:03:37 2008
**      by: The User Interface Compiler ($Id: qt/main.cpp   3.3.8   edited Jan 11 14:47 $)
**
** WARNING! All changes made in this file will be lost!
****************************************************************************/

#ifndef GLMODELLER_H
#define GLMODELLER_H

#include <qvariant.h>
#include <qpixmap.h>
#include <qmainwindow.h>
#include "Primitive.h"

class QVBoxLayout;
class QHBoxLayout;
class QGridLayout;
class QSpacerItem;
class QAction;
class QActionGroup;
class QToolBar;
class QPopupMenu;
class GLPreview;
class QTabWidget;
class QWidget;
class QSpinBox;
class QLabel;
class QComboBox;
class QCheckBox;
class QLineEdit;
class QPushButton;
class QTable;
class QSplitter;
class QListView;
class QListViewItem;
class QFrame;
class QSlider;

class GLModeller : public QMainWindow
{
    Q_OBJECT

public:
    GLModeller( QWidget* parent = 0, const char* name = 0, WFlags fl = WType_TopLevel );
    ~GLModeller();

    QTabWidget* tabWidget2;
    QWidget* tab;
    QSpinBox* frotzbox;
    QLabel* textLabel5;
    QLabel* textLabel9;
    QSpinBox* srotxbox;
    QSpinBox* srotybox;
    QSpinBox* srotzbox;
    QLabel* textLabel1_2;
    QSpinBox* frotxbox;
    QComboBox* typecombo;
    QSpinBox* frotybox;
    QCheckBox* cullfacecheck;
    QSpinBox* tranxbox;
    QSpinBox* tranybox;
    QSpinBox* tranzbox;
    QSpinBox* frametimebox;
    QLabel* textLabel1_4;
    QWidget* TabPage;
    QLabel* textLabel1_7;
    QLineEdit* nameedit;
    QCheckBox* facingbox;
    QWidget* tab_2;
    QLabel* textLabel1_3;
    QLabel* textLabel1_5;
    QLabel* textLabel1_8;
    QSpinBox* verty;
    QSpinBox* vertz;
    QSpinBox* texcoordy;
    QSpinBox* texcoordx;
    QComboBox* texunitcombo;
    QSpinBox* vertx;
    QWidget* TabPage_2;
    QPushButton* vert1button;
    QPushButton* vert2button;
    QPushButton* vert3button;
    QCheckBox* collidebox;
    QWidget* TabPage_3;
    QTable* matlist;
    QPushButton* addmatbutton;
    QPushButton* removematbutton;
    QSplitter* splitter5;
    QSplitter* splitter4;
    QListView* vertlist;
    QTable* trilist;
    GLPreview* display;
    QFrame* frame3;
    QLabel* textLabel1;
    QLabel* xglobalbox;
    QLabel* textLabel2;
    QLabel* zoomglobalbox;
    QSlider* zoomslider;
    QLabel* textLabel13;
    QSlider* globalxslider;
    QSlider* globalyslider;
    QSlider* globalzslider;
    QSlider* globalytran;
    QSlider* globalxtran;
    QSlider* globalztran;
    QLabel* textLabel1_6;
    QLabel* textLabel2_2;
    QMenuBar *MenuBar;
    QPopupMenu *fileMenu;
    QPopupMenu *Edit;
    QAction* fileNewAction;
    QAction* fileOpenAction;
    QAction* fileSaveAction;
    QAction* fileSaveAsAction;
    QAction* filePrintAction;
    QAction* fileExitAction;
    QAction* editAddAction;
    QAction* editDeleteAction;
    QAction* fileSave_MaterialsAction;
    QAction* fileOpen_MaterialsAction;
    QAction* editCopyAction;
    QAction* editPasteAction;
    QAction* editAdd_TriangleAction;

public slots:
    virtual void init();
    virtual void Add();
    virtual void AddVertex( QListViewItem * parent, const QString & id );
    virtual QListViewItem * AddContainer( QListViewItem * parent, const QString & id );
    virtual void AddQuad( QListViewItem * parent );
    virtual void DeleteVertex();
    virtual void DeletePrim( QListViewItem * i );
    virtual void AddTriangle();
    virtual void UpdateDisplay();
    virtual void vertlist_selectionChanged( QListViewItem * item );
    virtual void DeletePrimByID( QString id );
    virtual void fileSaveAction_activated();
    virtual void fileSaveAsAction_activated();
    virtual void SaveToFile( QString filename );
    virtual void fileOpenAction_activated();
    virtual QListViewItem * FindPrimInList( QString id );
    virtual void fileNewAction_activated();
    virtual void addmatbutton_clicked();
    virtual void fileSave_MaterialsAction_activated();
    virtual void fileOpen_MaterialsAction_activated();
    virtual void editCopyAction_activated();
    virtual void editPasteAction_activated();
    virtual void PasteAdd( QListViewItem * i, QListViewItem * parent );
    virtual void texunitcombo_activated( int );
    virtual void vert1button_clicked();
    virtual void vert2button_clicked();
    virtual void vert3button_clicked();
    virtual void trilist_selectionChanged();

protected:
    QGridLayout* GLModellerLayout;
    QGridLayout* tabLayout;
    QGridLayout* TabPageLayout;
    QSpacerItem* spacer1;
    QGridLayout* frame3Layout;

protected slots:
    virtual void languageChange();

private:
    QPixmap image0;
    QPixmap image1;
    QPixmap image2;
    QPixmap image3;
    QPixmap image4;

};

#endif // GLMODELLER_H
