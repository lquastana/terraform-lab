terraform {
  required_version = ">= 1.12"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "random_pet" "app" {
  length    = 2
  separator = "-"
}



output "app_name" {
  value = random_pet.app.id
}