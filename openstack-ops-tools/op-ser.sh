#!/usr/bin/env bash
op=$2
n_type=$1

case "$n_type" in

"api") sers='openstack-cinder-api.service openstack-glance-api.service openstack-glance-registry.service openstack-keystone.service openstack-nova-api.service neutron-server.service';;
"compute") sers='openstack-nova-compute neutron-openvswitch-agent';;
"controller") sers='openstack-cinder-api.service openstack-cinder-scheduler.service openstack-cinder-volume.service openstack-glance-api.service openstack-glance-registry.service openstack-keystone.service openstack-nova-api.service openstack-nova-cert.service openstack-nova-conductor.service openstack-nova-consoleauth.service openstack-nova-console.service openstack-nova-novncproxy.service openstack-nova-scheduler.service neutron-dhcp-agent.service neutron-l3-agent.service neutron-metadata-agent.service neutron-openvswitch-agent.service neutron-server.service';;
esac

for i in $sers
do
    if [ $op = "status" ];then
        systemctl status $i|awk -F"\n" 'NR==1||NR==3{print $0 }'
    else
        systemctl $op $i
    fi
done

