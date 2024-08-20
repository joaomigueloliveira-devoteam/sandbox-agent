terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.78.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~>4.78.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0" # Or whichever version is appropriate
    }
  }
  backend "gcs" {}
}
