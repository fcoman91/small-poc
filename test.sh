#!/bin/bash

echo -e "\nCheck ports on services on all provisioned servers via Ansible based on generated inventory file"
ansible-playbook -i $PWD/provisioning/inventory $PWD/provisioning/check.yml
