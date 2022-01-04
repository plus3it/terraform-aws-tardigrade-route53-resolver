# terraform-aws-tardigrade-route53-resolver

Terraform module to manage a Route53 Resolver.

## Testing

At the moment, testing is manual:

```
# Replace "xxx" with an actual AWS profile, then execute the integration tests.
export AWS_PROFILE=xxx 
make terraform/pytest PYTEST_ARGS="-v --nomock"
```

For automated testing, PYTEST_ARGS is optional and no profile is needed:

```
make mockstack/up
make terraform/pytest PYTEST_ARGS="-v"
make mockstack/clean
```

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.49.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.49.0 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_direction"></a> [direction](#input\_direction) | Direction of DNS queries to or from the Route 53 Resolver endpoint. Valid values are INBOUND (resolver forwards DNS queries to the DNS service for a VPC from your network or another VPC) or OUTBOUND (resolver forwards DNS queries from the DNS service for a VPC to your network or another VPC) | `string` | n/a | yes |
| <a name="input_ip_addresses"></a> [ip\_addresses](#input\_ip\_addresses) | List of IP address objects for the resolver endpoint | <pre>list(object({<br>    # ID of the subnet in which to create the resolver endpoint<br>    subnet_id = string<br>    # IP to use for the resolver endpoint (set to `null` to let AWS choose an IP)<br>    ip = string<br>  }))</pre> | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the resolver endpoint | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the Route 53 resolver endpoint | `string` | `null` | no |
| <a name="input_query_log_configs"></a> [query\_log\_configs](#input\_query\_log\_configs) | List of query log configurations for the resolver endpoint | <pre>list(object({<br>    name            = string<br>    destination_arn = string<br>    tags            = map(string)<br>    associations = list(object({<br>      # `name` used as for_each key<br>      name = string<br>      # ID of a VPC to associate with this query log configuration<br>      resource_id = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | List of resolver rules for the resolver endpoint | <pre>list(object({<br>    domain_name = string<br>    name        = string<br>    rule_type   = string<br>    tags        = map(string)<br>    target_ips = list(object({<br>      # IP address where DNS queries will be forwarded (must be IPv4)<br>      ip = string<br>      # Port at `ip` listening for DNS queries (set to `null` to default to `53`)<br>      port = number<br>    }))<br>    associations = list(object({<br>      # `name` used as for_each key<br>      name = string<br>      # ID of a VPC to associate with the resolver rule<br>      vpc_id = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | ID of the rule to associate to the VPC | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_query_log_configs"></a> [query\_log\_configs](#output\_query\_log\_configs) | Map of Route53 resolver query log configurations and associations |
| <a name="output_resolver_endpoint"></a> [resolver\_endpoint](#output\_resolver\_endpoint) | Object containing the Route53 resolver endpoint |
| <a name="output_rules"></a> [rules](#output\_rules) | Map of Route53 resolver rules and associations |

<!-- END TFDOCS -->
