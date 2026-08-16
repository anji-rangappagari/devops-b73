provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "web" {
  for_each              = var.instace_count
  ami                    = data.aws_ami.rhel9_devops.id
  instance_type          = lookup(each.value, "instance_type", "t2.micro")

  tags = {
    Name = var.instace_count[each.key].name
}
}

data "aws_ami" "rhel9_devops" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

variable "instace_count" {
  default     = {
    "frontend" = {
        name = "frontend"
        instance_type = "t2.small"

    }
    "catalog"  = {
        name = "catalog"
        instance_type = "t2.micro"
    }
    "user"     = {
        name = "user"
        instance_type = "t3.micro"
    }

  }
  }




