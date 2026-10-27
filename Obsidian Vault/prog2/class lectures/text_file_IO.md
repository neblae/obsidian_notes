1. #FileStreamsandOpeningFiles
	**From Binary Files to Text Files:**
		**similar to bin IO:** same fstream header, stream classes, and open -> check -> use -> close process
		**difference to bin IO:** data is transferred using << >> and getline() for formatted characters, instead of working with raw bytes 
	**The fstream header: **
		provides the same three file-stream classes:
			ofstream - write to a file
			ifstream - read a file 
			fstream - read,write, or both, depending on opening mode 
	**Two ways to open a file:**
		1. ofstream output("welcome.txt."); // opens in the constructor 
		2. ofstream other; other.open("notes.txt"); // open later with open()
			useful when you don't know the filename at the moment of declaration
	**Check and close:** 
		if (!output.is_open()) {
			cout << "Could not open the file.\n";
			return 1;
			}
			output.close();
		Possible reasons for failure to open a file:
			directory does not exist
			path is incorrect
				incorrect filenames can make a new unintended file
			permissions deny access
			OS restriction prevents access
	|Syntax|Meaning|
		|---|---|
		|`#include <fstream>`|Includes file-stream classes.|
		|`ofstream output("welcome.txt")`|Creates an output stream and attempts to open the named file.|
		|`other.open("notes.txt")`|Opens a file using an existing stream.|
		|`output.is_open()`|Checks whether a file is associated with the stream.|
		|`!`|Reverses a Boolean condition.|
		|`return 1;`|Ends `main()` with a nonzero result.|
		|`output.close()`|Closes the file associated with the stream.|
_____
2. #FileOpeningModes 
	opening modes:
		opening modes control how the stream uses the file
			|Mode|Meaning|
				|---|---|
				|`ios_base::in`|Input; default for `ifstream`.|
				|`ios_base::out`|Output; default for `ofstream`.|
				|`ios_base::trunc`|Remove existing file contents on opening.|
				|`ios_base::app`|Append each output operation at the end.|
				|`ios_base::ate`|Move to the end immediately after opening; subsequent positioning is allowed.|
				|`ios_base::binary`|Binary mode (covered in the separate binary guide).|
	Syntax:
		|Syntax|Meaning|
			|---|---|
			|`ofstream appendFile("journal.txt", ios_base::app)`|Opens for appending rather than replacing contents.|
			|`ios_base::app`|Sends writes to the end of the file.|
			|`ios_base::ate`|Sets the initial position to the end after opening.|
			|`ios_base::trunc`|Clears existing contents on opening.|
			|`ios_base::out \|ios_base::app`|Combines mode flags with bitwise OR.|
			|`getline(input, line)`|Reads one entire text line into `line`.|
____
3. #WritingTextwithofstream
	**what to know:**
		writing text works like cout, except your "couting" into a file!
			output << "Score: " << 90 << '\n';	
		**Syntax:**
			|Syntax|Meaning|
			|---|---|
			|`output << value`|Writes formatted text to the file.|
			|`<<` chained together|Writes each item consecutively.|
			|`'\n'`|Adds a newline character.|
			|`'\t'`|Adds a tab character.|
			|`score *= 2`|Doubles `score` after each iteration.|
____
4. #ReadingTextwithifstream
	**what to know:** 
		ifstream reads file data INTO program variables, just like how cin reads user input
			if you have a word/formatted number:
				use >> , like input >> score
			if you have an entire line, including space:
				use getline(), like getline(input, name);
			remember to match the reading method to the file format, i.e. if you have multiple lines to input, **use getline**, but if you just have individual values you want to read seperated by one whitespace, **use >>** 
	**syntax:**
		|Syntax|Meaning|
		|---|---|
		|`ifstream input("student.txt")`|Opens the file for input.|
		|`input >> score`|Reads a formatted value and converts it to `int`.|
		|`input >> gpa`|Reads a formatted value and converts it to `double`.|
		|`getline(input, name)`|Reads the entire line, including embedded spaces.|
______
5. #ReadinganUnknownNumberofValues
	**what to know:** 
		when a file has no fixed element count, you have to read through until a read operation fails:
			while (input >> value) {
				numbers.push_back(value);
				}
		this way, extraction can only occur inside the condition, *which continues only after a successful read*
____
6. #ReadingFileswithaStoredCount
	**what to know:**
		some files have metadata (data that simply has the information to describe data)
			ie. count is a measure of how many other values exist; if count is 3, it means there are 3 other values, but it does not count itself! 
	how to do it (its just a for loop like normal):
		for (int i = 0; i < count; i++)
			int score;
			input >> score;
			scores.push_back(score);
___
7. #DelimitersandFileFormats 
	**file formats and delimiters:**
		a **record** groups related values describing one item:
			one record can occupy multiple lines, or even just a single line with values separated by a **delimiter**
				delimiter - a character that marks the boundary between data values
		|Delimiter|Example|
			|---|---|
			|Space|`Alex 90`|
			|Comma|`Alex,90`|
			|Pipe|`Alex\|90`|
		- don't use a space when a title contains several words
		- to register pipe delimiter, you have to understand getline args:
			getline(stream, destination, delimiter);
		- if you leave out the delimiter, it is automatically \n, so you can make it "|"
			getline(input, name, '|'); // name is "Ada Lovelace"
	**CSV:**
		Comma-Separated Values stores tabular text, where every line is a row, and commas separate columns
			Code,Title,Credits 
			COP3503C,Programming Fundamentals 2,4 
			COP3530,Data Structures and Algorithms,3
___
8. #ReadingDelimitedTextwith_istringstream
	**what is a stream?**
		a stream is a sequence of data flowing in or out of a program
			i.e. cin goes from keyboard -> program, cout goes from program -> terminal
		istringstream lets you read an existing string piece by piece, in the same way i would physically read a file with my own eyes (have to include sstream)
	**splitting a CSV record:**
		1. read a complete line with getline(input, line)
		2. create a stream from that line
		3. specify a comma as the third argument of getline();
		ex:
			istringstream stream(line);
			getline(stream, code, ',');
			getline(stream, title, ',');
			getline(stream, token, ',');
	**numeric conversion:**
		- getline() will return a string, even if a token is numeric
		- stoi(token) converts numeric text into an int
		- stod(token) converts it into a double 
___
9. #ReadingTextFilesintoClassObjects
	**reconstructing objects from text:**
		text files only **store characters**, not C++ objects
		for each record in the file:
			read the values
			convert numeric tokens
			construct an object
			add to vector
	**constructing and storing an object:**
		repeat for every line- this builds a vector of objects that the rest of the program can use:
			int credits = stoi(token); Course course(code, title, credits); courses.push_back(course);
_____
Makefiles:
		- makefiles are text files that tells the make tool how to build a project:
			- which files depend on which
			- what commands to run to produce each one
		- instead of typing a long compile by hand, you just have to write the recipe one and run make
	**basic structure:**
		rules:
			- makefiles are made of rules:
				target: dependencies
					command
				- target: the file you want to produce, or the name for an action
				- dependencies: the files the target is builtg from
				- command: the shell command that builds the target (must be indented with a tab)
		example:
			myprogram: main.o utils.o
				g++ -o myprogram main.o utils.o
			
			main.o: main.cpp utils.h
				g++ -c main.cpp
			
			utils.o: utils.cpp utils.h
				g++ -c utils.cpp
			
			clean:
				rm -f *.o myprogram
	how to understand 