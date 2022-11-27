#!/bin/bash

if [ -n "$KERNEL_ENVS_DIR" ]
then

    if [ -n "$CLONE_BASE_TO" ]
    then
        echo "Cloning base conda environment into: $CLONE_BASE_TO (within $KERNEL_ENVS_DIR)"
        conda create --prefix "$KERNEL_ENVS_DIR/$CLONE_BASE_TO" --clone base
        echo "Done cloning"
    fi

    echo "Adding kernels for environments in: $KERNEL_ENVS_DIR"
    shopt -s nullglob
    for p in "$KERNEL_ENVS_DIR"/*/bin/python
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