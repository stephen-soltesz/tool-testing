#!/bin/bash

if [ -z ${HOSTNAME} ] ; then
    echo "Hi. We need 'HOSTNAME' set in the envirnment to run this test."
    echo "Good bye."
    exit 1
fi

BUILD_DIR=${BUILD_DIR:-$PWD}
IP=`python -c 'import socket; print socket.gethostbyname('${HOSTNAME}')'`
$BUILD_DIR/prober -n ${IP}  > testrun.log
