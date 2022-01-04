variable "name" {
  description = "Name of the Route 53 rule association"
  type        = string
  default     = null
}

variable "resolver_rule_id" {
  description = "ID of the Route 53 resolver rule"
  type        = string
}

variable "vpc_id" {
  description = "ID of a VPC to associate with this resolver rule"
  type        = string
}
