#!/usr/bin/env bash
config.section.CINDER

conf=$(run conf/cinder/gen-conf.sh)
run_scp $conf root@$ext_ip:/etc/cinder/cinder.conf
