module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.7.0"

  name            = "tardigrade-route53-rr-association-testing"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "aws_security_group" "this" {
  name        = "empty_sg"
  description = "empty_sg for testing"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_route53_resolver_endpoint" "this" {
  name      = "foo"
  direction = "OUTBOUND"

  security_group_ids = [
    "${aws_security_group.this.id}",
  ]

  ip_address {
    subnet_id = module.vpc.private_subnets[0]
    ip        = "10.0.1.4"
  }

  ip_address {
    subnet_id = module.vpc.private_subnets[1]
    ip        = "10.0.2.8"
  }
}

resource "aws_route53_resolver_rule" "this" {
  domain_name          = "example.com"
  name                 = "example"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.this.id

  target_ip {
    ip = "123.45.67.89"
  }
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "resolver_rule_id" {
  value = aws_route53_resolver_rule.this.id
}
