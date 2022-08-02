#ifndef _MOVIES_H_
#define _MOVIES_H_
#include "Movie.h"

#include <string>
#include <iostream>
#include <climits>
#include <vector>
#include <string>
#include <cmath>
#include<iomanip>

using namespace std;

class Movies{
    public:
    vector <Movie> movies;
    

    Movies();
    ~Movies();

    bool add_movie(string name, int rating, int watched);

    bool increment_watched(string name); 

    void display();

};

#endif