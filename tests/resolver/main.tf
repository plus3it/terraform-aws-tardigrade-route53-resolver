provider "aws" {
  region  = "us-east-1"
  profile = "aws"
}

module "resolver" {
  source = "../../"

  name               = local.name
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.resolver.id]
  tags               = {}
  query_log_configs  = local.query_log_configs
  rules              = local.rules

  ip_addresses = [for subnet in module.vpc1.private_subnets : {
    subnet_id = subnet
    ip        = null
  }]
}

locals {
  id   = data.terraform_remote_state.prereq.outputs.test_id.result
  name = "tardigrade-resolver-${local.id}"

  query_log_configs = [
    {
      name            = "${local.name}-ql1"
      destination_arn = aws_s3_bucket.ql1.arn
      tags            = {}
      associations = [
        {
          name        = "${local.name}-ql1-vpc1"
          resource_id = module.vpc1.vpc_id
        },
        {
          name        = "${local.name}-ql1-vpc2"
          resource_id = module.vpc2.vpc_id
        },
      ]
    },
    {
      name            = "${local.name}-ql2"
      destination_arn = aws_cloudwatch_log_group.ql2.arn
      tags            = {}
      associations = [
        {
          name        = "${local.name}-ql2-vpc1"
          resource_id = module.vpc1.vpc_id
        },
        {
          name        = "${local.name}-ql2-vpc2"
          resource_id = module.vpc2.vpc_id
        },
      ]
    },
  ]

  rules = [
    {
      name        = "${local.name}-r1"
      domain_name = "foo.local"
      rule_type   = "FORWARD"
      tags        = {}
      target_ips = [
        {
          ip   = "10.0.0.44"
          port = null
        },
      ]
      associations = [
        {
          name   = "${local.name}-r1-vpc1"
          vpc_id = module.vpc1.vpc_id
        },
        {
          name   = "${local.name}-r1-vpc2"
          vpc_id = module.vpc2.vpc_id
        },
      ]
    },
  ]
}

module "vpc1" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v3.14.2"

  name            = "${local.name}-vpc1"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "vpc2" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v3.14.4"

  name            = "${local.name}-vpc2"
  cidr            = "10.1.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
}

resource "aws_security_group" "resolver" {
  name   = local.name
  vpc_id = module.vpc1.vpc_id

  dynamic "ingress" {
    for_each = ["tcp", "udp"]
    content {
      description = "Inbound ${ingress.value} DNS"
      from_port   = 53
      to_port     = 53
      protocol    = ingress.value
      cidr_blocks = [module.vpc1.vpc_cidr_block]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "ql1" {
  force_destroy = true
}

resource "aws_cloudwatch_log_group" "ql2" {}

data "terraform_remote_state" "prereq" {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}

output "resolver" {
  # Seems the nested dynamic block for target_ip in module.resolver.module.rules causes a persistent
  # diff in output. For the test, we're just going to remove the attribute from the rule object.
  value = merge(
    module.resolver,
    {
      rules = { for name, rule in module.resolver.rules : name => merge(
        rule,
        {
          resolver_rule = { for attr, value in rule.resolver_rule : attr => value if attr != "target_ip" }
        }
      ) }
    }
  )
}
