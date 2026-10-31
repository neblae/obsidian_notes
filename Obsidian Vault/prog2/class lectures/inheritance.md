1. #WhatisInheritance?
	1. Inheritance: One of the three pillars of *Object Oriented Programming (OOP)*
		**Encapsulation** - Groups data and functions into objects
		**Inheritance** - Builds new classes that reuse functionality from existing classes
		**Polymorphism** - Uses a common interface for different types of objects 
		one way to think of these pillars is how a [Hero] and an [Enemy] can both share functions of a [Character]
	2. Base and Derived Classes:
		The **Base (or parent)** class is the class that **provides the shared functionality** 
			would be the [Character] class
		The **Derived (or child)** class is the class that **receives shared functionality** 
			would be the [Hero] or [Enemy] class
	3. **Inheritance Syntax and IS-A**
		class Hero : public Character {
			your hero-specific members will go here!
		} ;
____
2. #Inheritance/CodeResuse 
	1. **Why Share Code?**
		If you have two classes that share member variables (like [Hero] and [Enemy]), using common base class avoids duplicate implementations
	2. **Shared Base, Different Derived Classes**
		![[Pasted image 20261030121249.png|397]]
	3. **Each Object Keeps its Own State:** 
		a function like TakeDamage(); functions on the same health member variable shared between different classes since they are inherited from the *same parent*
____
3. #AccessSpecifiersinInheritance
	1. **Three Access Specifiers:**
		- whereas i'm used to using **public** or **private** in classes, there is also [protected], which lets derived classes use a member without **making it publicly accessible** 
		![[Pasted image 20261030121832.png|451]]
	2. **Applying the Rules**
		- If you have a [Character] with a **private** [Name] and **protected** [health], a derived [Hero] class can modify health **directly**, but has to use **GetName() to read [name]**  
		![[Pasted image 20261030122044.png|408]]
	3. **Public Inheritance**
		in the case of [ class Hero : public Character]:
		- public members stay public 
		- protected members stay protected
		- private members stay inaccessible directly in Hero
___
4. #InheritanceHeirarchies
	 1. **Multilevel Inheritance** 
		you can derive a new class from another already derived class
		- this new class will be the *derived* class, and the previously derived class will be *both a parent and a child class* 
	2. **IS-A Across the Hierarchy**
		you can have branching across a hierarchy tree:
		![[Pasted image 20261030122507.png|456]]
			IS-A is just a way to say a class **is a** subclass of another:
			dragon, a subclass of Enemy, is a type of superclass (character)
___
5. #ContainmentvsInheritance
	1. **Inheritance Means IS-A**
		for class Hero : public Character {};
			hero IS A character, so it can use Character functionality
	2. **Containment Means HAS-A** 
		for class Hero : public Character {
		public:
			Weapon weapon; 
		};
		- the [Hero] **HAS A** [Weapon]; containment just means the object created is stored as a member of [Hero], and it doesn't turn the owner of the member into that type 
	3. **Using a Contained Object:**
		player.weapon.Attack(); -> this is direct access to public member
		player.UseWeapon(); -> this is accessed through the [Hero] function 
___
6. #PrivateandProtected 
	1. **Three Different Types of Inheritance Rules**
		![[Pasted image 20261030211909.png|373]]
		- protected becomes a good mix of both member types
	2. **Private Inheritance** 
		![[Pasted image 20261030212021.png]]
		- this means you can't print out Hero.PrintHealth(); yourself, you can only use Hero.ShowStatus(); Character.PrintHealth(); however does work 
	3. **Protected Inheritance** 
		![[Pasted image 20261030212856.png]]
		- Enemy (a different derived class) is a **protected** class of parent Character; it can call PrintHealth() on itself, but classes derived from Enemy **cannot** (like monster)
____
7. #Constructors/Inheritance 
	1. **A Derived Object has a Base Part**
	   a **base part** is the information a derived class (Hero) got from its parent class (Character)
		- you must execute the base-class constructor (Character) [before] the derived class (Hero)
			- Character constructor -> Hero constructor 
	2. **Constructor Initializer lists**
	   ![[Pasted image 20261030215245.png|456]]
			int g is unique to the hero
	3. **Why do we need it?**
		Character(string n, int h) needs arguments to exist, and has no default constructor. 
		- compiler will try to use a nonexistent Character() 
		- if the base class has its own default constructor, **you do not need to add it**
	4. **Initializer Lists for Members**
		similar to the character initializer, you can initialize the parents members in the declaration of the derived class
		![[Pasted image 20261030234041.png|466]]
___
8. #MultpleInheritance/theDiamondProblem
	1. **Multiple Inheritance:**
		- a class can inherit information from different bases/parents 
			 class FlyingCar : public Car, public Airplane {};
		- the FlyingCar has driving functionality of both [Car] and [Airplane]
	2. **The Diamond Problem: Why is it Ambiguous?**
		- if you remove [virtual]
			class Car : public Vehicle {}; 
			class Airplane : public Vehicle {}; 
			FlyingCar : public Car, public Airplane {};
		![[Pasted image 20261030234911.png|413]]
		- FlyingCar inherits [Vehicle] twice, since [Car] and [Airplane] are Vehicles
		**The compiler doesn't know which vehicle path to use!**
	3. **How to fix this?**
		class Car : [virtual] Vehicle {}; 
		class Airplane : [virtual] public Vehicle {}; 
		FlyingCar : public Car, [virtual] Airplane {};
		- both intermediate clsses share only one vehicle bae 
	4. **Private and Protected Attributes**
		![[Pasted image 20261030235149.png|402]]
	5. **Parameterized Constructors and Order** 
		what do you do when you have multiple inherited classes, and they all have multiple **unique variables** that need to be input?
		- in what order do you input the arguments?
		FlyingCar(string n, int count, int wheels, int wings) 
		: Vehicle(n, count), Car(n, count, wheels), Airplane(n, count, wings) { 
			}
		- now, you input arguments from vehicle -> car -> airplane -> flyingcar 