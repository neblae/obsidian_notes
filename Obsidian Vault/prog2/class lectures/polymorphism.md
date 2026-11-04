1. #IntrotoPolymorphism
	1. **One interface, different behaviors**
		*polymorphism* : allowing **one function** to be used by **different class types** 
		- one of the three pillars of OOP (encapsulation, inheritance, polymorphism)
	2. **Character Hierarchy** 
		imagine you have 3 classes: one **base** class, [Character] and two classes **derived** from the base, [Warrior] and [Wizard]
			both have **attacks** - instead of testing which kind of attack to use with an if statement, you can just **call attack() on a Character* pointer***
	3. **Two Ingredients**
		- *base-class pointer*: [Character* first = &warrior;] points to a **derived object**
			- since you make a pointer to the derived object, to call the function, you 
		- *virtual function:* [virtual void Attack()] allows the implementation of the Attack() function to **vary** based off of **which class it is being called on**
			- use [override] on a **derived virtual function** to make sure the compiler knows the difference  
		*if base-class pointers and virtual functions aren't used, the compiler will have no idea what the modified functions will do, and instead just use the base class function*
____
2. #Base-ClassPointers/Upcasting/ObjectSliceing 
	1. **Upcasting: From Derived to Base**
		a *base-class pointer* can point to its **own type** or any **publicly derived type**
		- if you have Person(base)->Student->GradStudent:
			|Pointer type|Person object|Student object|GradStudent object|
				|---|---|---|---|
				|`Person*`|Yes|Yes|Yes|
				|`Student*`|No|Yes|Yes|
				|`GradStudent*`|No|No|Yes|
		- [Person* p = &student;] is called **automatic upcasting** - pointing to the base class gives you access to all members, including its derived class members
	2. **Why Upcast Pointers and not just Copy Objects?**
		when copying a *derived class* by **value** into its *base class*, you can run into the issue of **losing data from the derived class**:
		![[Pasted image 20261103202141.png|476]]
		- the solution is to use the **upcast pointer** [i.e., Person*], which does not slice data, as it **refers to the full object**
	3. **Downcasting Isn't Automatic** 
		*downcasting:* a base class pointing to a **derived** class [Student* s = &Person]
		- downcasting can be risky; think about a square and a rectangle:
			a **square** can be a **rectangle**, but a rectangle **cannot be a square** 
		- in the same way, sometimes downcasting cannot logically/automaticcaly work