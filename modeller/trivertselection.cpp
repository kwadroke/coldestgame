/****************************************************************************
** Form implementation generated from reading ui file 'trivertselection.ui'
**
** Created: Mon Jun 16 19:57:16 2008
**      by: The User Interface Compiler ($Id: qt/main.cpp   3.3.8   edited Jan 11 14:47 $)
**
** WARNING! All changes made in this file will be lost!
****************************************************************************/

#include "trivertselection.h"

#include <qvariant.h>
#include <qheader.h>
#include <qlistview.h>
#include <qpushbutton.h>
#include <qlayout.h>
#include <qtooltip.h>
#include <qwhatsthis.h>
#include "trivertselection.ui.h"

/*
 *  Constructs a TriVertSelection as a child of 'parent', with the
 *  name 'name' and widget flags set to 'f'.
 *
 *  The dialog will by default be modeless, unless you set 'modal' to
 *  TRUE to construct a modal dialog.
 */
TriVertSelection::TriVertSelection( QWidget* parent, const char* name, bool modal, WFlags fl )
    : QDialog( parent, name, modal, fl )
{
    if ( !name )
	setName( "TriVertSelection" );
    TriVertSelectionLayout = new QVBoxLayout( this, 0, 0, "TriVertSelectionLayout"); 

    vertlist = new QListView( this, "vertlist" );
    vertlist->addColumn( tr( "Type" ) );
    vertlist->addColumn( tr( "Name" ) );
    vertlist->addColumn( tr( "ID" ) );
    TriVertSelectionLayout->addWidget( vertlist );

    closebutton = new QPushButton( this, "closebutton" );
    TriVertSelectionLayout->addWidget( closebutton );
    languageChange();
    resize( QSize(248, 438).expandedTo(minimumSizeHint()) );
    clearWState( WState_Polished );

    // signals and slots connections
    connect( vertlist, SIGNAL( selectionChanged(QListViewItem*) ), this, SLOT( vertlist_selectionChanged(QListViewItem*) ) );
    connect( closebutton, SIGNAL( clicked() ), this, SLOT( close() ) );
    init();
}

/*
 *  Destroys the object and frees any allocated resources
 */
TriVertSelection::~TriVertSelection()
{
    // no need to delete child widgets, Qt does it all for us
}

/*
 *  Sets the strings of the subwidgets using the current
 *  language.
 */
void TriVertSelection::languageChange()
{
    setCaption( tr( "Vertex Selection" ) );
    vertlist->header()->setLabel( 0, tr( "Type" ) );
    vertlist->header()->setLabel( 1, tr( "Name" ) );
    vertlist->header()->setLabel( 2, tr( "ID" ) );
    closebutton->setText( tr( "Close" ) );
}

