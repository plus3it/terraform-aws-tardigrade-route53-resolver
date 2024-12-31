# terraform-aws-tardigrade-route53-resolver/query-log-config

Terraform module for managing a Route53 Resolver Query Log Config.

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
| <a name="input_destination_arn"></a> [destination\_arn](#input\_destination\_arn) | ARN of the resource where Route 53 Resolver will send query logs | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Route 53 Resolver query logging configuration | `string` | n/a | yes |
| <a name="input_associations"></a> [associations](#input\_associations) | List of Route53 query log config associations | <pre>list(object({<br/>    # `name` used as for_each key<br/>    name = string<br/>    # ID of a VPC to associate with this query log configuration<br/>    resource_id = string<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_query_log_associations"></a> [query\_log\_associations](#output\_query\_log\_associations) | Map of Route53 query log config association objects |
| <a name="output_query_log_config"></a> [query\_log\_config](#output\_query\_log\_config) | Object containing the Route53 query log config |

<!-- END TFDOCS -->
