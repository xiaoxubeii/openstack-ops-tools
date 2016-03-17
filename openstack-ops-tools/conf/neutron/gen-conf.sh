#!/usr/bin/env bash
function gen_config {
    case "$1" in
    "dhcp_agent" )
        sed -e "s#\$state_path#$state_path#g" $(conf_base_dir neutron/dhcp-agent.ini.sample) > $(conf_base_dir neutron/$host-dhcp-agent.ini)
        echo $(conf_base_dir neutron/$host-dhcp-agent.ini)
        ;;
    "dnsmasq-neutron" )
        cp $(conf_base_dir neutron/dnsmasq-neutron.conf.sample) $(conf_base_dir neutron/$host-dnsmasq-neutron.conf)
        echo $(conf_base_dir neutron/$host-dnsmasq-neutron.conf)
        ;;
    "metadata_agent" )
        sed -e "s/\$vip/$vip/g" -e "s#\$state_path#$state_path#g" $(conf_base_dir neutron/metadata-agent.ini.sample) > $(conf_base_dir neutron/$host-metadata-agent.ini)
        echo $(conf_base_dir neutron/$host-metadata-agent.ini)
        ;;
    "l3_agent" )
        sed -e "s#\$state_path#$state_path#g" $(conf_base_dir neutron/l3-agent.ini.sample) > $(conf_base_dir neutron/$host-l3-agent.ini)
        echo $(conf_base_dir neutron/$host-l3-agent.ini)
        ;;
    "ml2_conf" )
        sed -e "s/\$local_ip/$local_ip/g" $(conf_base_dir neutron/ml2-conf.ini.sample) > $(conf_base_dir neutron/$host-ml2-conf.ini)
        echo $(conf_base_dir neutron/$host-ml2-conf.ini)
        ;;
    "compute" )
        sed -e "s/\$vip/$vip/g" \
            -e "s/\$rabbit_hosts/$rabbit_hosts/g" \
            -e "s#\$log_dir#$log_dir#g" \
            -e "s#\$state_path#$state_path#g" $(conf_base_dir neutron/com-neutron.conf.sample) > $(conf_base_dir neutron/$host-com-neutron.conf)
            echo "$(conf_base_dir neutron/$host-com-neutron.conf)"
        ;;
    "controller" )
        rabbit_hosts=$(echo $(printf "localhost:5672, %s" "$rabbit_hosts") | sed -e "s/$host_ip:[0-9]*, *//g")
        sed -e "s/\$vip/$vip/g" \
            -e "s/\$rabbit_hosts/$rabbit_hosts/g" \
            -e "s/\$dhcp_agents_per_network/$dhcp_agents_per_network/g" \
            -e "s/\$l3_ha/$l3_ha/g" \
            -e "s/\$max_l3_agents_per_router/$max_l3_agents_per_router/g" \
            -e "s/\$min_l3_agents_per_router/$min_l3_agents_per_router/g" \
            -e "s#\$log_dir#$log_dir#g" \
            -e "s#\$state_path#$state_path#g" $(conf_base_dir neutron/con-neutron.conf.sample) > $(conf_base_dir neutron/$host-con-neutron.conf)
            echo "$(conf_base_dir neutron/$host-con-neutron.conf)"
        ;;
    esac
}

gen_config $1
