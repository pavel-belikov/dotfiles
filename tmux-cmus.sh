#!/bin/bash
s=`cmus-remote -C 'format_print "%a - %02n. %t"'`;
if (( ${#s} == 0 ))
then
    echo ""
elif (( ${#s} < 37 ))
then
    echo " $s "
else
    printf " %-37s \n" "${s:0:36}"
fi
