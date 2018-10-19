resource "aws_iam_user" "ecr_user" {
  name = "ecr_user"
  path = "/system/"
}

resource "aws_iam_access_key" "ecr_user" {
  user = "${aws_iam_user.ecr_user.id}"
}

resource "aws_iam_user_policy" "ecr_user" {
  name = "ecr_user_policy"
  user = "${aws_iam_user.ecr_user.id}"

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

output "aws_iam_access_key_ecr_user_id" {
  value = "${aws_iam_access_key.ecr_user.id}"
}

output "aws_iam_access_key_ecr_user_secret" {
  value = "${aws_iam_access_key.ecr_user.secret}"
}

resource "aws_iam_user" "ec2_profile" {
  name = "ec2_profile"
  path = "/system/"
}

resource "aws_iam_access_key" "ec2_profile" {
  user = "${aws_iam_user.ec2_profile.id}"
}

resource "aws_iam_user_policy" "ec2_profile" {
  name = "ec2_cloudwatch_policy"
  user = "${aws_iam_user.ec2_profile.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "logs:*",
            "Resource": "*"
        }
    ]
}
EOF
}

output "aws_iam_access_key_ec2_cloudwatch_id" {
  value = "${aws_iam_access_key.ec2_profile.id}"
}

output "aws_iam_access_key_ec2_cloudwatch_secret" {
  value = "${aws_iam_access_key.ec2_profile.secret}"
}