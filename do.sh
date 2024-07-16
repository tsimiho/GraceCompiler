#!/bin/bash

dune exec grace < "$1"
exit_code=$?
# echo "Exit code: $exit_code"
if [ -f a.ll ]; then
    llc a.ll -o a.s
    clang -g -o a.out a.s libgrc.a
    rm a.s a.ll
fi
exit $exit_code
