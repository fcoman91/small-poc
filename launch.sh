#!/bin/bash

function usage
{
  echo -e "\nUsage: $(basename $0) <option>, where <option> is one of the below:
  -w <number> - number of web servers to provisioned
  -i <interface> - interface on guest host where VirtualBox is installed that will be used as bridge for the provisioned machines
  -n <partial network address> - the first three octets of the network to be used for provisioned machines
  -s <partial network address> - 4th octet for the network to be used for web machines, incremental values of +1 will be used
  -l <partial network address> - 4th octet for the network to be used for nginx machine

  Note: ALL ARGUMENTS ARE MANDATORY !!!

  Example of using: bash $(basename $0) -w 2 -i \"wlp3s0\" -n \"192.168.100.\" -s 100 -l 200"

  exit
}

while getopts "w:i:n:s:l:" option
do
    case $option in
    w) web_count=$OPTARG ;;
    i) interface=$OPTARG ;;
    n) network=$OPTARG ;;
    s) web_start_ip=$OPTARG ;;
    l) lb_ip=$OPTARG ;;
    *) usage ;;
    esac
done

# Check validity of arguments
if [[ $# -eq 0 ]]
then
    usage
fi
if [[ ! $web_count || ! $interface || ! $network || ! $web_start_ip || ! $lb_ip ]]
then
    usage
fi

# Replace values given as input in Vagrantfile
sed -i "s/^WEB_COUNT.*/WEB_COUNT = $web_count/" $PWD/Vagrantfile
sed -i "s/^INTERFACE.*/INTERFACE = \"$interface\"/" $PWD/Vagrantfile
sed -i "s/^NETWORK.*/NETWORK = \"$network\"/" $PWD/Vagrantfile
sed -i "s/^WEB_START_IP.*/WEB_START_IP = $web_start_ip/" $PWD/Vagrantfile
sed -i "s/^LB_IP.*/LB_IP = $lb_ip/" $PWD/Vagrantfile

# Add appropriate path for SSH public key
sed -i "s|^SRC_PUB_KEY.*|SRC_PUB_KEY = \"$HOME/\.ssh/id_rsa.pub\"|" $PWD/Vagrantfile

echo -e "\nGenerate SSH key pair for \"$USER\" user"
ssh-keygen -q -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa

echo -e "\nProvision and configure web and nginx servers via Vagrant and Ansible"
vagrant up