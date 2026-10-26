#include <iostream>
using namespace std; 

// Template Classes and Functions 

// Template Syntax 
    // How to declare a template function with generic type T?
    template <typename T>
    void AddOne(T x)
    // What about a template class? 
    template <typename T>
    class Book {
        public: 
        T get() const { return value; } 
        private: 
        T value; 
    }
// Important: operator overloading is necessary when T is used 

    // Can you declare and define template functions and classes in different files?
        // Generally yes, but you must re-declare it between both .h and .cpp files  
    // T is a placeholder, so you can use it anywhere that a type name would be 
    // You can have multiple generic types with any name you want 
        template <typename T, typename K>

// Template Classes 
    // Should you split template classes into separate .h and .cpp files? 
        // make it a habit to declare the template each time it is used 
    // What file types does the splitting work for? 
        // if the files are split up, use #include ".h" and redeclare the template
    // If done incorrectly, you will get a linker error 
    
template <typename T>
class Box {
public:
    void set(T v);        // declaration only
    T get() const;
private:
    T value;
};

template <typename T>
void Box<T>::set(T v) { value = v; }          // template line + Box<T>::

template <typename T>
T Box<T>::get() const { return value; }

    // 