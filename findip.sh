#!/bin/bash
#       findip.sh
#
#       Copyright 2010 Stæld <staeld@staeld.co.cc>
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.

# findip.sh - Geolocate the given IP address(es) or hostmasks

URL='http://www.geobytes.com/IpLocator.htm?GetLocation&template=php3.txt&IpAddress='
ipFile=/tmp/ipInfo

function resolveHost () {
    number=0
    for i in "$(nslookup $hostName | grep -A 1 -P '^Name:' | grep -P '^Address:')"; do
        IP=([$number]=$(nslookup $hostName | grep -A 1 -P "^Name:" | grep -P "^Address:" | sed -e 's,^.*: ,,'))
        let number=$number+1
    done
}

function findInfo () {
    grep "\"$1\"" $ipFile | sed -e 's,^.*t=",,' -e 's,">,,'
}
function getInfo () {
    locCode="$(findInfo locationcode)"
    country="$(findInfo country)"
    city="$(findInfo city)"
    timeZone="$(findInfo timezone)"
    certainty="$(findInfo certainty)"
}
function presentInfo () {
    echo "Location code: $locCode"
    echo "Country:       $country"
    echo "City:          $city"
    echo "Time zone:     $timeZone"
    echo "Certainty:     $certainty"
}

if [ -n "$1" ]; then
    IP=$(echo $1 | sed -e 's,.*@,,')
else
    echo -n 'IP: '
    read IP
fi

if [ -n "$(echo $IP | grep -P '[a-zA-Z]')" ]; then
    hostName="$IP"
    resolveHost
    echo Resolved hosts: ${IP[*]}
fi

ipNum=0
for ip in ${IP[*]}; do
    let ipNum=$ipNum+1
    echo
    echo IP nr. $ipNum
    wget -q -O $ipFile ${URL}$ip
    if [ -z "$(grep 'true' $ipFile)" ]; then
        echo IP \'$ip\' not found/known!
    else
        getInfo
        presentInfo
    fi
    rm $ipFile
done
exit 0
#EOF
