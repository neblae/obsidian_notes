#include <iostream> 

using namespace std;

// Class Basics

// Default vs parameterized Constructor 

// My definition : a default constructor creates an object of a given class
// without any input parameters, while a parameterized constructor has 
// defined parameters needed for the object to be initalized with data members
// set to the given values 

// you can't write a parameterized construtor if you don't write a default 
// constructor beforehand 
// can only have one default but as many parameterized as you want 

// Ex:

class Dog {
public:
    Dog(string n = "none", int a = 0) : name(n), age(a) {}

private:
    string name;
    int age; 
}

// in this case, you can actually write both the default and the parameterized 
// constructor in one. how? 
    // "string n = "none", int a = 0" is the default constructor, 
    // while the : separates the default from the parameterized constructor. 
    // name(n) and age(a) sets the member variables to different parameters

    // this is the same thing as writing: 

class Dog {
public:
    Dog() : name("none"), age(0) {}

    Dog(string n, int a) : name(n), age(a) {}

private:
    string name;
    int age; 
}


// Remember that declarations would be put in Dog.h, and definitions would be 
// put in Dog.cpp

// Dog.h

class Dog {
public:
    Dog(string name = "none", int a = 0);

private:
    string name;
    int age;
}

// Dog.cpp

#include "Dog.h" 

Dog::Dog(string n, int a) : name(n), age(a) {}



// Setters and Getters 

    // setter: a public function that changes a private member - 
        // void setAge(int a)
    // setters work as checkpoints for member variables. since you have to use a 
    // function to change the value of a private member, you can make sure the 
    // value going in is something that you want 

    // getter: a public function that returns a private member's value - 
        // int getAge() const 
    // some variables shouldn't be able to be changed from a setter (something 
    // like the size of a linked list), however the getter can access the 
    // variable to display it without changing the value 

// Access Specifiers 

// What is the difference between private vs public within a class? 
    // private members are accessible only by the class's own defined member
    // functions. this means that an object whos member variable is private
    // cannot simply be modified/returned without a function defined to 
    // do so.
    // if int value of object A is private, A.value = 5 will show a compile error 

// What is the difference between a class and a struct?
    // by default, classes will make member variables/functions be Private, while
    // structures will make them public 

// Where should variables go, private or public? Functions? 
    // Variables generally be private if you don't want them to be easily 
    // changed. If you want functions to access your private member variables 
    // outside the definition of the class (like when working with objects) 
    // functions should be public

// Class Basics Example Class

class Book {
public:
    Book(string n = "None", string a = "None", unsigned int p = 0) 
        : name(n), author(a), pages(p)  {}
        
    void setName(string n) {
        name = n;
    }

    void setAuthor(string a) {
        author = a;
    }

    void setPages(unsigned int p) {
        pages = p;
    }
        
    string getName() const { 
        return name;
    }

    string getAuthor() const {
        return author; 
    }

    unsigned int getPages() const {
        return pages;
    }

private:
    string name;
    string author; 
    unsigned int pages;
};
