# terraform-aws-tardigrade-route53-resolver/rule

Terraform module for managing a Route53 Resolver Rule.

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
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | DNS queries for this domain name are forwarded to the IP addresses specified using `target_ip` | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name for the rule displayed in the Resolver dashboard in the Route 53 console | `string` | n/a | yes |
| <a name="input_rule_type"></a> [rule\_type](#input\_rule\_type) | Type of resolver rule (valid values are: `FORWARD`, `RECURSIVE`, `SYSTEM`) | `string` | n/a | yes |
| <a name="input_associations"></a> [associations](#input\_associations) | List of Route53 resolver rule associations | <pre>list(object({<br>    # `name` used as for_each key<br>    name = string<br>    # ID of a VPC to associate with the resolver rule<br>    vpc_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_resolver_endpoint_id"></a> [resolver\_endpoint\_id](#input\_resolver\_endpoint\_id) | ID of the outbound resolver endpoint to use when routing DNS queries to the IP addresses specified using `target_ip` (Should only be specified for `FORWARD` type rules) | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_target_ips"></a> [target\_ips](#input\_target\_ips) | List of target IP blocks where DNS queries will be forwarded (specifiy only for the `FORWARD` rule\_type) | <pre>list(object({<br>    # IP address where DNS queries will be forwarded (must be IPv4)<br>    ip = string<br>    # Port at `ip` listening for DNS queries (set to `null` to default to `53`)<br>    port = number<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resolver_rule"></a> [resolver\_rule](#output\_resolver\_rule) | Object containing the Route53 resolver rule |
| <a name="output_resolver_rule_associations"></a> [resolver\_rule\_associations](#output\_resolver\_rule\_associations) | Map of Route53 resolver rule association objects |

<!-- END TFDOCS -->
