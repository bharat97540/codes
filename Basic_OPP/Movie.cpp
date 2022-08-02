#include <string>
#include <iostream>
#include <climits>
#include <vector>
#include <string>
#include <cmath>
#include<iomanip>
#include "Movie.h"

using namespace std;

Movie::Movie(string name, int rating, int watched)
    :name(name), rating(rating), watched(watched){

}


Movie::~Movie() {
}

void Movie::display()
{
    cout<<name<<endl;
}

