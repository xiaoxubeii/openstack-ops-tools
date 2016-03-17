#!/usr/bin/env bash

function gen_config {
    case $1 in
    "api" )
        sed -e "s/\$vip/$vip/g" -e "s/\$my_ip/$host_ip/g" \
            -e "s#\$log_dir#$log_dir#g" \
            -e "s#\$filesystem_store_datadir#$filesystem_store_datadir#g" \
            -e "s#\$state_path#$state_path#g" $(conf_base_dir glance/glance-api.conf.sample) > $(conf_base_dir glance/$host-glance-api.conf)
            echo "$(conf_base_dir glance/$host-glance-api.conf)"
            ;;
    "registry" )
        sed -e "s/\$vip/$vip/g" -e "s/\$my_ip/$host_ip/g" \
            -e "s#\$log_dir#$log_dir#g" \
            -e "s#\$filesystem_store_datadir#$filesystem_store_datadir#g" \
            -e "s#\$state_path#$state_path#g" $(conf_base_dir glance/glance-registry.conf.sample) > $(conf_base_dir glance/$host-glance-registry.conf)
            echo "$(conf_base_dir glance/$host-glance-registry.conf)"
            ;;
    esac
}

gen_config $1
