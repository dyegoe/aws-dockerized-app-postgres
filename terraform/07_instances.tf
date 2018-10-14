data "template_file" "aws_credentials" {
  template = <<EOF
[default]
aws_access_key_id = $${aws_access_key_id}
aws_secret_access_key = $${aws_secret_access_key}
  EOF
  vars {
    aws_access_key_id = "${aws_iam_access_key.asg_user.id}"
    aws_secret_access_key = "${aws_iam_access_key.asg_user.secret}"
  }
}

data "template_file" "aws_config" {
  template = <<EOF
[profile default]
region = $${aws_region}
output = json
  EOF
  vars {
    aws_region = "${var.region}"
  }
}

data "template_file" "cloud_init" {
  template = <<EOF
#cloud-config",
repo_update: true
repo_upgrade: all

packages:
  - docker
  - aws-cli

write_files:
  - encoding: b64
    content: $${aws_config}
    owner: root:root
    path: /root/.aws/config
    permissions: '0600'
  - encoding: b64
    content: $${aws_credentials}
    owner: root:root
    path: /root/.aws/credentials
    permissions: '0600'

runcmd:
  - chkconfig docker on
  - service docker restart
  - curl -L https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker
  - $(aws ecr get-login --no-include-email)
EOF
  vars {
    aws_config = "${base64encode("${data.template_file.aws_config.rendered}")}"
    aws_credentials = "${base64encode("${data.template_file.aws_credentials.rendered}")}"
  }
}

data "template_cloudinit_config" "user_data" {
  part {
    content = "${data.template_file.cloud_init.rendered}"
  }
}

resource "aws_instance" "app1" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.public-a.id}"
  key_name = "${aws_key_pair.default.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
  user_data = "${data.template_cloudinit_config.user_data.rendered}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-lt"
    )
  )}"
  lifecycle {
    create_before_destroy = true
  }
}