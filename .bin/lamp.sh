#!/bin/sh
case "${1:-''}" in
'start')
rc.d start httpd
rc.d start mysqld
/usr/bin/memcached -d -m 512 -l 127.0.0.1 -p 11211 -u nobody
tput bold;
echo ":: Starting Memcached Daemon                                                [DONE]"
;;

'stop')
rc.d stop httpd
rc.d stop mysqld
killall memcached
tput bold;
echo ":: Stopping Memcached Daemon                                                [DONE]"
;;

'restart')
lamp stop
lamp start
;;
*)
echo "start, stop or restart, please"
;;
esac
