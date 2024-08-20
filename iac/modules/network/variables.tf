variable "project_id" {
  type        = string
  description = "ID of the project where the network is located"
}

variable "region" {
  type        = string
  description = "Region where the network is located"
}

variable "name" {
  type        = string
  description = "Name of the network"
}

variable "vpc_access_connector" {
  type = object({
    name          = string,
    region        = string,
    ip_cidr_range = string,
  })
}

variable "subnet_cidr_range" {
  type        = string
  description = "CIDR range of the subnet"
}

variable "subnet_name" {
  type        = string
  description = "Name of the subnet"
}
