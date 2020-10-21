variable "direction" {
  description = "Direction of DNS queries to or from the Route 53 Resolver endpoint. Valid values are INBOUND (resolver forwards DNS queries to the DNS service for a VPC from your network or another VPC) or OUTBOUND (resolver forwards DNS queries from the DNS service for a VPC to your network or another VPC)"
  type        = string
  validation {
    condition     = contains(["INBOUND", "OUTBOUND"], var.direction)
    error_message = "Direction must be one of: \"INBOUND\", \"OUTBOUND\"."
  }
}

variable "security_group_ids" {
  description = "List of security group IDs for the resolver endpoint"
  type        = list(string)
}

variable "ip_addresses" {
  description = "List of IP address objects for the resolver endpoint"
  type = list(object({
    # ID of the subnet in which to create the resolver endpoint
    subnet_id = string
    # IP to use for the resolver endpoint (set to `null` to let AWS choose an IP)
    ip = string
  }))
}

variable "name" {
  description = "Name of the Route 53 resolver endpoint"
  type        = string
  default     = null
}

variable "tags" {
  description = "ID of the rule to associate to the VPC"
  type        = map(string)
  default     = {}
}

variable "query_log_configs" {
  description = "List of query log configurations for the resolver endpoint"
  type = list(object({
    name            = string
    destination_arn = string
    tags            = map(string)
    associations = list(object({
      # `name` used as for_each key
      name = string
      # ID of a VPC to associate with this query log configuration
      resource_id = string
    }))
  }))
  default = []
}

variable "rules" {
  description = "List of resolver rules for the resolver endpoint"
  type = list(object({
    domain_name = string
    name        = string
    rule_type   = string
    tags        = map(string)
    target_ips = list(object({
      # IP address where DNS queries will be forwarded (must be IPv4)
      ip = string
      # Port at `ip` listening for DNS queries (set to `null` to default to `53`)
      port = number
    }))
    associations = list(object({
      # `name` used as for_each key
      name = string
      # ID of a VPC to associate with the resolver rule
      vpc_id = string
    }))
  }))
  default = []
}
