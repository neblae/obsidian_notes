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
- 