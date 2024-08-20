data "google_project" "project" {}

locals {

  cloud_runs = { for k, v in var.cloud_runs : k => merge(v, {
    service_account_email = try(module.basic.service_accounts[v.service_account].email, var.service_accounts[v.service_account].email)
    iam = merge(
      merge([for sa, roles in v.sa : { for role in roles : "${sa}/${role}" => {
        member = "serviceAccount:${try(module.basic.service_accounts[sa].email, var.service_accounts[sa].email)}"
        role   = role
      } }]...),
      merge([for user, roles in v.users : { for role in roles : "${user}/${role}" => {
        member = "user:${user}"
        role   = role
      } }]...),
      merge([for group, roles in v.groups : { for role in roles : "${group}/${role}" => {
        member = "group:${group}"
        role   = role
      } }]...)
    ) })
  }

  all_vertex_ai_agents = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-aiplatform.iam.gserviceaccount.com",
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-aiplatform-cc.iam.gserviceaccount.com"
  ]

  updated_artifact_registry_maps = {
    for artifact_repo_name, artifact_repo_content in var.artifact_registry_repositories : artifact_repo_name => {
      location    = artifact_repo_content.location
      description = artifact_repo_content.description
      format      = artifact_repo_content.format
      role_group_map = lookup(artifact_repo_content.role_group_map, "roles/artifactregistry.reader", null) != null ? tomap({
        for role, groups in artifact_repo_content.role_group_map : role => role == "roles/artifactregistry.reader" ? tolist(set(concat(groups, local.all_vertex_ai_agents))) : groups
        }) : tomap({
        "roles/artifactregistry.reader" = tolist(local.all_vertex_ai_agents)
      })
    }
  }
  cloud_build_substitutions = merge(
    { for trigger_name, config in merge(
      var.pipeline_triggers,
      var.component_triggers,
      var.container_triggers,

      ) : trigger_name => merge(config.substitutions, {
        "_PROJECT_ROOT"                     = var.project_id
        "_PROJECT_ID"                       = var.project_id
        "_REGION"                           = var.region
        "_ARTIFACT_REGISTRY_CONTAINERS_URL" = "${var.artifact_registry_repositories["pipeline-containers"].location}-docker.pkg.dev/${var.project_id}/pipeline-containers"
        "_ARTIFACT_REGISTRY_TEMPLATES_URL"  = "https://${var.artifact_registry_repositories["pipeline-templates"].location}-kfp.pkg.dev/${var.project_id}/pipeline-templates"
    }) },
    { for trigger_name, run in local.cloud_runs : trigger_name => merge(run.cloud_build_trigger.substitutions, {
      "_PROJECT_ROOT"                     = var.project_id
      "_PROJECT_ID"                       = var.project_id
      "_REGION"                           = var.region
      "_SERVICE_NAME"                     = trigger_name
      "_SERVICE_ACCOUNT"                  = run.service_account_email
      "_ARTIFACT_REGISTRY_CONTAINERS_URL" = "${var.artifact_registry_repositories["pipeline-containers"].location}-docker.pkg.dev/${var.project_id}/pipeline-containers"
      "_ARTIFACT_REGISTRY_TEMPLATES_URL"  = "https://${var.artifact_registry_repositories["pipeline-templates"].location}-kfp.pkg.dev/${var.project_id}/pipeline-templates"
    }) }
  )

  cloud_build_service_account_email = "projects/-/serviceAccounts/sa-cloud-build-triggers@${var.project_id}.iam.gserviceaccount.com"
  # IAM


  cloud_build_service_account = {

    email  = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
    create = false
  }

  service_accounts = merge(var.service_accounts, { "cloudbuild" : local.cloud_build_service_account })

  service_agents = {
    "aiplatform.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@gcp-sa-aiplatform.iam.gserviceaccount.com"
      create = false
    },
    "cc-aiplatform.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@gcp-sa-aiplatform-cc.iam.gserviceaccount.com"
      create = false
    },
    "artifactregistry.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
      create = false
    },
    "cloudbuild.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@gcp-sa-cloudbuild.iam.gserviceaccount.com"
      create = false
    },
    "compute.googleapis.com" = {
      email  = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
      create = false
    },
    "containerregistry.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@containerregistry.iam.gserviceaccount.com"
      create = false
    },
    "ml.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@cloud-ml.google.com.iam.gserviceaccount.com"
      create = false
    },
    "pubsub.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
      create = false
    },
    "run.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@serverless-robot-prod.iam.gserviceaccount.com"
      create = false
    },
    "servicenetworking.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@service-networking.iam.gserviceaccount.com"
      create = false
    },
    "cloudservices" = {
      email  = "${data.google_project.project.number}@cloudservices.gserviceaccount.com"
      create = false
    },
    "vpcaccess.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@gcp-sa-vpcaccess.iam.gserviceaccount.com",
      create = false
    },
    "alloydb.googleapis.com" = {
      email  = "service-${data.google_project.project.number}@gcp-sa-alloydb.iam.gserviceaccount.com"
      create = false
    }
  }

  all_service_accounts = merge(local.service_agents, local.service_accounts)

  default_roles = {
    "aiplatform.googleapis.com" : ["projects/${data.google_project.project.project_id}/roles/artifactRegistryUser", "roles/aiplatform.serviceAgent"],
    "cc-aiplatform.googleapis.com" : ["roles/aiplatform.customCodeServiceAgent"],
    "artifactregistry.googleapis.com" : ["roles/artifactregistry.serviceAgent"],
    "cloudbuild.googleapis.com" : ["roles/cloudbuild.serviceAgent"],
    "compute.googleapis.com" : ["roles/editor"],
    "containerregistry.googleapis.com" : ["roles/containerregistry.ServiceAgent"],
    "ml.googleapis.com" : ["roles/ml.serviceAgent"],
    "pubsub.googleapis.com" : ["roles/pubsub.serviceAgent"],
    "run.googleapis.com" : ["roles/run.serviceAgent"],
    "cloudservices" = ["roles/editor"],
    "servicenetworking.googleapis.com" : ["roles/servicenetworking.serviceAgent"],
    "vpcaccess.googleapis.com" : ["roles/vpcaccess.serviceAgent", "roles/editor"]
    "alloydb.googleapis.com" : ["roles/alloydb.serviceAgent", "roles/editor"]
  }

  project_iam = {
    (var.project_id) = {
      "project_id" = var.project_id
      "groups"     = var.group_roles
      "sa"         = merge(var.service_account_roles, local.default_roles)
      "users"      = var.user_roles
    }
  }
}
