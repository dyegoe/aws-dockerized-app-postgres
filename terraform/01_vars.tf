variable "aws_access_key_id" {}

variable "aws_secret_access_key" {}

variable "region" {
  default = "eu-west-1"
}

variable "public_key" {}

variable "project_name" {
  default = "aws-sg-docker"
}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "subnet1_cidr" {
  default = "10.10.1.0/24"
}

variable "subnet2_cidr" {
  default = "10.10.2.0/24"
}

variable "amis" {
  type = "map"
  default = {
    "ap-south-1" = "ami-0912f71e06545ad88"
    "eu-west-3" = "ami-0ebc281c20e89ba4b"
    "eu-west-2" = "ami-f976839e"
    "eu-west-1" = "ami-047bb4163c506cd98"
    "ap-northeast-2" = "ami-0a10b2721688ce9d2"
    "ap-northeast-1" = "ami-06cd52961ce9f0d85"
    "sa-east-1" = "ami-07b14488da8ea02a0"
    "ca-central-1" = "ami-0b18956f"
    "ap-southeast-1" = "ami-08569b978cc4dfa10"
    "ap-southeast-2" = "ami-09b42976632b27e9b"
    "eu-central-1" = "ami-0233214e13e500f77"
    "us-east-1" = "ami-0ff8a91507f77f867"
    "us-east-2" = "ami-0b59bfac6be064b78"
    "us-west-1" = "ami-0bdb828fd58c52235"
    "us-west-2" = "ami-a0cfeed8"
  }
}

variable "instance_type" {
  default = "t3.micro"
}

locals {
  common_tags = {
    Project = "${var.project_name}"
    Environment = "production"
  }
}