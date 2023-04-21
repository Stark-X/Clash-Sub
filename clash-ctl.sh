#!/bin/bash

SUB_URL=""
root_path="/share/Container/clash"


__ScriptVersion="0.1"

#===  FUNCTION  ================================================================
#         NAME:  usage
#  DESCRIPTION:  Display usage information.
#===============================================================================
function usage ()
{
    echo "Usage :  $0 [options] [--] <action>

    Options:
    -h|help       Display this message
    -v|version    Display script version

    Action:
    check         Check if clash working fine, if not working fine, will proform a update action
    update        Update config file
    "
}    # ----------  end of function usage  ----------

check () {
    echo '[INFO] Checking Clash'
    http_status=`curl -sI -X GET localhost:9090 | head -1 | cut -d ' ' -f 2`
    if [[ ${http_status} != 200 ]]; then
        >&2 echo '[ERROR] Clash is not working'
        return 1
    else
        echo '[INFO] Clash is working fine'
    fi
}

update () {
    echo '[INFO] Updating Clash config'
    wget -O ${root_path}/config.yml "http://localhost:25500/sub?target=clash&url=${SUB_URL}&config=https%3A%2F%2Fjihulab.com%2FStark-X%2Fclash-sub%2F-%2Fraw%2Fmaster%2FremoteConfigs%2Fdefault.ini&filename=config.yml&emoji=true&list=false&udp=true&tfo=false&scv=false&fdn=false&sort=true"

    #sed -i '1imixed-port: 7890' ${root_path}/config.yml
    #sed -i 's/^port: 7890/port: 0/' ${root_path}/config.yml

    docker compose restart clash
}


#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

while getopts ":hv" opt
do
  case $opt in

    h|help     )  usage; exit 0   ;;

    v|version  )  echo "$0 -- Version $__ScriptVersion"; exit 0   ;;

    * )  echo -e "\n  Option does not exist : $OPTARG\n"
          usage; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

if [[ $1 == 'check' ]]; then
    check
    if [[ $? == 1 ]]; then
        update
    fi
elif [[ $1 == 'update' ]]; then
    update
else
    usage
fi

