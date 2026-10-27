# ------------------------------------------------------------------------------
# The AWS Lambda function that terminates EC2 instances in the Images account
# that have existed longer than a maximum age.  The ZIP file is created with:
# https://github.com/cisagov/ec2-reaper-lambda
# ------------------------------------------------------------------------------

resource "aws_lambda_function" "ec2_reaper" {
  provider = aws.imagesprovisionaccount

  # The log group must exist before the function first runs, or Lambda will
  # create one without a retention policy.
  depends_on = [
    aws_cloudwatch_log_group.lambda_logs,
  ]

  description   = var.lambda_function_description
  function_name = var.lambda_function_name
  handler       = "lambda_handler.handler"
  memory_size   = 128
  role          = aws_iam_role.lambdaexecution_role.arn
  runtime       = "python3.14"
  s3_bucket     = var.lambda_bucket_name
  s3_key        = var.lambda_key
  timeout       = 900
}

# Don't retry failed runs.  A retry would resend the summary, and the next
# scheduled run tries again anyway.
resource "aws_lambda_function_event_invoke_config" "ec2_reaper" {
  provider = aws.imagesprovisionaccount

  function_name          = aws_lambda_function.ec2_reaper.function_name
  maximum_retry_attempts = 0
}

# The CloudWatch log group for the Lambda function
resource "aws_cloudwatch_log_group" "lambda_logs" {
  provider = aws.imagesprovisionaccount

  name              = format("/aws/lambda/%s", var.lambda_function_name)
  retention_in_days = 30
}

# Schedule the Lambda function to run at a regular cadence
resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  provider = aws.imagesprovisionaccount

  description         = format("Executes %s Lambda every %s.", var.lambda_function_name, var.lambda_schedule_interval)
  name                = format("%s-every-%s", var.lambda_function_name, replace(var.lambda_schedule_interval, " ", "-"))
  schedule_expression = format("rate(%s)", var.lambda_schedule_interval)
}

resource "aws_cloudwatch_event_target" "lambda_schedule" {
  provider = aws.imagesprovisionaccount

  arn = aws_lambda_function.ec2_reaper.arn
  input = jsonencode({
    dry_run           = var.dry_run
    max_age_hours     = var.max_age_hours
    sns_topic_arn     = module.ec2_reaper_sns.sns_topic.arn
    task              = "reap"
    terminate_stopped = var.terminate_stopped
  })
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "lambda"
}

# Allow the CloudWatch event to invoke the Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  provider = aws.imagesprovisionaccount

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_reaper.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
  statement_id  = "AllowExecutionFromCloudWatch"
}
