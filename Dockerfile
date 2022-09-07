FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive

ENV PROJECTOR_USER_NAME nn

ENV TZ Asia/Shanghai
ENV LESSCHARSET=utf-8

RUN cp -rf /etc/apt/sources.list /etc/apt/sources.list.bak \
 && echo "deb http://mirrors.163.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list \
 && echo "deb http://mirrors.163.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb http://mirrors.163.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb http://mirrors.163.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb-src http://mirrors.163.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb-src http://mirrors.163.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb-src http://mirrors.163.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
 && echo "deb-src http://mirrors.163.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list

RUN apt-get update -y \
 && apt-get install -y \
    git \
    software-properties-common \
    imagemagick \
    mesa-utils \
    net-tools \
    sudo \
    gosu \
    novnc \
    onboard \
    tigervnc-standalone-server \
    tigervnc-xorg-extension \
    x11-apps \
    xfce4 \
    xfce4-terminal \
    xfce4-clipman \
    xfce4-taskmanager \
    xterm \
    mousepad \
    firefox \
    xauth xinit dbus-x11 \
    gdebi \
    wget \
    curl \
    bash-completion \
 && rm -rf /var/lib/apt/lists/* \
 && chmod g+rw /home && mkdir -p /home/$PROJECTOR_USER_NAME \
 && useradd -M -d /home/$PROJECTOR_USER_NAME -s /bin/bash $PROJECTOR_USER_NAME \
 && usermod -a -G sudo $PROJECTOR_USER_NAME \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && mkdir /home/$PROJECTOR_USER_NAME/.vnc \
 && echo "#!/bin/sh\nstartxfce4" > /home/$PROJECTOR_USER_NAME/.vnc/xstartup \
 && chmod +x /home/$PROJECTOR_USER_NAME/.vnc/xstartup \
 && chown -R $PROJECTOR_USER_NAME:$PROJECTOR_USER_NAME /home/$PROJECTOR_USER_NAME

COPY entrypoint.sh /
RUN chmod a+x entrypoint.sh

USER $PROJECTOR_USER_NAME
ENV HOME /home/$PROJECTOR_USER_NAME

# create .bashrc.d folder and source it in the bashrc
RUN mkdir -p /home/$PROJECTOR_USER_NAME/.bashrc.d \
 && (echo; echo "for i in \$(ls -A \$HOME/.bashrc.d/); do source \$HOME/.bashrc.d/\$i; done"; echo) >> /home/$PROJECTOR_USER_NAME/.bashrc

ENTRYPOINT ["/entrypoint.sh"]