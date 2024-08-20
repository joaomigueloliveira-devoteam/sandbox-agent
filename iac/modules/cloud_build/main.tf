resource "google_cloudbuild_trigger" "default" {
  project         = var.project_id
  name            = var.trigger_name
  substitutions   = var.substitutions
  filename        = var.path
  included_files  = var.included
  location        = var.location
  service_account = var.service_account
  repository_event_config {
    repository = "projects/${var.project_id}/locations/${var.location}/connections/${var.parent_connection}/repositories/${var.repository_name}"
    push {
      branch = var.branch_regex
    }
  }
}
