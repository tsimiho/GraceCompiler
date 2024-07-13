# Grace Compiler

Compiler for the programming language Grace - Compilers course @ NTUA

## Dependencies

- ocaml 4.14.1
- clang 14.0.6
- LLVM 14.0.6
- opam 2.1.5:
  - menhir
  - ocamllex
  - camlp5
  - llvm.14.0.6

## Build

To build the compiler, run:

```
dune build
```

To remove the \_build directory, run:

```
dune clean
```

## Usage

After building the compiler, you can compile a program by running:

```
bash do.sh path_to_program
```

For example:

```
bash do.sh programs/hello.grc
```

To run your program, execute:

```
./a.out
```
