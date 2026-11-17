## Text Files and Binary Files
- **Two Types of Files:**
	- [text files] 
		- stores info as **encoded characters** (chars, ints, floats etc)
		- converts numeric values into **character representations**
			- 42 is a **character representation** - the program converts the separate characters '4' and '2' from ASCII format
			- 4 -> 52 -> 34 -> 00110100
			- character -> ASCII -> hexadecimal byte -> binary byte
		- usually human readable
	- [binary files] 
		- stores info using a **defined sequence of raw bytes**
		- holds numeric values in *byte representation* **directly** 
		- not human readable 
___
## Opening and Closing Binary Files
- the `<fstream>` header includes three **file stream** classes:
	- [ofstream] - writes to a file
	- [ifstream] - reads from a file 
	- [fstream] - read write or both
- **opening a binary file:**
	`ofstream output("score.bin", ios_base::binary);` 
		- where arg1 is the filename, arg2 is the opening mode 
		- you can combine opening modes with `|` 
- **check and close** 
	``` 
	if (!output.is_open()) {
		cout << "Could not open score.bin. \n";
		return 1;
	}
	output.close();
	```
	you need this incase the input file is missing or maybe the filepath is incorrect 
___
## Writing Binary Files with write() 
1. **writing with** `write()` 
	- [write()] copies a variables **actual bytes**, while [<<] just produces **formatted text** 
	 `output.write(reinterpret_cast<char*>(&score), sizeof(score));` 
		 - where arg1 is where the data **begins in memory**, and arg2 is **how many** bytes to write 
	 - [char*] can access memory a byte at a time, so [write()] can use `const char*` to access data as a sequence of bytes 
	 - *casts* are instructions to treat a value as a different type:
		 - `static_casts` support value/type conversions
		 - `reinterpret_cast` reinterprets pointer conversions 
		 - `const_cast` adds or removes const/volatile qualification
		 - `dynamic_cast` runtime checked conversions in suitable polymorphic hierarchies (idk what this means)
____
## Reading Binary Files with read()
use `read()` to restore bytes written using `write()` 
	- >> interprets formatted text
	- get() reads character data 
- **reading different types**:
	  if reading a `char` , you can use the reference **directly**
		  `input.read(&marker, sizeof(marker));`
	  for **any other type**, cast the address to a writeable [char*]
		`input.read(reinterpret_cast<char*>(&passed), sizeof(passed));` 
- **order matters!**
	- since binary files don't **label its values**, the function must match **type, size, order, and compatible byte representation** 
___
## Binary File Layout and Byte Offsets 
- **what is a byte offset?**
	- a position at in the file, **starting at 0** 
	- every time [write()] iterates, it stores its bytes immediately after the previous value 
	lets say a file has `marker` at offset 0, and `level` at offsets 1-2. if you want to skip those two variables:
		`int scoreOffset = sizeof(marker) + sizeof(level)` 