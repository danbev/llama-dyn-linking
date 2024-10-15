## Example dynamic linking llama.cpp
This example can be places in the same directory as the checked out llama repository,
as the `LLAMA_PATH` is set to `../llama`. 

First we need to build llama.cpp into a shared libaray:
```console
$ make llama
```

Then we can build the `llama-simple` example:
```console
$ make llama-simple
```

And we need a model to use:
```console
$ make download-model
```

```console
$ make run-simple
```

```console
$ make debug-simple
```

