#!/bin/sh
	
########################################
# Name: Mount SMB
#
# about: Mount SMB file server through VPN (Mac OS X)
#
# Usage: start|stop|restart
#
# Author: Teppei Fukuda
# Date: 2014/10/06
########################################


PROGNAME=`basename $0`
BASEDIR=`dirname $0`

source $BASEDIR/vpn.conf

start() {
    echo "Starting..."

    # Connect VPN
    networksetup -connectpppoeservice $VPN
    sleep 3

    # Mount Samba file server
    mkdir -p /Volumes/$DIR
    mount_smbfs //guest:$PASSWORD@$SMB/$DIR /Volumes/$DIR
}

stop() {
    echo "Stopping..."

    # Disconnect VPN
    #networksetup -disconnectpppoeservice $VPN
    sudo killall pppd

    # Unmount Samba file server
    umount /Volumes/$DIR
}

status() {
    networksetup -showpppoestatus $VPN
}

usage() {
  echo "usage: $PROGNAME {start|stop|restart}"
}


case "$1" in
'start')
	start
        ;;
'stop')
	stop
        ;;
'status')
	status
        ;;
'restart')
	stop
	start
        ;;
*)
	usage
        exit 1
        ;;
esac

