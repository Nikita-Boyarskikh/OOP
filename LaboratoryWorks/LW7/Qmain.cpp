#include <QCoreApplication>
#include <QMap>
#include <QFile>
#include <QString>
#include <QTextStream>
#include <QStringList>
#include <QVector>

class MyString : public QString
{
public:
  bool operator <(const MyString &str) const;
};

bool MyString::operator <(const MyString &str) const
{
  return this->toLower() < str.toLower();
}

int main()
{
  QTextStream cout(stdout);
  QFile file("data.tsv");
  if( !file.open(QFile::ReadOnly | QIODevice::Text) ) {
      cout << "Error while opening file!" << endl;
    }
  QTextStream ifs(&file);
  QMap< MyString, QVector<int> > map;
  while( !ifs.atEnd() ) {
      QVector<int> vec;
      MyString str;
      ifs >> str;
      QStringList list = ifs.readLine().split('\t');
      QString i;
      foreach (i, list) {
          vec.append( i.toInt() );
        }
      map.insert(str, vec);
    }
  return 0;
}
