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
		}


