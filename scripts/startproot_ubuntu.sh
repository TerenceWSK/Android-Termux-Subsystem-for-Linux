#!/bin/bash

# Kill all old processes
killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android termux-wake-lock

# Start Termux X11
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 -ac &
sleep 3

# Start PulseAudio
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

# Start GPU accelerated virglserver
virgl_test_server_android &

# Log in to proot Ubuntu and start the desktop environment. Note that startxfce4 at the end is used to start the XFCE4 desktop.
proot-distro login ubuntu --user user --shared-tmp -- bash -c "export DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session startxfce4"
