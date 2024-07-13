#!/bin/bash

dune exec grace < "$1"
if [ -f a.ll ]; then
    llc a.ll -o a.s
    clang -g -o a.out a.s libgrc.a
    # ./a.out
    # rm a.out a.s a.ll
fi
