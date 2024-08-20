variable "project_id" {
  type        = string
  description = "Project ID of the project"
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

# Services
variable "api_services" {
  description = "GCP API services to enable"
  type        = map(string)
}

# Artifact Registry
variable "artifact_registry_repositories" {
  description = "The artifact registry repositories to create"
  type = map(object({
    location       = string
    description    = optional(string)
    format         = string
    role_group_map = map(set(string))
  }))
}

# Cloud Build
variable "repo_owner" {
  type        = string
  description = "The owner of the repository containing pipelines definitions in Google Source Repositories."
}

variable "repo_name" {
  type        = string
  description = "The ID of the repository containing pipelines definitions in Google Source Repositories."
}

variable "pipeline_triggers" {
  description = "The Cloud Build triggers to build pipelines."
  type = map(object({
    included      = list(string)
    path          = string
    substitutions = map(string)
    branch_regex  = string
  }))
}
variable "component_triggers" {
  description = "The Cloud Build triggers to build pipelines."
  type = map(object({
    included      = list(string)
    path          = string
    substitutions = map(string)
    branch_regex  = string
  }))
}
variable "container_triggers" {
  description = "The Cloud Build triggers to build containers."
  type = map(object({
    included      = list(string)
    path          = string
    substitutions = map(string)
    branch_regex  = string
  }))
}
# GCS
variable "buckets" {
  type = map(object({
    name   = string
    region = string
  }))
  description = "Defines the buckets to be built."
}

# Cloud Run
variable "cloud_runs" {
  type = map(object({
    location                = string
    cpu                     = optional(string, "2")
    memory                  = optional(string, "8Gi")
    service_account         = string
    timeout                 = optional(string, "3600s")
    max_instance_count      = optional(number)
    min_instance_count      = optional(number)
    startup_cpu_boost       = optional(bool)
    port                    = optional(string, "8080")
    environment_variables   = optional(map(string), {})
    vpc_access_connector_id = optional(string)
    container_image         = optional(string)
    groups                  = optional(map(list(string)), {})
    sa                      = optional(map(list(string)), {})
    users                   = optional(map(list(string)), {})
    path_url_map            = optional(string)
    protocol_name           = optional(string)
    enable_iap              = bool
    cloud_build_trigger = object({
      included      = list(string)
      path          = string
      substitutions = map(string)
      branch_regex  = string
    })
    secrets = optional(map(object({
      version = optional(string, "latest")
      name    = string
    })), {})
    traffic = optional(object({
      type     = string
      percent  = optional(number)
      revision = optional(string)
      tag      = optional(string)
      }), {
      type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
      percent = 100
    })
  }))
  default     = {}
  description = "Defines the Cloud Run services."
}

# IAM
variable "service_accounts" {
  type = map(object({
    gcp_project_id = optional(string)
    description    = optional(string)
    display_name   = optional(string)
    create         = optional(bool)
    disabled       = optional(bool)
    email          = optional(string)
    groups         = optional(map(list(string)), {})
    sa             = optional(map(list(string)), {})
    users          = optional(map(list(string)), {})
    tenant         = optional(string)
    environment    = optional(string)
    stage          = optional(string)
    name           = optional(string)
    attributes     = optional(list(string), [])
    label_order    = optional(list(string), [])
  }))
}

variable "groups" {
  type    = any
  default = {}
}

variable "folders" {
  type    = any
  default = {}
}

variable "group_roles" {
  type    = any
  default = {}
}

variable "service_account_roles" {
  type    = any
  default = {}
}

variable "user_roles" {
  type    = any
  default = {}
}
variable "parent_connection" {
  type        = string
  description = "connection name"
}

variable "location" {
  type        = string
  description = "Location of repository"

}
# AlloyDB
variable "alloydb_project_id" {
  type        = string
  description = "The project ID of the AlloyDB cluster"
}

variable "alloydb_region" {
  type        = string
  description = "The region of the AlloyDB cluster"
}

variable "alloydb_cluster_id" {
  type        = string
  description = "The ID of the AlloyDB cluster"
}

variable "alloydb_instance_id" {
  type        = string
  description = "The ID of the AlloyDB instance"
}

variable "alloydb_instance_cpu_count" {
  type        = number
  description = "The number of CPUs for the AlloyDB instance"
}

variable "alloydb_username" {
  type        = string
  description = "The username for the AlloyDB cluster"
}

variable "alloydb_password" {
  type        = string
  description = "The password for the AlloyDB cluster"
}

variable "vpc_access_connector" {
  type = object({
    name          = string,
    ip_cidr_range = string,
  })
}

variable "subnet_cidr_range" {
  type        = string
  description = "CIDR range of the subnet"
}
# Secret manager
variable "secrets" {
  type = map(object({
    labels                = map(string)
    replication_locations = optional(list(string))
    policies              = map(list(string))
  }))
  default = {}
}
