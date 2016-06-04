#!/bin/bash

if ! type "zenity" > /dev/null; then
    echo "ERROR: Please install zenity"
    exit 1
fi

readonly argument="${1}"
readonly vt_basepath=~/verges-tools

currentUser=$(id -u -n)

case "${argument}" in
    skype)
        echo "Starting Skype docker container"
        docker rm $(docker ps -a | grep Exited | grep "sameersbn/skype" | awk '{print $1}') 2>&1 >/dev/null || true
        docker run -d -it \
            -v /etc/localtime:/etc/localtime \
            -v /home/${currentUser}/.Skype:/home/skype/.Skype \
            -v /home/${currentUser}/Downloads:/home/skype/Downloads \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -v /tmp/.docker.xauth:/tmp/.docker.xauth \
            -v /run/user/1000/pulse:/run/pulse \
            -e USER_UID=1000 \
            -e USER_GID=1000 \
            -e DISPLAY \
            -e XAUTHORITY=/tmp/.docker.xauth \
            -e TZ=CEST \
            --device "/dev/video0" --privileged \
        sameersbn/skype:latest \
        skype
    ;;

    tachrome)
        echo "Starting throw-away-chrome docker container"
        docker rm $(docker ps -a | grep Exited | grep "sotapanna108/chrome-privacy" | awk '{print $1}') 2>&1 >/dev/null || true
        docker run -d -it \
            --net host \
            --cpuset-cpus 0 \
            --memory 512mb \
            -v /etc/localtime:/etc/localtime:ro \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            -e DISPLAY=unix$DISPLAY \
            -v /var/lib/dbus:/var/lib/dbus \
            -v $HOME:/root/parent_home \
            -v $HOME/Downloads:/root/Downloads \
            -e PULSE_SERVER=tcp:127.0.0.1:4713 \
            -e PULSE_COOKIE_DATA=`pax11publish -d | grep --color=never -Po '(?<=^Cookie: ).*'` \
            -e USER_UID=${user_uid} \
            -e USER_GID=${user_gid} \
            --group-add audio \
            --group-add video \
            --device /dev/dri \
            -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket:ro \
            -v /dev/shm:/dev/shm \
            -v /run/dbus/:/run/dbus/:rw \
            -v /dev/snd:/dev/snd --privileged \
        sotapanna108/chrome-privacy
    ;;
    *)
        msg="The service was not recognized as Docker service."
        zenity --info --text="${msg}"
        echo "${msg}"
        echo $"Usage: $0 {skype|tachrome}"
esac