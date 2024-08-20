variable "project_id" {
  type = string
}

variable "instance_id" {
  description = "The ID of the instance."
  type        = string
}

variable "instance_cpu_count" {
  description = "The number of CPUs for the instance."
  type        = number
}

variable "cluster_id" {
  description = "The ID of the cluster."
  type        = string
}

variable "cluster_region" {
  description = "The region of the cluster."
  type        = string
}

variable "username" {
  type        = string
  description = "The username for the AlloyDB cluster."
}

variable "password" {
  type        = string
  description = "The password for the AlloyDB cluster."
}

variable "network_id" {
  type        = string
  description = "ID of the network used by AlloyDB."
}
