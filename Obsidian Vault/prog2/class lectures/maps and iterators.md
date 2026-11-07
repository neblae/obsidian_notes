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
	4. **Two Ways to Insert values into a map** 
		1. [courses.emplace("COP3503", "Programming Fundamentals 2");]
			emplace() inserts if it doesn't already exist 
		2. [courses["COP3502"] = "Programming Fundamentals 1"]
			[] can either insert a missing key, or change the value of an existing key 
	5. **Two Ways to Retrieve/Return values from a map**
		1. [courses["COP3503"];] makes a new entry if the key doesn't exist 
		2. [courses.at("COP3503");] if there is no existing key, [.at()] throws an out_of_range 
___
2. #AddingandModifyingMapElements
	1. **Insert with emplace()**
		maps **cannot** have **duplicates** of *keys*:
		two cases:
			1. if the inserted *key* doesn't exist:
				[emplace()] inserts into map
			2. if the inserted *key* already exists: 
				the [emplace()] call is completely **ignored** - it doesn't overwrite the old value or produce an error
	2. **Insert or Update with []**
		