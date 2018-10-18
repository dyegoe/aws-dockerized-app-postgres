# Project

## Application

The application to deploy is a copy from [NodeJam in Flask](https://github.com/komarserjio/notejam/tree/master/flask) and its source code is under `src/`.

It has some adjustments to work on this infrastructure:

- On source code:
  - `nodejam/config.py` to use environment vars and postgres database.
  - `runserver.py` include `db.create_all()` to create on docker launch.
  - `nodejam/views.py` include `/health` route for load balancer.

- Include a Dockerfile to test and build the image.

### Env vars

These vars are needed to run the container.

- NOTEJAM_SECRET_KEY
- DB_USER
- DB_PASSWORD
- DB_HOST
- DB_NAME

## Requirements for execution

This project was tested using a ubuntu 18.04 as workstation/desktop

### Inventory

You **must** keep the `inventories/inventory.conf` as default.

### Group Vars

Inside the `group_vars/` directory, you can find an example file. You must copy/move/rename it to `all.yml` after run the playbook. Further, you must configure vars there **before** run playbook.

```yaml
---
aws_access_key_id: put-here-your-access-key
aws_secret_access_key: put-here-your-secret-key
aws_region: us-east-1
project_name: notejam
vpc_cidr: 10.10.0.0/16
vpc_subnets_count: 2
instance_type: t3.micro
instance_app_count: 2
db_user: db_user
db_password: db_password
db_name: db_name
db_instance: db.t2.small
db_instance_count: 1
notejam_secret: you-can-put-anything-as-you-want
```

### Terraform binary

You must have `terraform` in your computer. [Download it](https://www.terraform.io/downloads.html)

### Python virtual env

```text
dyego@ubuntu:~/dyego-alexandre-eugenio$ sudo apt install python-pip python-virtualenv
dyego@ubuntu:~/dyego-alexandre-eugenio$ virtualenv -p /usr/bin/python3 ~/python3-ansible
dyego@ubuntu:~/dyego-alexandre-eugenio$ source ~/python3-ansible/bin/activate
(python3-ansible) dyego@ubuntu:~/dyego-alexandre-eugenio$ pip install -r ansible/requirements.txt
```

### To run the playbook

```text
(python3-ansible) dyego@dyego:~/dyego-alexandre-eugenio/ansible/$ ansible-playbook -i inventories/inventory.conf deploy_infra.yml
```

### To destroy

```text
(python3-ansible) dyego@dyego:~/dyego-alexandre-eugenio/ansible/$ ansible-playbook -i inventories/inventory.conf destroy_infra.yml
```

## Coverage

### deploy_infra.yml

- Create a pair of ssh keys.
- Apply a terraform infrastructure
- Create a inventory file `inventories/deploy_inventory.cfg` with the terraform outputs.

### Terraform

It creates the AWS infrastructure.

- Key pair
- User to login to ECR
- VPC
  - 2 public subnets
  - IPv4 auto assignment
- SSH security group
- Instances with docker
- Bucket for logs
- ECR
- Application Load Balancer
- DB Instance (RDS)

### destroy_infra.yml

- Destroy a terraform infrastructure.