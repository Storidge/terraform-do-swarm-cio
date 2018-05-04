#!/bin/bash
SSH_USER=$1
SSH_ADDRESS=$2
PRIVATE_ADDRESS=$3

SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

rm -f ./sds_key*
rm storidge.token
ssh-keygen -f ./sds_key -N ''
sleep 20
ssh ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS} "cioctl create --ip ${PRIVATE_ADDRESS} > storidge.token"
ssh-copy-id ${SSH_OPTIONS} -i ./sds_key ${SSH_USER}@${SSH_ADDRESS}
#scp ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS}:worker.token .
#scp ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS}:manager.token .
scp ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS}:storidge.token .
