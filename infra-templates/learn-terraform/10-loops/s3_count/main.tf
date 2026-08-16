provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  count  = length(var.bucket_names)
  bucket = "roboshop-${var.bucket_names[count.index]}"

  tags = {
    Name        = var.bucket_names[count.index]
    Environment = "Dev"
  }
}

variable "bucket_names" {
  type    = list(string)
  default = ["frontend", "catalog",]
}
