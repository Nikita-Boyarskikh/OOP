#ifndef DIRECTION_VALIDATOR_DELEGATE_H
#define DIRECTION_VALIDATOR_DELEGATE_H

#include <QItemDelegate>

/// Validate columns in main overview (delegate)
class ValidatorDelegate : public QItemDelegate
{
    Q_OBJECT
public:
    explicit ValidatorDelegate(QObject *parent = 0);

protected:
    QWidget* createEditor(QWidget *parent, const QStyleOptionViewItem &option, const QModelIndex &index) const;
    void setEditorData(QWidget * editor, const QModelIndex & index) const;
    void setModelData(QWidget * editor, QAbstractItemModel * model, const QModelIndex & index) const;
};

#endif // DIRECTION_VALIDATOR_DELEGATE_H
