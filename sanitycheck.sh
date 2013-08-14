#!/usr/bin/env bash


function check_port () {
    local hostname=$1
    local port=$2
    nc -z $hostname $port > /dev/null
}

function error () {
    echo "ERROR"
}
function ok () {
    echo "PASS"
}

function check () {
    local hostname=$1
    local port=$2
    echo -n "$hostname:$port - "
    (check_port $hostname $port && ok ) || error
}

HOST=${1:?arg1 missing: <hostname>}
HOST=$HOST.measurement-lab.org

# SSH
check $HOST 22
check $HOST 806

# NDT
# rsync port:   7999
# server port:  3001
# fakeweb port: 7123
for port in 7999 3001 7123 ; do
    check ndt.iupui.$HOST $port
done
/usr/bin/rsync -4 --port=7999  rsync://ndt.iupui.$HOST

# NPAD
# rsync port:   7999
# server port:  8001
# web port:     8000
for port in 7999 8001 8000 ; do
    check npad.iupui.$HOST $port
done
/usr/bin/rsync -4 --port=7999  rsync://npad.iupui.$HOST


