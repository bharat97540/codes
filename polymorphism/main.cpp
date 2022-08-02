#include <iostream>
#include <memory>
#include "Account.h"
#include "Checking_Account.h"
#include "Savings_Account.h"
#include "Trust_Account.h"
#include "Account_Util.h"

using namespace std;

int main() {
//    
    //Account joe;
    Checking_Account bharat;
    cout<<bharat<<endl;
    Savings_Account bh {"neelam",1000,5};
    cout<<bh<<endl;

    Account *pt = new Trust_Account();
    cout<<*pt<<endl;

    
    return 0;
}

