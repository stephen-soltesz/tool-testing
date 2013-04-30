#!/bin/bash

SOURCE_DIR=${SOURCE_DIR:-$PWD}
BUILD_DIR=${BUILD_DIR:-$PWD}

FILE=shaperprobe.tgz
if ! test -d ${FILE%%.tgz} ; then
    wget http://www.cc.gatech.edu/~partha/diffprobe/$FILE
    tar -zxvf $FILE
fi
pushd $SOURCE_DIR/${FILE%%.tgz} 
    patch -p0 < $SOURCE_DIR/prober.c.diff 
    make
    cp prober $BUILD_DIR
popd
