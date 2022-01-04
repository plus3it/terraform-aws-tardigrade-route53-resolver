resource "aws_route53_resolver_rule" "this" {
  domain_name          = var.domain_name
  name                 = var.name
  rule_type            = var.rule_type
  resolver_endpoint_id = var.resolver_endpoint_id
  tags                 = merge({ Name = var.name }, var.tags)

  dynamic "target_ip" {
    for_each = var.target_ips
    content {
      ip   = target_ip.value.ip
      port = target_ip.value.port
    }
  }
}

module "associations" {
  source   = "../rule-association"
  for_each = { for association in var.associations : association.name => association }

  name             = each.value.name
  resolver_rule_id = aws_route53_resolver_rule.this.id
  vpc_id           = each.value.vpc_id
}
