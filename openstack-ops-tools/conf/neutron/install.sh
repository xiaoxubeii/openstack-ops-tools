#!/usr/bin/env bash
config.section.NEUTRON

if [ "$type" = "controller" -o "$type" = "api" ];then
    conf_type="controller"
else
    conf_type="compute"
fi

conf=$(run conf/neutron/gen-conf.sh "$conf_type")
run_scp $conf root@$ext_ip:/etc/neutron/neutron.conf

if [ "$type" = "controller" ];then
    conf=$(run conf/neutron/gen-conf.sh "ml2_conf")
    run_scp $conf root@$ext_ip:/etc/neutron/plugins/ml2/ml2_conf.ini
fi

for service in "${services[@]}"
do
    case $service in
    "metadata_agent"|"l3_agent" )
        conf=$(run conf/neutron/gen-conf.sh "$service")
        run_scp $conf root@$ext_ip:/etc/neutron/$service.ini
        ;;
    "dhcp_agent" )
        conf=$(run conf/neutron/gen-conf.sh "dhcp_agent")
        run_scp $conf root@$ext_ip:/etc/neutron/dhcp_agent.ini

        conf=$(run conf/neutron/gen-conf.sh "dnsmasq-neutron")
        run_scp $conf root@$ext_ip:/etc/neutron/dnsmasq-neutron.conf
        ;;
    esac
done
