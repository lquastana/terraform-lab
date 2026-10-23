terraform {
  required_version =">=1.12"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version ="~>2.5"

    }
  }
}

module "fhir" {
  source = "./modules/service-file"
  name   = "fhir"
  port   = 8080
  public = true
}


module "postgres" {
  source = "./modules/service-file"

  name   = "postgres"
  port   = 5432
  public = false
}

output "fhir_file" {
  value = module.fhir.file_path
}

