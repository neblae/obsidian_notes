#include "linkedlist.hpp"
#include <iostream>
#include <string>

using namespace std;

int main() {

    LinkedList<int> llInt;
    llInt.AddHead(5); 
    llInt.PrintForward();

    return 0;
}

