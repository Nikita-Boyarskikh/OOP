#include <QMessageBox>
#include <QStandardItemModel>
#include <QItemSelection>
#include <QtSql>
#include <QtCharts>
#include <QTableView>

#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "validator_delegate.h"

MainWindow::MainWindow( QWidget *parent ) :
    QMainWindow( parent ),
    ui( new Ui::MainWindow ),
    db( QSqlDatabase::addDatabase("QSQLITE") )
{
    // Setup UI
    ui->setupUi(this);
    ui->wdgGraphExport->setLayout(
                new QBoxLayout( QBoxLayout::TopToBottom, ui->tabGraphExport )
                );

    // Setup dinamic variables
    model = nullptr;
    chart = nullptr;
    chart_series = nullptr;
    chart_axis = nullptr;
    chart_view = nullptr;
    chart_set = nullptr;

    // Setup validator
    delegate = new ValidatorDelegate;
    ui->tblMainOverview->setItemDelegate( delegate );

    // Sqlite file
    QString filename = QString("../PR3/Practice3.sqlite");

    // Setup DB
    if( !setup_database( filename ) ) {
        QMessageBox::critical( this, tr("Error"), tr("Error: failed to setup database"));
        exit(1);
    }

    // Setup Main Overview
    update_main_overview();
}

MainWindow::~MainWindow()
{
    db.close();

    delete ui;
    delete delegate;
    delete model;
    delete main_model;
    delete chart;
}

/// Slots
void MainWindow::on_tabBarMain_currentChanged( int index ) {
    switch( index ) {
    case 0:  // Main Overview
        update_main_overview();
        break;
    case 1:  // Import product report
        update_import_product_report();
        break;
    case 2: // Import country report
        update_import_country_report();
        break;
    case 3:  // Graph export
        update_graph_export();
        break;
    }

    // Cleanup
    ui->statusBar->clearMessage();
}

void MainWindow::on_iptImportProductReport_returnPressed() {
    QSqlError error = create_import_product_report_model();
    if( error.isValid() ) {
        QMessageBox::critical( this, tr("Error"), error.text() );
        exit(1);
    }
    setup_table_view( ui->tblImportProductReport );

    QString title = ui->iptImportProductReport->text();

    update_import_product_report();
    ui->tblImportProductReport->setEnabled( true );
    ui->tblImportProductReport->show();

    QSqlQuery query;
    query.prepare("SELECT SUM(`count`) FROM `practice_3` "
                  "WHERE `direction` = 'i' AND `title` = ? "
                  "GROUP BY `title`");
    query.addBindValue( title );
    bool ok = query.exec();
    bool exists = query.next();
    
    if( ok && exists ) {
        ui->statusBar->clearMessage();
        ui->outImportProductReportSummary->setText( query.value(0).toString() );
    } else if( ok ) {
        ui->statusBar->showMessage( tr("This product is not imported") );
    } else {
        ui->statusBar->showMessage( tr("Error occured while getting data") );
    }
}

void MainWindow::on_iptImportCountryReport_returnPressed() {
    QSqlError error = create_import_country_report_model();
    if( error.isValid() ) {
        QMessageBox::critical( this, tr("Error"), error.text() );
        exit(1);
    }

    QString country = ui->iptImportCountryReport->text();

    setup_table_view( ui->tblImportCountryReport );
    update_import_country_report();

    ui->tblImportCountryReport->setEnabled( true );
    ui->tblImportCountryReport->show();

    QSqlQuery query;
    query.prepare("SELECT SUM(`count`) FROM `practice_3` "
                  "WHERE `direction` = 'i' AND `country` = ? "
                  "GROUP BY `country`");
    query.addBindValue( country );
    bool ok = query.exec();
    bool exists = query.next();

    if( ok && exists ) {
        ui->statusBar->clearMessage();
        ui->outImportCountryReportSummary->setText( query.value(0).toString() );
    } else if( ok ) {
        ui->statusBar->showMessage( tr("The products from this country were not imported") );
    } else {
        ui->statusBar->showMessage( tr("Error occured while getting data") );
    }
}

void MainWindow::on_iptGraphExport_returnPressed() {
    QString title = ui->iptGraphExport->text();

    update_graph_export();
    ui->wdgGraphExport->setEnabled( true );

    if( !create_chart( title ) ) {
        ui->statusBar->showMessage("No data to display");
    }

    ui->wdgGraphExport->layout()->addWidget( chart_view );
    ui->wdgGraphExport->show();
}

/// Private functions
void MainWindow::update_main_overview() {
    if( !create_main_overview_model() ) {
        QMessageBox::critical( this, tr("Error"), tr("Failed to create main data model") );
        exit(1);
    }

    ui->tblMainOverview->setModel(main_model);
    ui->tblMainOverview->setColumnHidden( 0, true );
    ui->tblMainOverview->show();

    ui->outExportLeadingCountry->clear();

    QSqlQuery query;
    query.prepare(
                "SELECT `country` FROM `practice_3` "
                "WHERE `direction` = 'e' GROUP BY `country` "
                "ORDER BY SUM(`count`) DESC LIMIT 1");
    bool ok = query.exec();
    bool exists = query.next();

    if( ok && exists ) {
        ui->statusBar->clearMessage();
        ui->outExportLeadingCountry->setText( query.value(0).toString() );
    } else if( ok ) {
        ui->statusBar->showMessage( tr("No data to display") );
    } else {
        ui->statusBar->showMessage( tr("Error occured while getting data") );
    }
}

void MainWindow::update_import_product_report() {
    ui->tblImportProductReport->setEnabled( false );
    ui->outImportProductReportSummary->clear();
    ui->iptImportProductReport->clear();
    ui->iptImportProductReport->setFocus();
}

void MainWindow::update_import_country_report() {
    ui->tblImportCountryReport->setEnabled( false );
    ui->outImportCountryReportSummary->clear();
    ui->iptImportCountryReport->clear();
    ui->iptImportCountryReport->setFocus();
}

void MainWindow::update_graph_export() {
    ui->iptGraphExport->clear();
    ui->iptGraphExport->setFocus();
    ui->wdgGraphExport->setEnabled( false );
}

bool MainWindow::create_main_overview_model() {
    main_model->setTable("practice_3");
    main_model->setHeaderData( 0, Qt::Horizontal, tr("Id") );
    main_model->setHeaderData( 1, Qt::Horizontal, tr("Title") );
    main_model->setHeaderData( 2, Qt::Horizontal, tr("Amount") );
    main_model->setHeaderData( 3, Qt::Horizontal, tr("Year") );
    main_model->setHeaderData( 4, Qt::Horizontal, tr("Country") );
    main_model->setHeaderData( 5, Qt::Horizontal, tr("Direction") );
    main_model->setSort( 1, Qt::DescendingOrder );
    main_model->setEditStrategy( QSqlTableModel::OnFieldChange );

    return main_model->select();
}

QSqlError MainWindow::create_import_product_report_model() {
    if( model ) {
        delete model;
    }

    QString title = ui->iptImportProductReport->text();
    QSqlQuery query;
    query.prepare(
                "SELECT `id`, `country`, SUM(`count`) AS summa "
                "FROM `practice_3` WHERE `direction` = 'i' AND `title` = ? "
                "GROUP BY `country` ORDER BY summa DESC"
                );
    query.addBindValue( title );
    query.exec();

    model = new QSqlQueryModel( this );
    model->setQuery( query );
    model->setHeaderData( 0, Qt::Horizontal, tr("Id") );
    model->setHeaderData( 1, Qt::Horizontal, tr("Country") );
    model->setHeaderData( 2, Qt::Horizontal, tr("Summary amount") );

    return model->lastError();
}

QSqlError MainWindow::create_import_country_report_model() {
    if( model ) {
        delete model;
    }

    QString country = ui->iptImportCountryReport->text();
    QSqlQuery query;
    query.prepare("SELECT `id`, `title`, SUM(`count`) FROM `practice_3` "
                  "WHERE `direction` = 'i' AND `country` = ? "
                  "GROUP BY `title` ORDER BY SUM(`count`) DESC");
    query.addBindValue( country );
    query.exec();

    model = new QSqlQueryModel( this );
    model->setQuery( query );
    model->setHeaderData( 0, Qt::Horizontal, tr("Id") );
    model->setHeaderData( 1, Qt::Horizontal, tr("Product") );
    model->setHeaderData( 2, Qt::Horizontal, tr("Summary amount") );

    return model->lastError();
}

bool MainWindow::create_chart( QString title ) {
    // Dataset
    if( chart_set ) {
        delete chart_set;
    }
    chart_set = new QBarSet( title, this );

    // Categories
    QStringList categories;

    // Reading data from DB
    QSqlQuery query;
    query.prepare("SELECT `id`, `year`, SUM(`count`) "
                  "FROM `practice_3` WHERE `title` = ? AND `direction` = 'e' "
                  "GROUP BY `year` ORDER BY `year`");
    query.addBindValue( title );
    query.exec();

    bool exists = query.next();
    if( !exists ) return false;
    while( exists ) {
        chart_set->append( query.value(2).toInt() );
        categories << query.value(1).toString();
        exists = query.next();
    }

    // Series
    if( chart_series ) {
        delete chart_series;
    }
    chart_series = new QBarSeries( this );
    chart_series->append( chart_set );

    // Chart
    if( chart ) {
        delete chart;
    }
    chart = new QChart();
    chart->addSeries( chart_series );
    chart->setTitle( tr("Export of product by years") );
    chart->setAnimationOptions( QChart::SeriesAnimations );

    // Axis
    if( chart_axis ) {
        delete chart_axis;
    }
    chart_axis = new QBarCategoryAxis( this );
    chart_axis->append( categories );
    chart->createDefaultAxes();
    chart->setAxisX( chart_axis, chart_series );

    // Legend
    chart->legend()->setVisible( true );
    chart->legend()->setAlignment( Qt::AlignBottom );

    ui->wdgGraphExport->layout()->removeWidget( chart_view );

    // View
    if( chart_view ) {
        delete chart_view;
    }
    chart_view = new QChartView( chart, this );
    chart_view->setRenderHint( QPainter::Antialiasing );
    chart_view->setGeometry( 10, 40, 400, 350 );
    chart_view->setBaseSize( 400, 350 );

    return true;
}

void MainWindow::setup_table_view( QTableView* table_view ) {
    table_view->setModel( model );
    table_view->setColumnHidden( 0, true );
    table_view->show();
}

bool MainWindow::setup_database( QString dbname ) {
    db.setDatabaseName( dbname );
    db.open();

    QSqlQuery query;
    bool result = true;
    if( !db.tables().contains( QLatin1String("practice_3") ) ) {
        // Create table
        result = query.exec(
                    "CREATE TABLE `practice_3` ("
                    "   `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"
                    "   `title` VARCHAR(255),"
                    "   `count` INTEGER,"
                    "   `year` YEAR,"
                    "   `country` VARCHAR(255),"
                    "   `direction` VARCHAR(1)"
                    ")");
    }
    query.clear();

    main_model = new QSqlTableModel( this, db );

    return result;
}
