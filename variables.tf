# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
#
# You must provide a value for each of these parameters.
# ------------------------------------------------------------------------------

variable "lambda_bucket_name" {
  description = "The name of the S3 bucket containing the EC2 reaper Lambda function deployment package."
  nullable    = false
  type        = string
}

variable "lambda_key" {
  description = "The S3 key associated with the EC2 reaper Lambda function deployment package."
  nullable    = false
  type        = string
}

variable "terraform_state_bucket" {
  description = "The name of the S3 bucket where Terraform state is stored."
  nullable    = false
  type        = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
#
# These parameters have reasonable defaults.
# ------------------------------------------------------------------------------

variable "aws_region" {
  default     = "us-east-1"
  description = "The AWS region where the non-global resources are to be provisioned (e.g. \"us-east-1\")."
  nullable    = false
  type        = string
}

variable "dry_run" {
  default     = false
  description = "Whether the EC2 reaper Lambda should only report the instances it would terminate, without terminating them."
  nullable    = false
  type        = bool
}

variable "lambda_function_description" {
  default     = "Lambda function to terminate EC2 instances that have existed longer than a maximum age."
  description = "The description of the Lambda function that terminates EC2 instances that have existed longer than a maximum age."
  nullable    = false
  type        = string
}

variable "lambda_function_name" {
  default     = "ec2-reaper"
  description = "The name of the Lambda function that terminates EC2 instances that have existed longer than a maximum age."
  nullable    = false
  type        = string
}

variable "lambda_schedule_interval" {
  default     = "4 hours"
  description = "A string representing a rate expression defining the cadence at which the Lambda function is to be run.  See [the relevant AWS documentation](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html#eb-rate-expressions) for more details."
  nullable    = false
  type        = string
}

variable "lambdaexecution_role_description" {
  default     = "Allows the EC2 reaper Lambda to find and terminate EC2 instances that have existed longer than a maximum age, and to publish a summary to its SNS topic."
  description = "The description to associate with the IAM role (and policy) that allows the EC2 reaper Lambda to find and terminate EC2 instances that have existed longer than a maximum age, and to publish a summary to its SNS topic."
  nullable    = false
  type        = string
}

variable "lambdaexecution_role_name" {
  default     = "EC2ReaperLambda"
  description = "The name to assign the IAM role (and policy) that allows the EC2 reaper Lambda to find and terminate EC2 instances that have existed longer than a maximum age, and to publish a summary to its SNS topic."
  nullable    = false
  type        = string
}

variable "max_age_hours" {
  default     = 24
  description = "A strictly positive integer denoting the number of hours, measured from an instance's root volume attach time, after which the instance is terminated."
  nullable    = false
  type        = number
  validation {
    condition     = alltrue([floor(var.max_age_hours) == var.max_age_hours, var.max_age_hours > 0])
    error_message = "max_age_hours must be a positive integer greater than zero."
  }
}

variable "sns_topic_display_name" {
  default     = "EC2 Reaper"
  description = "The display name of the SNS topic to which the EC2 reaper Lambda publishes its summaries."
  nullable    = false
  type        = string
}

variable "sns_topic_name" {
  default     = "ec2-reaper"
  description = "The name of the SNS topic to which the EC2 reaper Lambda publishes its summaries."
  nullable    = false
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags to apply to all AWS resources created."
  nullable    = false
  type        = map(string)
}

variable "terminable_instance_tags" {
  default     = {}
  description = "Tags that an EC2 instance must carry for the EC2 reaper Lambda to be permitted to terminate it (e.g. {\"Team\" = \"VM Fusion - Development\"}).  If empty, any instance in the account may be terminated.  Old instances without these tags are reported as errors in the summary."
  nullable    = false
  type        = map(string)
}

variable "terminate_stopped" {
  default     = true
  description = "Whether the EC2 reaper Lambda should also terminate stopped (and stopping) instances, rather than only running instances."
  nullable    = false
  type        = bool
}
