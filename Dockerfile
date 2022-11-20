FROM nvcr.io/nvidia/pytorch:22.10-py3

WORKDIR /root

RUN pip install --upgrade pip \
    && pip install jupyterlab \
    && apt-get update \
    && apt-get install -y tmux git tree rsync openssh-server

# setup for SSH server:
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/' -i /etc/ssh/sshd_config
RUN sed 's/session\s*required\s*pam_loginuid.so/session optional pam_loginuid.so/' -i /etc/pam.d/sshd

ENTRYPOINT sleep infinity