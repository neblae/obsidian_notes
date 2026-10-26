1. Text Files and Binary Files
	- Why are files useful? 
		- since programs store information in variables why they run, relying on them can have some issues:
			1. **repetitive input:** entering large amounts of information manually whenever a program is initialized is very inefficient and inconvenient
			2. **hardcoded data:** directly writing information into source code makes a less flexible and less generically applicable program, since changing the data may need a lot more manual labor 
			3. **temporary storage:** information stored in normal program variables is lost when the program ends 
	- Two Types of Files:
	

| Text Files                                             | Binary Files                                        |
| ------------------------------------------------------ | --------------------------------------------------- |
| Stores information as characters                       | Stores information using raw bytes                  |
| Usually human readable                                 | May not be readable                                 |
| Converts numeric values into character representations | Can preserve the numeric value's in memory directly |
| Example: scores.txt                                    | Example: scores.bin                                 |
	Text Files: Numbers Saved as Characters
		A text file represents information using characters. Although each character is encoded as binary values, integers like 42 must also be decoded into binary.

| File position | Character | ASCII | Hexadecimal | Binary   |
| ------------- | --------- | ----- | ----------- | -------- |
| Byte 0        | '4'       | 52    | 34          | 00110100 |
| Byte 1        | '2'       | 50    | 32          | 00110010 |

------------------------------------------------------------------------
2. Opening and Closing Binary Files
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

| Modes            | Purpose           |
| ---------------- | ----------------- |
| ios_base::in     | read              |
| ios_base::out    | write             |
| ios_base::binary | binary mode       |
| ios_base::app    | append to the end |
		you can also combine different modes with "|"
			ex. "fstream file("score.bin", ios_base::in | ios_base::out | ios_base::binary);"
	Check and Close:
		if (!output.is_open()) {
			cout << "Could not open score.bin.|n";
			return 1;
		}
		output.close();
		**Why opening may fail:** a missing input file, incorrect path, inaccessible permissions, nonexistent destination directory, or an operating-system restriction. A missing output filename alone does not normally cause failure: `ofstream` creates it.
		

| Syntax Breakdown |         |
| ---------------- | ------- |
| Syntax           | Meaning |
|                  |         |
