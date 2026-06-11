variable "nsg_name" {}
variable "location" {}
variable "resource_group_name" {}

# SSH Rule

variable "ssh_rule_name" {}
variable "ssh_priority" {}
variable "ssh_direction" {}
variable "ssh_access" {}
variable "ssh_protocol" {}

variable "ssh_source_port_range" {}
variable "ssh_destination_port_range" {}

variable "ssh_source_address_prefix" {}
variable "ssh_destination_address_prefix" {}

# HTTP Rule

variable "http_rule_name" {}
variable "http_priority" {}
variable "http_direction" {}
variable "http_access" {}
variable "http_protocol" {}

variable "http_source_port_range" {}
variable "http_destination_port_range" {}

variable "http_source_address_prefix" {}
variable "http_destination_address_prefix" {}

# HTTPS Rule

variable "https_rule_name" {}
variable "https_priority" {}
variable "https_direction" {}
variable "https_access" {}
variable "https_protocol" {}

variable "https_source_port_range" {}
variable "https_destination_port_range" {}

variable "https_source_address_prefix" {}
variable "https_destination_address_prefix" {}