touch .xinitrc.local
. ~/.xinitrc.local
xrdb -merge .Xresources &
numlockx on &
type awesome && exec dbus-launch awesome || true
