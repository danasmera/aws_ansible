# aws_ansible
Provision and configure AWS instances with Ansible.

Requirements - a VPC, VPC subnet ID, Boto - Python library for AWS, Ansible, AWS credentials, ec2.py for pulling dynamic inventory from AWS.

Update keyname, instance type, security group, AMI id, VPC subnet id, tag name in playbook. The shell wrapper script can be easily modified to accept these parameters as arguments.

Shell wrapper to provision EC2 instance
-----------------------------

By default, the provision script will launch a tier 2 Ubuntu micro instance. Script will add hostname 'server1' to /etc/hosts on provisioning server.


  $ sudo ./provision-ec2.sh -h

  This help output.

  Usage: provision-ec2.sh -o LINUX_DISTRO_NAME[centos|ubuntu] -i IPADDRESS
  
  Example: sudo ./provision-ec2.sh -o centos -i 192.168.2.10


Run playbook directly [ not recommended ]
--------------------------------------

  $ sudo ansible-playbook awsplaybook.yml --private-key=aws.pem --extra-vars='imageid=ami-d05e75b8 private_ip=192.168.2.9'  -v

Run only configuration playbook for Ubutnu instance
---------------

  $ ansible-playbook single.yml -i /usr/local/bin/ec2.py --private-key=aws.pem  -v 

Note: This will run against all AWS inventory, make sure to use '--limit' to run it against specific instances.
