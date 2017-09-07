#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QStandardItemModel>
#include <QItemSelection>
#include <QTableView>
#include <QtSql>
#include <QtCharts>

#include "validator_delegate.h"

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
    void on_tabBarMain_currentChanged( int index );
    void on_iptImportProductReport_returnPressed();
    void on_iptImportCountryReport_returnPressed();
    void on_iptGraphExport_returnPressed();

private:
    Ui::MainWindow* ui;
    ValidatorDelegate* delegate;

    QSqlQueryModel* model;
    QSqlTableModel* main_model;
    QSqlDatabase db;

    QLabel* lblGraphExport;
    QLineEdit* iptGraphExport;

    QChartView* chart_view;
    QBarCategoryAxis* chart_axis;
    QChart* chart;
    QBarSeries* chart_series;
    QBarSet* chart_set;

    bool create_main_overview_model();
    QSqlError create_import_product_report_model();
    QSqlError create_import_country_report_model();
    bool create_chart( QString title );

    void update_main_overview();
    void update_import_product_report();
    void update_import_country_report();
    void update_graph_export();

    void setup_table_view( QTableView *table_view );
    bool setup_database( QString dbname );
};

#endif // MAINWINDOW_H
