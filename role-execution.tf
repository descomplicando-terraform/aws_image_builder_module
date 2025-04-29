locals {
  core_iam_policies = [
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilder",
    "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/service-role/EC2ImageBuilderLifecycleExecutionPolicy",
  ]
}

data "aws_iam_policy_document" "execution_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:*",
      "ssm:*",
      "ecr:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "iam:PassRole"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "execution_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["imagebuilder.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution_role" {
  assume_role_policy = data.aws_iam_policy_document.execution_assume_role.json
  name_prefix        = "${var.name}-image-execution-role"
}
resource "aws_iam_policy" "execution_policy" {
  name        = "${var.name}-image-execution-policy"
  description = "Policy for image builder execution role"
  policy      = data.aws_iam_policy_document.execution_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_core" {
  count = length(local.core_iam_policies)

  policy_arn = local.core_iam_policies[count.index]
  role       = aws_iam_role.execution_role.name
}

resource "aws_iam_role_policy_attachment" "execution_role" {

  policy_arn = aws_iam_policy.execution_policy.arn
  role       = aws_iam_role.execution_role.name
}
