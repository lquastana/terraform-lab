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

resource "local_file" "hello" {
  content  = "${var.greeting}, ${random_pet.pet.id}!"
  filename = "${path.module}/hello.txt"
}

output "random_pet" {
  value = random_pet.pet.id
}

output "file_path" {
  value = local_file.hello.filename
}





