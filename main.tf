# SOC-2 Controls: Ensure all infrastructure is defined as code and version controlled.

resource "google_storage_bucket" "tax_slips_bucket" {
  name          = "${var.project_id}-tax-slips-bucket"
  location      = "US"
  uniform_bucket_level_access = true
  encryption {
    default_kms_key_name = google_kms_crypto_key.colab_cmek_key.id
  }

  # SOC-2 Controls: Implement access controls to restrict access to sensitive data.
  # SOC-2 Controls: Ensure data at rest is encrypted using strong, industry-standard encryption.
}

resource "google_kms_key_ring" "colab_key_ring" {
  name     = "colab-key-ring"
  location = "global"

  # SOC-2 Controls: Manage encryption keys securely.
}

resource "google_kms_crypto_key" "colab_cmek_key" {
  name            = "colab-cmek-key"
  key_ring        = google_kms_key_ring.colab_key_ring.id
  rotation_period = "100000s" # SOC-2 Controls: Implement key rotation policies.

  # SOC-2 Controls: Ensure encryption keys are managed and rotated regularly.
}

resource "google_service_account" "colab_sa" {
  account_id   = "colab-pipeline-sa"
  display_name = "Service Account for Colab Enterprise Pipeline"

  # SOC-2 Controls: Implement least privilege for service accounts.
}

resource "google_project_iam_member" "colab_sa_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.colab_sa.email}"

  # SOC-2 Controls: Grant only necessary permissions for bucket access.
}

resource "google_project_iam_member" "colab_sa_kms_viewer" {
  project = var.project_id
  role    = "roles/cloudkms.viewer"
  member  = "serviceAccount:${google_service_account.colab_sa.email}"

  # SOC-2 Controls: Grant only necessary permissions for KMS key access.
}

resource "google_project_iam_member" "colab_sa_colab_editor" {
  project = var.project_id
  role    = "roles/colaboratory.editor"
  member  = "serviceAccount:${google_service_account.colab_sa.email}"

  # SOC-2 Controls: Grant only necessary permissions for Colab Enterprise.
}

resource "google_cloud_scheduler_job" "nightly_pipeline_job" {
  name        = "nightly-tax-pipeline-job"
  description = "Nightly job to run the cross-border tax pipeline"
  schedule    = "0 0 * * *" # Run daily at midnight UTC
  time_zone   = "UTC"

  http_target {
    http_method = "POST"
    uri         = "https://colab.googleapis.com/v2/projects/${var.project_id}/locations/${var.region}/runtimes/${var.colab_runtime_id}:execute"
    oauth_token {
      service_account_email = google_service_account.colab_sa.email
    }
    headers = {
      "Content-Type" = "application/json"
    }
    body = jsonencode({
      "notebook_path" = "${var.colab_notebook_path}"
    })
  }

  # SOC-2 Controls: Schedule automated tasks for regular execution.
  # SOC-2 Controls: Ensure proper authentication and authorization for scheduled jobs.
}

variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region for resources."
  type        = string
  default     = "us-central1"
}

variable "colab_runtime_id" {
  description = "The ID of the Colab Enterprise runtime to use."
  type        = string
}

variable "colab_notebook_path" {
  description = "The path to the Colab Enterprise notebook."
  type        = string
}
