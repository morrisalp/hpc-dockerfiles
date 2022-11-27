#!/bin/bash

if [ -n "$1" ]
then
    echo "Adding kernels..."
    shopt -s nullglob
    for p in $1/*/bin/python
    do
        name=$(basename $(dirname $(dirname $p)))
        echo "  Adding kernel: $p ($name)"
        "$p" -m ipykernel install --name "$name"
    done
    echo "Kernels added"
else
    echo "No environment directory passed; skipping adding kernels"
fi