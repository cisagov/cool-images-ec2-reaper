# ------------------------------------------------------------------------------
# Create the IAM policy that allows the EC2 reaper Lambda to access all
# resources needed to do its job.
# ------------------------------------------------------------------------------

data "aws_iam_policy_document" "lambdaexecution_doc" {
  statement {
    actions = [
      "logs:CreateLogGroup",
    ]

    resources = [
      format("arn:%s:logs:%s:%s:*", data.aws_partition.images.partition, var.aws_region, local.images_account_id),
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      format("arn:%s:logs:%s:%s:log-group:/aws/lambda/%s:*",
      data.aws_partition.images.partition, var.aws_region, local.images_account_id, var.lambda_function_name),
    ]
  }

  # These actions do not support resource-level permissions.
  statement {
    actions = [
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:TerminateInstances",
    ]

    resources = [
      format("arn:%s:ec2:*:%s:instance/*", data.aws_partition.images.partition, local.images_account_id),
    ]

    dynamic "condition" {
      for_each = var.terminable_instance_tags

      content {
        test     = "StringEquals"
        values   = [condition.value]
        variable = "aws:ResourceTag/${condition.key}"
      }
    }
  }

  statement {
    actions = [
      "sns:Publish",
    ]

    resources = [
      module.ec2_reaper_sns.sns_topic.arn,
    ]
  }
}

resource "aws_iam_policy" "lambdaexecution_policy" {
  provider = aws.imagesprovisionaccount

  description = var.lambdaexecution_role_description
  name        = var.lambdaexecution_role_name
  policy      = data.aws_iam_policy_document.lambdaexecution_doc.json
}
