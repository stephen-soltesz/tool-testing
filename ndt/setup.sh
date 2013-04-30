#!/bin/bash

BUILD_DIR=$PWD
SOURCE_DIR=$PWD

NDTFILE=ndt-3.6.5.1.tar.gz
WEBFILE=web100_userland-1.8.tar.gz
if ! test -f $NDTFILE ; then
    wget https://ndt.googlecode.com/files/$NDTFILE
    tar -zxvf $NDTFILE
fi
if ! test -f $WEBFILE ; then
    wget http://www.web100.org/download/userland/version1.8/$WEBFILE
    tar -zxvf $WEBFILE
fi

if ! test -e $SOURCE_DIR/build/lib/libI2util.a ; then
    svn checkout -r 216 http://anonsvn.internet2.edu/svn/I2util/trunk/ I2util
    pushd $SOURCE_DIR/I2util/
        ./bootstrap.sh 
        ./configure --prefix=$BUILD_DIR/build
        make
        make install
    popd 
fi

if ! test -e $SOURCE_DIR/build/lib/libweb100.a ; then
    chmod 755 $SOURCE_DIR/${WEBFILE%%.tar.gz}
    pushd $SOURCE_DIR/${WEBFILE%%.tar.gz}
        ./configure --prefix=$BUILD_DIR/build  --disable-gtk2 --disable-gtktest
        make
        make install
    popd
fi

pushd $SOURCE_DIR/${NDTFILE%%.tar.gz}
    export CPPFLAGS="-I$BUILD_DIR/build/include -I$BUILD_DIR/build/include/web100"
    export LDFLAGS="-L$BUILD_DIR/build/lib"
    ./configure --prefix=$BUILD_DIR/build --with-I2util=$BUILD_DIR/build/.
    make || :  # this will break b/c the java Applet and janalyze need special treatment..
    make install || :
    #pushd Applet
    #    javac -source 1.4 *.java 
    #popd
    #pushd janalyze
    #    make JAVACFLAGS="-source 1.5"
    #popd
    #make install   # should not break now b/c of the earlier steps 
popd

