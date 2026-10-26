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
		