terraform {
  required_version = ">=1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~>2.5"

    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.6"
    }
  }
}

# Imported on 2026-10-25 with an import block + plan -generate-config-out (cleaned up)
resource "random_string" "api_key" {
  length = 14
}

resource "random_string" "legacy" {
  length = 12
}

module "service" {
  for_each = {
    fhir = {
      port   = 8080
      public = true
    }
    keycloak = {
      port   = 3000
      public = true
    }
    postgres = {
      port   = 5432
      public = false
    }
  }
  source = "git::https://github.com/lquastana/terraform-lab.git//06-modules/modules/service-file?ref=service-file-v1.1.0"
  name   = each.key
  port   = each.value.port
  public = each.value.public
}



output "files" {
  value = { for name, m in module.service : name => m.file_path }
}

