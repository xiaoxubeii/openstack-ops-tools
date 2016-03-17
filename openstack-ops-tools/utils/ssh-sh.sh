#!/usr/bin/env bash
function format_host {
    local host=$1
    if [[ ! "$host" =~ [@] ]]; then
        echo "root@$host"
    else
        echo $host
    fi
}

#TODO cannot accept params like "root@123 root@123" 123
IFS=',' read -ra hosts <<< "$1"
if [ -e "$2" ];then
    sh_file=$2
    if [ $# -gt 2 ];then
        sed_cmd="sed %s $sh_file"
        str=''
        j=1

        for ((i=3;i<=$#;i++))
        do
            str+="-e 's/\$$((j++))/${!i}/g' "
        done

        sed_cmd=$(printf "$sed_cmd" "$str")
        temp_sh=/tmp/$RANDOM.tmp
        bash -c "$sed_cmd > $temp_sh"
        for h in "${hosts[@]}"
        do
            ssh $(format_host $h) bash < $temp_sh
        done
    else
        for h in "${hosts[@]}"
        do
            ssh $(format_host $h) bash < $sh_file
        done
    fi
else
    sh_cmd=$2
    echo $sh_cmd
    for h in "${hosts[@]}"
    do
        ssh $(format_host $h) "$sh_cmd"
    done
fi
