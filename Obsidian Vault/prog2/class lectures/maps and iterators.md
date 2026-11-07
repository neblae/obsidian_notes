1. #IntroductiontoMaps
	1. **What is a map?** 
		a *map* stores **key to value pairs:**  
		- a *key* identifies an entry
		- a *value* is the data associated with the *key*
		each *key* is inside of the [map] is **unique** ; they are also automatically maintained in **sorted order** 
		- maps sort their keys in **ascending order** using a < operator
	2. **How to make a map?**
		1. include [map]
		2. declare a *map* variable
			- map<"KeyType, ValueType> variableName; 
			- **int, short, char, and string** work well as a [KeyType]
			- **floats and doubles** also work, but can have issues
			- user-defined classes can work if it has **suitable ordering**
			- ex. [map<int, string> heroes;] 
	3. **Maps vs Vectors** 
		![[Pasted image 20261107123945.png|455]]
			- useful when you are storing data values in a very particular way 
	4. **Two Ways to Insert** 
		1. [courses.emplace("COP3503", "Programming Fundamentals 2");]
			emplace() inserts if the key doesn't exist 
		2. [courses["COP3502"] = "Programming Fundamentals 1"]
			[] can either insert a missing key, or change the value of an existing key 
	5. **Two Ways to Retrieve**
		1. [courses["COP3503"];] the missing key creates an entry 
