#include <iostream>
#include <boost/crc.hpp>
#include <boost/filesystem.hpp>
#include <fstream>
#include <unordered_set>
#include <set>
#include <algorithm>
#include <string>

#define HASHTABLE_INITIAL_NUMBER_OF_BUCKETS 8
typedef std::unordered_set< std::string, std::function<size_t(std::string)> > HashTable;
const std::string ENABLED_CHARS = std::string("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789") +
                                  std::string("абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ");

template <class T>
struct CRC16 : public std::hash<T> {
    size_t operator() ( T obj );
};

template <class T>
struct HashComparator {
    bool operator() ( const std::pair<size_t, T> &a, const std::pair<size_t, T> &b ) const;
};

void create_index( std::string input_file_name, std::string index_file_name );

void create_dict( std::string input_file_name, std::string index_file_name = "index.tsv",
                           std::string result_file_name = "result.tsv" );

int main( int argc, char *argv[] )
{
    for( size_t i = 1; i < argc; i++ ) create_dict( argv[i] );
    return 0;
}

void create_dict( std::string input_file_name, std::string index_file_name, std::string result_file_name )
{
    if( !boost::filesystem::exists( input_file_name.c_str() ) ) {
        throw std::runtime_error( std::string("Can't open file '") + input_file_name + std::string("'.") );
    }
    std::ifstream text_file( input_file_name.c_str() );

    if( !boost::filesystem::exists( index_file_name.c_str() ) ) {
        create_index( input_file_name, index_file_name );
    }

    std::ifstream crc_file( index_file_name.c_str() );
    std::ofstream result_file( result_file_name.c_str() );

    std::string str;
    size_t hash;
    std::set< std::pair<size_t, std::string>, HashComparator<std::string> > hash_table;
    std::multiset<std::string> result;
    while( crc_file >> hash >> str ) {
        hash_table.insert( std::make_pair(hash, str) );
    }

    while( text_file >> str ) {
        for( size_t i = 0; i < str.size(); i++ ) {
            if( ENABLED_CHARS.find(str[i]) == std::string::npos ) {
                str.erase(i);
            }
        }
        if( str != "" ) result.insert( str );
    }

    std::multiset< std::pair<size_t, std::string>, HashComparator<std::string> > sorted_result;
    for( auto i : hash_table ) {
        sorted_result.insert( std::make_pair(result.count(i.second), i.second) );
    }

    for( auto i : sorted_result ) {
        result_file << i.first << '\t' << i.second << std::endl;
    }

    text_file.close();
    crc_file.close();
    result_file.close();
}

void create_index( std::string input_file_name, std::string index_file_name )
{
    std::ifstream text_file( input_file_name.c_str() );
    std::ofstream crc_file( index_file_name.c_str() );

    std::string str;
    HashTable table( HASHTABLE_INITIAL_NUMBER_OF_BUCKETS, CRC16<std::string>() );
    while( text_file >> str ) {
        for( size_t i = 0; i < str.size(); i++ ) {
            if( ENABLED_CHARS.find(str[i]) == std::string::npos ) {
                str.erase(i);
            }
        }
        if( str != "" ) table.insert( str );
    }

    HashTable::hasher hasher = table.hash_function();
    std::set< std::pair<size_t, std::string>, HashComparator<std::string> > result;
    for( auto it : table ) {
        result.insert( std::make_pair(hasher(it), it) );
    }

    for( auto it : result ) {
        crc_file << it.first << '\t' << it.second << std::endl;
    }

    text_file.close();
    crc_file.close();
}

template <class T>
size_t CRC16<T>::operator() ( T obj )
{
    boost::crc_16_type result;
    result.process_bytes( obj.data(), obj.size() );
    return result.checksum();
}

template <class T>
bool HashComparator<T>::operator() ( const std::pair<size_t, T> &a, const std::pair<size_t, T> &b ) const
{
    return a.first < b.first;
}
