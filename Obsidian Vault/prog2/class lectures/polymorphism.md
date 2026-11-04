1. #IntrotoPolymorphism
	1. **One interface, different behaviors**
		*polymorphism* : allows **one function** to be used by **different class types** 
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
		- a base-class pointer can point to its own type or any **publicly derived type**
		- if you have Person->Student->GradStudent:
			|Pointer type|Person object|Student object|GradStudent object|
				|---|---|---|---|
				|`Person*`|Yes|Yes|Yes|
				|`Student*`|No|Yes|Yes|
				|`GradStudent*`|No|No|Yes|
		- [Person* p = &student;] is called **automatic upcasting** - the person pointer can access members defined in the base Person class (but can't access members from Student)
	2. **Upcasting Pointers vs Copying Objects**
		