#!/bin/sh
# Set the screen DPI (uncomment this if needed!)
# xrdb ~/.emacs.d/exwm/Xresources
# Enable screen locking on suspend

xss-lock -- slock &
# Fire it up
exec dbus-launch --exit-with-session emacs -mm --debug-init 
