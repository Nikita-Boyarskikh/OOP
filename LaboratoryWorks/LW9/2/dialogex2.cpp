#include <QtGui>
#include "dialogex2.h"
#include <QMessageBox>

DialogEx2::DialogEx2(QWidget *parent)
    :QDialog(parent)
{
    setupUi(this);
    connect(btnExit, SIGNAL(clicked()), this, SLOT(onExitClicked()));
}

void DialogEx2::onExitClicked()
{
    if ( QMessageBox::question(
             this, QString(), "Завершить приложение?", QMessageBox::Yes|QMessageBox::No
             ) == QMessageBox::Yes
         ) {
        exit(0);
    }
}
