output "resolver_endpoint" {
  description = "Object containing the Route53 resolver endpoint"
  value       = aws_route53_resolver_endpoint.this
}

output "query_log_configs" {
  description = "Map of Route53 resolver query log configurations and associations"
  value       = module.query_log_configs
}

output "rules" {
  description = "Map of Route53 resolver rules and associations"
  value       = module.rules
}
