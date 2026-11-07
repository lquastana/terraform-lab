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

variable "greeting" {
  type    = string
  default = "Hello"
}

resource "random_pet" "a" {
  length    = 2
  separator = "-"
}

resource "random_pet" "b" {
  length    = 2
  separator = "-"
}

resource "local_file" "note" {
  filename = "${path.module}/note.txt"
  content  = "pet=${random_pet.a.id}\n"
}

output "pet" {
  value = random_pet.a.id
}

