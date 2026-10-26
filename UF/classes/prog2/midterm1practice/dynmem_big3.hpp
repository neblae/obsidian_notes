#include <iostream> 
using namespace std;

// Dynamic Memory and Big Three

// Comparison with Static Memory 

    // static memory is on the stack, dynamic is on the heap 
    // static is known at compile time, dynamic is known at run time 
        // say you have a dynamic array of size[n]; the compiler will not know that 
        // size until it execute the function. this is okay, however, since there 
        // will always be enough space in heap, whereas if the array was in the stack,
        // there is a chance it would run out of space 
    // static is automatically deleted (when the stack closes) however dynamic has to
    // be freed manually (through the destructor)
    
// Dynamic Memory Syntax

    // the new keyword defines a variable/array to be stored dynamically in the heap
        // dynamic object - new T / new T(args) - delete p;
        // dynamic array - new T[n] - delete[] p;  
        // new returns a pointer to the address of the dynamically stored memory 
            // Dog* d = new Dog; returns Dog* pointing at the object 
            // to access members in a dynamic object, use -> (d->getName()) and []
            // for arrays arr[3] = 5 
// good habit: after delete p; , set p = nullptr; 


// The Big Three

// If a class owns heap memory, you must define the big three:
    // Destructor - frees memory when an object dies
    // Copy constructor - builds a new object as a copy of an existing one 
    // copy assignment operator - overwrites an existing object with a copy of another 

// Example code snippet from study guide: 
main() {
    myDynClass veteran; 
    myDynClass middleman; 
    middleman = veteran; // copy assignment operator 
    myDynClass noobie = veteran; // copy constructor 
}

// How do you define the destructor for a class?
    // ~myDynClass() { delete[] data; }

// Why do we need to redefine it when using dynamic memory?
    // the compiler is unable to fully free up the space taken up by dynamic memory. 
    // if it deletes a pointer like int* data, it will delete the address stored in 
    // data, but not the actual value in the heap
    // writing the destructor ensures that there are no memory leaks 

// When is it called in the snippet, and for which instances? 
    // when main() ends, the destructor is called on all three objects. it is not called
    // during the working of the function 

    // Destructor 
        // defined with the ~ in front, with no parameters and return type 
        // ~myDynClass() { delete[] data; }
            // you must delete any dynamically defined members 

// Copy constructor vs Copy assignment operator 
    // CC makes a brand new object, CAO changes an existing object
    // CC triggered by myDynClass b = a / b(a), where b is new; CAO uses b
    // declared earlier for b = a; 
    // CC doesn't need to free any memory, CAO needs to free the original memory
    // at array b
    // CC does not need self-assignment check, CAO does 
    // CC returns nothing (constructor), CAO returns myDynClass& (*this)
    // CC signature is myDynClass(const myDynClass& other), CAO signature is 
    // myDynClass& operator=(const myDynClass& rhs)

// Copy Constructor 
    // 1. Copy the plain members: size(other.size)
    // 2. Allocate a new array of the same size: data(new int[other.size])
    // 3. Copy the values element by element into the new array 

myDynClass(const myDynClass& other) 
    : size(other.size), data(new int[other.size]) { // allocating a new array of the same size 
        for (int i = 0; i < size; i++) {
            data[i] = other.data[i];
        }
    }

// Copy assignment operator 
    // 1. self-assignment guard
    // 2. free the OLD array
    // 3. copy plain members
    // 4. allocate a fresh array
    // 5. copy the values
    // 6. return the object for chaining 

myDynClass& operator=(const myDynClass& rhs) {
    if (this != &rhs) {
        delete[] data; // if you're wondering the function knows how to delete the right array, notice how you called the function on this. it will delete the array you are trying to copy new data into 
        size = rhs.size;
        data = new int[size]
        for (int i = 0; i < size; i++) {
            data[i] = rhs.data[i]; 
        }
    }
    return *this; 
}