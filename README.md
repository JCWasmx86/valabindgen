## No longer maintained

It is impossible to do this, for everything except the most trivial cases, as things like memory management won't work.
E.g. this function

```c
void* foo (void);
```
Do I have to free the return value? I can't say that without knowing more about the function.

Same with:
```c
void bar (int *a);
```
What is `a`? Is it an `in` parameter or an `out` parameter or both?


# valabindgen
An attempt to write a bindings generator for Vala that generates vapis from C headers
