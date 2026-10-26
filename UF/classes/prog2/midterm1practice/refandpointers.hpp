#include <iostream> 

using namespace std; 

// References and Pointers

// Syntax Labeling 

    // int& myThing = yourThing;
        // invalid reference assignment X
        // reference assignment 
        // by setting the address of myThing to yourThing, myThing becomes 
        // another name for yourThing 
    // int& favNumber = 37;
        // reference assignment X
        // invalid reference assignment 
        // this would be like trying to set a non cons reference to a literal
    // int myValue = *someValue;
        // invalid pointer assignment X
        // pointer dereferencing 
        // *someValue goes to the address and returns the value, which is 
        // copied into myValue 
    // int number = 10; 
        // normal variable assignment 
    // int* bigAns = 42; 
        // pointer assignment X
        // invalid pointer assignment 
        // pointers hold addresses, and 42 is not an address 
    // int* myObj = &otherObj; 
        // pointer dereferencing X
        // pointer assignment 
        // the address of otherObj is being assigned into pointer myObj 

    // & in a declaration (like int& r) means r is a reference. & in an expression 
    // (&x) means address of
        // must be initialized 
        // cannot be repointed later
        // cannot be null
        // does not need to be dereferenced to access value 

    // * in a declaration (int* p) means p is pointer. * in an expression 
    // (*p) means dereference 
        // doesn't need to be initialized, but should
        // can be re-pointed after 
        // can be null
        // needs to be derefenced to access the value 

// Passing Into Functions 

// Pass By Copy
	// Making a copy of an object without changing the original. Also can be expensive memory wise

void addOne(int x) {
x = x + 1; 
}

int n = 5; 
addOne(n);
cout << n; // n will still be 5, since passing by copy does nothing to the actual value stored at the address of x. 

// Pass by Reference 
	// Passing in the address of a variable to change it directly 
	// you save space by simply modifying the value at the variable directly instead of making a copy
	// one risk is that you can accidentally change the caller's data. 
	// cannot take a literal unless you make the parameter a const reference
        // void fooFunc(const int& x)
	
void addOne(int& x) {
x = x + 1; 
}

int x = 5;
addOne(x);
cout << x; // n will now be equal to 6, since the value at the reference of the variable was modified directly

// Pass by Pointer 
	// When passing by pointer, you are passing in the direct address of a variable.
    // No, it does not change the original pointer. When you pass in a pointer as a 
    // functions parameter, the pointer in the parameter will point at the same address
    // as the one that you input. It is a copy of the callers pointer, so when you change
    // it, it doesn't change the original pointer. 
    // If you dereference the paramteter and modify the value. it will change the orginal
    // variable 
	
void AddOne(int* x) {
x* = x* + 1;
}

