# ------------------------------------------------------------------------------
# Retrieve the effective Account ID, User ID, and ARN in which Terraform is
# authorized.  This is used to calculate the session names for assumed roles.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "current" {}

# ------------------------------------------------------------------------------
# Retrieve the caller identity for the Images provider in order to
# get the associated Account ID.
# ------------------------------------------------------------------------------
data "aws_caller_identity" "images" {
  provider = aws.imagesprovisionaccount
}

# ------------------------------------------------------------------------------
# Retrieve the partition for the Images provider, for use in ARNs.
# ------------------------------------------------------------------------------
data "aws_partition" "images" {
  provider = aws.imagesprovisionaccount
}

# ------------------------------------------------------------------------------
# Evaluate expressions for use throughout this configuration.
# ------------------------------------------------------------------------------
locals {
  # Extract the user name of the current caller for use
  # as assume role session names.
  caller_user_name = split("/", data.aws_caller_identity.current.arn)[1]

  # The Images account ID
  images_account_id = data.aws_caller_identity.images.account_id
}
