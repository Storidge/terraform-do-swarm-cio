#!/bin/bash
SSH_USER=$1
SSH_ADDRESS=$2
PRIVATE_ADDRESS=$3

SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

sleep 20
scp ${SSH_OPTIONS} sds_key ${SSH_USER}@${SSH_ADDRESS}:sds_key.pem
command="$(cat storidge.token | grep join) --ip ${PRIVATE_ADDRESS}"
ssh ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS} "${command}"
