# HPC Dockerfiles

You can use these to create environments for jobs on HPC (Runai). Images come with Python, Pytorch, CUDA drivers, and a few useful utilities (tree, tmux, git).

## Requirements

* Make sure you have Docker installed - [HERE](https://www.docker.com/)
* If you want to build images from scratch, create a [Docker Hub account](https://hub.docker.com/)
* For use with Runai: university network access
* For use with Pycharm: Professional edition

## Contents

* `Dockerfile` - Base environment. You can run scripts in this using `tmux`. Comes with `Jupyterlab` and `ssh` support (for use with Pycharm).
* `Dockerfile-jl` - Built on base image; has Jupyterlab entrypoint
* `Dockerfile-ssh` - Build on base image; has ssh server entrypoint (for use with Pycharm)

For the latter two images, replace the `FROM` base image with your own if you want to build from scratch.

## Building

* `build -t yourdockerhubname/base .` - Builds base image (`Dockerfile`)
* `build -f Dockerfile-jl -t yourdockerhubname/jl .` - Builds Jupyterlab image
* `build -f Dockerfile-ssh -t yourdockerhubname/ssh .` - Builds ssh server image

Once you build an image, push it to Docker Hub with `docker push imagename`.

## Running job on Runai (base image)

* `runai submit --pvc=storage:/storage -i  morrisalp/base --name myjobname`

You can enter it with `runai bash myjobname` and run persistent scripts in `tmux`.

## Running job on Runai (JL / SSH)

Run one of:

* `runai submit --pvc=storage:/storage -i  morrisalp/jl --name myjobname  --interactive --service-type=portforward --port 8888:8888`
* `runai submit --pvc=storage:/storage -i  morrisalp/ssh --name myjobname  --interactive --service-type=portforward --port 8888:22`

(Replace `morrisalp/imagename` with your own Docker Hub image if you built it from scratch.)

If you use one of the latter with port forwarding, make sure to submit this in `tmux` and leave it running. If you are on some university server `uid@serverip`, you must also set up port forwarding locally with:

* `ssh uid@serverip -NL 8888:localhost:8888`

Now you can access the service (JL/ssh) locally at `localhost:8888`. For Jupyterlab, enter this into your browser, and use the token from `runai logs myjobname`. For ssh (Pycharm), create a new remote interpreter for your project with settings: `localhost:8888`, username=password=`root`.