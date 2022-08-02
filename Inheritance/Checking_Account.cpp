#include "Checking_Account.h"
#include <iostream>
#include <string>

using namespace std;

Checking_Account::Checking_Account(string name, double balance)
    : Account{name,balance} {

}

bool Checking_Account::withdraw(double amount)
{
    amount -= 1.5;
    return Account::withdraw(amount);
}


ostream &operator<<(ostream &os, const Checking_Account &account) {
    os << "[Checking_Account: " << account.name << ": " << account.balance << "%]";
    return os;
}