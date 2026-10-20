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

variable "greeting" {
  type        = string
  description = "Greeting message to include in the file"
  default     = "Hello"
}

resource "random_pet" "pet" {
  length    = 2
  separator = "-"
}

resource "local_file" "greeting" {
  content  = "${var.greeting}, ${random_pet.pet.id}!"
  filename = "${path.module}/hello.txt"
}


output "pet_name" {
  value = random_pet.pet.id
}

output "file_path" {
  value = local_file.greeting.filename
}

moved {
  from = local_file.hello
  to   = local_file.greeting
}

removed {
  from = local_file.note
  lifecycle {
    destroy = false
  }
}


