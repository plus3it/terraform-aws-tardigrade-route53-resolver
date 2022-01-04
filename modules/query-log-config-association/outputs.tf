output "query_log_association" {
  description = "Object containing the Route53 query log config association"
  value       = aws_route53_resolver_query_log_config_association.this
}
