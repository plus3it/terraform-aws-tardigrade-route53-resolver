/*
  The workflow for cross-account associations is a bit of a dance. There are several things that must
  take place in the "owner" account, in order for the associations to work properly in the "member"
  account.

  Owner account:
  - Create the resolver
  - Create the resolver rule and/or the query log config
  - Create the RAM share
  - Associate the resolver rule and query log config resources to the RAM share
  - Invite the "member" account to the RAM share as a principal

  Member account:
  - Accept the invitation to the RAM share
  - Create the associations for the resolver rule and/or the query log config

  IMPORTANT: The associations in the member account are dependent on *several* resources that are not
  direct attributes of the association. In order for terraform to properly manage the ordering of create/destroy
  actions, use `depends_on` for the RAM share accepter, the principal association, and the resource association.
*/

provider "aws" {
  region  = "us-east-1"
  profile = "aws"
}

provider "aws" {
  region  = "us-east-1"
  alias   = "owner"
  profile = "awsalternate"
}

module "query_log_config_association" {
  source = "../../modules/query-log-config-association"

  resolver_query_log_config_id = module.resolver.query_log_configs["${local.name}-ql1"].query_log_config.id
  resource_id                  = module.vpc_member.vpc_id

  depends_on = [
    module.ram_share_accepter,
    module.ram_share,
  ]
}

module "rule_association" {
  source = "../../modules/rule-association"

  name             = local.name
  resolver_rule_id = module.resolver.rules["${local.name}-r1"].resolver_rule.id
  vpc_id           = module.vpc_member.vpc_id

  depends_on = [
    module.ram_share_accepter,
    module.ram_share,
  ]
}

module "resolver" {
  source = "../.."
  providers = {
    aws = aws.owner
  }

  name               = local.name
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.resolver.id]
  tags               = {}
  query_log_configs  = local.query_log_configs
  rules              = local.rules

  ip_addresses = [for subnet in module.vpc_owner.private_subnets : {
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
      associations    = []
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
      associations = []
    },
  ]
}

module "ram_share" {
  source = "git::https://github.com/plus3it/terraform-aws-tardigrade-ram-share.git?ref=3.0.1"
  providers = {
    aws = aws.owner
  }

  name                      = "${local.name}-ram-share"
  allow_external_principals = true

  resources = [
    {
      name         = "${local.name}-ql1"
      resource_arn = module.resolver.query_log_configs["${local.name}-ql1"].query_log_config.arn
    },
    {
      name         = "${local.name}-r1"
      resource_arn = module.resolver.rules["${local.name}-r1"].resolver_rule.arn
    },
  ]
}

module "ram_share_accepter" {
  source = "git::https://github.com/plus3it/terraform-aws-tardigrade-ram-share.git//modules/cross_account_principal_association?ref=3.0.1"

  providers = {
    aws       = aws
    aws.owner = aws.owner
  }

  resource_share_arn = module.ram_share.resource_share.arn
}

module "vpc_member" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v3.11.0"

  name            = "${local.name}-vpc-member"
  cidr            = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "vpc_owner" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v3.11.1"
  providers = {
    aws = aws.owner
  }

  name            = "${local.name}-vpc-owner"
  cidr            = "10.1.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
}

resource "aws_security_group" "resolver" {
  provider = aws.owner

  name   = local.name
  vpc_id = module.vpc_owner.vpc_id

  dynamic "ingress" {
    for_each = ["tcp", "udp"]
    content {
      description = "Inbound ${ingress.value} DNS"
      from_port   = 53
      to_port     = 53
      protocol    = ingress.value
      cidr_blocks = [module.vpc_owner.vpc_cidr_block]
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
  provider      = aws.owner
  force_destroy = true
}

data "terraform_remote_state" "prereq" {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}
