#!/bin/bash
case "$(xset -q | grep LED | awk '{print $10}')" in
  "00000002") KBD=" `setxkbmap -query | grep layout | awk '{print $2}' | cut -d',' -f 1` " ;;
  "00001002") KBD=" `setxkbmap -query | grep layout | awk '{print $2}' | cut -d',' -f 2` " ;;
  *) KBD="" ;;
esac
echo "$KBD"
