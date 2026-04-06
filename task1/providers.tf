terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    endpoints = {
      s3 = "https://fra1.digitaloceanspaces.com"
    }
    region                      = "us-east-1"
    bucket                      = "exam-tfstate-bucket-andrus" 
    key                         = "terraform.tfstate"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

# Оголошуємо змінні, які ми передаємо з Jenkins
variable "do_token" {}
variable "spaces_access_id" {}
variable "spaces_secret_key" {}

provider "digitalocean" {
  token             = var.do_token
  # Додаємо ключі для створення бакета (Spaces)
  spaces_access_id  = var.spaces_access_id
  spaces_secret_key = var.spaces_secret_key
}
