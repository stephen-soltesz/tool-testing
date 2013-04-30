#!/bin/bash

if [ -z ${HOSTNAME} ] ; then
    echo "Hi. We need 'HOSTNAME' set in the envirnment to run this test."
    echo "Good bye."
    exit 1
fi

BUILD_DIR=${BUILD_DIR:-$PWD}

$BUILD_DIR/build/bin/web100clt -n ${HOSTNAME} -p 3001 > testrun.log
