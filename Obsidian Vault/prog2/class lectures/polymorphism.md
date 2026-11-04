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
		- in the same way, sometimes downcasting cannot logically/automatically work
____
3. #Base-ClassPointers/DynamicMemory/Vectors
	1. **Why use just one vector for a family of classes?**
		whereas you could separate [vector[limousine]], [vector[SUV]] for different derivatives objects of a base class, you can instead just store **all class pointers to one vector:** [vector{Car*}]
		![[Pasted image 20261103205929.png|325]]
		- this is especially important, since doing so allows you to **loop through only one vector to access all objects**
	2. **Dynamic Allocation and Upcasting**
		- [new Limousine] allocates a derived object and returns its pointer; push_back stores the pointer as [Car*] **through automatic upcasting** 
	3. **Using One Loop for Every Vehicle**
		if [Drive()] is an **inherited function among all derived classes**, then using [allOurCars[i]->Drive()] calls the inherited function
		- all projects will print the **same message** since Drive() isn't virtual nor specialized 
		- [allOurCars.push_back(new Car);]
		- [allOurCars[i]->Drive();]
	4. **Cleaning Up Dynamic Objects** 
		- each [new] must have a matching [delete]
		- making the [~Car()] destructor **virtual** allows you delete all derived objects through Car*
_____
3. #VirtualvsNonVirtual_Functions/Overriding
	1. **Same Function, Different Calculation**
		[Car::GetValue()] returns a **mileage** based value, while [Pickup::GetValue()] adds the **bed and towing values** 
		- both are accessed through [Car*]
	2. **Virtual vs Non-Virtual**
		![[Pasted image 20261103212823.png|373]]
	3. **override Helps Catch Mistakes**
		[override] makes sure that the function actually **changes the virtual base function** 
	4. **One Loop for Many Types**
		![[Pasted image 20261103213237.png|370]]
___
5. #OverridingVirtualFunctions
	1. **One Call, Three Results**
		you can have different derived classes can use a **base function** in its own way
		- ie. [TakeDamage(25)] function will work differently between a [Character], a [Knight], and a [Wizard]
	2. **Base-Class Implementation**
		when you have a function that changes the **private member variables** of the *base* class, you must **reuse the implementation in derived classes instead of accessing it directly** 
		- ie. [Character::TakeDamage()] subtracts from [hitpoints], which is a private variable
	3. **Specialized Behavior**
		- [ArmoredKnight] subtracts [armor] from incoming damage, clamps to zero
		- [Wizard] uses one-use barrier to set the first incoming damage to zero
			Each then calls [Character::TakeDamage(amount)]
	4. **Explicitly Call the Base Version of the Function** 
		notice how I have been using the **scope resolution operator ::** to call TakeDamage():
			this is because calling [TakeDamage(amount)] from inside the override would call itself recursively
			![[Pasted image 20261103215508.png|447]]
___
6. #VirtualDestructors/DestructionOrder
	1. **Why Virtual Destructors Matter** 
		[Character* hero = new Wizard;] makes a derived object, storing its address in a **base class pointer**; thus, [delete hero] must destroy the **entire wizard allocation** 
		- if a class is deleted through its **base pointer** , and the base pointer **is non-virtual,** then the behavior is *undefined* 
	2. **Correct Construction and Destruction Order** 
		you must run destructors of *derived* classes **before** destroying the *base* class 
	3. **Making the Base Destructor Virtual**
		[virtual ~Character() { }]
		- making the base destructor virtual means **every derived class is also virtual** 
____
7. #AbstractBaseClasses/PureVirtualFunctions
	1. **What is an Abstract Base Class** 
		*abstract base class (ABC)* - a class designed solely to be inherited by others
		- can't be **instantiated on its own** 
		- a class is abstract if it has **at least one pure virtual function** 
	2. **Pure Virtual Functions** 
		what makes a function **pure virtual?** 
		- [virtual void Introduce() = 0;] 
		the [ = 0] makes a function pure virtual; **any concrete derived class has to implement it** 
	3. **Shared and Required Behavior**
		![[Pasted image 20261104131843.png|396]]
		- whereas [PrintName()] has a body and is inherited as it, [Introduce()] **needs to be implemented** for each derived class 
		- ![[Pasted image 20261104132037.png|364]]
______
8. #AbstractClassesinPractice/PureVirtualDestructors
	1. **One interface for Different Button Shapes**
		imagine you have an abstract [UIButton] class, where you can have different looking UIButtons that carry the same function;
		- both derived classes must answer: **was this button clicked?** if so, they both deal with it differently
	2. **Rectangle: Check X and Y Boundaries** 
		![[Pasted image 20261104132353.png|433]]
	3. **Circle: Check Distance from Center** 
		use [distance = sqrt(pow(clickX - xPos, 2) + pow(clickY - yPos, 2))] to calculate if the **distance is <= radius**
	4. **Pure Virtual Destructor: The Exception** 
		imagine your *ABC* declares **two pure virtual functions**: 
		- [virtual bool WasClicked(int clickX, int ClickY) = 0;]
		- [virtual ~UIButton() = 0;]
		unlike the normal pure virtual function, the *pure virtual destructor* has to **have its own definition**, since it **always runs when derived objects are destroyed** 
		- [UIButton::~UIButton() { cout << "UIButton cleaned up.\n"; }]
		the *pure virtual destructor* stays **virtual**, and makes the base class **abstract** 
		- remember that derived destructors will run before the UIButton destructor 