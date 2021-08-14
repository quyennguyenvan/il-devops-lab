terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
  region = "ap-northeast-1"
  profile = "quyennvdotcom"
}

provider "http" {}
