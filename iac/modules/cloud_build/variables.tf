
variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "trigger_name" {
  type        = string
  description = "Name of the trigger"
}

variable "substitutions" {
  type        = map(string)
  description = "Substitutions to perform in Cloud Build"
}

variable "path" {
  type        = string
  description = "Path to the Cloud Build file"
}

variable "included" {
  type        = list(string)
  description = "File paths that trigger the trigger"
}

variable "branch_regex" {
  type        = string
  description = "Regex of the branch to run the trigger"
  default     = ".*"
}

variable "location" {
  type        = string
  description = "Location of repository"
}

variable "parent_connection" {
  type        = string
  description = "connection name"
}

variable "repository_name" {
  type        = string
  description = "repository name"
}

variable "repository_org" {
  type        = string
  description = "repository org"
}
variable "service_account" {
  type        = string
  description = "service account"
}
