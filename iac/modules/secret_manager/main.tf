resource "google_secret_manager_secret" "secret" {
  project   = var.project_id
  secret_id = var.name

  labels = var.labels

  replication {
    dynamic "user_managed" {
      # Just create one 'user_managed' instance or not
      for_each = length(var.replication_locations) == 0 ? [] : [1]
      content {
        dynamic "replicas" {
          # create multiple replicas instance
          for_each = var.replication_locations
          content {
            location = replicas.value
          }
        }
      }
    }
    automatic = length(var.replication_locations) == 0 ? true : null
  }
}

data "google_iam_policy" "iam_policy" {
  dynamic "binding" {
    for_each = var.policies

    content {
      role    = format("roles/secretmanager.%s", binding.key)
      members = binding.value
    }
  }
}

resource "google_secret_manager_secret_iam_policy" "secret_policy" {
  project     = google_secret_manager_secret.secret.project
  secret_id   = google_secret_manager_secret.secret.secret_id
  policy_data = data.google_iam_policy.iam_policy.policy_data
}
