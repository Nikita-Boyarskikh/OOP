#ifndef WIDGET_H
#define WIDGET_H

#include <QWidget>
#include <QFile>
#include <QDataStream>
#include <QString>
#include <QtMath>
#include <QPainter>
#include <vector>
#include <QMessageBox>
using namespace std;

namespace Ui {
class Widget;
}
struct cor{
    double x,y,z;
};

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = 0);
    ~Widget();
    QString FName="Rec.txt";
    QFile Record;
    double x,y,z;
    double pi=3.141526536;
    bool flag=false;
private slots:
    void MakeCoordFile();
    void ShowCords();
    void Draw();
    QPointF SterToFlat(double x1,double y1,double z1);
    void paintEvent(QPaintEvent *event);
private:
    Ui::Widget *ui;
};

#endif // WIDGET_H
