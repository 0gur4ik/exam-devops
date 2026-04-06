terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  # Зберігання tfstate у DO Spaces (S3-сумісне сховище)
  backend "s3" {
    endpoint                    = "fra1.digitaloceanspaces.com"
    region                      = "us-east-1" # Для DO Spaces завжди пишеться us-east-1 в налаштуваннях AWS S3 бекенду
    bucket                      = "andrus-tfstate-bucket" # Бакет, який ти створив вручну
    key                         = "terraform.tfstate"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}
