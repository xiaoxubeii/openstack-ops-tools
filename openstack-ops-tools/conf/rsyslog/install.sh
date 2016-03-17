#!/usr/bin/env bash
config.section.RSYSLOG

if [ "$type" = "monitor" ];then
    conf=$(run conf/rsyslog/gen-conf.sh "server")
    run_scp $conf root@$ext_ip:/etc/rsyslog.d/server.conf
else
    conf=$(run conf/rsyslog/gen-conf.sh "client")
    run_scp $conf root@$ext_ip:/etc/rsyslog.d/client.conf
fi
