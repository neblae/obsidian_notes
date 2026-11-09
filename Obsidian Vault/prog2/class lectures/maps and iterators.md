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
			// code to work on the element 
		![[Pasted image 20261107191956.png|460]]
	5. **Difference Between Containers**
	- **vectors**: position based
		- [10] [20] [30] 
	- **maps:** sorted by key 
		- [Alex] -> 85, [Jordan] -> 90 
	- **useful functions:** all three support [begin()], [end()], [++iter], and dereferencing
___
5. #IteratorTraversalandOperators
	1. **begin() and end()** 
		- [begin()] points to the **first** element
		- [end()] is an **iterator** located **one past the last element** 
			- **never deference [end()]** 
	2. **Standard Iterator Loop**
		[for (iter = numbers.begin(); iter != numberss.end(); ++iter) {
			[cout << * iter << endl;]
		- * iter reads the current element being incremented 
	3. **Move Forward and Back** 
		![[Pasted image 20261108163134.png|431]]
	4. **Vector Iterator Arithmetic** 
		![[Pasted image 20261108163157.png|452]]
	5. **Last Element of a Vector** 
		since [end()] is an iterator after the last element, you need a better way to acces the **true last element** 
			[* (numbers.end() - 1)]
			if you have a **nonempty vector**, you can use this to access the final element 
	6. **Operators don't work the same for every container:** 
	![[Pasted image 20261108163427.png|501]]
____
6. #AccessingandModifyingElementswithIterators 
	1. **Dereferencing an Iterator** 
		[* iter] -> the * operator actually **accesses the element at the current iterator position** 
	2. **Reading Values** 
		[cout << * iter << endl;] -> [cout << * iter + 3 << endl;] 
		- if * iter returns the value [5], then the **expressions will print 5 and 8** 
	3. **Modifying Values** 
		- dereferencing a modifiable vector iterator ( * iter) will return a **reference to its element**
	4. **Important Difference: [++iter] vs. [( * iter)++]** 
		[++iter] -> will move the iterator to next element 
		[(* iter)++] -> increments the current integer element 
	5. **Iterators to Class Objects** 
		- If you have a container with [Hero] objects, to access the name at the element of the *iterator* : 
			[(* iter).GetName();]
			[iter->GetName();]
			both do the same thing; -> is just easier to use 
___
7. #IteratingThroughMaps
	1. **Map Iterators Visit Pairs** 
		whereas a *vector(int)* iterator refers to a specific element, a *map* iterator refers the **entire key-value pair** (you can access both at the same time)
	2. **Key and Value Access** 
		[iter->first;] accesses the *key* of the pair (or [(* iter).first;] )
		[iter->second;] accesses the *value* of the pair (or [(* iter).second;])
	3. **Loop Across a Map** 
		![[Pasted image 20261108230858.png|524]]
	4. **Map Iteration is Sorted by Key** 
		when sorted, only the *keys* are **sorted** - it doesn't matter what the values are
		- Insertion (when you first add the values into map) 
			22, 19, 30, 17
		- Iteration (after added into the map)
			17, 19, 22, 30
	5. **Values Can Change, Key Cannot**
	![[Pasted image 20261108232014.png]]
___
8. #SearchingMapwithfind 
	1. **You must first check the key's existence: Why?**
		[cout << studentScores["Morgan"] << end;]
		- if the *key* is **missing**, then [] will make a new pair with the **default integer value 0** 
		- if you **don't want the map to be modified,** use [find()] 
	2. [find()] **returns an iterator** 
		[studentScores.find("Taylor")] returns an iterator to the matching pair (if the key exists) 
	3. **Test for an Existing Key** 
	![[Pasted image 20261108232854.png]]
	4. **Test for a Missing Key** 
	![[Pasted image 20261108232916.png]]
	5. **Retrieve a Found Pair Through Its Iterator** 
	![[Pasted image 20261108233311.png]]