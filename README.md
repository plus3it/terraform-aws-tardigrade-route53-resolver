# terraform-aws-tardigrade-route53-rr-association

Terraform module to associate route53 resolver rules

## Testing

At the moment, testing is manual:

```
# Replace "xxx" with an actual AWS profile, then execute the integration tests.
export AWS_PROFILE=xxx 
make terraform/pytest PYTEST_ARGS="-v --nomock"
```

For automated testing, PYTEST_ARGS is optional and no profile is needed:

```
make terraform/pytest PYTEST_ARGS="-v"
```

<!-- BEGIN TFDOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dependencies"></a> [dependencies](#input\_dependencies) | List of resource dependencies to force terraform to wait until they are done | `list(string)` | `[]` | no |
| <a name="input_resolver_rule_id"></a> [resolver\_rule\_id](#input\_resolver\_rule\_id) | ID of the rule to associate to the VPC | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC that will be associated to the rule | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_route53_resolver_rule_association"></a> [aws\_route53\_resolver\_rule\_association](#output\_aws\_route53\_resolver\_rule\_association) | ID of the resolver rule association |

<!-- END TFDOCS -->
