 - allows to read and write data
Text fileio
		 able to read/write from human readable data (csv,json)
			 csv - first row is headings
		important to understand structure of the data to efficiently parse it
	operations/opening a file
		 fstream variable_name(filename, ios::in | ios::out);
		 ifstream variable+name(filename);
		ofstream variable_name(filename)'
	Data streams
		include <*fstream*>
		want to be able to take arguments from command line into a file 
			- ex. cin, cout->
			- istringstream, ostringstream, stringstream (combination of in and ostream)
Read Text File IO. Operations
	if you want to move ifstream file content to var adata:
		file >> data;
			moves file content to data, itha. whitespace separator
		getline(file, data, separator);
			moves file content to data until the separator (default endline) 
	syntax:
		string line, name, college, major;
			getline(file, line);
			istringstream data(line);
			getline(data, name, ',');
				the moment the function arrives at a comma, it will read it and save it to 'data'
			getline(data, college, '');
			getline(data, major, '\n'); 
Write Text File IO
	you can write data into a text file using the *<<* than operator 
		IEL file  
	ofstream file("cop3503c_pm.csv", ios::app);
	if (!file.is_open()) {
	cout *<<* "error!"



Parsing
	1. read from console
		arguments passed in as an array of chars
		given number of args in array
		make the array a vector of strings
		{
		int main(int argc, char* argv[] {
			vector<*string*> args = {};
	2. go through arguments
		check args are valid before or while trying to use them
		can have multple methods
			something like ./proj2.bin [name] [age] [method] will have 4 arguments, but you will do 4-1 since ./prog2.bin counts as an argument when input into the CLI 
	3. keep track of what argument you're on 
		different arguments have different numbers of files necessary
		can have multiple operations
		need to operate on files
			Recommendations: 
				use while loops instead of for loops when going through arguments
				increment based on a number of files a method requires 
	4. perform the operations
		run the method on the files
		write the output to the required file 
		go to next 



| Syntax   |                            |               |
| -------- | -------------------------- | ------------- |
| variable | purpose                    | logic         |
| stoi()   | turns string to an integer | "2" -> int(2) |

tgaviewer, hxd demo for binary files 