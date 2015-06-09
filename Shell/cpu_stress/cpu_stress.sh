#!/bin/sh

# Script generates a 100% CPU usage and after a specific time it stops.
# 
# Mateusz Szablak
# 2015/06/08
start_loop() {
  for i in 1; do while : ; do : ; done & done
}

if [ $# -ne 1 ] ; then
  echo -e "Usage: $0 <max_running_time>"
  echo -e "\t<max_running_time> - number of seconds after which process will be terminated"
  echo -e "\tRunning time is determinated by a regex '^[0-9]+[shm]$', where:"
  echo -e "\t\t[0-9]+ - value of a period of the time"
  echo -e "\t\ts - seconds"
  echo -e "\t\tm - minutes"
  echo -e "\t\th - hours"
  echo -e "\tType 'inf' instead of <max_running_time> to run program without a maximum running time"
  exit 0
else
  PARAM1=$1
  if [ $PARAM1 = "inf" ] ; then
	start_loop
	echo -e "[`date`] Started an infinitive loop, PID: $1"
	exit 0
  else
	echo $PARAM1 | egrep -q "^[0-9]+[shm]$"
	if [ $? -eq 0 ] ; then
      start_loop
	  processPid=$!
	  echo -e "[`date`] Started a loop, exit time: $PARAM1, PID: $processPid"
	  sleep $PARAM1
	  kill -9 $processPid
	  echo -e "[`date`] Loop killed, PID: $processPid"
	  exit 0
	else
	  echo -e "Wrong input parameter!"
	fi
  fi
fi



