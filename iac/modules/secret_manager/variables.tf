variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "replication_locations" {
  type    = list(string)
  default = []
}

variable "policies" {
  type = map(list(string))
}
