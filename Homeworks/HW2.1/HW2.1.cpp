#include <iostream>
#include <string>
#include <sstream>
#include <vector>

using std::cout;
using std::cin;
using std::endl;
using std::string;
using std::stringstream;
using std::vector;

string correct(const string str, const int n);

int main(int argc, char **argv) {

    int width = 0;
    vector<string> corrected;
    cout << "Введите ширину строк: ";
    cin >> width;
    cin.ignore();
    cout << "Введите строки для корректировки > ";
    string s;
    while(getline(cin, s)) {
        s = correct(s, width);
        if( s == "" ) {
            cout << "Введённая ширина слишком мала для данных строк" << endl;
            return 1;
        }
        corrected.push_back(s);
    }

    cout << endl << "Скорректированные строки:" << endl << endl;

    for(auto i : corrected) {
        cout << i << endl;
    }

    return 0;
}

string correct(const string str, const int n)
{
    string result;
    size_t total_length = 0;
    stringstream ss;
    vector<string> vec;
    ss << str;

    string temp;
    while(ss >> temp) {
        total_length += temp.size();
        vec.push_back(temp);
    }

    if( vec.empty() ) {
        result.assign(n, ' ');
        return result;
    }

    if( vec.size() == 1 ) {
        if( vec[0].size() <= n ) {
            return vec[0];
        } else {
            return "";
        }
    }

    int spaces = (n - (int)total_length) / (int)(vec.size() - 1);
    if( spaces < 1 ) {
        return "";
    }

    int more_spaces = (n - (int)total_length) % (int)(vec.size() - 1);

    string delimiter;
    if(spaces > 0) {
        delimiter.assign(spaces, ' ');
    }

    for( int i = 0; i < vec.size() - 1; i++ ) {
        result = result + vec[i] + delimiter;
        if( more_spaces > 0 ) {
            result = result + ' ';
            more_spaces--; 
        }
    }
    result = result + vec[vec.size() - 1];

    if(spaces < 0)
        result.erase(result.size() + spaces);
    return result;
}
