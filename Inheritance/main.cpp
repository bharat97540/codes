// Section 15
// Challenge 
#include <iostream>
#include <vector>
#include "Savings_Account.h"
#include "Account_Util.h"
#include "Checking_Account.h"
using namespace std;

int main() {
    cout.precision(2);
    cout << fixed;
   
    //Accounts
    vector<Account> accounts;
    accounts.push_back(Account {});
    accounts.push_back(Account {"Larry"});
    accounts.push_back(Account {"Moe", 2000} );
    accounts.push_back(Account {"Curly", 5000} );
    
    display(accounts);
    deposit(accounts, 1000);
    withdraw(accounts,2000);
    
    // Savings 

    vector<Savings_Account> sav_accounts;
    sav_accounts.push_back(Savings_Account {"Wonderwoman", 5000, 5.0} );

    display(sav_accounts);
    deposit(sav_accounts, 1000);
    withdraw(sav_accounts, 2000);

    vector<Checking_Account> check_acc;
    check_acc.push_back(Checking_Account{"bharat", 5000});
    Checking_Account ac {"neelam",1000};
    ac.withdraw(10);
    cout<<"sdfsdfsd"<<ac.balance<<"\n"<<endl;
    display(check_acc);
    deposit(check_acc, 1000);

    return 0;
}

