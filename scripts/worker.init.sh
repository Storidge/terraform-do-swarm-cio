#!/bin/bash
SSH_USER=$1
SSH_ADDRESS=$2
PRIVATE_ADDRESS=$3
SSH_ADDRESS_SDS=$4

SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# TODO: wait for ssh to become available
sleep 30

jointoken="$(ssh ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS_SDS} 'cioctl join-token | grep "cioctl node add"')"
if [ $? -ne 0 ]; then
    echo "no cluster yet adding node to initial config..."
    echo "${jointoken}"
    scp ${SSH_OPTIONS} sds_key ${SSH_USER}@${SSH_ADDRESS}:sds_key.pem
    command="$(cat storidge.token | grep 'cioctl join') --ip ${PRIVATE_ADDRESS}"
    ssh ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS} "${command}"
else
    echo "adding node to existing cluster... ${jointoken}"
    scp ${SSH_OPTIONS} sds_key ${SSH_USER}@${SSH_ADDRESS}:sds_key.pem
    command="${jointoken} --ip ${PRIVATE_ADDRESS}"
    ssh ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS} "${command}"
fi

# TODO: remove net-error status node if there is no corresponding droplet to private IP after scaling down
# leavetoken="$(ssh ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS_SDS} 'cio node ls | grep "net-error"')"
