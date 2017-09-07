#include "widget.h"

Wid::Wid(QWidget *parent) : QWidget(parent)
{
    btn = new QPushButton("Convert",this);
    TEdit = new QTextEdit("",this);
    LEdit = new QLineEdit("",this);
    QVBoxLayout *myLayout = new QVBoxLayout(this);

    myLayout->addWidget(LEdit);
    myLayout->addWidget(btn);
    myLayout->addWidget(TEdit);

    connect(btn,SIGNAL(clicked(bool)),this,SLOT(convert()) );
    connect(LEdit,SIGNAL(textEdited(QString)),this,SLOT(print()));
}

void Wid::convert()
{
    QString str;
    TEdit->clear();
    str = LEdit->text();
    TEdit->insertPlainText("input: "+str+"\n");
    str = str.toLower();
    TEdit->insertPlainText("all lower: "+str+"\n");
    str = str.toUpper();
    TEdit->insertPlainText("ALL UPPER: "+str+"\n");
}

void Wid::print()
{
    QString str;
    TEdit->clear();
    str = LEdit->text();
    TEdit->insertPlainText("input: "+str+"\n");
}
