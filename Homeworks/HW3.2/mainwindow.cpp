#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QProgressDialog>
#include <QImage>
#include <QFileDialog>
#include <QMessageBox>
#include <QBoxLayout>

MainWindow::MainWindow( QWidget *parent ) :
    QMainWindow( parent ),
    ui( new Ui::MainWindow ),
    process( false )
{
    ui->setupUi( this );
    ui->centralWidget->layout()->setAlignment( Qt::AlignCenter );
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_actionRemove_green_color_triggered()
{
    process = true;
    ui->statusBar->showMessage( tr("Removing green started..."), 3000 );  // 3 sec
    if( !remove_green() ) {
        if( !img.load( filename ) ) {
            QMessageBox::critical( this, tr("Error"), tr("Can not reload image") );
        }
        ui->statusBar->showMessage( tr("Removing green was canceled"), 3000 );  // 3 sec
    } else {
        ui->statusBar->showMessage( tr("Removed green successfull"), 3000 );  // 3 sec
    }
    process = false;
}

void MainWindow::on_actionSave_triggered()
{
    if( img.save( filename ) )
    {
        ui->statusBar->showMessage( tr("Image saved"), 3000 );  // 3 sec
    } else {
        QMessageBox::critical( this, tr("Error"), tr("Can not load image") );
    }
}

void MainWindow::on_actionOpen_triggered()
{
    filename = QFileDialog::getOpenFileName(
                this, tr("Open image"), "",
                "*.bmp *.jpg *.jpeg *.png *.xpm *.xbm *.ppm"
                );
    if( !img.load( filename ) ) {
        QMessageBox::critical( this, tr("Error"), tr("Can not load image") );
        return;
    } else {
        ui->label->setMinimumSize( img.size() );
    }

    paint();
}

void MainWindow::paintEvent( QPaintEvent* event )
{
    paint();
}

bool MainWindow::remove_green()
{
    int n = img.height() * img.width();
    QProgressDialog pprd(
                tr("Removing the green color..."), tr("&Cancel"),
                0, n
                );

    pprd.setMinimumDuration( 500 );  // 0.5 sec
    pprd.setWindowTitle( tr("Please Wait") );

    for( int i = 0; i < img.width(); ++i )
    {
        if ( pprd.wasCanceled() )
        {
            pprd.hide();
            return false;
        }
        for( int j = 0; j < img.height(); ++j )
        {
            if( pprd.wasCanceled() ) {
                break;
            }
            QColor pixel = img.pixelColor( i, j );
            int r, g, b;
            pixel.getRgb( &r, &g, &b );
            g = 0;
            img.setPixelColor( i, j, QColor( r, g, b ) );
            pprd.setValue( i*img.height() + j ) ;
            qApp->processEvents();
        }
    }
    pprd.setValue( n );
    return true;
}

void MainWindow::paint()
{
    if( !process )
    {
        ui->label->setPixmap( QPixmap::fromImage( img ) );
    }
    ui->label->show();
}
