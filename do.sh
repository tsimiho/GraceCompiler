#!/bin/bash

dune exec grace < $1
llc a.ll -o a.s
clang -o a.out a.s libgrc.a
./a.out
rm a.out a.s a.ll
