1. #FunctionsHaveAddresses
	1. **Calling a function vs. Referring to a function**
		- Calling a function:
		original way to use a function; by calling a function with **parenthesis** (i.e. [Random100()]) it executes the function, taking in some value, and directly returns it 
			[Random100()] returns **42**
		- Referring to a function:
		a function without its parenthesis, like [Random100], refers to the **functions address, rather than executing it**
		as such, the *function pointer* **ptr** can call the same code from a function using [ptr()]:
			[int (* ptr) = Random100;] - **stores the function address in a pointer** 
			ptr() - **calls the function through the pointer**
			(void * )ptr - **displays the function's memory address**
			(ptr == Random100) - **compares function addresses** 
	2. **Functions Exist in Memory** 
		![[Pasted image 20261115163735.png]]
	3. **Creating a Function Pointer** 
		![[Pasted image 20261115163907.png]]without the parenthesis, the compiler thinks that the * is for the *return type*: 
			int * ptr() looks like the function is returning an **integer pointer instead** 
	4. **Calling a Function Through a Pointer** 
		the whole point of using a *function pointer* is that **a function pointer can later be reassigned to another compatible function** 
			[ptr()] and [Random100()] both return **42**, but the *function pointer* can be changed, while the original function **cannot** 
	5. **Displaying a Function's Memory Address** 
		1. [ cout << "Function address: " << (void * )ptr << endl;]
			need to use **(void * )** ,since without it, **printing a** *function pointer* **can be interpreted as a Boolean** 
	6. **Comparing Function Addresses** 
		![[Pasted image 20261115164522.png]]
_____
2. #DeclaringandReassigningFunctionPointers
	1. **Function Pointer Types and Signatures** 
		every time you declare a *function pointer*, you must make sure it has **identical return and parameter types with its** *prototype function*: 
			int Random100() -->  [int (* functPtr)() = Random100;]
			void DoSomeStuff(int value) --> [void (* p)(int) = DoSomeStuff;]
			int SomeFunc(float x, char y) --> [int (* var)(float, char) = SomeFunc;]
	2. **Calling Functions Through Pointers** 
		arguments must be **compatible** with the *pointed-to function, or the prototype function* 
			[cout << functPtr() << endl;] takes in no argument 
			[p(7);] takes in an integer
			[cout << var(2.5f, 'A') << endl;] takes in a float and a char
	3. **Reassigning a Pointer** 
		*reassigning* only works when the **new** function have the **same return type and parameters** 
			[var = SomeFunc2;], where SomeFunc2 and SomeFunc both have **return type int** and **parameters (float, char)** 
		*reassigning* **doesn't modify** either function 
	4. **Using [auto]**
		instead of [void ( * functionPointer)(int) = DoSomeStuff;]  
		write [**auto** functionPointer = DoSomeStuff;]  
			the compiler automatically knows the **arguments** and **return types**, so you don't need to rewrite anything 
___
3. **Passing Function Pointers to a Sort Function** 
	