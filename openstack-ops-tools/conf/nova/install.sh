#!/usr/bin/env bash
config.section.NOVA

if [ "$type" = "controller" -o "$type" = "api" ];then
    conf_type="controller"
else
    conf_type="compute"
fi

conf=$(run conf/nova/gen-conf.sh "$conf_type")
run_scp $conf root@$ext_ip:/etc/nova/nova.conf

