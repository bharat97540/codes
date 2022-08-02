#include "Movies.h"

#include <iostream>
#include <climits>
#include <vector>
#include <string>
#include <cmath>
#include<iomanip>


using namespace std;

Movies::Movies(){

}

Movies::~Movies() {
}   

bool Movies::add_movie(string name, int rating, int watched)
{
    for (Movie &movie:movies)
    {
        if(movie.get_name()==name)
        {
            cout<<"movie already exsist"<<endl;
            return false;
        }

    }

    Movie temp {name, rating, watched};
    movies.push_back(temp);
    return true;
}

bool Movies::increment_watched(string name)
{
    for (Movie &movie:movies)
    {
        if(movie.get_name()==name)
            movie.inc_watched();
    }
    return false;
}

void Movies::display(){
if (movies.size() == 0) {
        std::cout << "Sorry, no movies to display\n" << std::endl;
    } else {
        std::cout << "\n===================================" << std::endl;
        for (auto &movie: movies)
            movie.display();
        std::cout << "\n===================================" << std::endl;
    }
}