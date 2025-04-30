#!/bin/bash
set -e
cd ../terraform

IPS=$(terraform output -json instance_ips | jq -r '.[]')
COUNTER=0
echo "[all]"
for ip in $IPS; do
  ((COUNTER++))
  echo "vm$COUNTER ansible_host=$ip ansible_user=admin ansible_ssh_private_key_file=~/.ssh/id_dev"
done