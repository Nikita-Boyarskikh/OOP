#include <iostream>
#include <map>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <iterator>
#include <cctype>

struct comparator {
    bool operator() ( std::string const &a, std::string const &b ) const
    {
        std::string new_a(a);
        std::string new_b(b);
        std::transform( new_a.begin(), new_a.end(), new_a.begin(), tolower );
        std::transform( new_b.begin(), new_b.end(), new_b.begin(), tolower );
        return new_a < new_b;
    }
};

int main( int argc, char *argv[] )
{
    std::ifstream file("data.tsv");
    std::string string, nums;
    std::map< std::string, std::vector<int>, comparator > map;
    while( file >> string && getline(file, nums) ) {
        std::vector<int> vec;
        std::stringstream ss;
        ss << nums;
        std::copy
            (
            std::istream_iterator<int>(ss),
            std::istream_iterator<int>(),
            std::back_inserter(vec)
            );
        map.insert( std::make_pair(string, vec) );
    }

    return 0;
}
