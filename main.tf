resource "aws_route53_resolver_endpoint" "this" {
  name               = var.name
  direction          = var.direction
  security_group_ids = var.security_group_ids
  tags               = merge({ Name = var.name }, var.tags)

  dynamic "ip_address" {
    for_each = var.ip_addresses
    content {
      ip        = ip_address.value.ip
      subnet_id = ip_address.value.subnet_id
    }
  }
}

module "query_log_configs" {
  source   = "./modules/query-log-config"
  for_each = { for config in var.query_log_configs : config.name => config }

  name            = each.value.name
  destination_arn = each.value.destination_arn
  tags            = each.value.tags
  associations    = each.value.associations
}

module "rules" {
  source   = "./modules/rule"
  for_each = { for rule in var.rules : rule.name => rule }

  name                 = each.value.name
  domain_name          = each.value.domain_name
  rule_type            = each.value.rule_type
  resolver_endpoint_id = each.value.rule_type == "FORWARD" ? aws_route53_resolver_endpoint.this.id : null
  tags                 = each.value.tags
  target_ips           = each.value.target_ips
  associations         = each.value.associations
}
