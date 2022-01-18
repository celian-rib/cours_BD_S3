#!/bin/bash

global="$(pwd)"
replace="."
for file in $(find ./ -name "*.md"); do
    sed "s+$global+$replace+" $file > $file
done