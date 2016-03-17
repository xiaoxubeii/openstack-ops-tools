#!/usr/bin/env bash
function gen_config {
    rabbit_hosts=$(get_rabbit_hosts)
    sed -e "s/\$vip/$vip/g" -e "s/\$my_ip/$host_ip/g" \
        -e "s/\$rabbit_hosts/$rabbit_hosts/g" \
        -e "s/\$default_volume_type/$default_volume_type/g" \
        -e "s#\$log_dir#$log_dir#g" \
        -e "s#\$state_path#$state_path#g" $(conf_base_dir cinder/cinder.conf.sample) > $(conf_base_dir cinder/$host-cinder.conf)
        echo "$(conf_base_dir cinder/$host-cinder.conf)"
}

gen_config
