#!/bin/bash

if [ -n "$1" ]
then
    echo "Adding kernels for environments in: $1"
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

echo "Starting Jupyter Lab session..."
jupyter-lab --config=.jupyter/nbconfig/tree.json --allow-root