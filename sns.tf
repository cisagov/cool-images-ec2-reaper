# ------------------------------------------------------------------------------
# Create the SNS topic to which the EC2 reaper Lambda publishes its summaries.
# Subscribe the Images account email to the new SNS topic.
# ------------------------------------------------------------------------------

module "ec2_reaper_sns" {
  providers = {
    aws                         = aws.imagesprovisionaccount
    aws.organizations_read_only = aws.organizationsreadonly
  }
  source = "github.com/cisagov/sns-send-to-account-email-tf-module"

  topic_display_name = var.sns_topic_display_name
  topic_name         = var.sns_topic_name
}
