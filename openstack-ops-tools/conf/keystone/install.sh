#!/usr/bin/env bash
config.section.KEYSTONE

conf=$(run conf/keystone/gen-conf.sh)
run_scp $conf root@$ext_ip:/etc/keystone/keystone.conf

