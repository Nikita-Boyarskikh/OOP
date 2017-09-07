#include "validator_delegate.h"

#include <QLineEdit>
#include <QRegExp>
#include <QRegExpValidator>
#include <QIntValidator>

ValidatorDelegate::ValidatorDelegate( QObject* parent ) :
    QItemDelegate( parent ) {}

QWidget* ValidatorDelegate::createEditor( QWidget* parent,
                                     const QStyleOptionViewItem& option,
                                     const QModelIndex& index ) const
{
    QLineEdit* editor = new QLineEdit( parent );

    switch( index.column() ) {
        case 1:    // title
        case 4: {  // country
            break;
        }
        case 2: {  // count
            editor->setValidator( new QIntValidator( 0, 16777215, editor ) );
            break;
        }
        case 3: {  // year
            editor->setValidator( new QIntValidator( 1900, 2200, editor ) );
            break;
        }
        case 5: {  // direction
            QRegExp direction_re("export|import");
            editor->setValidator( new QRegExpValidator( direction_re ) );
            break;
        }
    }

    return editor;
}


void ValidatorDelegate::setEditorData( QWidget* editor,
                                  const QModelIndex& index ) const
{
    QString value = index.model()->data( index, Qt::EditRole ).toString();
    QLineEdit* line = static_cast<QLineEdit*>( editor );

    switch( index.column() ) {
        case 1:    // title
        case 2:    // count
        case 3:    // year
        case 4: {  // country
            line->setText( value );
            break;
        }
        case 5: {  // direction
            if( value == "i" ) {
                line->setText("import");
            } else {
                line->setText("export");
            }
            break;
        }
    }
}

void ValidatorDelegate::setModelData( QWidget *editor,
                                 QAbstractItemModel *model,
                                 const QModelIndex &index ) const
{
    QLineEdit *line = static_cast<QLineEdit*>( editor );
    QString value = line->text();

    switch( index.column() ) {
        case 1:    // title
        case 2:    // count
        case 3:    // year
        case 4: {  // country
            model->setData( index, value );
            break;
        }
        case 5: {   // direction
            if( value == "import" ) {
                model->setData( index, "i" );
            } else {
                model->setData( index, "e" );
            }
            break;
        }
    }
}
