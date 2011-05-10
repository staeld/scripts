#!/bin/bash
# archupdates.2.sh - check for available updates via pacman
# Copyright Stæld Lakorv, 2010 <staeld@staeld.co.cc>
# Released under the GNU GPLv3
#
# v.2a1 - 2010-08-08/13:42

LOGFILE=~/.archupdates.2.sh.log
INFOFILE=/etc/archupdates

function log_check () {
    if [ ! -e $LOGFILE ]; then
    #msg_info_nolog no logfile exists, attemtping to create..
    log_create || sudo log_create || (echo logfile creation failed! && exit 1)
    fi
    if [ ! -w $LOGFILE ]; then
    #msg_info_nolog logfile not writable, attempting to chmod..
    log_setW || sudo log_setW || (echo setting +w on logfile failed! && exit 1)
    fi
}
function log_create () {
    touch $LOGFILE >/dev/null 1>/dev/null 2>&1 || (sudo touch $LOGFILE && sudo chown $(whoami) $LOGFILE)
    log_entry ! $LOGFILE - logfile for $0
    log_entry ! logfile created
}
function log_setW () {
    chmod +w $LOGFILE
}
function log_entry () {
    echo "$(date +%Y-%m-%d/%H:%M:%S): $@"  >>$LOGFILE
}
function file_check () {
    if [ ! -e $INFOFILE ]; then
        log_entry error: no infofile to read!
        exit 1
    fi
}
function msg_error () {
    #zenity --error --text="error: ${*}"
    notify-send -t 12000 -c error,warning "feil: " "${*}"
    log_entry "feil: ${*}"
    exit 1
}
function msg_info () {
    #zenity --info --text="${*}"
    notify-send -t 12000 -c info,message,msg "melding: " "${*}"
    log_entry "melding: ${*}"
}

log_check
file_check
PKGS="$(<$INFOFILE)"

if [ "$PKGS" -eq 0 ]; then
    log_entry no new packages
elif [ "$PKGS" -eq 1 ]; then
    msg_info 1 new package available!
elif [ "$PKGS" -gt 1 ]; then
    msg_info $PKGS new packages available!
else
    msg_error out of cheese!
    exit 1
fi
