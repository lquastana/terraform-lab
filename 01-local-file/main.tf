terraform {
  required_version = ">=1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~>2.5"

    }
  }
}

resource "local_file" "hello" {
  content  = "Hello, World!"
  filename = "${path.module}/hello.txt"
}