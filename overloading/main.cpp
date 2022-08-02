#include <iostream>
#include <climits>
#include <vector>
#include <string>
#include <cstring>
#include<iomanip>

using namespace std;

class Mystring
{  
    private :
    char *str;

    public:
    Mystring();
    Mystring(char *s);
    Mystring(Mystring &source);
    Mystring(Mystring &&source);

    Mystring &operator=(Mystring &rhs);
    Mystring &operator=(Mystring &&rhs);

    Mystring operator-();
    Mystring operator+(Mystring &rhs);
    bool operator==(Mystring &rhs);

    ~Mystring(){};
    void display();
    int get_length();
    char *get_str();

};

Mystring::Mystring()
    :str(nullptr){
        str = new char[1];
        *str = '\0';
    }

 Mystring::Mystring(char *s)
    :  str{nullptr}
    {
        str = new char[strlen(s)+1];
        strcpy(str,s);
    }
//copy constructor
Mystring::Mystring (Mystring &source)
    :str{nullptr}{
        str = new char[strlen(source.str)+1];
        strcpy(str,source.str);
}
//move constructor
Mystring::Mystring(Mystring &&source)
:str{source.str}{
    source.str = nullptr;

}

//copy
Mystring &Mystring::operator=(Mystring &rhs)
{   if(this==&rhs)
        return *this;

    delete [] this->str;

    str = new char[strlen(rhs.str)+1];
    strcpy(str,rhs.str);
    return *this;

    }

//Move 
Mystring &Mystring::operator=(Mystring &&rhs)
{
     if(this==&rhs)
        return *this;

    delete [] this->str;

    str = rhs.str;
    rhs.str = nullptr;
    return *this;
}

bool Mystring::operator==(Mystring &rhs)
{
    return (strcmp(this->str,rhs.str)==0);
}

Mystring Mystring::operator-()
{
    char *temp = new char[strlen(str)+1];
    strcpy(temp,str);
    for(size_t i=0;i<strlen(str);i++)
    {
        temp[i] = tolower(temp[i]);
    }
    Mystring buff {temp};
    delete [] temp;
    return buff;
    
}

Mystring Mystring::operator+(Mystring &rhs)
{
    char *temp = new char[strlen(str) + strlen(rhs.str)+1];
    strcpy(temp,this->str);
    strcat(temp,rhs.str);
    Mystring buff {temp};
    delete [] temp;
    return buff;
}

void Mystring::display()
{
    cout<<str<<":"<<get_length()<<endl;
}

int Mystring::get_length()
{return strlen(str);}

char *Mystring::get_str()
{
    return str;
}

int main()
{
    cout<<boolalpha<<endl;

    Mystring larry{(char *)"Larry"}; 
    Mystring moe{(char *)"Moe"};
    
    Mystring stooge = larry;
    larry.display();                                                                      
    moe.display();                                                                     

    cout << (larry == moe) << endl;                                         
    cout << (larry == stooge) << endl; 

    Mystring result = larry + stooge;
    result.display();
    return 0;
}