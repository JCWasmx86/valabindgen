# Planning

The user should give `valabindgen` header files. Those are written into a file like this:
```c
#include <firstheader.h>
#include <secondheader.h>
/* And so on */
```
Then the preprocessor is ran over this file, so you get one huge, standalone file.

Then - using libclang - an AST is built and visited.

## Extracting relevant information

Structs, enums, typedefs and functions are extracted

## Transforming the extracted information

Functions are assigned to enums, iff:

- The first argument is the enum itself

Functions are assigned to structs, iff:
- The first argument is the struct itself
- (Or as a constructor), if the struct itself is returned.
- If only one argument is taken and `void` is returned, and it contains e.g. `free`, `dispose`, and so on, consider it the cleanup function

Typedefs are transformed:
- Typedefs to fundamental types like `int` are transformed to e.g. `class Foo : int`

Functions are transformed:
- Non-typedef'd function pointers get a new delegate with a generated name
- Using heuristics, reduce the number of parameters:
  - If there is an array and the next parameter is like `$SOMEINT_VALUE size_$PARAMNAME`, consider it as an array length
  - If the parameter is a function pointer and the next element is a `void *` and the last parameter of the function pointer is a `void*`, too, consider it a user_data and ignore this parameter
  
Delegates are transformed:
- If every time this delegate is passed to a function, the next argument resolves to `void*` and the last argument of the delegate is a `void*`, too.

Names are transformed:
- Remove the common prefix, but only until `_`.
- Make all enum values `UPPER_CASE`
- Make all function names `snake_case`
- Make all class/enum names `PascalCase`

## Writing the VAPI
The user should give a regex for function names, like `gl.*` for OpenGL or `clang_` for libclang. Only the types used by the function will be generated.
