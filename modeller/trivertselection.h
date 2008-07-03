/****************************************************************************
** Form interface generated from reading ui file 'trivertselection.ui'
**
** Created: Mon Jun 16 19:57:16 2008
**      by: The User Interface Compiler ($Id: qt/main.cpp   3.3.8   edited Jan 11 14:47 $)
**
** WARNING! All changes made in this file will be lost!
****************************************************************************/

#ifndef TRIVERTSELECTION_H
#define TRIVERTSELECTION_H

#include <qvariant.h>
#include <qdialog.h>

class QVBoxLayout;
class QHBoxLayout;
class QGridLayout;
class QSpacerItem;
class QListView;
class QListViewItem;
class QPushButton;

class TriVertSelection : public QDialog
{
    Q_OBJECT

public:
    TriVertSelection( QWidget* parent = 0, const char* name = 0, bool modal = FALSE, WFlags fl = 0 );
    ~TriVertSelection();

    QListView* vertlist;
    QPushButton* closebutton;

public slots:
    virtual void vertlist_selectionChanged( QListViewItem * );

protected:
    QVBoxLayout* TriVertSelectionLayout;

protected slots:
    virtual void languageChange();

private:
    void init();

};

#endif // TRIVERTSELECTION_H
