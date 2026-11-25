terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "random" {}            # default configuration (no alias)

provider "random" {
  alias = "second"              # a 2nd configuration of the SAME provider
}

resource "random_pet" "a" {     # no provider argument → uses the default
  length = 2
}

resource "random_pet" "b" {
  provider = random.second      # name.alias, no quotes
  length   = 2
}