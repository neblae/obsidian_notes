#include <iostream> 
using namespace std; 

// Operator Overloading

// Function Overloading

    // Overloading a function means having a function with the same name, but taking
    // in different parameters. Based off of the arguments when the operator is called,
    // the compiler decides which definition to use.

    // To overload a function, you must define its arguments for different data members

void printThing(int x) {
    cout << x << endl;
}

void printThing(string y) {
    cout << y << endl;
}


// Common Operators

    // + adds the values of the two arguments together, making a new value without 
    // changing their original values
    // += adds the value of the second var to the first var, changing the first var
    // without changing the second var 

    // += adds the value of the second var to the first var, while >= is a boolean 
    // operator which returns a true or false value given the nature of the statement



// Operator Overload Syntax 

    // operator +
        // returns new value, argument is a constant T&
    // operator -
        // returns new value, argument is a constant T&
    // operator -= 
        // modifies *this, argument is a constant T&
    // operator += 
        // modifies *this, argument is a const T&
    // operator = 
        // copy assignment, modifies *this to be the same as argument
    // operator !=
        // returns boolean value, argument is a constant T&
    // operator < 
        // returns boolean value, argument is a constant T&

// important: arithmetic assignments returns a value (T) while compound/copy returns
// a reference (T&). this is because arithmetic assignments returns a new value, while 
// the others return *this 

    // -= and = can be void since they are modifying this, not making anything new
    // the others shouldn't be void
    // you are better off returning T& in order to be able to use the modified value 

    // assignment operators change the calling object (this) 

    // const is generally used in the parameter (const T& rhs) to ensure the function 
    // won't change the rhs, which is usually not modified 
    // if const is used after the parameter list (operator(T& rhs) const {}) you can
    // ensure *this isn't being modified. 
        // use for +, -, !=, or <, which is read only 
    // -= and = modify this so don't use const 

    // the arithmetic operator+ is called by the callee (A) on the operand B. 
    // the expected return type is just whatever the data member of A and B are, which
    // in this case is myObj 