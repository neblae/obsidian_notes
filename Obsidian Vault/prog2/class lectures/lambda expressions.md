## Creating and Calling Lambda Expressions 
a *lambda expression* is a shorter way for writing a **function object** 
- useful when used as a **one off operation**, written **inline** wherever needed 
- the compiler makes a *function-object type* for each lambda expression
**Characteristics**
	- [short and anonymous]: small operation without its **own function name**
	- [inline]: written wherever needed 
	- [callable]: takes parameters and returns a value like normal functions
	- [captures local variables]:  by using a *capture clause*, lambdas can use values from the **surrounding scope**  
	- [optional return type]: compiler usually knows what the return type will be so you **don't need to write it** 
```
[]() { <- [] captures no local variables, () recieves no arguments 
cout << "Checking scores\n" <- lambda body 
}(); () calls the lambda immediately, ; ends the statement 
```
![[Pasted image 20261117011544.png]]
___
## Customizing Lambdas with Capture Clauses
*capture clauses* (written inside []) is how lambdas **access local variables** from its scope 
- **Capture methods:**
	- `[]` - no captures
	- `[=]` - by value; stores copies when lambda is created
	- `[&]` - by reference; uses the original variables
	- `[=, &checks]` - by value by default, with [checks] specifically by reference 
- Example (pass by value):
	```
	int main() {
		int threshold = 70;
		int checks = 0;
		
		auto byValue = [=](int score){
			return score >= threshold <- uses a saved copy of the threshold value
		};
	}
	```
this is an example of **pass by value** , where the *parameter* `score` is being passed in every time its called; `treshold` and `checks` are *captured variables* taken from the `main`
	- notice how it is structured like a *class*, except it is instantiated within main itself 
[what if you wanted to change the threshold?]
 - Example (pass by reference):
 ```
 int main() {
		int threshold = 70;
		int checks = 0;
		
		auto byValue = [&](int score){
		threshold = 85; <- only through reference can you change the threshold!
			return score >= threshold
		};
	}
 ```
 - **Mixed-capture syntax**
 `[=, &checks](int score)` 
	- `=` sets the **default** to use local variables **by value**
	- the comma separates the **default** from a specific capture 
	- `&checks` captures `checks` by reference 
	- `int score` is a parameter supplied when the **lambda is called** 
