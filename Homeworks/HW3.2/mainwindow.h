#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QImage>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow( QWidget *parent = 0 );
    ~MainWindow();

public slots:
    void on_actionOpen_triggered();
    void on_actionSave_triggered();
    void on_actionRemove_green_color_triggered();

protected:
    void paintEvent( QPaintEvent* event );

private:
    Ui::MainWindow *ui;
    QImage img;
    QString filename;
    bool process;

    bool remove_green();
    void paint();
};

#endif // MAINWINDOW_H
