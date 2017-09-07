#ifndef DIALOGEX2_H
#define DIALOGEX2_H

#include <QDialog>
#include <ui_ex2.h>

class DialogEx2 : public QDialog, public Ui::Dialog
{
    Q_OBJECT
public:
    DialogEx2( QWidget * parent =0);
private slots:
    void onExitClicked();
};

#endif // DIALOGEX2_H
