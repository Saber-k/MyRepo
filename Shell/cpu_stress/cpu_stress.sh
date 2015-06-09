#!/bin/sh

# Script generates a 100% CPU usage and after a specific time it stops.
# 
# Mateusz Szablak
# 2015/06/08
#
# v1.0 - Initial release [2015/06/08]
# v1.1 - Multiple instances, logging improved, trace logging [2015/06/09]

ENABLE_TRACE_LOGGING=true

start_loop() {
  while : ; do : ; done
}

trace_log() {
  $ENABLE_TRACE_LOGGING && echo -e $1
}

log() {
  echo -e $1
}

if [ $ENABLE_TRACE_LOGGING != true ] ; then
  ENABLE_TRACE_LOGGING=false
fi

if [ $# -ne 2 ] ; then
  echo -e "Usage: $0 <instances> <max_running_time>"
  echo -e ""
  echo -e "Script generates a 100% CPU usage and after a specific time it stops."
  echo -e "\t<instances> - number of instances, should be greater than 0"
  echo -e "\t<max_running_time> - number of seconds after which process will be terminated"
  echo -e "\tRunning time is determined by a regex '^[0-9]+[shm]$', where:"
  echo -e "\t\t[0-9]+ - value of a period of the time"
  echo -e "\t\ts - seconds"
  echo -e "\t\tm - minutes"
  echo -e "\t\th - hours"
  echo -e "\tType 'inf' instead of <max_running_time> to run program without a maximum running time"
  exit 0
else
  instances=$1
  echo $instances | egrep -q "^[1-9][0-9]*$"
  if [ $? -ne 0 ] ; then
    log "Wrong 1st input parameter! [$1]"
    exit 0
  fi
  time=$2
  if [ $time = "inf" ] ; then
    for i in `seq ${instances}` ;
      do
        start_loop &
        processPid=$!
        trace_log "[`date`] Started an infinitive loop, PID: $1"
      done
      log "[`date`] All $instances infinitive loops have been started"
    exit 0
  else
    echo $time | egrep -q "^[0-9]+[shm]$"
    if [ $? -ne 0 ] ; then
      log "Wrong 2nd input parameter! [$2]"
      exit 0
    fi
    PIDS=()
    for i in `seq ${instances}` ;
    do
      start_loop &
      processPid=$!
      trace_log "$i) [`date`] Started a loop, PID: $processPid"
      PIDS+=("$processPid")
    done
    log "[`date`] All $instances loops have been started"
    trace_log "[`date`] Exit time: $time"
    sleep $time
    for pid in "${PIDS[@]}"
    do
      kill -9 $pid
      trace_log "[`date`] Loop killed, PID: $pid"
    done
    log "[`date`] All $instances loops have benn stopped"
    exit 0
  fi
fi
