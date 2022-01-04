variable "destination_arn" {
  description = "ARN of the resource where Route 53 Resolver will send query logs"
  type        = string
}

variable "name" {
  description = "Name of the Route 53 Resolver query logging configuration"
  type        = string
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "associations" {
  description = "List of Route53 query log config associations"
  type = list(object({
    # `name` used as for_each key
    name = string
    # ID of a VPC to associate with this query log configuration
    resource_id = string
  }))
  default = []
}
