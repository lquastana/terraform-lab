terraform {
  required_version = ">=1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~>2.5"

    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
  }
}

variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be dev, test or prod."
  }
}

variable "config_version" {
  type    = number
  default = 2
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "Lab-Only-P@ss"
}

ephemeral "random_password" "temp" {
  length = 16
}


resource "random_pet" "suffix" {
  length    = 2
  separator = "-"
}


resource "local_file" "config" {
  content  = "Env=${var.environment}\nname=${random_pet.suffix.id}"
  filename = "${path.module}/config-${var.environment}-v${var.config_version}.txt"
  file_permission = "0640"
  lifecycle {
    precondition {
      condition     = (var.environment != "prod") || (var.config_version >= 3)
      error_message = "In prod, config_version must be >= 3."
    }
    create_before_destroy = true
    postcondition {
      condition     = self.file_permission == "0640"
      error_message = "Config file must not be world-readable."
    }
  }
}

resource "local_file" "app_conf" {
  content = "db_password=${var.db_password}\n"
  filename = "${path.module}/app.conf"
}

resource "local_file" "audit" {
  content    = "Audit trail V2"
  filename   = "${path.module}/audit.log"
  depends_on = [local_file.config]
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [content]
  }
}

check "audit_log_present" {
  assert {
    condition     = fileexists("${path.module}/audit.log")
    error_message = "audit.log is missing!"
  }
}


output "db_password_out" {
  value = var.db_password
  sensitive = true
}