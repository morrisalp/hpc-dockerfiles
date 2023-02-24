FROM nvcr.io/nvidia/pytorch:22.10-py3

WORKDIR /root

# the following avoid interactive questions in tzdata install (caused by opencv dependencies)
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jerusalem

RUN pip install --upgrade pip \
    && pip install -U jupyterlab \
    && apt-get update \
    && apt-get install -y ffmpeg libsm6 libxext6 htop tmux git tree rsync openssh-server python3-distutils python3-apt poppler-utils

# setup for SSH server:
RUN mkdir /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/' -i /etc/ssh/sshd_config \
    && sed 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/' -i /etc/pam.d/sshd

RUN pip install --upgrade --ignore-installed --force-reinstall jupyterlab_widgets \
    && source /usr/local/nvm/nvm.sh \ 
    && jupyter lab build
# the last lines fix a bug with the display of widgets such as tqdm progress bars in jupyter lab
# nvm setup is needed so jupyter lab build can see node (normally this is run via bashrc when starting bash shell)

ENTRYPOINT sleep infinity
