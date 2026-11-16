## 1. Functions Have Addresses
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

___

## 2. How to Declare and Reassigning Function Pointers
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

## 3. Passing Function Pointers to a Sort Function
1. **Why pass a Comparison Function?** 
	- assume you want to write a *sorting function* that can sort a vector[int] in one of two ways:
		- *Ascending* - low to high, so function returns **true** when a > b
		- *Descending* - high to low, so function returns **true** when a < b 
	- instead of **writing two separate sorting functions**, you can instead write one that **changes the sorting algorithm based on which** *function pointer* is passed in: 
		- [ void SortStuff(vector < int >& numbers, bool (* compare)(int, int))] 
		- where the **first** argument is a **reference to the vector**, and the **second** argument is a *pointer to a function* that **takes two integers and returns bool** 
2. **How to Call the Comparison** 
	![[Pasted image 20261115170943.png]]this functions the same **no matter which comparison type is passed in**; it either sorts low to high, or high to low. 
	- in this case, *function pointers* allows us to **avoid code duplication** 
3. **One Algorithm, Multiple Behaviors** 
	- as previous described, function names are passed **without ()**, since the *function pointer* wants the **address** of the *prototype function* in order to access its code.
		[SortStuff(numbers, **Ascending** )]
		[SortStuff(numbers, **Descending**)] 
4. **Sorting Code for Reference:** 
	![[Pasted image 20261115171351.png]]

___

## 4. Arrays of Function Pointers (Calculators)
1. **Arrays Can Store Functions** 
	if you have a *set of functions* that all have the **same return/argument** types, they are compatible to be stores in an **array** with **one function-pointer type** 
		ex. **calculator** functions Add, Subtract, Multiply, and Dive **all return double and take two double parameters**, so 
			[ double ( * operations[4](double, double))]
		- where [4] makes *operations* an array of **four function pointers** 
		- each element stores a *function address* 
2. **Assigning Functions**
	remember [operations[4]] is of size [4];
		operations[0] = Add;
		operations[1] = Subtract;
		operations[2] = Multiply;
		operations[3] = Divide;
			  notice how each *function* doesn't have [()] - we want the *function address* 
		operations[0] --> Add();
		operations[1] --> Subtract();
		operations[2] --> Multiply();
		operations[3] --> Divide();
			now, each operation index **calls its respective function** 
3. **What is an** [enum] **?** 
	an *enumeration* is a data type that allows you to **select names** for a **fixed set of integer constants** 
		syntax:
			*enum* **enumname** {value1, value2, value3}
	when you set a value to any constant in the *enumeration* (i.e. {RED, YELLOW, GREEN}) it automatically **sets each value to its position in the set** - as such YELLOW == 1, because it is in the **second position in the set** 
		going back to the operations[] example, you could set:
			*enum* **OPERATIONS** {ADD} = Add; 
			where value **ADD** will return the **address of the function Add** 
4. **Calling a Function from an Array**
	operations[2] (10, 5);
		since [2] == MULTIPLY, which returns the address to the Multiply function, the array takes in values (10, 5), and returns **42**  
5. **Menu Choices vs Array Indices** 
	![[Pasted image 20261115212853.png]]
6. **The Three Ways to Select an Operation:**
	1. *Function-pointer array* 
		**double** result = operations[opIndex -1] (value1, value2);
	2. *Using if / else if* 
		![[Pasted image 20261115213209.png]]
	3. *Using* [switch] 
		![[Pasted image 20261115213251.png]]
7. **Checking User Input** 
	- valid menu options are between [1 and 4] - check for index outside 
	- check for division by zero before calling [Divide] 
___
## 5. Simplifying Function Pointers with using 
1. **Why Use** [using] **?**
	writing *function pointer* syntax can get a bit convoluted:
		*bool* ( * myPtr)(int, int) = Ascending; 
	as an alternative, you can write a *type alias* for this entire chunk: 
		[*bool* ( * myPtr)(int, int)]
	a *type alias* is an alternative name for **an existing data type** 
		*using* Comparison = *bool* ( * myPtr)(int, int);
		Comparison myPtr = Ascending
	now, Comparison stands for a pointer to function that takes **two integers** and returns **bool** - can be reassigned to any compatible function 
		void SortStuff(vector< int>& numbers, bool ( * compare)(int, int)); 
		becomes -> 
		[void SortStuff(vector< int>& numbers, Comparison compare)]
2. **Arrays of Function Pointers** 
	since we've set a *type alias* Comparison for different function pointers, we can now **set an array** to hold various *function pointers*:
		Comparison funcs[3];
		funcs[0] = Ascending; 
		funcs[1] = Descending;
		funcs[2] = nullptr;
	index[2] means the pointer doesn't **refer to a function, but refers to nullptr instead**; as such, check to see if the index **calls a null function pointer** 
		if (funcs[2] != nullptr) {
			funcs[2](10, 5);
			}
3. **Vectors of Function Pointers** 
	the vector stores functions the same way it stores other values, except its elements are *function pointers:* 
		vector< Comparison > comparers;
		comparers.push_back(Ascending)
		comparers.push_back(Descending)
		cout << comparers[1] (10, 5) << endl; 
4. **Maps of Function Pointers** 
	the *key* chooses a *function address*; the final parentheses call that function:
		map< string, Comparison> operations; 
		operations["Ascending"] = Ascending;
		operations["Descending"] = Descending;
		cout << operations["Ascending"] (10, 5) << endl; 
5. **Readability**
	for reference, here is before *type alias* : 
		bool (* funcs[3]) (int, int);
		vector< bool (* )(int, int)> comparers;
		map< string, bool (* )(int, int)> operations;
	turns into:
		Comparison funcs[3];
		vector< Comparison> comparers;
		map< string, Comparison> operations;
_____
## Templates as an Alternative 
1. **Using templates instead of a pointer type** 
	a *function template* can **accept a comparison**
	