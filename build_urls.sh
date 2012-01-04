#!/bin/bash

#
# I use this script to build all URLs visible by a robot like gooble on a
# specific website. The goal is double : 
# - find unreachable part of website
# - build the full list of URLs for loadtest
#

PID=0

trap end_of_script 1 2 3 6 9 14 15

end_of_script () {
	#We must end the background wget process
	kill -0 $PID 2>/dev/null
	[ $? -eq 0 ] && kill -9 $PID

	[ -n "${1:-}" ] && EXIT="${1}" || EXIT=0
	[ -n "${2:-}" ] && echo "$2" >&2
	exit $EXIT
}

[ -n "${1:-}" ] && URL="${1}" || end_of_script 1 "Missing starting URL : $0 http://example.com"

# For a preprod website you must specify " -e robots=off" to force following of links when meta say "NOFOLLOW"
wget -e robots=off --mirror --spider "$URL" -o log &
PID=$!

COUNT=0
while [ $COUNT -eq 0 ]
do
	sleep 5
	grep "200 OK" -B 2 log | grep "$URL" | sed -e 's?.*http?http?' -e 's/\ .*//g' | sort | uniq \
		| grep -iv "(.jpg|.gif|.js|.css|.png|.zip|.exe|.ico)" \
		> urls.txt
	wc -l urls.txt
	kill -0 $PID 2>/dev/null
	COUNT=$?
done

