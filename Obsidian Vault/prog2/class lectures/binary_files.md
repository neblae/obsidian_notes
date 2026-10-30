1. #TextFilesandBinaryFiles
	- Why are files useful? 
		- since programs store information in variables why they run, relying on them can have some issues:
			1. **repetitive input:** entering large amounts of information manually whenever a program is initialized is very inefficient and inconvenient
			2. **hardcoded data:** directly writing information into source code makes a less flexible and less generically applicable program, since changing the data may need a lot more manual labor 
			3. **temporary storage:** information stored in normal program variables is lost when the program ends 
	- Two Types of Files:
		- Text Files | Binary Files
		| Stores information as characters                       | Stores information using raw bytes      | Usually human readable                                 | May not be readable                                 |
		| Converts numeric values into character representations | Can preserve the numeric value's in memory directly |
		| Example: scores.txt                                    | Example: scores.bin                                 |
	- Text Files: Numbers Saved as Characters
		A text file represents information using characters. Although each character is encoded as binary values, integers like 42 must also be decoded into binary.

| File position | Character | ASCII | Hexadecimal | Binary   |
| ------------- | --------- | ----- | ----------- | -------- |
| Byte 0        | '4'       | 52    | 34          | 00110100 |
| Byte 1        | '2'       | 50    | 32          | 00110010 |

------------------------------------------------------------------------
2. #Opening_and_closing_binary_files
	 The <*fstream*> header:
		including *fstream* to your progream gives you access to three file stream classes:
			ofstream - write to a file
				creates a missing file, replaces existing contents
			ifstream - read from a file
				needs an existing file
			fstream - read, write, or both
				also needs an existing file if opened with in | out
		works with both text and binary files 
	Opening a Binary File 
		ofstream output("score.bin", ios_base::binary);
			where arg1 is filename, arg2 is opening mode
		Modes | Purpose
			| ios_base::in     | read              |
			| ios_base::out    | write             |
			| ios_base::binary | binary mode       |
			| ios_base::app    | append to the end |
		you can also combine different modes with "|"
			ex. "fstream file("score.bin", ios_base::in | ios_base::out | ios_base::binary);"
	Check and Close:
		if (!output.is_open()) {
			cout << "Could not open score.bin.\n";
			return 1;
		}
		output.close();
		**Why opening may fail:** a missing input file, incorrect path, inaccessible permissions, nonexistent destination directory, or an operating-system restriction. A missing output filename alone does not normally cause failure: `ofstream` creates it.
		**Syntax Breakdown**
			Syntax || Meaning
				| *# include <*fstream*>*                    | Makes file stream classes available   |	| ofstream output(...)                       | creates an output stream named output |
				| "score.bin"                                | filename                              |
				| ios_base::binary                           | binary opening mode                   |
				| ios_base::in, ios_base::out, ios_base::app | input, output, append flags    |
				| ''                                         | combines opening flags                |
				| output.is_open()                           | whether the stream has an open file   |
				| !                                          | negates the condition                 |
				| output.close()                             | closes the file                       |
				| return 1                                   | ends main() with nonzero result       |
_______
3. #WritingBinaryFileswithwrite():
	**using write():**
		you can use write() to copy a variables actual bytes;
		in comparison, << only produces formatted text, even when a stream is opened in binary mode
		"output.write(reinterpret_cast<char*>(&score), sizeof(score));"
			arg1 is the address, where the data begins in memory
			arg2 is the byte count, which is how many bytes the function needs to write
	**why do we need char*?:**
		write() needs a const char* to access data as a sequence of bytes
		C++ guarantees that sizeof(char) == 1, so while char* accesses memory one byte at at time, int* points at an integer which can occupy several bytes
		**since &score is an int*, which can't be directly passed to write(), cast it to the required character-pointer type:**
			output.write(reinterpret_cast<char*>(&score), sizeof(score));
		this is because (char*)&score does not specify what the argument will be converted to, while reinterpret_cast *explicitly signals a low level reinterpretation* 
		The four c++ named casts:
			static cast:
				supported value/type conversions
					static_cast<*int*>(3.7) = 3
			reinterpret_cast
				low-level reinterpretation (*bytes stay the same, compiler reads a different type*), usually pointer conversions
					reinterpret_cast<char*>(&score)
			const_cast:
				adds or removes const/volatile qualification
				*note: volatile means that the value can change on its own, so the compiler will always reread it; opposite of const*
					const_cast<int*>(ptr)
			dynamic_cast:
				safely casts a base pointer down to a derived type by checking the object's real type at runtime. returns nullptr if the guess is wrong, and the base class needs a virtual function 
					dynamic_cast<Derived*>(basePtr) 
	**writing different fundamental types**
		a char doesn't need a cast since &marker already is type char*:
			output.write(&marker, sizeof(marker));
		**Type** | **Binary writing**
		_bool_ - output.write(reinterpret_cast<char*>(&passed), sizeof(passed));
		_short_ - output.write(reinterpret_cast<char*>(&level), sizeof(level));
		_int_ - output.write(reinterpret_cast<char*>(&score), sizeof(score));
		_float_ - output.write(reinterpret_cast<char*>(&temperature), sizeof(temperature));
		_double_ - output.write(reinterpret_cast<char*>(&accuracy), sizeof(accuracy));
		-
		**Syntax | Meaning**
		output.write(...) | writes the specified raw bytes
		&variable | gets the variable's address
		reinterpret_cast<char*>(...) | converts the address to a byte access pointer
		sizeof(variable) | returns the variables size in bytes
		24.5f | the f suffix indicates a float
		98.75 | a floating-point literal without a suffix is double
		if (!output) | checks the streams failure state 
	**what does the file contain?**
		each write() continues one after the other with no automatic separators 
		File offsets | Variable | Type | Common Size
			| 0            | marker      | char   | 1           |
			| ------------ | ----------- | ------ | ----------- |
			| 1            | passed      | bool   | 1           |
			| 2-3          | level       | short  | 2           |
			| 4-7          | score       | int    | 4           |
			| 8-11         | temperature | float  | 4           |
			| 12-19        | accuracy    | double | 8           |
			|              | total       |        | 20 bytes    |
______
4. #ReadingBinaryFileswithRead
	**reading with read();**
		use read(); to restore the bytes written by write()
		>> interprets formatted text, get() reads character data
		![[Pasted image 20261026192133.png|415]]
	**reading different types** 
		use &marker for char directly; the rest must cast the address to a writable char*:
		|Type|Binary reading|
			|`char`|`input.read(&marker, sizeof(marker));`|
			|`bool`|`input.read(reinterpret_cast<char*>(&passed), sizeof(passed));`|
			|`short`|`input.read(reinterpret_cast<char*>(&level), sizeof(level));`|
			|`int`|`input.read(reinterpret_cast<char*>(&score), sizeof(score));`|
			|`float`|`input.read(reinterpret_cast<char*>(&temperature), sizeof(temperature));`|
			|`double`|`input.read(reinterpret_cast<char*>(&accuracy), sizeof(accuracy));`| 
		|Syntax|Meaning|
			|`ifstream input(...)`|Opens a file for input.|
			|`"../03/data.bin"`|Relative path to the file created in Activity 03.|
			|`input.read(...)`|Copies file bytes into destination memory.|
			|`&variable`|Destination’s address.|
			|`reinterpret_cast<char*>(...)`|Supplies a writable byte pointer.|
			|`sizeof(variable)`|Number of bytes to read.|
			|`'\0'`|Null character used to initialize the marker.|
			|`if (!input)`|Detects a failed/incomplete read.|
	**order matters**
		binary files don't automatically label values, which means the reader has to *match a type, size, order, and compatible byte representation*
		|Writer order|Reader order|
			|marker|marker|
			|passed|passed|
			|level|level|
			|score|score|
			|temperature|temperature|
			|accuracy|accuracy|
		every time read() iterates, it advances the file position:
			important: check **if (!input)** before using the restored values 
______
5. #BinaryFileLayoutandByteOffsets 
	**what is a byte offset?**
		a byte offset is a position in the file, starting at 0 (similar to index)
		each write() stores its bytes immediately after the previous value
			i.e 30, 31, 32, 33, ....,
	**file layout** 
		assuming common data type sizes:
		|Variable|Size|Byte offsets|
			|---|---|---|
			|`marker`|1 | 0|
			|`level`| 2 | 1–2 |
			|`score`| 4 | 3–6 |
			|`temperature`| 4 | 7–10 |
			|`accuracy`| 8 | 11–18 |
			|**Total** |**19 bytes**| |
	**calculating an offset** 
		you can add the sizes of every value written before the target:
			> int scoreOffset = sizeof(marker) + sizeof(level);
			> sizeof(marker) + sizeof(level) would be the amount of preceding values
			> accuracyOffset + sizeof(accuracy) would be the total file payload because accuracy is last 
______
6. #SavingandLoadingArraysandVectors
	**why save the count?**
		a binary file has no way to automatically count how many array elements are saved
		write the count first, and then the values 
			scores.bin 
			| count: 3 | 80 | 90 | 100 | 
			| 4 B | 4B | 4B | 4 B | 
			Total: 16 bytes (assuming four-byte int)
	**writing the array:**
	
		output.write(reinterpret_cast<char*>(&count),sizeof(count));                              output.write(reinterpret_cast<char*>(scores), count * sizeof(int)); 
		*one call*
	**reading into a dynamic array**
		first read the count, then allocate that many elements, and then read them:
		int* loadedScores = new int[loadedCount]; 
		input.read(reinterpret_cast<char*>(loadedScores), loadedCount * sizeof(int)); delete[] loadedScores;
	**reading into a vector** 
		1. read one value at a time and use push_back();
		2. this:
			vector<*int*> loadedVector; for (int i = 0; i < vectorCount; i++) { int value = 0; vectorInput.read(reinterpret_cast<char*>(&value), sizeof(value)); loadedVector.push_back(value); }
			>useful since the vector grows automatically AND manages its own memory
	**syntax breakdown**
		|Syntax|Meaning|
			|`reinterpret_cast<char*>(scores)`|Byte pointer to the first array element; no `&` needed here.|
			|`count * sizeof(int)`|Bytes occupied by all elements.|
			|`new int[loadedCount]`|Allocates an array with runtime size.|
			|`delete[] loadedScores`|Releases the dynamic array.|
			|`vector<int> loadedVector;`|Creates an empty integer vector.|
			|`int value = 0;`|Temporary destination for one value.|
			|`push_back(value)`|Adds that value to the vector.|
		|Dynamic array|Vector|
			|Allocate with `new[]`.|Grow using `push_back()`.|
			|Can read all elements at once.|Read and append each element.|
			|Must call `delete[]`.|Releases its own memory.|
______
7. #SavingandLoadingStrings
	**how to save a string**
		string objects manage its own characters internally
		writing sizeof(name) doesn't save the text properly, since you need to first save the length, and then the characters 
		example:
			name.bin 
			| length: 5 | G | a | t | o | r | 
			| 4 B |1B |1B |1B |1B |1B | 
			Total: 9 bytes (assuming a four-byte int and ASCII)
			__
			int length = name.size(); 
			output.write(reinterpret_cast<char*>(&length), sizeof(length)); 
			// Either of these writes the same length characters: 
			output.write(name.c_str(), length); 
			// output.write(name.data(), length);
	**how to read directly into a string (c++17)**
		1. non dynamic array
			// resize creates the destination storage; non-const data() returns a writable char*)
			int loadedLength = 0; 
			input.read(reinterpret_cast<char*>(&loadedLength), sizeof(loadedLength)); string loadedName; 
			loadedName.resize(loadedLength); 
			input.read(loadedName.data(), loadedLength);
		2. dynamic character array
			char* characters = new char[loadedLength + 1]; 
			input.read(characters, loadedLength); 
			characters[loadedLength] = '\0'; 
			string loadedName = characters; 
			delete[] characters;
	**c_str() vs data()**
		|Function|Purpose|Writing|Reading|
			|---|---|---|---|
			|`c_str()`|Read-only, null-terminated characters (`const char*`).|Yes|No|
			|`data()`|Pointer to contiguous characters.|Yes|Yes (non-const string, C++17+)|
		|Syntax|Meaning|
			|---|---|
			|`name.size()`|Number of characters.|
			|`name.c_str()`|Read-only pointer to null-terminated characters.|
			|`name.data()`|Pointer to the string’s contiguous characters.|
			|`loadedName.resize(loadedLength)`|Creates space for the characters.|
			|`input.read(loadedName.data(), loadedLength)`|Reads directly into that space (C++17+).|
			|`new char[loadedLength + 1]`|Allocates characters plus a null terminator.|
			|`characters[loadedLength] = '\0'`|Adds the null terminator.|
			|`delete[] characters`|Releases the dynamic array.|
___
8. #SavingandLoadingClassObjects
	**serialization**:
		serialization is important to save an object's important data; 
			**deserialization** restores it!
		instead of putting every operation in main(), you can define two member functions:
			save() - writes members in a defined order
			load() - reads those members back in the same order 
				// make sure NOT! to write the entire object with sizeof(GameCharacter), since the resulting string does not contain the nicknames characters
	**file layout** 
		|Order|Data|Type|Common size|
			|1|Level|`int`|4 bytes|
			|2|Health|`float`|4 bytes|
			|3|Nickname length|`int`|4 bytes|
			|4|`"Pixel"`|Characters|5 bytes|
			||**Total**||**17 bytes**|
	**member functions for file i/o**
		void Save(ofstream& file) const 
			{ // Write members in order. } 
		void Load(ifstream& file) 
			{ // Read members back in the same order. }
	**syntax breakdown**
		|Syntax|Meaning|
			|---|---|
			|`ofstream& file`|Receives the existing output stream by reference.|
			|`ifstream& file`|Receives the existing input stream by reference.|
			|`const` after `Save()`|Saving does not modify object members.|
			|`const char*`|Read-only pointer to bytes for writing.|
			|`reinterpret_cast<const char*>(&level)`|Byte pointer to a member without writable access through that pointer.|
			|`original.Save(output)`|Calls the object’s saving member function.|
			|`restored.Load(input)`|Restores saved data into another object.|
		// remember save and load are not built in file operations 