touch .xinitrc.local
. ~/.xinitrc.local
xrdb -merge .Xresources &
numlockx on &
exec dbus-launch awesome
