#!/usr/bin/env bash
function gen_config {
    case "$1" in
    "server" )
        sed -e "s/\$ext_ip/$ext_ip/g" $(conf_base_dir rsyslog/server.conf.sample) > $(conf_base_dir rsyslog/$host-server.conf)
        echo "$(conf_base_dir rsyslog/$host-server.conf)"
        ;;
    "client" )
        sed -e "s/\$server_ip/$server_ip/g" $(conf_base_dir rsyslog/client.conf.sample) > $(conf_base_dir rsyslog/$host-client.conf)
        echo "$(conf_base_dir rsyslog/$host-client.conf)"
        ;;
    esac
}

gen_config $1
