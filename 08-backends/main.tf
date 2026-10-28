terraform {
  required_version = ">=1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~>2.5"

    }
  }

  backend "local" { }
}

resource "local_file" "env" {
  filename = "${path.module}/env-${terraform.workspace}.txt"
  content = "workspace=${terraform.workspace}\n"
}


