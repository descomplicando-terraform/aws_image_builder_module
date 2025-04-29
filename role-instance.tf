data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "instance_role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

data "aws_iam_policy_document" "instance_policy" {
  statement {
    effect = "Allow"
    actions = [
      "inspector2:*"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [aws_s3_bucket.this.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      var.github_token_secret_arn,
    ]
  }
}

resource "aws_iam_policy" "instance_policy" {
  name        = "image-builder-instance-policy-${var.name}"
  description = "Policy to allow the temporary instance to access the required resources"
  policy      = data.aws_iam_policy_document.instance_policy.json
}

resource "aws_iam_role_policy_attachment" "instance_policy" {
  role       = aws_iam_role.instance.name
  policy_arn = aws_iam_policy.instance_policy.arn
}

resource "aws_iam_role_policy_attachment" "core" {
  count = length(local.core_iam_policies)

  policy_arn = local.core_iam_policies[count.index]
  role       = aws_iam_role.instance.name
}

resource "aws_iam_instance_profile" "example" {
  name = "image-builder-instance-profile-${var.name}"
  role = aws_iam_role.instance.name
}