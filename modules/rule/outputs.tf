output "resolver_rule" {
  description = "Object containing the Route53 resolver rule"
  value       = aws_route53_resolver_rule.this
}

output "resolver_rule_associations" {
  description = "Map of Route53 resolver rule association objects"
  value       = { for name, association in module.associations : name => association.rule_association }
}
