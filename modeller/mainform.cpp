/****************************************************************************
** Form implementation generated from reading ui file 'mainform.ui'
**
** Created: Sat Jun 21 23:03:40 2008
**      by: The User Interface Compiler ($Id: qt/main.cpp   3.3.8   edited Jan 11 14:47 $)
**
** WARNING! All changes made in this file will be lost!
****************************************************************************/

#include "mainform.h"

#include <qvariant.h>
#include </home/cybertron/source/modeller/GLPreview.h>
#include <qpushbutton.h>
#include <qtabwidget.h>
#include <qwidget.h>
#include <qspinbox.h>
#include <qlabel.h>
#include <qcombobox.h>
#include <qcheckbox.h>
#include <qlineedit.h>
#include <qtable.h>
#include <qsplitter.h>
#include <qheader.h>
#include <qlistview.h>
#include <qframe.h>
#include <qslider.h>
#include <qlayout.h>
#include <qtooltip.h>
#include <qwhatsthis.h>
#include <qaction.h>
#include <qmenubar.h>
#include <qpopupmenu.h>
#include <qtoolbar.h>
#include <qimage.h>
#include <qpixmap.h>

#include "/home/cybertron/source/modeller/GLPreview.h"
#include "mainform.ui.h"
static const unsigned char image1_data[] = { 
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x16,
    0x08, 0x06, 0x00, 0x00, 0x00, 0xc4, 0xb4, 0x6c, 0x3b, 0x00, 0x00, 0x00,
    0x74, 0x49, 0x44, 0x41, 0x54, 0x38, 0x8d, 0xed, 0xd5, 0xc1, 0x09, 0xc0,
    0x20, 0x0c, 0x05, 0xd0, 0x6f, 0xe9, 0x36, 0x81, 0x2c, 0x10, 0xb2, 0xff,
    0xdd, 0x85, 0xd2, 0x53, 0x85, 0xb6, 0xa9, 0x91, 0x48, 0x0f, 0x05, 0x3f,
    0x08, 0x1a, 0xf0, 0x29, 0x12, 0x10, 0xf8, 0x28, 0xc5, 0xa9, 0xd9, 0xc4,
    0xde, 0x96, 0xcd, 0x2b, 0x9a, 0xd9, 0xeb, 0x00, 0x00, 0x66, 0x0e, 0x2f,
    0xe0, 0xc2, 0x51, 0x98, 0x39, 0xc4, 0xf7, 0x0c, 0x4c, 0x44, 0x6d, 0x5e,
    0x6b, 0x35, 0x38, 0xcf, 0x92, 0x82, 0x45, 0xe4, 0xb2, 0xf6, 0xf0, 0x14,
    0xac, 0xaa, 0x8f, 0xda, 0x1d, 0x4f, 0xc1, 0xa5, 0x74, 0x1b, 0x22, 0x07,
    0x9f, 0x9d, 0x11, 0x1d, 0x96, 0xea, 0x8a, 0x91, 0x2c, 0x78, 0xc1, 0x0b,
    0xee, 0x64, 0xe6, 0x07, 0x19, 0xf5, 0x7e, 0x92, 0x03, 0xad, 0x45, 0x2a,
    0x04, 0xcc, 0x4e, 0x50, 0x20, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4e,
    0x44, 0xae, 0x42, 0x60, 0x82
};

static const unsigned char image2_data[] = { 
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x16,
    0x08, 0x06, 0x00, 0x00, 0x00, 0xc4, 0xb4, 0x6c, 0x3b, 0x00, 0x00, 0x00,
    0x99, 0x49, 0x44, 0x41, 0x54, 0x38, 0x8d, 0xed, 0x94, 0x41, 0x0e, 0x85,
    0x20, 0x0c, 0x44, 0x5f, 0x89, 0xc7, 0x36, 0x7f, 0x61, 0xbc, 0x77, 0x5d,
    0x28, 0x48, 0xa4, 0x28, 0x60, 0xff, 0xce, 0xd9, 0x54, 0x8b, 0xbe, 0x8e,
    0x13, 0x04, 0x3e, 0x1d, 0x92, 0x81, 0x77, 0xf4, 0x81, 0xa1, 0x23, 0xdc,
    0x2b, 0x34, 0xf6, 0xf4, 0x7a, 0x3d, 0xe2, 0xb8, 0x65, 0xa8, 0x84, 0x3f,
    0x40, 0x01, 0x98, 0x2a, 0x0b, 0x3d, 0x5f, 0x62, 0xc5, 0x83, 0x00, 0xaa,
    0x1a, 0xd7, 0x05, 0x50, 0x44, 0x9a, 0xb9, 0xd5, 0x07, 0xa7, 0x73, 0xa8,
    0xa4, 0xba, 0x4f, 0x92, 0xa2, 0xdf, 0x33, 0x3c, 0x64, 0xc6, 0x3b, 0xeb,
    0xbd, 0x82, 0xe5, 0xb8, 0xad, 0xde, 0xcb, 0xcc, 0x78, 0x20, 0xeb, 0x42,
    0x66, 0xc6, 0x39, 0x74, 0x5d, 0xfa, 0x80, 0xf3, 0x6f, 0xaf, 0x66, 0xc6,
    0x6f, 0xa1, 0x9c, 0x3f, 0x88, 0x2f, 0xb4, 0x70, 0xec, 0x05, 0xcd, 0xc0,
    0xbe, 0xd0, 0x78, 0x93, 0xf6, 0x8e, 0x17, 0x14, 0x92, 0x63, 0x5f, 0x68,
    0x6c, 0x3e, 0xef, 0xf6, 0xba, 0x3c, 0x8f, 0xdd, 0x36, 0x6d, 0xc4, 0xc0,
    0x45, 0x2c, 0x87, 0x81, 0xf8, 0x08, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45,
    0x4e, 0x44, 0xae, 0x42, 0x60, 0x82
};

static const unsigned char image3_data[] = { 
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x16,
    0x08, 0x06, 0x00, 0x00, 0x00, 0xc4, 0xb4, 0x6c, 0x3b, 0x00, 0x00, 0x00,
    0xa0, 0x49, 0x44, 0x41, 0x54, 0x38, 0x8d, 0xd5, 0x95, 0x4d, 0x0a, 0x80,
    0x20, 0x10, 0x85, 0x9f, 0xd1, 0x46, 0x68, 0xe1, 0x8d, 0xe6, 0x62, 0xd2,
    0x22, 0xbc, 0x98, 0x37, 0x6a, 0x21, 0xb4, 0xac, 0x45, 0x19, 0x92, 0xc6,
    0x64, 0x69, 0xe0, 0xb7, 0xf1, 0x87, 0xf1, 0xf1, 0x1c, 0x47, 0x05, 0x2a,
    0x21, 0x8e, 0x76, 0x2d, 0xad, 0xdb, 0xfb, 0x9e, 0x99, 0xf6, 0x56, 0x8f,
    0x80, 0xb5, 0x36, 0x4b, 0x85, 0x88, 0xce, 0x35, 0x44, 0x04, 0x00, 0xe8,
    0x0a, 0x39, 0x8c, 0xe8, 0xf9, 0x90, 0x34, 0xd2, 0x29, 0x2c, 0xc3, 0x7c,
    0x8e, 0xbd, 0x53, 0x0f, 0xeb, 0x58, 0x3a, 0x05, 0xe9, 0x54, 0x34, 0x1f,
    0x8a, 0x02, 0x7b, 0x2a, 0x7d, 0x3a, 0x1f, 0x09, 0xbf, 0x85, 0x4d, 0xc5,
    0xd5, 0xd9, 0x53, 0xaa, 0x39, 0x6e, 0x4f, 0x38, 0xca, 0xb1, 0x99, 0xe2,
    0xd2, 0xe1, 0x08, 0xab, 0xe1, 0x56, 0xf8, 0x2e, 0x30, 0x97, 0x7f, 0xcb,
    0x4d, 0x8f, 0xf9, 0x42, 0xd7, 0x5d, 0xbe, 0xbe, 0xd2, 0xe1, 0x43, 0x95,
    0x3a, 0x93, 0xf6, 0xca, 0xad, 0x3d, 0x61, 0x11, 0xf4, 0x4b, 0x7d, 0x4f,
    0x82, 0x0f, 0xf9, 0xc0, 0x06, 0x9b, 0xb5, 0x1e, 0xcd, 0xed, 0x31, 0x8c,
    0x5c, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60,
    0x82
};

static const unsigned char image4_data[] = { 
    0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00, 0x00, 0x0d,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x16,
    0x08, 0x06, 0x00, 0x00, 0x00, 0xc4, 0xb4, 0x6c, 0x3b, 0x00, 0x00, 0x02,
    0x9c, 0x49, 0x44, 0x41, 0x54, 0x38, 0x8d, 0x8d, 0x95, 0xad, 0x76, 0xdb,
    0x40, 0x10, 0x85, 0x3f, 0xf7, 0x18, 0xcc, 0x32, 0x89, 0xd9, 0x50, 0xd0,
    0x61, 0x36, 0x34, 0x4c, 0x98, 0xc3, 0x62, 0x96, 0x40, 0x87, 0x25, 0x6f,
    0x50, 0x3f, 0x42, 0x61, 0x61, 0x02, 0x1b, 0xe6, 0xb2, 0x84, 0x25, 0x50,
    0x61, 0x2e, 0x8b, 0xe1, 0x42, 0x99, 0x49, 0x6c, 0x86, 0x6d, 0xc1, 0x4a,
    0xb2, 0xfc, 0x77, 0xda, 0x21, 0x92, 0x66, 0x57, 0x77, 0xee, 0xdc, 0x3b,
    0x5a, 0xf5, 0x38, 0x13, 0xaf, 0xaf, 0xaf, 0x41, 0x44, 0x48, 0xd3, 0x74,
    0x2f, 0x6f, 0x66, 0x00, 0xa8, 0x2a, 0x00, 0x55, 0x55, 0x91, 0x24, 0x09,
    0x57, 0x57, 0x57, 0xbd, 0xee, 0xbe, 0xfe, 0x39, 0x60, 0x11, 0x61, 0x32,
    0x99, 0xb4, 0x40, 0x87, 0x6b, 0x4d, 0x94, 0x65, 0x89, 0xf7, 0xfe, 0x68,
    0xcf, 0x59, 0x60, 0x80, 0xcd, 0x66, 0x73, 0x04, 0x76, 0x58, 0x48, 0x55,
    0x71, 0xce, 0xfd, 0x3f, 0xf0, 0x29, 0x00, 0x33, 0x3b, 0x2a, 0x70, 0xaa,
    0x23, 0x80, 0x6f, 0xa7, 0x92, 0x79, 0x9e, 0x07, 0x33, 0x6b, 0x99, 0x38,
    0xe7, 0x70, 0xce, 0xed, 0xe9, 0xdd, 0xe8, 0x2f, 0x22, 0x47, 0xfa, 0x9e,
    0x65, 0xac, 0xaa, 0x24, 0x49, 0x42, 0x59, 0x96, 0x88, 0x48, 0x6b, 0x54,
    0x37, 0x4e, 0xb5, 0xff, 0x4f, 0xc6, 0x10, 0x5b, 0x3c, 0x9c, 0x88, 0x2e,
    0x68, 0x53, 0xec, 0x9c, 0x14, 0x27, 0x19, 0x37, 0x6c, 0x4e, 0x31, 0xed,
    0xe6, 0x55, 0x75, 0x6f, 0x42, 0xba, 0x71, 0xa4, 0x0d, 0xc0, 0x6a, 0xb5,
    0x0a, 0x59, 0x96, 0x31, 0x1c, 0x0e, 0xcf, 0x82, 0x37, 0x46, 0x7e, 0x7e,
    0x7e, 0x02, 0x20, 0x92, 0x30, 0x9f, 0x5f, 0xb7, 0x78, 0x7b, 0x8c, 0xdf,
    0xdf, 0xdf, 0x83, 0xf7, 0x9e, 0xfc, 0x23, 0x47, 0x66, 0x82, 0x88, 0xb4,
    0x00, 0x87, 0xd7, 0x86, 0x69, 0x59, 0x94, 0xe4, 0x79, 0xce, 0xb6, 0xda,
    0xf2, 0xf0, 0xf0, 0x10, 0x66, 0xb3, 0x19, 0xd7, 0xd7, 0xd7, 0xbd, 0x5e,
    0x17, 0x74, 0xb3, 0xf1, 0x54, 0xc5, 0x16, 0x35, 0x80, 0xd3, 0x4c, 0x01,
    0x9c, 0xa4, 0x08, 0x02, 0x0e, 0x7c, 0xe1, 0x59, 0xaf, 0xff, 0xb0, 0xdd,
    0x16, 0xa8, 0x1a, 0x17, 0x17, 0x19, 0x8b, 0xc5, 0x22, 0x4a, 0xd1, 0x30,
    0xbd, 0x9c, 0x5e, 0xe2, 0xd2, 0x14, 0x55, 0x03, 0x53, 0x8e, 0x6c, 0x31,
    0x03, 0x84, 0x9c, 0x4f, 0x3e, 0x78, 0x65, 0x6a, 0x53, 0xd2, 0xaf, 0x94,
    0xe7, 0x97, 0x67, 0xfc, 0x57, 0xfc, 0xfa, 0xd4, 0x94, 0x6c, 0x74, 0x11,
    0x41, 0x9f, 0x9e, 0x7e, 0x85, 0xb2, 0x28, 0xc3, 0xff, 0xc4, 0x57, 0xf8,
    0x0a, 0xa3, 0x30, 0x0a, 0x12, 0x24, 0x8c, 0xc2, 0x28, 0xac, 0xd7, 0xeb,
    0xf0, 0xe3, 0xfb, 0xcf, 0x30, 0x1e, 0x8f, 0xc3, 0x60, 0x90, 0x85, 0x24,
    0x49, 0x42, 0x36, 0xc8, 0x42, 0xbf, 0xda, 0x56, 0xdc, 0xdd, 0xdd, 0x9c,
    0x75, 0xf7, 0x30, 0x52, 0x52, 0x2e, 0x99, 0x92, 0x23, 0xcc, 0x98, 0x31,
    0x1e, 0x8f, 0x49, 0x64, 0x48, 0x69, 0x05, 0xcf, 0xbf, 0x5e, 0xa8, 0xaa,
    0x8a, 0x74, 0x90, 0xd2, 0x37, 0xc0, 0xfb, 0x22, 0xce, 0xa3, 0x19, 0x88,
    0x10, 0x6b, 0x48, 0xed, 0x36, 0x38, 0x5c, 0x54, 0xdc, 0x14, 0xc4, 0xf1,
    0x60, 0xdf, 0xb9, 0xc1, 0x33, 0xb4, 0x21, 0x7f, 0xd8, 0x80, 0x19, 0xe9,
    0x70, 0x18, 0xd7, 0x6b, 0x77, 0xfa, 0x65, 0x51, 0xe0, 0x45, 0xa2, 0x9e,
    0x66, 0xb4, 0xbe, 0x39, 0x88, 0x2e, 0xd6, 0x9d, 0x38, 0x03, 0x15, 0x20,
    0xe6, 0x04, 0xf0, 0xb6, 0xc5, 0x88, 0x67, 0x88, 0xdf, 0x6c, 0x5a, 0x4f,
    0x1c, 0xf5, 0xb8, 0x35, 0x09, 0x6b, 0x00, 0xb1, 0x76, 0x28, 0x14, 0x8b,
    0x35, 0x74, 0x6f, 0x67, 0x3b, 0x39, 0xd2, 0x78, 0xda, 0x09, 0x45, 0xe9,
    0x23, 0x60, 0x65, 0xe7, 0x05, 0xad, 0xc9, 0x76, 0x37, 0x1a, 0x20, 0x0a,
    0x76, 0xb8, 0xe2, 0x30, 0x2b, 0xa9, 0xfb, 0x6c, 0x7a, 0x63, 0x32, 0x99,
    0xf2, 0x0d, 0xeb, 0xb0, 0x6c, 0xc9, 0x6a, 0x7c, 0xb4, 0xfa, 0xba, 0x07,
    0xea, 0x9a, 0x6d, 0x35, 0x68, 0x0d, 0x58, 0xcb, 0x39, 0x18, 0x0c, 0x58,
    0x2c, 0xee, 0x22, 0x63, 0xef, 0x7d, 0x63, 0x15, 0x88, 0x41, 0x25, 0x40,
    0x15, 0x9d, 0x33, 0x8b, 0x30, 0xd2, 0xb0, 0xb2, 0x1d, 0x18, 0x3b, 0xcd,
    0x31, 0x43, 0x04, 0x96, 0xcb, 0x25, 0xf3, 0xf9, 0xbc, 0xd7, 0xcf, 0xb2,
    0x8c, 0x8f, 0xb7, 0x0f, 0x7e, 0xbf, 0xbd, 0xa1, 0x6a, 0xc4, 0xf3, 0x47,
    0xd8, 0x1b, 0x3e, 0xe9, 0x3c, 0xcb, 0x0e, 0xb2, 0xed, 0xb3, 0x9e, 0xa6,
    0xe5, 0x72, 0xc9, 0xe3, 0xe3, 0x63, 0x0f, 0x3a, 0x87, 0xd0, 0x6a, 0xb5,
    0x0a, 0xab, 0xd5, 0x1b, 0xdb, 0xfa, 0xff, 0xa5, 0x68, 0x6d, 0xca, 0xce,
    0x99, 0xdd, 0x5f, 0x03, 0x54, 0xcb, 0x78, 0x5f, 0x19, 0x93, 0xe9, 0x84,
    0xdb, 0xdb, 0x5b, 0xee, 0xef, 0xef, 0x5b, 0xbc, 0xbf, 0xd1, 0xf6, 0x9e,
    0x0c, 0x3f, 0xec, 0x24, 0x86, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4e,
    0x44, 0xae, 0x42, 0x60, 0x82
};


/*
 *  Constructs a GLModeller as a child of 'parent', with the
 *  name 'name' and widget flags set to 'f'.
 *
 */
GLModeller::GLModeller( QWidget* parent, const char* name, WFlags fl )
    : QMainWindow( parent, name, fl )
{
    (void)statusBar();
    QImage img;
    img.loadFromData( image1_data, sizeof( image1_data ), "PNG" );
    image1 = img;
    img.loadFromData( image2_data, sizeof( image2_data ), "PNG" );
    image2 = img;
    img.loadFromData( image3_data, sizeof( image3_data ), "PNG" );
    image3 = img;
    img.loadFromData( image4_data, sizeof( image4_data ), "PNG" );
    image4 = img;
    if ( !name )
	setName( "GLModeller" );
    setCentralWidget( new QWidget( this, "qt_central_widget" ) );
    GLModellerLayout = new QGridLayout( centralWidget(), 1, 1, 11, 6, "GLModellerLayout"); 

    tabWidget2 = new QTabWidget( centralWidget(), "tabWidget2" );
    tabWidget2->setSizePolicy( QSizePolicy( (QSizePolicy::SizeType)7, (QSizePolicy::SizeType)0, 0, 0, tabWidget2->sizePolicy().hasHeightForWidth() ) );
    tabWidget2->setTabPosition( QTabWidget::Top );
    tabWidget2->setTabShape( QTabWidget::Rounded );

    tab = new QWidget( tabWidget2, "tab" );
    tabLayout = new QGridLayout( tab, 1, 1, 11, 6, "tabLayout"); 

    frotzbox = new QSpinBox( tab, "frotzbox" );
    frotzbox->setMaxValue( 360 );
    frotzbox->setMinValue( -360 );

    tabLayout->addWidget( frotzbox, 3, 1 );

    textLabel5 = new QLabel( tab, "textLabel5" );

    tabLayout->addWidget( textLabel5, 0, 2 );

    textLabel9 = new QLabel( tab, "textLabel9" );

    tabLayout->addWidget( textLabel9, 0, 3 );

    srotxbox = new QSpinBox( tab, "srotxbox" );
    srotxbox->setMaxValue( 360 );
    srotxbox->setMinValue( -360 );

    tabLayout->addWidget( srotxbox, 1, 3 );

    srotybox = new QSpinBox( tab, "srotybox" );
    srotybox->setMaxValue( 360 );
    srotybox->setMinValue( -360 );

    tabLayout->addWidget( srotybox, 2, 3 );

    srotzbox = new QSpinBox( tab, "srotzbox" );
    srotzbox->setMaxValue( 360 );
    srotzbox->setMinValue( -360 );

    tabLayout->addWidget( srotzbox, 3, 3 );

    textLabel1_2 = new QLabel( tab, "textLabel1_2" );

    tabLayout->addWidget( textLabel1_2, 0, 1 );

    frotxbox = new QSpinBox( tab, "frotxbox" );
    frotxbox->setMaxValue( 360 );
    frotxbox->setMinValue( -360 );

    tabLayout->addWidget( frotxbox, 1, 1 );

    typecombo = new QComboBox( FALSE, tab, "typecombo" );

    tabLayout->addWidget( typecombo, 1, 0 );

    frotybox = new QSpinBox( tab, "frotybox" );
    frotybox->setMaxValue( 360 );
    frotybox->setMinValue( -360 );

    tabLayout->addWidget( frotybox, 2, 1 );

    cullfacecheck = new QCheckBox( tab, "cullfacecheck" );

    tabLayout->addWidget( cullfacecheck, 2, 0 );

    tranxbox = new QSpinBox( tab, "tranxbox" );
    tranxbox->setMaxValue( 10000 );
    tranxbox->setMinValue( -10000 );
    tranxbox->setLineStep( 100 );

    tabLayout->addWidget( tranxbox, 1, 2 );

    tranybox = new QSpinBox( tab, "tranybox" );
    tranybox->setMaxValue( 10000 );
    tranybox->setMinValue( -10000 );
    tranybox->setLineStep( 100 );

    tabLayout->addWidget( tranybox, 2, 2 );

    tranzbox = new QSpinBox( tab, "tranzbox" );
    tranzbox->setMaxValue( 10000 );
    tranzbox->setMinValue( -10000 );
    tranzbox->setLineStep( 100 );

    tabLayout->addWidget( tranzbox, 3, 2 );

    frametimebox = new QSpinBox( tab, "frametimebox" );
    frametimebox->setMaxValue( 100000 );
    frametimebox->setLineStep( 100 );
    frametimebox->setValue( 1000 );

    tabLayout->addWidget( frametimebox, 1, 5 );

    textLabel1_4 = new QLabel( tab, "textLabel1_4" );

    tabLayout->addWidget( textLabel1_4, 1, 4 );
    tabWidget2->insertTab( tab, QString::fromLatin1("") );

    TabPage = new QWidget( tabWidget2, "TabPage" );

    textLabel1_7 = new QLabel( TabPage, "textLabel1_7" );
    textLabel1_7->setGeometry( QRect( 20, 20, 44, 18 ) );

    nameedit = new QLineEdit( TabPage, "nameedit" );
    nameedit->setGeometry( QRect( 70, 20, 138, 23 ) );

    facingbox = new QCheckBox( TabPage, "facingbox" );
    facingbox->setGeometry( QRect( 20, 50, 68, 22 ) );
    tabWidget2->insertTab( TabPage, QString::fromLatin1("") );

    tab_2 = new QWidget( tabWidget2, "tab_2" );

    textLabel1_3 = new QLabel( tab_2, "textLabel1_3" );
    textLabel1_3->setGeometry( QRect( 11, 11, 93, 18 ) );

    textLabel1_5 = new QLabel( tab_2, "textLabel1_5" );
    textLabel1_5->setGeometry( QRect( 130, 10, 75, 17 ) );

    textLabel1_8 = new QLabel( tab_2, "textLabel1_8" );
    textLabel1_8->setGeometry( QRect( 240, 10, 81, 18 ) );

    verty = new QSpinBox( tab_2, "verty" );
    verty->setGeometry( QRect( 11, 66, 93, 25 ) );
    verty->setMaxValue( 10000 );
    verty->setMinValue( -10000 );
    verty->setLineStep( 100 );

    vertz = new QSpinBox( tab_2, "vertz" );
    vertz->setGeometry( QRect( 11, 97, 93, 25 ) );
    vertz->setMaxValue( 10000 );
    vertz->setMinValue( -10000 );
    vertz->setLineStep( 100 );

    texcoordy = new QSpinBox( tab_2, "texcoordy" );
    texcoordy->setGeometry( QRect( 130, 70, 57, 23 ) );
    texcoordy->setMaxValue( 1000 );
    texcoordy->setLineStep( 10 );

    texcoordx = new QSpinBox( tab_2, "texcoordx" );
    texcoordx->setGeometry( QRect( 130, 40, 57, 23 ) );
    texcoordx->setMaxValue( 1000 );
    texcoordx->setLineStep( 10 );

    texunitcombo = new QComboBox( FALSE, tab_2, "texunitcombo" );
    texunitcombo->setGeometry( QRect( 240, 30, 40, 31 ) );

    vertx = new QSpinBox( tab_2, "vertx" );
    vertx->setGeometry( QRect( 10, 30, 93, 25 ) );
    vertx->setButtonSymbols( QSpinBox::UpDownArrows );
    vertx->setMaxValue( 10000 );
    vertx->setMinValue( -10000 );
    vertx->setLineStep( 100 );
    tabWidget2->insertTab( tab_2, QString::fromLatin1("") );

    TabPage_2 = new QWidget( tabWidget2, "TabPage_2" );

    vert1button = new QPushButton( TabPage_2, "vert1button" );
    vert1button->setGeometry( QRect( 10, 10, 106, 29 ) );

    vert2button = new QPushButton( TabPage_2, "vert2button" );
    vert2button->setGeometry( QRect( 10, 50, 106, 29 ) );

    vert3button = new QPushButton( TabPage_2, "vert3button" );
    vert3button->setGeometry( QRect( 10, 90, 106, 29 ) );

    collidebox = new QCheckBox( TabPage_2, "collidebox" );
    collidebox->setGeometry( QRect( 160, 10, 69, 22 ) );
    tabWidget2->insertTab( TabPage_2, QString::fromLatin1("") );

    TabPage_3 = new QWidget( tabWidget2, "TabPage_3" );
    TabPageLayout = new QGridLayout( TabPage_3, 1, 1, 0, 6, "TabPageLayout"); 

    matlist = new QTable( TabPage_3, "matlist" );
    matlist->setNumCols( matlist->numCols() + 1 );
    matlist->horizontalHeader()->setLabel( matlist->numCols() - 1, tr( "Filename" ) );
    matlist->setResizePolicy( QTable::Default );
    matlist->setNumRows( 0 );
    matlist->setNumCols( 1 );
    matlist->setColumnMovingEnabled( TRUE );
    matlist->setSelectionMode( QTable::SingleRow );
    matlist->setFocusStyle( QTable::FollowStyle );

    TabPageLayout->addMultiCellWidget( matlist, 0, 2, 0, 0 );

    addmatbutton = new QPushButton( TabPage_3, "addmatbutton" );

    TabPageLayout->addWidget( addmatbutton, 0, 1 );

    removematbutton = new QPushButton( TabPage_3, "removematbutton" );

    TabPageLayout->addWidget( removematbutton, 1, 1 );
    spacer1 = new QSpacerItem( 20, 41, QSizePolicy::Minimum, QSizePolicy::Expanding );
    TabPageLayout->addItem( spacer1, 2, 1 );
    tabWidget2->insertTab( TabPage_3, QString::fromLatin1("") );

    GLModellerLayout->addWidget( tabWidget2, 1, 0 );

    splitter5 = new QSplitter( centralWidget(), "splitter5" );
    splitter5->setOrientation( QSplitter::Horizontal );

    splitter4 = new QSplitter( splitter5, "splitter4" );
    splitter4->setOrientation( QSplitter::Vertical );

    vertlist = new QListView( splitter4, "vertlist" );
    vertlist->addColumn( tr( "Vertex" ) );
    vertlist->addColumn( tr( "Name" ) );
    vertlist->addColumn( tr( "ID" ) );
    vertlist->setSizePolicy( QSizePolicy( (QSizePolicy::SizeType)7, (QSizePolicy::SizeType)7, 0, 3, vertlist->sizePolicy().hasHeightForWidth() ) );
    vertlist->setRootIsDecorated( TRUE );

    trilist = new QTable( splitter4, "trilist" );
    trilist->setNumCols( trilist->numCols() + 1 );
    trilist->horizontalHeader()->setLabel( trilist->numCols() - 1, tr( "Triangle" ) );
    trilist->setNumCols( trilist->numCols() + 1 );
    trilist->horizontalHeader()->setLabel( trilist->numCols() - 1, tr( "Vertices" ) );
    trilist->setSizePolicy( QSizePolicy( (QSizePolicy::SizeType)7, (QSizePolicy::SizeType)7, 0, 1, trilist->sizePolicy().hasHeightForWidth() ) );
    trilist->setNumRows( 0 );
    trilist->setNumCols( 2 );
    trilist->setSelectionMode( QTable::Single );

    display = new GLPreview( splitter5, "display" );
    display->setSizePolicy( QSizePolicy( (QSizePolicy::SizeType)5, (QSizePolicy::SizeType)5, 1, 0, display->sizePolicy().hasHeightForWidth() ) );

    GLModellerLayout->addMultiCellWidget( splitter5, 0, 0, 0, 1 );

    frame3 = new QFrame( centralWidget(), "frame3" );
    frame3->setFrameShape( QFrame::StyledPanel );
    frame3->setFrameShadow( QFrame::Raised );
    frame3Layout = new QGridLayout( frame3, 1, 1, 11, 6, "frame3Layout"); 

    textLabel1 = new QLabel( frame3, "textLabel1" );

    frame3Layout->addWidget( textLabel1, 5, 0 );

    xglobalbox = new QLabel( frame3, "xglobalbox" );

    frame3Layout->addWidget( xglobalbox, 2, 0 );

    textLabel2 = new QLabel( frame3, "textLabel2" );

    frame3Layout->addMultiCellWidget( textLabel2, 3, 4, 0, 0 );

    zoomglobalbox = new QLabel( frame3, "zoomglobalbox" );

    frame3Layout->addWidget( zoomglobalbox, 6, 0 );

    zoomslider = new QSlider( frame3, "zoomslider" );
    zoomslider->setMaxValue( 100000 );
    zoomslider->setLineStep( 100 );
    zoomslider->setPageStep( 500 );
    zoomslider->setValue( 1000 );
    zoomslider->setOrientation( QSlider::Horizontal );

    frame3Layout->addMultiCellWidget( zoomslider, 6, 6, 1, 2 );

    textLabel13 = new QLabel( frame3, "textLabel13" );

    frame3Layout->addWidget( textLabel13, 1, 1 );

    globalxslider = new QSlider( frame3, "globalxslider" );
    globalxslider->setMinValue( -360 );
    globalxslider->setMaxValue( 360 );
    globalxslider->setOrientation( QSlider::Horizontal );

    frame3Layout->addWidget( globalxslider, 2, 1 );

    globalyslider = new QSlider( frame3, "globalyslider" );
    globalyslider->setMinValue( -360 );
    globalyslider->setMaxValue( 360 );
    globalyslider->setOrientation( QSlider::Horizontal );

    frame3Layout->addMultiCellWidget( globalyslider, 3, 4, 1, 1 );

    globalzslider = new QSlider( frame3, "globalzslider" );
    globalzslider->setMinValue( -360 );
    globalzslider->setMaxValue( 360 );
    globalzslider->setOrientation( QSlider::Horizontal );

    frame3Layout->addWidget( globalzslider, 5, 1 );

    globalytran = new QSlider( frame3, "globalytran" );
    globalytran->setMinValue( -10000 );
    globalytran->setMaxValue( 10000 );
    globalytran->setOrientation( QSlider::Horizontal );

    frame3Layout->addWidget( globalytran, 4, 2 );

    globalxtran = new QSlider( frame3, "globalxtran" );
    globalxtran->setMinValue( -10000 );
    globalxtran->setMaxValue( 10000 );
    globalxtran->setOrientation( QSlider::Horizontal );

    frame3Layout->addMultiCellWidget( globalxtran, 2, 3, 2, 2 );

    globalztran = new QSlider( frame3, "globalztran" );
    globalztran->setMinValue( -10000 );
    globalztran->setMaxValue( 10000 );
    globalztran->setOrientation( QSlider::Horizontal );

    frame3Layout->addWidget( globalztran, 5, 2 );

    textLabel1_6 = new QLabel( frame3, "textLabel1_6" );

    frame3Layout->addMultiCellWidget( textLabel1_6, 0, 0, 1, 2 );

    textLabel2_2 = new QLabel( frame3, "textLabel2_2" );

    frame3Layout->addWidget( textLabel2_2, 1, 2 );

    GLModellerLayout->addWidget( frame3, 1, 1 );

    // actions
    fileNewAction = new QAction( this, "fileNewAction" );
    fileNewAction->setIconSet( QIconSet( image1 ) );
    fileOpenAction = new QAction( this, "fileOpenAction" );
    fileOpenAction->setIconSet( QIconSet( image2 ) );
    fileSaveAction = new QAction( this, "fileSaveAction" );
    fileSaveAction->setIconSet( QIconSet( image3 ) );
    fileSaveAsAction = new QAction( this, "fileSaveAsAction" );
    filePrintAction = new QAction( this, "filePrintAction" );
    filePrintAction->setIconSet( QIconSet( image4 ) );
    fileExitAction = new QAction( this, "fileExitAction" );
    editAddAction = new QAction( this, "editAddAction" );
    editDeleteAction = new QAction( this, "editDeleteAction" );
    fileSave_MaterialsAction = new QAction( this, "fileSave_MaterialsAction" );
    fileOpen_MaterialsAction = new QAction( this, "fileOpen_MaterialsAction" );
    editCopyAction = new QAction( this, "editCopyAction" );
    editPasteAction = new QAction( this, "editPasteAction" );
    editAdd_TriangleAction = new QAction( this, "editAdd_TriangleAction" );


    // toolbars


    // menubar
    MenuBar = new QMenuBar( this, "MenuBar" );


    fileMenu = new QPopupMenu( this );
    fileNewAction->addTo( fileMenu );
    fileOpenAction->addTo( fileMenu );
    fileSaveAction->addTo( fileMenu );
    fileSaveAsAction->addTo( fileMenu );
    fileOpen_MaterialsAction->addTo( fileMenu );
    fileSave_MaterialsAction->addTo( fileMenu );
    fileMenu->insertSeparator();
    fileExitAction->addTo( fileMenu );
    MenuBar->insertItem( QString(""), fileMenu, 1 );

    Edit = new QPopupMenu( this );
    editAddAction->addTo( Edit );
    editDeleteAction->addTo( Edit );
    Edit->insertSeparator();
    editCopyAction->addTo( Edit );
    editPasteAction->addTo( Edit );
    MenuBar->insertItem( QString(""), Edit, 2 );

    languageChange();
    resize( QSize(770, 731).expandedTo(minimumSizeHint()) );
    clearWState( WState_Polished );

    // signals and slots connections
    connect( fileExitAction, SIGNAL( activated() ), this, SLOT( close() ) );
    connect( vertx, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( verty, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( vertz, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( frotxbox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( frotybox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( frotzbox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( srotxbox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( srotybox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( srotzbox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( tranxbox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( tranybox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( tranzbox, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( fileSaveAction, SIGNAL( activated() ), this, SLOT( fileSaveAction_activated() ) );
    connect( fileOpenAction, SIGNAL( activated() ), this, SLOT( fileOpenAction_activated() ) );
    connect( fileNewAction, SIGNAL( activated() ), this, SLOT( fileNewAction_activated() ) );
    connect( addmatbutton, SIGNAL( clicked() ), this, SLOT( addmatbutton_clicked() ) );
    connect( matlist, SIGNAL( selectionChanged() ), this, SLOT( UpdateDisplay() ) );
    connect( cullfacecheck, SIGNAL( toggled(bool) ), this, SLOT( UpdateDisplay() ) );
    connect( editCopyAction, SIGNAL( activated() ), this, SLOT( editCopyAction_activated() ) );
    connect( editPasteAction, SIGNAL( activated() ), this, SLOT( editPasteAction_activated() ) );
    connect( texcoordx, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( texcoordy, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( nameedit, SIGNAL( textChanged(const QString&) ), this, SLOT( UpdateDisplay() ) );
    connect( fileSaveAsAction, SIGNAL( activated() ), this, SLOT( fileSaveAsAction_activated() ) );
    connect( fileOpen_MaterialsAction, SIGNAL( activated() ), this, SLOT( fileOpen_MaterialsAction_activated() ) );
    connect( fileSave_MaterialsAction, SIGNAL( activated() ), this, SLOT( fileSave_MaterialsAction_activated() ) );
    connect( vertlist, SIGNAL( selectionChanged(QListViewItem*) ), this, SLOT( vertlist_selectionChanged(QListViewItem*) ) );
    connect( editAddAction, SIGNAL( activated() ), this, SLOT( Add() ) );
    connect( editDeleteAction, SIGNAL( activated() ), this, SLOT( DeleteVertex() ) );
    connect( editAdd_TriangleAction, SIGNAL( activated() ), this, SLOT( AddTriangle() ) );
    connect( vert1button, SIGNAL( clicked() ), this, SLOT( vert1button_clicked() ) );
    connect( vert2button, SIGNAL( clicked() ), this, SLOT( vert2button_clicked() ) );
    connect( vert3button, SIGNAL( clicked() ), this, SLOT( vert3button_clicked() ) );
    connect( globalxslider, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( globalyslider, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( globalzslider, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( zoomslider, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( texunitcombo, SIGNAL( activated(int) ), this, SLOT( UpdateDisplay() ) );
    connect( globalxtran, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( globalytran, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( globalztran, SIGNAL( valueChanged(int) ), this, SLOT( UpdateDisplay() ) );
    connect( trilist, SIGNAL( selectionChanged() ), this, SLOT( trilist_selectionChanged() ) );
    connect( collidebox, SIGNAL( toggled(bool) ), this, SLOT( UpdateDisplay() ) );
    connect( facingbox, SIGNAL( toggled(bool) ), this, SLOT( UpdateDisplay() ) );
    connect( display, SIGNAL( zoomin() ), zoomslider, SLOT( subtractStep() ) );
    connect( display, SIGNAL( zoomout() ), zoomslider, SLOT( addStep() ) );
    connect( display, SIGNAL( rotatexneg() ), globalxslider, SLOT( subtractLine() ) );
    connect( display, SIGNAL( rotatexpos() ), globalxslider, SLOT( addLine() ) );
    connect( display, SIGNAL( rotateyneg() ), globalyslider, SLOT( subtractLine() ) );
    connect( display, SIGNAL( rotateypos() ), globalyslider, SLOT( addLine() ) );
    connect( display, SIGNAL( translatexneg() ), globalxtran, SLOT( subtractStep() ) );
    connect( display, SIGNAL( translatexpos() ), globalxtran, SLOT( addStep() ) );
    connect( display, SIGNAL( translateyneg() ), globalytran, SLOT( addStep() ) );
    connect( display, SIGNAL( translateypos() ), globalytran, SLOT( subtractStep() ) );

    // tab order
    setTabOrder( vertx, verty );
    setTabOrder( verty, vertz );
    setTabOrder( vertz, texcoordx );
    setTabOrder( texcoordx, texcoordy );
    setTabOrder( texcoordy, frotxbox );
    setTabOrder( frotxbox, frotybox );
    setTabOrder( frotybox, frotzbox );
    setTabOrder( frotzbox, tranxbox );
    setTabOrder( tranxbox, tranybox );
    setTabOrder( tranybox, tranzbox );
    setTabOrder( tranzbox, srotxbox );
    setTabOrder( srotxbox, srotybox );
    setTabOrder( srotybox, srotzbox );
    setTabOrder( srotzbox, tabWidget2 );
    setTabOrder( tabWidget2, vertlist );
    setTabOrder( vertlist, typecombo );
    setTabOrder( typecombo, cullfacecheck );
    setTabOrder( cullfacecheck, matlist );
    setTabOrder( matlist, addmatbutton );
    setTabOrder( addmatbutton, removematbutton );
    setTabOrder( removematbutton, frametimebox );
    setTabOrder( frametimebox, nameedit );
    setTabOrder( nameedit, texunitcombo );
    setTabOrder( texunitcombo, vert1button );
    setTabOrder( vert1button, vert2button );
    setTabOrder( vert2button, vert3button );
    setTabOrder( vert3button, trilist );
    setTabOrder( trilist, zoomslider );
    setTabOrder( zoomslider, globalxslider );
    setTabOrder( globalxslider, globalyslider );
    setTabOrder( globalyslider, globalzslider );
    setTabOrder( globalzslider, globalytran );
    setTabOrder( globalytran, globalxtran );
    setTabOrder( globalxtran, globalztran );
    init();
}

/*
 *  Destroys the object and frees any allocated resources
 */
GLModeller::~GLModeller()
{
    // no need to delete child widgets, Qt does it all for us
}

/*
 *  Sets the strings of the subwidgets using the current
 *  language.
 */
void GLModeller::languageChange()
{
    setCaption( tr( "GL Modeller" ) );
    textLabel5->setText( tr( "Translation:" ) );
    textLabel9->setText( tr( "Rotation:" ) );
    textLabel1_2->setText( tr( "Rotation:" ) );
    typecombo->clear();
    typecombo->insertItem( tr( "Container" ) );
    typecombo->insertItem( tr( "Vertex" ) );
    typecombo->insertItem( tr( "Triangle" ) );
    typecombo->insertItem( tr( "Quad" ) );
    cullfacecheck->setText( tr( "Cull Faces" ) );
    textLabel1_4->setText( tr( "Frametime" ) );
    tabWidget2->changeTab( tab, tr( "Main" ) );
    textLabel1_7->setText( tr( "Name:" ) );
    facingbox->setText( tr( "Facing" ) );
    QToolTip::add( facingbox, tr( "Should this polygon always face the camera?" ) );
    tabWidget2->changeTab( TabPage, tr( "Container" ) );
    textLabel1_3->setText( tr( "Position" ) );
    textLabel1_5->setText( tr( "Tex Coords" ) );
    textLabel1_8->setText( tr( "Texture Unit" ) );
    texunitcombo->clear();
    texunitcombo->insertItem( tr( "0" ) );
    texunitcombo->insertItem( tr( "1" ) );
    texunitcombo->insertItem( tr( "2" ) );
    texunitcombo->insertItem( tr( "3" ) );
    texunitcombo->insertItem( tr( "4" ) );
    texunitcombo->insertItem( tr( "5" ) );
    texunitcombo->insertItem( tr( "6" ) );
    texunitcombo->insertItem( tr( "7" ) );
    tabWidget2->changeTab( tab_2, tr( "Vertex" ) );
    vert1button->setText( tr( "Set Vertex 1" ) );
    vert2button->setText( tr( "Set Vertex 2" ) );
    vert3button->setText( tr( "Set Vertex 3" ) );
    collidebox->setText( tr( "Collide" ) );
    tabWidget2->changeTab( TabPage_2, tr( "Triangle" ) );
    matlist->horizontalHeader()->setLabel( 0, tr( "Filename" ) );
    addmatbutton->setText( tr( "Add" ) );
    removematbutton->setText( tr( "Remove" ) );
    tabWidget2->changeTab( TabPage_3, tr( "Material" ) );
    vertlist->header()->setLabel( 0, tr( "Vertex" ) );
    vertlist->header()->setLabel( 1, tr( "Name" ) );
    vertlist->header()->setLabel( 2, tr( "ID" ) );
    trilist->horizontalHeader()->setLabel( 0, tr( "Triangle" ) );
    trilist->horizontalHeader()->setLabel( 1, tr( "Vertices" ) );
    textLabel1->setText( tr( "Z-Axis" ) );
    xglobalbox->setText( tr( "X-Axis" ) );
    textLabel2->setText( tr( "Y-Axis" ) );
    zoomglobalbox->setText( tr( "Zoom" ) );
    textLabel13->setText( tr( "Rotation" ) );
    textLabel1_6->setText( tr( "Global" ) );
    textLabel2_2->setText( tr( "Translation" ) );
    fileNewAction->setText( tr( "New" ) );
    fileNewAction->setMenuText( tr( "&New" ) );
    fileNewAction->setAccel( tr( "Ctrl+N" ) );
    fileOpenAction->setText( tr( "Open" ) );
    fileOpenAction->setMenuText( tr( "&Open..." ) );
    fileOpenAction->setAccel( tr( "Ctrl+O" ) );
    fileSaveAction->setText( tr( "Save" ) );
    fileSaveAction->setMenuText( tr( "&Save" ) );
    fileSaveAction->setAccel( tr( "Ctrl+S" ) );
    fileSaveAsAction->setText( tr( "Save As" ) );
    fileSaveAsAction->setMenuText( tr( "Save &As..." ) );
    fileSaveAsAction->setAccel( QString::null );
    filePrintAction->setText( tr( "Print" ) );
    filePrintAction->setMenuText( tr( "&Print..." ) );
    filePrintAction->setAccel( tr( "Ctrl+P" ) );
    fileExitAction->setText( tr( "Exit" ) );
    fileExitAction->setMenuText( tr( "E&xit" ) );
    fileExitAction->setAccel( QString::null );
    editAddAction->setText( tr( "Add" ) );
    editAddAction->setMenuText( tr( "Add" ) );
    editAddAction->setAccel( tr( "A" ) );
    editDeleteAction->setText( tr( "Delete" ) );
    editDeleteAction->setMenuText( tr( "Delete" ) );
    editDeleteAction->setAccel( tr( "D" ) );
    fileSave_MaterialsAction->setText( tr( "Save Materials" ) );
    fileSave_MaterialsAction->setMenuText( tr( "Save Materials" ) );
    fileOpen_MaterialsAction->setText( tr( "Open Materials" ) );
    fileOpen_MaterialsAction->setMenuText( tr( "Open Materials" ) );
    editCopyAction->setText( tr( "Copy" ) );
    editCopyAction->setMenuText( tr( "Copy" ) );
    editCopyAction->setAccel( tr( "Ctrl+C" ) );
    editPasteAction->setText( tr( "Paste" ) );
    editPasteAction->setMenuText( tr( "Paste" ) );
    editPasteAction->setAccel( tr( "Ctrl+V" ) );
    editAdd_TriangleAction->setText( tr( "Add Triangle" ) );
    editAdd_TriangleAction->setMenuText( tr( "Add Triangle" ) );
    editAdd_TriangleAction->setAccel( tr( "T" ) );
    if (MenuBar->findItem(1))
        MenuBar->findItem(1)->setText( tr( "&File" ) );
    if (MenuBar->findItem(2))
        MenuBar->findItem(2)->setText( tr( "Edit" ) );
}

