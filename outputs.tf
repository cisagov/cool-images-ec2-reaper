output "cloudwatch_event_rule" {
  description = "The CloudWatch event rule that kicks off the EC2 reaper Lambda function at a regular cadence."
  value       = aws_cloudwatch_event_rule.lambda_schedule
}

output "cloudwatch_log_group" {
  description = "The CloudWatch log group where the EC2 reaper Lambda function's logs are written."
  value       = aws_cloudwatch_log_group.lambda_logs
}

output "lambda_function" {
  description = "The Lambda function that terminates EC2 instances that have existed longer than a maximum age."
  value       = aws_lambda_function.ec2_reaper
}

output "lambda_role" {
  description = "The IAM role used by the EC2 reaper Lambda function."
  value       = aws_iam_role.lambdaexecution_role
}

output "sns_topic" {
  description = "The SNS topic to which the EC2 reaper Lambda function publishes its summaries."
  value       = module.ec2_reaper_sns.sns_topic
}
