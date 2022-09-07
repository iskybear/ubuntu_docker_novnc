#!/bin/bash

USER_UID=${LOCAL_USER_UID:-1000}
USER_GID=${LOCAL_USER_GID:-1000}
USER_PASS=${LOCAL_USER_PASSWORD:-"123456"}
USERNAME=nn

echo "entrypoint.sh"
echo "Starting with USER_UID : $USER_UID"
echo "Starting with USER_GID : $USER_GID"
echo "Starting with USER_PASS : $USER_PASS"

# 启动传UID=1000  不需要修改UID，GID值
if [[ $USER_UID != 1000 ]]; then
    echo "---usermod uid start---"$(date "+%Y-%m-%d %H:%M:%S")
    usermod -u $USER_UID $USERNAME
    find / -user 1000 -exec chown -h $USERNAME {} \;
    echo "---usermod uid end---"$(date "+%Y-%m-%d %H:%M:%S")
fi

if [[ $USER_GID != 1000 ]]; then
    echo "---usermod gid start---"$(date "+%Y-%m-%d %H:%M:%S")
    # groupmod -g $USER_GID $USERNAME
    groupmod -g $USER_GID --non-unique $USERNAME
    find / -group 1000 -exec chgrp -h $USERNAME {} \;
    echo "---usermod gid end---"$(date "+%Y-%m-%d %H:%M:%S")
fi

export HOME=/home/$USERNAME

echo "root:$USER_PASS" | sudo chpasswd
echo "$USERNAME:$USER_PASS" | sudo chpasswd

sudo rm -rf /tmp/.X*lock
sudo rm -rf /tmp/.X11-unix

sleep 1; xset s off
sleep 1; xset s noblank

tigervncserver -SecurityTypes None > /dev/null
sudo sed -i 's/$(hostname)/localhost/g' /usr/share/novnc/utils/launch.sh
sudo /usr/share/novnc/utils/launch.sh --vnc localhost:5901 > /dev/null