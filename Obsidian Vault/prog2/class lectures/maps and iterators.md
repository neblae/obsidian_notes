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
		same concept, maps can't have duplicates so:
		two cases:
		1. if the *key* doesn't exist:
			[] **inserts** the pair 
		2. if the *key* exists:
			[] **updates** the pair with a new *value* 
	3. **modify with at()**
		[at()] returns a reference to an **existing** *value* 
		- how is it different from just using []? [at()] throws an **out of range for a missing key** 
	4. **Comparison** 
		![[Pasted image 20261107151131.png]]
____
3. #AccessingMapElementsbyKey
	1. **Important: Keys are NOT Positions**
		in a *vector*, [numbers[0]] refers the **first** element (index), whereas in a *map*, [heroes[22]] refers to the *key* [22], not element **number** 22.
	2. **Missing Keys with []** 
		[cout << heroes[0] << endl;]
		- if key [0] doesn't exist, the map will make a **new pair**; this **pair** will be initiated with an **empty string value**, increasing the size of the map
	3. **Missing Keys with at()** 
		[cout << heroes.at(100) << endl;] 
		- if key [100] doesn't exist, [at()] throws an **out_of_range** exception, without adding a new pair 
	4. **Negative Integer Keys**
		[heroes[-28] = "Mystery Hero";]
		- this is fine since its a *key* and not an *index* 
	5. **Why [size() - 1] isn't the Last Key**
		[heroes[heroes.size() - 1];]
			map size is the **number of pairs** (as opposed to an index in a vector), so this wouldn't give the last key; maps are **non-contiguous** 
___
4. #IntroductiontoIteratorsAcrossContainers
	1. **Why Iterators?**
		- index loops don't work for maps, so *iterators* are used to visit elements **without knowing their indices or keys** 
	2. **An Iterator Is Similar to a Pointer in a vector**
		![[Pasted image 20261107165659.png|412]]
	3. **Declaring an Iterator** 
		each *iterator* has its own **name**:
			numberIter, wordIter, mapIter, ageIter, etc. 
		each *iterator* will be defined by its *type* (ContainerType) that tells the iterator what it will be storing 
		[ContainerType::iterator variableName;]
		![[Pasted image 20261107190823.png|446]]
	4. **Same General Loop, Different Element Access** 
		[ for (iter = container.begin(); iter != container.end(); ++iter)] 
			// work with current element 