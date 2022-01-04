output "query_log_config" {
  description = "Object containing the Route53 query log config"
  value       = aws_route53_resolver_query_log_config.this
}

output "query_log_associations" {
  description = "Map of Route53 query log config association objects"
  value       = { for name, association in module.associations : name => association.query_log_association }
}
