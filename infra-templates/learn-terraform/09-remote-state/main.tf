terraform {
  backend "s3" {
    bucket = "roboshop-dev-remote-state-bucket"
    key    = "roboshop-dev-remote-state/terraform.tfstate"
    region = "us-east-1"
  }
}


output "bucket" {
  value = "roboshop-dev-remote-state-bucket"
}