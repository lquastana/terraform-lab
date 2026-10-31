terraform {
  required_version = ">= 1.12"

  cloud {
    organization = "lquastana-lab"

    workspaces {
      name = "terraform-lab"
    }
  }

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

variable "greeting" {
  type    = string
  default = "Hello"
}

resource "random_pet" "pet" {
  length    = 3
  separator = "-"
}

resource "local_file" "file" {
  filename = "${path.module}/where-am-i.txt"
  content = "${var.greeting} from ${random_pet.pet.id}\n"
}

output "pet_name" {
  value = random_pet.pet.id
}

