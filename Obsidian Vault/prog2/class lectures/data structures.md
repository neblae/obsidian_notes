1. #WhyDataStructuresMatter
	 data structures organize data in a way programs can easily access and modify them whenever they need. 
	 different structures are useful for different causes, of which depends on tradeoffs in speed, memory use, and flexibility
	 **types:**
		 |data structure | useful problem | how its data is organized |
		 | arrays | fixed number of readings | contiguous elements accessed by index |
		 | vectors | fixed number of readings | contiguous elements accessed by index |
		 | stack | undoing the most recent action | LIFO |
		 | queue | process requests in arrival order | FIFO|
		 | map | find student score by ID | associate key with a value
	before determining which structure is best for each case, you should ask yourself these questions:
		1. is the number of elements fixed or can they change?
		2. will the program access data by position, key, or order?
		3. which operations happen most often?
		4. how much time and memory can those operations use?
	**some functions to note:**
	
		- queue<string> arrivalOrder;
			- arrivalOrder.push(); -> pushes argument onto queue 
		- stack<string> moreRecentFirst;
			- moreRecentFirst.push(); -> pushes argument onto stack
		- while (!arrivalOrder.empty()) {
			  cout << arrivalOrder.front() << endl;
			  }



 

     

  

 before determining which structure is best for each case, you should ask yourself these questions:

     is the number of elements fixed or can they change?

     will the program access data by position, key, or order?

     which operations happen most often?

     how much time and memory can those operations use?

  

 some functions to note:

queue<string> arrivalOrder;

stack<string> moreRecentFirst;

  

arrivalOrder.push();  pushes argument onto queue

moreRecentFirst.push();  pushes argument onto stack

  

while (!arrivalOrder.empty()); empty returns a bool value dependent on if there are values in the queue, assuming a false will return when there are values in queue, so while (!(not)false) or not empty

{

    cout << arrivalOrder.front() << endl;  printing whatever is at the front of the queue, which will be the first value you put into the queue (FIFO)

    arrivalOrder.pop();  again, pop seems to work on the front of the queue, which is the end of the queue, which is the first value put into the queue (FIFO)

}

  

while (!mostRecentFirst.empty())  same thing

{

    cout << mostRecentFirst.top() << endl;  interesting the different between the functions that return the "out" of each data structure; for stacks it is the top value (LIFO)

    mostRecentFirst.pop();  same thing

}