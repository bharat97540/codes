#ifndef _MOVIE_H_
#define _MOVIE_H_
#include <string>
#include <iostream>
#include <climits>
#include <vector>
#include <string>
#include <cmath>
#include<iomanip>

using namespace std;


class Movie{
private:    
    string name;
    int rating;
    int watched;
public:
    Movie(string name,int rating, int watched); 
    ~Movie();

    void set_name(string name){this->name = name;}
    string get_name(){return name;}
    void set_rating(int rating){this->rating = rating;}
    int get_rating(){return rating;}
    void set_watched(int watched){this->watched = watched;}
    int get_watched(){return watched;}
    void inc_watched(){++watched;}
    void display();

};

#endif