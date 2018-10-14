resource "aws_db_subnet_group" "main" {
  name = "${var.project_name}-rds-sg-main"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-rds-sg-main"
    )
  )}"
}

resource "aws_rds_cluster_instance" "main" {
  count = 2
  identifier = "${var.project_name}-rds-${count.index}"
  cluster_identifier = "${aws_rds_cluster.main.id}"
  instance_class = "${var.db_instance}"
  publicly_accessible = false
  db_subnet_group_name = "${aws_db_subnet_group.main.id}"
  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${var.project_name}-rds-${count.index}"
    )
  )}"
}

resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.project_name}-rds"
  engine = "aurora-postgresql"
  availability_zones = ["${aws_subnet.public.*.availability_zone}"]
  db_subnet_group_name = "${aws_db_subnet_group.main.id}"
  database_name = "${var.db_name}"
  master_username = "${var.db_user}"
  master_password = "${var.db_password}"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  apply_immediately = true
}