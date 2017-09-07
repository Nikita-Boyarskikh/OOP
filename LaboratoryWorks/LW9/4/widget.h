#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QVBoxLayout>
#include <QPushButton>
#include <QLineEdit>
#include <QTextEdit>
#include <QVBoxLayout>
#include <QtGui>

class Wid : public QWidget
{
    Q_OBJECT

public:
    Wid(QWidget *parent = 0);
    QPushButton * btn;
    QTextEdit * TEdit;
    QLineEdit * LEdit;
private slots:
    void convert();
    void print();
};

#endif // WIDGET_H
