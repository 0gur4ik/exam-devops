terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    # Оновлений синтаксис для endpoint з обов'язковим https://
    endpoints = {
      s3 = "https://fra1.digitaloceanspaces.com"
    }
    region                      = "us-east-1"
    bucket                      = "exam-tfstate-bucket-andrus" 
    key                         = "terraform.tfstate"
    
    # Вимикаємо специфічні AWS-перевірки, які DO Spaces не підтримує
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true # Саме це виправляє твою поточну помилку
    skip_s3_checksum            = true # Це запобігає наступній можливій помилці з DO
  }
}
