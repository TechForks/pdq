#!/bin/sh
case "${1:-''}" in
'start')
systemctl start httpd
systemctl start mysqld
/usr/bin/memcached -d -m 512 -l 127.0.0.1 -p 11211 -u nobody
tput bold;
echo ":: Starting Memcached Daemon                                                [DONE]"
;;

'stop')
systemctl stop httpd
systemctl stop mysqld
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
