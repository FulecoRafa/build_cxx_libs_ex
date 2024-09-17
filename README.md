# How to build CXX programs
## Compiling programs
CXX are compiled languages. In this case C++.
To create an executable, we need all the source code as input to the compiler
and generate an ELF file (on Linux).

For this, compile the program using a CXX compiler.

Ex:
```bash
clang++ src/main/main.cpp -o main
```

And run the program
```bash
> ./main
Hello, ProFusion
```

## Compiling libraries
If you want to create a library, reuse code between binaries, you may
compile your source files using special flags to create **object files**.

A library is composed of two kinds of files:
- lib.h[pp]: The header file, defining function and type signatures so that
  other developers may know what is available for you to use. Check
  [slib.hpp](src/slib/slib.hpp) to see a function definition.<br>
  This is considered where you make your functions public and should be included
  in main sources.
- lib.cpp: The file with the actual code to be executed. This will be put in the
  compilation process.

### Header files
This has to do with the `#include` directive of the compiler. It simply gets the
contents of the file passed as first argument and pastes in file.
Therefore, the result of
```cpp
#include "dlib/dlib.hpp"

int main(void) {
    ...
}
```
Would be
```cpp

#include <string>

void greet(std::string name);

int main(void) {
    ...
}
```

And then it would recurse resolving these directives.

Notice that now, there is a function signature for the library function
before its code is even declared. This allows the compiler to check the function
call before the function itself.

The `#include` directive will look for the header file:
- In the system include path, usually in `/usr/include`, if path is in diamond
brackets.  Ex: `#include <cstdlib>`. Normally used for stdlib or system-wide
libraries.
- In the include path, which may be altered by the user, if passed in quotes.
Ex: `#include "mylib/mylib.h"`. For this to work with custom libraries, the
folder including `mylib` should be added to include path:
```bash
clang++ main.cpp -Ipath/to/my/libraries -o main
```
- Relative to file including the lib, if path in quotes. Ex: `#include "../lib.h"`

### Library types
There are two types of libraries:
#### Static Libraries
Static libraries are compiled alondside main program as though they were simply
glued together. To do this, first we compile the static library to an object the
linker can use.

```bash
clang++ -c slib/slib.cpp -o slib.o 
```
The -c flag tells the compiler to stop at creating the object file.

With that in hand we can add the object file as another argument to the main
compilation. Don't forget to include the header file path.
```bash
clang++ src/main/main.cpp slib.o -Isrc -o main
```
#### Dynamic Libraries
Dynamic libraries, or shared libraries, are those that exist in the system in
question and may be used by various binaries and other libraries. These are not
added to the final object of the user-code, but are referenced by the **linker**
to be used in runtime. This makes final compiled artifacts smaller, but create a
dependency on this library existing in the system.

Similarly to static libraries, we can create dynamic libraries with special
compilation flags to create a **shared object**.

```bash
clang++ -shared dlib/dlib.cpp -o shared/libdlib.so # notice name starts with `lib`
```
We send the result to a special folder. This is easier to administer since when
compiling the main program, we can pass just the directory for shared libraries
to add to the linker.

```bash
clang++ src/main/main.cpp slib.o -Isrc -Lshared -ldlib -o main
```
We add 2 flags:
- -L{dir} which adds a folder to the LD_PATH, where the linker may search for
shared libraries
- -l{libname} which tells the linker to look for `lib{libname}.so` in LD_PATH to
link to our program.

## Makefile
Doing all this by hand all the time as very annoying, so we can use a build
system. For CXX, normally [GNU Make](https://www.gnu.org/software/make/) is used
(in Linux). Please check [the docs](https://www.gnu.org/software/make/) and [the
repo's Makefile](Makefile) to get see how it is used.

## CMake
