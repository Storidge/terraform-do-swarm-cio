#!/bin/bash
SSH_USER=$1
SSH_ADDRESS=$2
PRIVATE_ADDRESS=$3

SSH_OPTIONS="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

command="$(cat storidge.token | grep init)"
ssh ${SSH_OPTIONS} ${SSH_USER}@${SSH_ADDRESS} "${command}"
