#!/bin/bash

## Provision a RHEL/Centos or Ubuntu instance in AWS
ARGCOUNT="$#"
SKIP=0

# Usage
function Usage {
echo "Usage: $(basename $0) -o LINUX_DISTRO_NAME[rhel|centos|ubuntu] -i IPADDRESS"
exit 1
}

# Prompt user for confirmation before launching the instance
function updateinput {
read -p "IP address: " newipaddress
export IPADDRESS=$newipaddress
return 0
}
if [ "$ARGCOUNT" -eq 0 ]; then
  MYDISTRO=${MYDISTRO-"ubuntu"}
  IMAGEID=${IMAGEID-"ami-d05e75b8"}
  MYUSER=${MYUSER-"ubuntu"}
  IPADDRESS=${MANPATH-"192.168.2.9"}
  MYPLAYBOOK='provision_ubuntu.yml'
  SKIP=1
  else
  IPADDRESS=${MANPATH-"192.168.2.9"}
fi

if [ "$SKIP" -ne 1 ]; then

  while getopts ":o:i:h" opt; do
  case $opt in
    o)
       MYDISTRO=$OPTARG
       echo "${MYDISTRO}" | grep -q -i -P '(\s+)?(rhel|redhat|centos|ubuntu)(\s+)?$'
       if [ "$?" -ne 0 ]; then Usage; fi
       ;;
    i)
       IPADDRESS=$OPTARG
       ;;
    \?)
       echo "Invalid option: -$OPTARG"
       Usage
       ;;
    h)
       echo "This help output." >&2
       Usage
       ;;
    esac
  done
fi
## If RHEL, let us set set the image ID and user name
echo "$MYDISTRO" | grep -q -i -P '(\s+)?(rhel|redhat|centos)(\s+)?$' 
[[ $? -eq 0 ]] && { IMAGEID='ami-90248af8' ; MYUSER='cloud-user'; MYPLAYBOOK='provision_centos.yml' ; }
echo "$MYDISTRO" | grep -q -i -P '(\s+)?(ubuntu)(\s+)?$'
[[ $? -eq 0 ]] && { IMAGEID='ami-d05e75b8' ; MYUSER='ubuntu' ; MYPLAYBOOK='provision_ubuntu.yml' ;}
## Provision
echo "We will provision an EC2 with the following specification."
echo "Linux Distro: $MYDISTRO"
echo "IP address: $IPADDRESS"
echo "Image ID:  $IMAGEID"
echo 
response=''

read  -p "Press [Y|YES] to continue. or [U|UPDATE] to change IP.  " response

if [ "$response" = 'Y' -o "$response" = 'YES' ]; then
  echo "Provisioning in progress .... "
elif [ "$response" = 'U' -o "$response" = 'UPDATE' ]; then
  updateinput
else
  echo "Interrupted provisioning."
  exit 1
fi
##vars
PRIVKEY='aws.pem'

export imageid="$IMAGEID"
export private_ip="$IPADDRESS"
DEPLOY_CMD="ansible-playbook ${MYPLAYBOOK} --private-key=${PRIVKEY} -v --extra-vars='imageid=${IMAGEID} private_ip=${IPADDRESS}'"

echo "${DEPLOY_CMD}"  | bash
