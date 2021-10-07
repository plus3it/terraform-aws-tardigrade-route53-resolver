data "terraform_remote_state" "prereq" {
  backend = "local"
  config = {
    path = "prereq/terraform.tfstate"
  }
}

module "create_rr_association" {
  source = "../../"

  vpc_id           = data.terraform_remote_state.prereq.outputs.vpc_id
  resolver_rule_id = data.terraform_remote_state.prereq.outputs.resolver_rule_id
}
