
# This is my 1st change!
# This is my 2nd change!

terraform {
  cloud {
    organization = "Bumlistic"
    workspaces {
      name = "terra-house-1"
    }
  }

  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length   = 16
  special  = false
}


output "random_bucket_name" {
  value = random_string.bucket_name.result
}