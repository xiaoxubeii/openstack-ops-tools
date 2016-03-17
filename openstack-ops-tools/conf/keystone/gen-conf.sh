#!/usr/bin/env bash
function gen_config {
    sed -e "s/\$vip/$vip/g" -e "s/\$my_ip/$host_ip/g" \
        -e "s#\$log_dir#$log_dir#g" \
        -e "s/\$servers/$servers/g" $(conf_base_dir keystone/keystone.conf.sample) > $(conf_base_dir keystone/$host-keystone.conf)
        echo "$(conf_base_dir keystone/$host-keystone.conf)"
}

gen_config
