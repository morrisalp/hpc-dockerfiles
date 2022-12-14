FROM nvcr.io/nvidia/pytorch:22.10-py3

WORKDIR /root

RUN pip install --upgrade pip \
    && pip install -U jupyterlab \
    && apt-get update \
    && apt-get install -y tmux git tree rsync openssh-server python3-distutils python3-apt

# setup for SSH server:
RUN mkdir /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/' -i /etc/ssh/sshd_config \
    && sed 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/' -i /etc/pam.d/sshd

ENTRYPOINT sleep infinity
