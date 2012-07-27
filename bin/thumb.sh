#!/bin/sh
Streams=$(ffmpeg -i $1 2>&1 | grep '^[[:blank:]]*Stream' | sed 's/^[^:]*.[^:]*..//;s/([^)]*.//g;s/ ,/,/g')
Text=$(echo -ne "File: $1\nSize: $(stat -c '%s' $1) bytes\n$Streams")
ffpoth -b10 -e-10 -w320 -n32 $1 |
  convert - -gravity northeast -stroke '#000C' -strokewidth 2 -annotate 0 '%c' -stroke none -fill white -annotate 0 '%c' MIFF:- |
    montage - -geometry +1+1 -tile 4x MIFF:- |
      convert label:"$Text" - -append $1.png