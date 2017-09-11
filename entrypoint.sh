#!/bin/sh

: ${SLEEP_LENGTH:=2}
: ${TIMEOUT:=120}

wait_for() {

  CURRENT_WAIT_TIME=0
  echo Waiting for $1 to listen on $2...
  while ! nc -z $1 $2; do
    CURRENT_WAIT_TIME=`expr $CURRENT_WAIT_TIME + $SLEEP_LENGTH`

    if [ ${CURRENT_WAIT_TIME} -lt ${TIMEOUT} ]; then
        echo sleeping; sleep $SLEEP_LENGTH;
        continue
    else
        echo Service $1 never came up on port: $2...
        exit 1
    fi
  done
}

for var in "$@"
do
  host=${var%:*}
  port=${var#*:}
  wait_for $host $port
done
