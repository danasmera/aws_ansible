# aws_ansible
Provision and configure AWS instances with Ansible.

Requirements - a VPC, VPC subnet ID, Boto - Python library for AWS, Ansible, AWS credentials, ec2.py for pulling dynamic inventory from AWS.

Shell wrapper to provision EC2 instance
-----------------------------

  $ sudo ./provision-ec2.sh -h

  This help output.

  Usage: provision-ec2.sh -o LINUX_DISTRO_NAME[rhel|ubuntu] -i IPADDRESS


Run playbook directly [ not recommended ]
--------------------------------------

  $ sudo ansible-playbook awsplaybook.yml --private-key=aws.pem --extra-vars='imageid=ami-d05e75b8 private_ip=192.168.2.9'  -v

Run only configuration playbook
---------------

  $ ansible-playbook single.yml -i /usr/local/bin/ec2.py --private-key=aws.pem  -v 

Note: This will run against all AWS inventory, make sure to use '--limit' to run it against specific instances.
