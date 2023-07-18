#!/bin/bash

for program in ../syntax_gen/progs/*
do
  output=$(./grace < "$program" 2>&1)
  if [[ "$output" != *"Success"* ]]; then
    echo "Failed: $program"
    echo "$output"
  fi
done
