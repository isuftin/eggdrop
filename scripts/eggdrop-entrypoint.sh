#!/bin/bash -x

if [ "$1" = 'eggdrop' ]; then

    init_directory="/docker-egg-init.d"

    . configure-eggdrop.sh > eggdrop.conf

    if [ -d "$init_directory" ]; then
        for f in  `ls ${init_directory}/*.sh | sort -n -t _ -k 2`; do
            [ -f "$f" ] && . "$f"
        done
    fi
    
    if [ $(crontab -l | grep -c botchk) -ne 1 ]; then 
        scripts/autobotchk eggdrop.conf -${crontab_check_time:-5} -noemail
    fi
    
    exec "$@"
else
    exec "$@"
fi

