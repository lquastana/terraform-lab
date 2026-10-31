terraform {
  required_version = ">= 1.12"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

variable "env" {
  type    = string
}

resource random_pet app {
  prefix    = var.env
  length    = 2
  separator = "-"
}


output "app_name" {
  value = random_pet.app.id
}

