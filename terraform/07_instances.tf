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
    aws_region = "${var.aws_region}"
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
  - pip install docker-py
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

resource "aws_instance" "app" {
  count = "${var.instance_app_count}"
  ami = "${lookup(var.amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  key_name = "${aws_key_pair.default.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
  user_data = "${data.template_cloudinit_config.user_data.rendered}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-app-${count.index}"
    )
  )}"
  lifecycle {
    create_before_destroy = true
  }
}

output "aws_instance_app_private_ip" {
  value = ["${aws_instance.app.*.private_ip}"]
}

output "aws_instance_app_public_ip" {
  value = ["${aws_instance.app.*.public_ip}"]
}