terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.70"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
