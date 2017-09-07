#include "widget.h"
#include "ui_widget.h"

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);
    Record.setFileName(FName);
    connect(ui->FileButton,SIGNAL(clicked(bool)),this,SLOT(MakeCoordFile()));
    connect(ui->DrawButton,SIGNAL(clicked(bool)),this,SLOT(Draw()));
}

void Widget::MakeCoordFile(){
    int grad;
    Record.open(QIODevice::WriteOnly);
    QDataStream in(&Record);
    for (x=-pi/4;x<=0.75*pi;x+=pi/30){
        for(grad=0;grad<=375;grad+=15){
            y=sin(x)*sin(grad*pi/180);
            z=sin(x)*cos(grad*pi/180);
            in<<x<<y<<z;
        }
    }
    Record.close();
    ui->DrawButton->setEnabled(true);
    ui->CordList->setEnabled(true);
    ShowCords();
}

void Widget::ShowCords(){
    Record.open(QIODevice::ReadOnly);
    QDataStream out(&Record);
    QString Txt="";
    while (!out.atEnd()){
        out>>x>>y>>z;
        Txt=Txt+QString::number(x)+" "+QString::number(y)+" "+QString::number(z)+" "+"\n";
    }
    ui->CordList->setPlainText(Txt);
    Record.close();
}

void Widget::paintEvent(QPaintEvent *event){
    Record.open(QIODevice::ReadOnly);
    QDataStream out(&Record);
    QPainter painter(this);
    Q_UNUSED(event);
    painter.setPen(QPen(Qt::black,2,Qt::SolidLine));;
    painter.drawLine(QLineF(20,360,20,20));
    painter.drawLine(QLineF(20,20,360,20));
    painter.drawLine(QLineF(360,20,360,360));
    painter.drawLine(QLineF(360,360,20,360));
    painter.drawLine(QLineF(190,190,190,40));
    painter.drawLine(QLineF(190,190,320,265));
    painter.drawLine(QLineF(190,190,60,265));
    painter.drawText(QRect(200,40,210,50),"Z");
    painter.drawText(QRect(330,265,340,275),"X");
    painter.drawText(QRect(70,265,80,275),"Y");
    if (flag){
        painter.setPen(QPen(QColor(255,0,0),1,Qt::SolidLine));;
        vector<cor> Spin1, Spin2;
        for(int i=0;i<15;i++){
 //           painter.setPen(QPen(QColor(255-(i*15),i*15,i*15),1,Qt::SolidLine));
            cor inp;
            Spin1.clear();
                for (int j=0;j<=25;j++){
                    out>>inp.x>>inp.y>>inp.z;
                    Spin1.push_back(inp);
                }
                if ((i>0)&(i!=15)){
                    painter.setPen(QPen(QColor(rand()%256,rand()%256,rand()%256),1,Qt::SolidLine));
                    for (int j=0;j<25;j++){
                      painter.drawLine(QLineF(SterToFlat(Spin1[j].x,Spin1[j].y,Spin1[j].z),
                                       SterToFlat(Spin2[j].x,Spin2[j].y,Spin2[j].z)));
                    }
                }
                Spin2.clear();
                for (int j=0;j<=25;j++){
                    out>>inp.x>>inp.y>>inp.z;
                    Spin2.push_back(inp);
                }
                painter.setPen(QPen(QColor(rand()%256,rand()%256,rand()%256),1,Qt::SolidLine));
                for (int j=0;j<25;j++){
                    painter.drawLine(QLineF(SterToFlat(Spin1[j].x,Spin1[j].y,Spin1[j].z),
                                     SterToFlat(Spin1[j+1].x,Spin1[j+1].y,Spin1[j+1].z)));
                    painter.drawLine(QLineF(SterToFlat(Spin2[j].x,Spin2[j].y,Spin2[j].z),
                                     SterToFlat(Spin2[j+1].x,Spin2[j+1].y,Spin2[j+1].z)));
                    painter.drawLine(QLineF(SterToFlat(Spin1[j].x,Spin1[j].y,Spin1[j].z),
                                     SterToFlat(Spin2[j].x,Spin2[j].y,Spin2[j].z)));
                 }
        }
    }
    Record.close();
}

QPointF Widget::SterToFlat(double x1, double y1, double z1){
    int fx,fy;
    fy=round((x1*0.5+y1*0.5-z1)*50) + 190;
    fx=round((x1*cos(pi/6)-y1*cos(pi/6))*50) + 190;
    return QPointF(fx,fy);
}

void Widget::Draw(){
    flag=true;
    repaint();
}

Widget::~Widget()
{
    Record.remove();
    delete ui;
}
