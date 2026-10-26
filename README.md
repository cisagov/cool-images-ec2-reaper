# cool-images-ec2-reaper #

[![GitHub Build Status](https://github.com/cisagov/cool-images-ec2-reaper/workflows/build/badge.svg)](https://github.com/cisagov/cool-images-ec2-reaper/actions)
[![License](https://img.shields.io/github/license/cisagov/cool-images-ec2-reaper)](https://spdx.org/licenses/)
[![CodeQL](https://github.com/cisagov/cool-images-ec2-reaper/workflows/CodeQL/badge.svg)](https://github.com/cisagov/cool-images-ec2-reaper/actions/workflows/codeql-analysis.yml)

This is a generic skeleton project that can be used to quickly get a
new [cisagov](https://github.com/cisagov) [Terraform
module](https://www.terraform.io/docs/modules/index.html) GitHub
repository started.  This skeleton project contains [licensing
information](LICENSE), as well as [pre-commit
hooks](https://pre-commit.com) and
[GitHub Actions](https://github.com/features/actions) configurations
appropriate for the major languages that we use.

See the [Terraform
documentation](https://www.terraform.io/docs/modules/index.html) for
more details on Terraform modules and the standard module structure.

<!-- BEGIN_TF_DOCS -->
## Requirements ##

| Name | Version |
| ---- | ------- |
| terraform | ~> 1.1 |
| aws | ~> 6.21 |

## Providers ##

| Name | Version |
| ---- | ------- |
| aws | ~> 6.21 |
| aws.imagesprovisionaccount | ~> 6.21 |
| terraform | n/a |

## Modules ##

| Name | Source | Version |
| ---- | ------ | ------- |
| ec2\_reaper\_sns | github.com/cisagov/sns-send-to-account-email-tf-module | n/a |

## Resources ##

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_event_rule.lambda_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.lambda_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.lambdaexecution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambdaexecution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambdaexecution_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.ec2_reaper](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.allow_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_caller_identity.images](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.lambda_assume_role_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambdaexecution_doc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.images](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [terraform_remote_state.images](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.master](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs ##

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| aws\_region | The AWS region where the non-global resources are to be provisioned (e.g. "us-east-1"). | `string` | `"us-east-1"` | no |
| dry\_run | Whether the EC2 reaper Lambda should only report the instances it would terminate, without terminating them. | `bool` | `false` | no |
| lambda\_bucket\_name | The name of the S3 bucket containing the EC2 reaper Lambda function deployment package. | `string` | n/a | yes |
| lambda\_function\_description | The description of the Lambda function that terminates EC2 instances that have existed longer than a maximum age. | `string` | `"Lambda function to terminate EC2 instances that have existed longer than a maximum age."` | no |
| lambda\_function\_name | The name of the Lambda function that terminates EC2 instances that have existed longer than a maximum age. | `string` | `"ec2-reaper"` | no |
| lambda\_key | The S3 key associated with the EC2 reaper Lambda function deployment package. | `string` | n/a | yes |
| lambda\_schedule\_interval | A string representing a rate expression defining the cadence at which the Lambda function is to be run.  See [the relevant AWS documentation](https://docs.aws.amazon.com/eventbridge/latest/userguide/eb-scheduled-rule-pattern.html#eb-rate-expressions) for more details. | `string` | `"4 hours"` | no |
| lambdaexecution\_role\_description | The description to associate with the IAM role (and policy) that allows the EC2 reaper Lambda to find and terminate EC2 instances that have existed longer than a maximum age, and to publish a summary to its SNS topic. | `string` | `"Allows the EC2 reaper Lambda to find and terminate EC2 instances that have existed longer than a maximum age, and to publish a summary to its SNS topic."` | no |
| lambdaexecution\_role\_name | The name to assign the IAM role (and policy) that allows the EC2 reaper Lambda to find and terminate EC2 instances that have existed longer than a maximum age, and to publish a summary to its SNS topic. | `string` | `"EC2ReaperLambda"` | no |
| max\_age\_hours | A strictly positive integer denoting the number of hours, measured from an instance's root volume attach time, after which the instance is terminated. | `number` | `24` | no |
| sns\_topic\_display\_name | The display name of the SNS topic to which the EC2 reaper Lambda publishes its summaries. | `string` | `"EC2 Reaper"` | no |
| sns\_topic\_name | The name of the SNS topic to which the EC2 reaper Lambda publishes its summaries. | `string` | `"ec2-reaper"` | no |
| tags | Tags to apply to all AWS resources created. | `map(string)` | `{}` | no |
| terminable\_instance\_tags | Tags that an EC2 instance must carry for the EC2 reaper Lambda to be permitted to terminate it (e.g. {"Team" = "VM Fusion - Development"}).  If empty, any instance in the account may be terminated.  Old instances without these tags are reported as errors in the summary. | `map(string)` | `{}` | no |
| terminate\_stopped | Whether the EC2 reaper Lambda should also terminate stopped (and stopping) instances, rather than only running instances. | `bool` | `true` | no |
| terraform\_state\_bucket | The name of the S3 bucket where Terraform state is stored. | `string` | n/a | yes |

## Outputs ##

| Name | Description |
| ---- | ----------- |
| cloudwatch\_event\_rule | The CloudWatch event rule that kicks off the EC2 reaper Lambda function at a regular cadence. |
| cloudwatch\_log\_group | The CloudWatch log group where the EC2 reaper Lambda function's logs are written. |
| lambda\_function | The Lambda function that terminates EC2 instances that have existed longer than a maximum age. |
| lambda\_role | The IAM role used by the EC2 reaper Lambda function. |
| sns\_topic | The SNS topic to which the EC2 reaper Lambda function publishes its summaries. |
<!-- END_TF_DOCS -->

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, this is only the main directory.

## New Repositories from a Skeleton ##

Please see our [Project Setup guide](https://github.com/cisagov/development-guide/tree/develop/project_setup)
for step-by-step instructions on how to start a new repository from
a skeleton. This will save you time and effort when configuring a
new repository!

## Contributing ##

We welcome contributions!  Please see [`CONTRIBUTING.md`](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
