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

## Running job on Runai (JL)

* `runai submit --pvc=storage:/storage -i  morrisalp/jl --name myjobname  --interactive --service-type=portforward --port 8888:8888`

Make sure to leave this running (recommended in `tmux`) so that port forwarding persists. If you are on some university server `uid@serverip`, you must also set up port forwarding locally with:

* `ssh uid@serverip -NL 8888:localhost:8888`

Now you can access the service locally at `localhost:8888`. Enter this into your browser, and use the token from `runai logs myjobname`. 

If you would like JupyterLab to use a subdirectory of your storage directory as the working directory, add the `--working-dir` flag as shown:

* `runai submit --pvc=storage:/storage -i  morrisalp/jl --name myjobname  --interactive --service-type=portforward --port 8888:8888 --working-dir /storage/yourname/notebooks`

(Replace `yourname` with your name and create the corresponding directory.)

In all of the above, replace `8888` with another local port if needed.

## Running job on Runai (SSH / PyCharm)

* `runai submit --pvc=storage:/storage -i  morrisalp/ssh --name myjobname  --interactive --service-type=portforward --port 8888:22`

Make sure to leave this running (recommended in `tmux`) so that port forwarding persists. If you are on some university server `uid@serverip`, you must also set up port forwarding locally with:

* `ssh uid@serverip -NL 8888:localhost:8888`

Now you can access the service locally at `localhost:8888`. Create a new remote interpreter for your project with settings: `localhost:8888`, username=password=`root`.

In all of the above, replace `8888` with another local port if needed.