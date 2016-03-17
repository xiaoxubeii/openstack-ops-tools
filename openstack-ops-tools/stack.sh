#!/usr/bin/env bash
TOP_DIR=$(cd $(dirname "$0") && pwd)
UTILS_DIR=$TOP_DIR/utils
LIB_DIR=$TOP_DIR/lib

source $TOP_DIR/utils/functions
source $UTILS_DIR/ini_config
source $UTILS_DIR/rootwrap
source $UTILS_DIR/meta_config

source $LIB_DIR/lvm

rm -f $TOP_DIR/.localrc.auto
if [[ -r $TOP_DIR/local.conf ]]; then
    LRC=$(get_meta_section_files $TOP_DIR/local.conf local)
    for lfile in $LRC; do
        if [[ "$lfile" == "localrc" ]]; then
            if [[ -r $TOP_DIR/localrc ]]; then
                warn $LINENO "localrc and local.conf:[[local]] both exist, using localrc"
            else
                echo "# Generated file, do not edit" >$TOP_DIR/.localrc.auto
                get_meta_section $TOP_DIR/local.conf local $lfile >>$TOP_DIR/.localrc.auto
            fi
        fi
    done
fi

source $TOP_DIR/stackrc

source $TOP_DIR/tools/install_prereqs

declare -A PROJECT_VENV
mkdir -p $DEST

source $LIB_DIR/mysql
initialize_mysql
if is_service_enabled mysql; then
    install_database_mysql
fi

source $LIB_DIR/rabbitmq
if is_service_enabled rabbitmq; then
    install_rpc_rabbitmq
fi

source $LIB_DIR/base
stack_install_service base
init_base
start_base

modules=(keystone glance cinder nova neutron)

# source first
for m in "${modules[@]}"; do
    source $LIB_DIR/$m
done

for m in "${modules[@]}"; do
    if is_service_enabled $m; then
        case "$m" in
        "keystone")
            stack_install_service keystone
            configure_keystone
            init_keystone
            systemctl daemon-reload
            start_keystone

            export OS_IDENTITY_API_VERSION=3

            # Set up a temporary admin URI for Keystone
            SERVICE_ENDPOINT=$KEYSTONE_AUTH_URI/v3

            # Setup OpenStackClient token-endpoint auth
            export OS_TOKEN=$SERVICE_TOKEN
            export OS_URL=$SERVICE_ENDPOINT

            create_keystone_accounts
            create_nova_accounts
            create_neutron_accounts
            create_cinder_accounts
            create_glance_accounts

            unset OS_TOKEN OS_URL

            export OS_AUTH_URL=$KEYSTONE_AUTH_URI
            export OS_USERNAME=admin
            export OS_USER_DOMAIN_ID=default
            export OS_PASSWORD=$ADMIN_PASSWORD
            export OS_PROJECT_NAME=admin
            export OS_PROJECT_DOMAIN_ID=default
            export OS_REGION_NAME=$REGION_NAME
            ;;
        *)
            stack_install_service $m
            configure_$m
            init_$m
            systemctl daemon-reload
            start_$m
            ;;
        esac
    fi
done
