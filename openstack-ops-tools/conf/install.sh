#!/usr/bin/env bash
source base.sh
include_func utils/conf-helper.sh
config_parser "env.ini"
config.section.DEFAULT
config_parser "service.ini"

#TODO
IFS=', *' read -ra hs <<< "$hosts"

for host in "${hs[@]}"
do
    config.section.$host
    config.section.$type
    IFS=', *' read -ra modules <<< "$install_modules"
    for m in "${modules[@]}"
    do
        IFS=', *' read -ra services <<< ${!m}
        #run conf/$m/install.sh
    done

    printf_info "config rsyslog"
    run conf/rsyslog/install.sh
    #TODO need fix
    ssh root@$ext_ip "systemctl restart rsyslog"
    printf_info "done"

    printf_info "restarting services"
    #bash_run utils/ssh-sh.sh $ext_ip $(base_dir op-ser.sh) $type restart
    printf_info "done"
done

