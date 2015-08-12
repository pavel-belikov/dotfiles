xrdb -merge .Xresources
numlockx on &
source .xinitrc.local &
exec dbus-launch awesome
