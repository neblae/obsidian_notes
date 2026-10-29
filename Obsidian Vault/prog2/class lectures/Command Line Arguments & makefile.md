1. #CommandLineEssentials 
	activity files: start with cd activities/01
	1. **what is a command-line interface?** 
		CLIs let you interact with your computer **using commands** instead of a GUI
	2. **essential CLI commands:**
		pwd - display current directory
			W : cd
		ls - list files
			W: dir
		cd - change directory 
		cd .. - move to parent directory (no it isn't?)
		mkdir folder - create a folder 
		clear - clear terminal
			W: cls
	3. **compiling and running a program** 
		to compile main.cpp:
			g++ main.cpp -o program
				-o flag names the executable 
			./program to run it
____
2. #CommandLineArguments
	1. **what are command-line arguments?**
		this is how you pass information into a program when launching it
			i.e. ./program Alex 25 
	2. **receiving arguments in main()**
		instead of writing an empty *int main()*, you can instead receive args like:
			int main(int argc, const char* argv[]) {
				return 0;
			}
	3. **how are arguments stored?**
		![[Pasted image 20261028185008.png|300]]
	4. **what is *argv*?** 
		an array of C-style string that ends with a null character ('\0')
			const char* argv[] - an array of pointers to characters; characters cannot be modified through pointers 
			can also use const char** argv
	5. **Accessing Arguments**
		![[Pasted image 20261028185351.png|311]]
_____
3. #UsingCLIArgs 
	1. **checking the number of arguments**
		in the case of - ./program Alex 25 - , we are only expecting two arguments, meaning argc = 3
			use an if statement to check the count before accessing the arguments
				if (argc != 3) {
					cout << "Usage: ./program <*name*> <*age*>\n"
					return 1;
				}
	2. **arguments are strings**
		even when an argument has numbers/looks numeric, it is a C-style string 
			in the case of ./program Alex 25 , you can use stoi(argv[2]) to convert it to an integer 
	3. **arguments containing spaces** 
		if you have a word that has spaces (Computer Science) use quotes around it
____
4. #CompilingandLInkingcpp
	1. **compiling a c++ program** 
		g++ main.cpp, or g++ main.cpp -o program to name it 
	2. **compiling multiple source files** 
		if you have the main.cpp, header.h and .cpp file,you only need to compile:
				g++ main.cpp math_utils.cpp -o program
			as header files are brought into source files through #include 
		if you want to compile multiple .cpp files in a directory:
			g++ (asterisk).cpp -o program
	3. **understanding compilation and linking** 
		![[Pasted image 20261028193020.png|312]]
	4. **compiling without linking (-c)**
		g++ -c main.cpp produces main.o object files
	5. **linking object files** 
		g++ main.o math_utils.o -o program (or just use asterisk to get all .o files in directory)
___
	5. #IntroductiontoMakefiles
		1. **what is a makefile?**
			plain-text file containing instructions for building a program
			instead of typing:
				g++ main.cpp -o program
			put it in a makefile and run "make"
		2. **understanding the process**
			makefile -> make -> g++ main.cpp =o program -> executable 
		3. **creating a makefile** 
			![[Pasted image 20261028193434.png|305]]
		4. **running a makefile**
			from activity directory:
				make
				./program
_____
6. #makefileRulesandTargets
	1. **using multiple rules**
		makefiles can have different rules(targets) to define it for 
			all - builds a executable named program 
			run - runs the executable 
			clean - removes the executable 
		- looks like:
			target:
				command
	2. **running different rules**
		make ()selects the first target (all)
		make (run) runs ./program
		make (clean) removes the executable 
			important to run make before make run, since you need the .exe to exist ???????
	3. **understanding (make clean)**
			clean:
				rm -f program 
		clean - target named clean
		rm - removes a file 
		-f - doesn't report any errors if the file is missing 
		program - the executable file to remove, not the source code 
___
7. #MakeProgramsandBuildTools
	1. **Makefile vs Make Program** 
		- makefiles are text files containing build instructions, while make programs are a program that reads and executes instructions
		- makefiles define rules and commands, while make programs processes requested rules 
	2. **different make programs**
		![[Pasted image 20261028194829.png|356]]
		3. **what is CMake?** 
			cmake is a build-system generator used to manage projects
			CMake config -> generated build files -> build tool -> C++ compiler -> exe
		4. **why build tools?** 
			while a small program might only need a simple g++ main.cpp -o program compilation, larger projects have a lot more files to put together 
____
8. #CLIargumentsandMakefiles
	1. **putting the concepts together:**
		main.cpp + makefile completes the make program -> compiles program -> input the argument (./program Alex 85) -> argc=3; argv[1]="Alex"; argv[2]="85" ->stoi("85") turns into an int 85 -> displays result
	2. **processing arguments**
		validate the count (if argc != 3) and then turn the number string into int
	3. **building and running with a makefile**
		using make all, run, or clean, run arguments 
