#!/bin/bash

./Main.native < $1
llc a.ll -o a.s
clang -o a.out a.s libminibasic.a
