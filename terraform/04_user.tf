resource "aws_iam_user" "asg_user" {
  name = "asg_user"
  path = "/system/"
}

resource "aws_iam_access_key" "asg_user" {
  user = "${aws_iam_user.asg_user.id}"
}

resource "aws_iam_user_policy" "asg_user" {
  name = "asg_user_policy"
  user = "${aws_iam_user.asg_user.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetRepositoryPolicy",
            "ecr:DescribeRepositories",
            "ecr:ListImages",
            "ecr:BatchGetImage"
        ],
        "Resource": [ "*" ]
    }
  ]
}
EOF
}

output "aws_access_key_id" {
  value = "${aws_iam_access_key.asg_user.id}"
}

output "aws_secret_access_key" {
  value = "${aws_iam_access_key.asg_user.secret}"
}
