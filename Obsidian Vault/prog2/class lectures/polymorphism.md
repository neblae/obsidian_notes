1. #IntrotoPolymorphism
	1. **One interface, different behaviors**
		polymorphism : allows different types to be used by the **same function call** in different ways
		- one of the three pillars of OOP
	2. **Character Hierachy** 
		imagine you have 3 classes, one base class, [Character] and two classes derived from the base, [Warrior] and [Wizard]
			both have attacks - instead of testing which kind of attack to use with an if statement, you can just **call attack() on a Character***
	3. **Two Ingredients**
		- **base-class pointer:** [Character* first = &warrior;] can point to an object from a derived class 
		- **virtual function:** [virtual void Attack()] allows the implementation of the Attack() function to vary based off of which class it is being called on
			- use [override] on a derived virtual function to make sure the compiler knows the difference  
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
		