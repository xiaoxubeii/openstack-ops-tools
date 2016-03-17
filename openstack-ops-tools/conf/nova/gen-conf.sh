#!/usr/bin/env bash
function gen_config {
    case $1 in
    "compute" )
        sed -e "s/\$vip/$vip/g" -e "s/\$my_ip/$host_ip/g" \
            -e "s/\$ext_vip/$ext_vip/g" \
            -e "s/\$rabbit_hosts/$rabbit_hosts/g" \
            -e "s#\$log_dir#$log_dir#g" \
            -e "s#\$state_path#$state_path#g" $(conf_base_dir nova/com-nova.conf.sample) > $(conf_base_dir nova/$host-com-nova.conf)
            echo "$(conf_base_dir nova/$host-com-nova.conf)"
            ;;
    "controller" )
        rabbit_hosts=$(echo $(printf "localhost:5672, %s" "$rabbit_hosts") | sed -e "s/$host_ip:[0-9]*, *//g")
        sed -e "s/\$vip/$vip/g" -e "s/\$my_ip/$host_ip/g" \
            -e "s/\$ext_vip/$ext_vip/g" \
            -e "s/\$rabbit_hosts/$rabbit_hosts/g" \
            -e "s#\$log_dir#$log_dir#g" \
            -e "s#\$state_path#$state_path#g" $(conf_base_dir nova/con-nova.conf.sample) > $(conf_base_dir nova/$host-con-nova.conf)
            echo "$(conf_base_dir nova/$host-con-nova.conf)"
            ;;
    esac
}

gen_config $1
