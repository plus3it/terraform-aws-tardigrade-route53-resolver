resource "aws_route53_resolver_query_log_config" "this" {
  name            = var.name
  destination_arn = var.destination_arn
  tags            = merge({ Name = var.name }, var.tags)
}

module "associations" {
  source   = "../query-log-config-association"
  for_each = { for association in var.associations : association.name => association }

  resolver_query_log_config_id = aws_route53_resolver_query_log_config.this.id
  resource_id                  = each.value.resource_id
}
