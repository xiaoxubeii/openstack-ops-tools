#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function rm {
    D=/tmp/$(date +%Y%m%d%H%M%S); mkdir -p $D; mv "$@" $D && echo "moved to $D ok";
}

function include_func {
    source $DIR/$1
}

function run {
    source $DIR/$1 ${@:2}
}

function bash_run {
    bash $DIR/$1 ${@:2}
}

function base_dir {
    echo "$DIR/$1"
}

function conf_base_dir {
    echo "$DIR/conf/$1"
}

function get_rabbit_hosts {
    echo $(printf "localhost:5672, %s" "$rabbit_hosts") | sed -e "s/$host_ip:[0-9]*, *//g"
}

function remove_last_char {
    echo "${1%?}"
}

function run_scp {
    scp ${@:1}
    #echo ${@:1}
}

function clean_conf {
    for f in `ls conf/*/[0-9]*.*`
    do
        rm $f
    done
}

function printf_info {
    printf "############### %s ###############\n" "$1"
}
