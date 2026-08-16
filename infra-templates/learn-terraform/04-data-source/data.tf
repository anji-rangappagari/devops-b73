data "aws_ami" "example" {
  executable_users = ["amazon"]
  most_recent      = true
  name_regex       = "^myami-[0-9]{3}"
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["myami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

provider "aws" {
  region = "us-east-1"
}   
output "ami_id" {
  value = data.aws_ami.example.id
}

output "arn" {
  value = data.aws_ami.example.arn
}

output "name" {
  value = data.aws_ami.example.name
}
output "description" {
  value = data.aws_ami.example.description
}
