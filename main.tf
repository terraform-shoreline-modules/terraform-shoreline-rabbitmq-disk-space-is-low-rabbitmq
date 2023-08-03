terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "low_disk_space_on_rabbitmq" {
  source    = "./modules/low_disk_space_on_rabbitmq"

  providers = {
    shoreline = shoreline
  }
}