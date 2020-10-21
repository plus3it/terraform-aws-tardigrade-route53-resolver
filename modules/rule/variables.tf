variable "domain_name" {
  description = "DNS queries for this domain name are forwarded to the IP addresses specified using `target_ip`"
  type        = string
}

variable "name" {
  description = "Name for the rule displayed in the Resolver dashboard in the Route 53 console"
  type        = string
}

variable "rule_type" {
  description = "Type of resolver rule (valid values are: `FORWARD`, `RECURSIVE`, `SYSTEM`)"
  type        = string
  validation {
    condition     = contains(["FORWARD", "RECURSIVE", "SYSTEM"], var.rule_type)
    error_message = "Rule type must be one of: \"FORWARD\", \"RECURSIVE\", \"SYSTEM\"."
  }
}

variable "resolver_endpoint_id" {
  description = "ID of the outbound resolver endpoint to use when routing DNS queries to the IP addresses specified using `target_ip` (Should only be specified for `FORWARD` type rules)"
  type        = string
  default     = null
}

variable "target_ips" {
  description = "List of target IP blocks where DNS queries will be forwarded (specifiy only for the `FORWARD` rule_type)"
  type = list(object({
    # IP address where DNS queries will be forwarded (must be IPv4)
    ip = string
    # Port at `ip` listening for DNS queries (set to `null` to default to `53`)
    port = number
  }))
  default = []
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "associations" {
  description = "List of Route53 resolver rule associations"
  type = list(object({
    # `name` used as for_each key
    name = string
    # ID of a VPC to associate with the resolver rule
    vpc_id = string
  }))
  default = []
}
