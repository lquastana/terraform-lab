terraform {
  required_version = ">=1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~>2.5"

    }
  }
}

variable "services" {
  type = map(object({
    port   = number
    public = bool
  }))
  default = {
    fhir = { port = 8080, public = true }
    postgres = { port = 5432, public = false }
  }
}


resource "local_file" "service" {
  for_each = var.services
  filename = "${path.module}/${each.key}.conf"
  content  = "[Service] ${each.key} Port: ${each.value.port} Public: ${each.value.public}"
}

resource "local_file" "summary" {
  filename = "${path.module}/summary.txt"
  content = "${trimspace(data.local_file.owner.content)}\npublic services: ${join(", ", local.public_services)}"
}

resource "local_file" "indexed" {
  count    = length(local.names)
  filename = "${path.module}/idx-${count.index}.txt"
  content  = local.names[count.index]
}

locals {
  public_services = [for key, value in var.services : key if value.public]
  names = ["fhir", "postgres"]
}

data "local_file" "owner" {
  filename = "${path.module}/owner.txt"
}


output "public_services" {
  value = local.public_services
}

output "service_files" {
  value = [for f in local_file.service : f.filename]
}

