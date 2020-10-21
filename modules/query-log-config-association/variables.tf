variable "resolver_query_log_config_id" {
  description = "ID of the Route 53 resolver query log configuration"
  type        = string
}

variable "resource_id" {
  description = "ID of a VPC to associate with this query log configuration"
  type        = string
}
