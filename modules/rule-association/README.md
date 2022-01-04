# terraform-aws-tardigrade-route53-resolver/rule-association

Terraform module for managing a Route53 Resolver Rule Association.

<!-- BEGIN TFDOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resolver_rule_id"></a> [resolver\_rule\_id](#input\_resolver\_rule\_id) | ID of the Route 53 resolver rule | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of a VPC to associate with this resolver rule | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Route 53 rule association | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rule_association"></a> [rule\_association](#output\_rule\_association) | Object containing the Route53 rule association |

<!-- END TFDOCS -->
