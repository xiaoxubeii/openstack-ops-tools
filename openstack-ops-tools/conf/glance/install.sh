#!/usr/bin/env bash
config.section.GLANCE

for service in "${services[@]}"
do
    case $service in
    "api" )
        conf=$(run conf/glance/gen-conf.sh "api")
        run_scp $conf root@$ext_ip:/etc/glance/glance-api.conf
        ;;
    "registry" )
        conf=$(run conf/glance/gen-conf.sh "registry")
        run_scp $conf root@$ext_ip:/etc/glance/glance-registry.conf
        ;;
esac
done
