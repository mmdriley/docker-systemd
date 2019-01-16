# Derived from https://github.com/solita/docker-systemd/blob/master/Dockerfile
# Containers that run this image must be started with `--privileged`.

FROM ubuntu:18.04

# https://github.com/systemd/systemd/blob/042cad5737917e6964ddddba72b8fcc0cb890877/src/basic/virt.c#L460
ENV container docker

# https://wiki.ubuntu.com/Minimal
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#run
RUN yes | unminimize && \
    apt-get update && \
    apt-get install -y \
        systemd \
        && \
    rm -rf /var/lib/apt/lists/*

# https://access.redhat.com/documentation/en-us/red_hat_ent# Default systemd 
# Default on install is graphical.target, which seems fine.
# RUN systemctl set-default multi-user.target

# Setting up AppArmor profiles from inside the Docker container doesn't go well.
# https://help.ubuntu.com/community/AppArmor
RUN systemctl disable apparmor

# http://man7.org/linux/man-pages/man1/systemd.1.html#SIGNALS
STOPSIGNAL SIGRTMIN+3

# occasionally used for testing; egregiously bad for security.
# RUN echo -ne 'hello\nhello\n' | passwd

COPY mitigate_38420 /usr/local/bin/
CMD ["/usr/local/bin/mitigate_38420", "/sbin/init"]
