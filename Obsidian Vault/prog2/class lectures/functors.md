## Introduction to Functors
1. **What is a Functor?** 
	- *functor* (function object) : **object** of a class that is **called like a function** 
		- works by **overloading** the *function call operator* [operator()]
		*class* **Greeter** {
		public: 
			**void operator**()() {
				cout << **"Called!"** << endl;
				}
			};
		- this way, making an **object from** [Greeter] can call the function within:
		**Greeter** greet;
		*greet*(); <- calls the objects overloaded function from operator() 
2. **How is this possible?**
	![[Pasted image 20261116230937.png]]
3. **What should the Return/Parameters be?**
	- [operator()] can have any return type and parameter list - it just depends on what you want the function to do 

____
## Creating Functors with State
- by **storing data in member variables**, *functors* can **remember information between calls** 
	- this is called its **state** 
	- each time *functors* are called, it **adds an argument to its list**, returning the updated value (similar to a queue) 
	**RunningTotal** first(10); // make object first() with starting value 10
	first(5); // add 5, returns 15
	first(3); // add 3, returns 18
___
## Functors vs Function Pointers
- while a *function pointer* **refers to a function**, a *functor* is its **own object** whose class defines [operator()]![[Pasted image 20261116233123.png]]
- the reason for using a *functor* over a normal *function pointer* is that *functors* can **store configurations or data** with the member variables of its class 
____
## STL Algorithms and Predicates
- *Predicate:* a callable that tests a condition, returning [true] or [false]
	- ie. count_if() applies a *predicate* for every iteration, returning how many calls are produced [true] 
	- both regular functions and functors can supply the same *predicate* 
	 **bool GreaterThan20**(**int** number) {
		 *return* number > 20; <- *predicate* 
		 }
1. **STL Algorithms Work on Iterator Ranges**
	- including *algorithm* provides [count_if], which counts how many elements **satisfy a predicate** 
	- syntax: *count_if*(numbers.*begin*(), numbers.*end*(), GreaterThan20)
		- where arguments are **starting iterator, one past ending iterator**, and **predicate** 
		- *begin* and *end* checks the first and one past the last (which would be nullptr or some absent value) 
2. **Both Function and Functor Work as a Predicate** 
	*count_if*(numbers.*begin*(), numbers.*end*(), GreaterThan20)
		passes a function
	*count_if*(numbers.*begin*(),numbers.*end*(), GreaterThan20Functor())
		passes a temporary functor object 
___
## Customizing Functors with Constructors
- a *functors* **constructor** can store **configuration** that its call operator uses
	*struct* **GreaterThan_X** { 
		*GreaterThan_X*(**int** checkValue) { 
			_ x = checkValue; } 
		
	**bool** **operator**()(**int** number) { 
		*return* number > _ x; 
	} 
	
	*private*: 
		**int** _ x; 
	};
	- here, the _ x is the **configuration**, and the *call operator* checks its input against it
1. **Reusing One Functor Type with** [count_if] 
	count_if(numbers.begin(), numbers.end(), GreaterThan_X(10)); count_if(numbers.begin(), numbers.end(), GreaterThan_X(20)); count_if(numbers.begin(), numbers.end(), GreaterThan_X(35));
	- each time the predicate is called, a separate temporary object is created holding a different threshold 