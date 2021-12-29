# terraform-aws-tardigrade-route53-resolver/query-log-config-association

Terraform module for managing a Route53 Resolver Query Log Config Association.

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
| <a name="input_resolver_query_log_config_id"></a> [resolver\_query\_log\_config\_id](#input\_resolver\_query\_log\_config\_id) | ID of the Route 53 resolver query log configuration | `string` | n/a | yes |
| <a name="input_resource_id"></a> [resource\_id](#input\_resource\_id) | ID of a VPC to associate with this query log configuration | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_query_log_association"></a> [query\_log\_association](#output\_query\_log\_association) | Object containing the Route53 query log config association |

<!-- END TFDOCS -->
