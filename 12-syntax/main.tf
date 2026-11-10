terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.0"
    }
  }
}

data local_file owner {
  filename = "${path.module}/owner.txt"
}

output "owner_line" {
  value = data.local_file.owner.content
}

locals {
  files = {
    "fhir.txt"     = "FHIR server"
    "keycloak.txt" = "Identity provider"
    "postgres.txt" = "Database"
  }
}

data "archive_file" "bundle" {
  type        = "zip"
  output_path = "${path.module}/bundle.zip"

  dynamic "source" {
    for_each = local.files
    content {
      filename = "${path.module}/${source.key}"
      content  = source.value
    }
  }
  lifecycle {
    postcondition {
      condition     = self.output_size > 0
      error_message = "The zip must not be empty."
    }
  }
}

output "zip_size" {
  value = data.archive_file.bundle.output_size
}


variable api_key {
  description = "API key for accessing the FHIR server"
  type        = string
  sensitive   = true
  default     = "default_api_key"
}


output "api_key" {
  value     = var.api_key
  sensitive = true
}

resource "local_file" "both" {
  for_each = local.files
  filename = "${path.module}/${each.key}"
  content  = each.value
}